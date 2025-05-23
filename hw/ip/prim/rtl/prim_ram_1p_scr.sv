// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This is a draft implementation of a low-latency memory scrambling mechanism.
//
// The module is implemented as a primitive, in the same spirit as similar prim_ram_1p_adv wrappers.
// Hence, it can be conveniently instantiated by comportable IPs (such as OTBN) or in top_earlgrey
// for the main system memory.
//
// The currently implemented architecture uses a reduced-round PRINCE cipher primitive in CTR mode
// in order to (weakly) scramble the data written to the memory macro. Plain CTR mode does not
// diffuse the data since the keystream is just XOR'ed onto it, hence we also we perform byte-wise
// diffusion using a (shallow) substitution/permutation network layers in order to provide a limited
// avalanche effect within a byte.
//
// In order to break the linear addressing space, the address is passed through a bijective
// scrambling function constructed using a (shallow) substitution/permutation and a nonce. Due to
// that nonce, the address mapping is not fully baked into RTL and can be changed at runtime as
// well.
//
// See also: prim_cipher_pkg, prim_prince

`include "prim_assert.sv"

module prim_ram_1p_scr import prim_ram_1p_pkg::*; #(
  parameter  int Depth               = 16*1024, // Needs to be a power of 2 if NumAddrScrRounds > 0.
  parameter  int InstDepth           = Depth,
  parameter  int Width               = 32, // Needs to be byte aligned if byte parity is enabled.
  parameter  int DataBitsPerMask     = 8, // Needs to be set to 8 in case of byte parity.
  parameter  bit EnableParity        = 1, // Enable byte parity.

  // Scrambling parameters. Note that this needs to be low-latency, hence we have to keep the
  // amount of cipher rounds low. PRINCE has 5 half rounds in its original form, which corresponds
  // to 2*5 + 1 effective rounds. Setting this to 3 lowers this to approximately 7 effective rounds.
  // Number of PRINCE half rounds, can be [1..5]
  parameter  int NumPrinceRoundsHalf = 3,
  // Number of extra diffusion rounds. Setting this to 0 to disables diffusion.
  // NOTE: this is zero by default, since the non-linear transformation of data bits can interact
  // adversely with end-to-end ECC integrity. Only enable this if you know what you are doing
  // (e.g. using this primitive in a different context with byte parity). See #20788 for context.
  parameter  int NumDiffRounds       = 0,
  // This parameter governs the block-width of additional diffusion layers.
  // For intra-byte diffusion, set this parameter to 8.
  parameter  int DiffWidth           = DataBitsPerMask,
  // Number of address scrambling rounds. Setting this to 0 disables address scrambling.
  parameter  int NumAddrScrRounds    = 2,
  // If set to 1, the same 64bit key stream is replicated if the data port is wider than 64bit.
  // If set to 0, the cipher primitive is replicated, and together with a wider nonce input,
  // a unique keystream is generated for the full data width.
  parameter  bit ReplicateKeyStream  = 1'b0,
  // Derived parameters
  localparam int AddrWidth           = prim_util_pkg::vbits(Depth),
  // Depending on the data width, we need to instantiate multiple parallel cipher primitives to
  // create a keystream that is wide enough (PRINCE has a block size of 64bit)
  localparam int NumParScr           = (ReplicateKeyStream) ? 1 : (Width + 63) / 64,
  localparam int NumParKeystr        = (ReplicateKeyStream) ? (Width + 63) / 64 : 1,
  // This is given by the PRINCE cipher primitive. All parallel cipher modules
  // use the same key, but they use a different IV
  localparam int DataKeyWidth        = 128,
  // Each 64 bit scrambling primitive requires a 64bit IV
  localparam int NonceWidth          = 64 * NumParScr,
  // Compute RAM tiling
  localparam int NumRamInst          = prim_util_pkg::ceil_div(Depth, InstDepth)
) (
  input                                    clk_i,
  input                                    rst_ni,

  // Key interface. Memory requests will not be granted if key_valid is set to 0.
  input                                    key_valid_i,
  input        [DataKeyWidth-1:0]          key_i,
  input        [NonceWidth-1:0]            nonce_i,

  // Interface to TL-UL SRAM adapter
  input                                    req_i,
  output logic                             gnt_o,
  input                                    write_i,
  input        [AddrWidth-1:0]             addr_i,
  input        [Width-1:0]                 wdata_i,
  input        [Width-1:0]                 wmask_i,  // Needs to be byte-aligned for parity
  // On integrity errors, the primitive surpresses any real transaction to the memory.
  input                                    intg_error_i,
  output logic [Width-1:0]                 rdata_o,
  output logic                             rvalid_o, // Read response (rdata_o) is valid
  output logic [1:0]                       rerror_o, // Bit1: Uncorrectable, Bit0: Correctable
  output logic [AddrWidth-1:0]             raddr_o,  // Read address for error reporting.

  // config
  input  ram_1p_cfg_t     [NumRamInst-1:0] cfg_i,
  output ram_1p_cfg_rsp_t [NumRamInst-1:0] cfg_rsp_o,


  // Write currently pending inside this module.
  output logic                             wr_collision_o,
  output logic                             write_pending_o,

  // When detecting multi-bit encoding errors, raise alert.
  output logic                             alert_o
);

  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi4_and_hi;
  import prim_mubi_pkg::mubi4_bool_to_mubi;
  import prim_mubi_pkg::mubi4_or_hi;
  import prim_mubi_pkg::mubi4_test_invalid;
  import prim_mubi_pkg::mubi4_test_true_loose;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4Width;

  //////////////////////
  // Parameter Checks //
  //////////////////////

  // The depth needs to be a power of 2 in case address scrambling is turned on
  `ASSERT_INIT(DepthPow2Check_A, NumAddrScrRounds <= '0 || 2**$clog2(Depth) == Depth)
  `ASSERT_INIT(DiffWidthMinimum_A, DiffWidth >= 4)
  `ASSERT_INIT(DiffWidthWithParity_A, EnableParity && (DiffWidth == 8) || !EnableParity)

  /////////////////////////////////////////
  // Pending Write and Address Registers //
  /////////////////////////////////////////

  // Writes are delayed by one cycle, such the same keystream generation primitive (prim_prince) can
  // be reused among reads and writes. Note however that with this arrangement, we have to introduce
  // a mechanism to hold a pending write transaction in cases where that transaction is immediately
  // followed by a read. The pending write transaction is written to memory as soon as there is no
  // new read transaction incoming. The latter can be a special case if the incoming read goes to
  // the same address as the pending write. To that end, we detect the address collision and return
  // the data from the write holding register.

  // Read / write strobes
  mubi4_t read_en, read_en_buf;
  logic   read_en_b;
  mubi4_t write_en_d, write_en_buf_d, write_en_q;
  logic   write_en_b;
  logic [MuBi4Width-1:0] read_en_b_buf, write_en_buf_b_d;
  assign gnt_o = req_i & key_valid_i;

  assign read_en = mubi4_bool_to_mubi(gnt_o & ~write_i);
  assign write_en_d = mubi4_bool_to_mubi(gnt_o & write_i);

  prim_buf #(
    .Width(MuBi4Width)
  ) u_read_en_buf (
    .in_i (read_en),
    .out_o(read_en_b_buf)
  );

  assign read_en_buf = mubi4_t'(read_en_b_buf);

  prim_buf #(
    .Width(MuBi4Width)
  ) u_write_en_d_buf (
    .in_i (write_en_d),
    .out_o(write_en_buf_b_d)
  );

  assign write_en_buf_d = mubi4_t'(write_en_buf_b_d);

  mubi4_t write_pending_q;
  mubi4_t addr_collision_d, addr_collision_q;
  logic [AddrWidth-1:0] addr_scr;
  logic [AddrWidth-1:0] waddr_scr_q;
  mubi4_t addr_match;
  logic [MuBi4Width-1:0] addr_match_buf;

  assign addr_match = (addr_scr == waddr_scr_q) ? MuBi4True : MuBi4False;
  prim_buf #(
    .Width(MuBi4Width)
  ) u_addr_match_buf (
    .in_i (addr_match),
    .out_o(addr_match_buf)
  );

  assign addr_collision_d = mubi4_and_hi(mubi4_and_hi(mubi4_or_hi(write_en_q,
      write_pending_q), read_en_buf), mubi4_t'(addr_match_buf));

  // Macro requests and write strobe
  // The macro operation is silenced if an integrity error is seen
  logic intg_error_buf, intg_error_w_q;
  prim_buf u_intg_error (
    .in_i(intg_error_i),
    .out_o(intg_error_buf)
  );
  logic macro_req;
  assign macro_req   = ~intg_error_w_q & ~intg_error_buf &
      mubi4_test_true_loose(mubi4_or_hi(mubi4_or_hi(read_en_buf, write_en_q), write_pending_q));
  // We are allowed to write a pending write transaction to the memory if there is no incoming read.
  logic macro_write;
  assign macro_write = mubi4_test_true_loose(mubi4_or_hi(write_en_q, write_pending_q)) &
    ~mubi4_test_true_loose(read_en_buf) & ~intg_error_w_q;
  // New read write collision
  logic rw_collision;
  assign rw_collision = mubi4_test_true_loose(mubi4_and_hi(write_en_q, read_en_buf));

  // Write currently processed inside this module. Although we are sending an immediate d_valid
  // back to the host, the write could take longer due to the scrambling.
  assign write_pending_o = macro_write | mubi4_test_true_loose(write_en_buf_d);

  // When a read is followed after a write with the same address, we return the data from the
  // holding register.
  assign wr_collision_o = mubi4_test_true_loose(addr_collision_q);

  ////////////////////////
  // Address Scrambling //
  ////////////////////////

  // We only select the pending write address in case there is no incoming read transaction.
  logic [AddrWidth-1:0] addr_mux;
  assign addr_mux = (mubi4_test_true_loose(read_en_buf)) ? addr_scr : waddr_scr_q;

  // This creates a bijective address mapping using a substitution / permutation network.
  if (NumAddrScrRounds > 0) begin : gen_addr_scr
    logic [AddrWidth-1:0] addr_scr_nonce;
    assign addr_scr_nonce = nonce_i[NonceWidth - AddrWidth +: AddrWidth];

    prim_subst_perm #(
      .DataWidth ( AddrWidth        ),
      .NumRounds ( NumAddrScrRounds ),
      .Decrypt   ( 0                )
    ) u_prim_subst_perm (
      .data_i ( addr_i         ),
      // Since the counter mode concatenates {nonce_i[NonceWidth-1-AddrWidth:0], addr} to form
      // the IV, the upper AddrWidth bits of the nonce are not used and can be used for address
      // scrambling. In cases where N parallel PRINCE blocks are used due to a data
      // width > 64bit, N*AddrWidth nonce bits are left dangling.
      .key_i  ( addr_scr_nonce ),
      .data_o ( addr_scr       )
    );
  end else begin : gen_no_addr_scr
    assign addr_scr = addr_i;
  end

  // We latch the non-scrambled address for error reporting.
  logic [AddrWidth-1:0] raddr_q;
  assign raddr_o = raddr_q;

  //////////////////////////////////////////////
  // Keystream Generation for Data Scrambling //
  //////////////////////////////////////////////

  // This encrypts the IV consisting of the nonce and address using the key provided in order to
  // generate the keystream for the data. Note that we instantiate a register halfway within this
  // primitive to balance the delay between request and response side.
  localparam int DataNonceWidth = 64 - AddrWidth;
  logic [NumParScr*64-1:0] keystream;
  logic [NumParScr-1:0][DataNonceWidth-1:0] data_scr_nonce;
  for (genvar k = 0; k < NumParScr; k++) begin : gen_par_scr
    assign data_scr_nonce[k] = nonce_i[k * DataNonceWidth +: DataNonceWidth];

    prim_prince #(
      .DataWidth      (64),
      .KeyWidth       (128),
      .NumRoundsHalf  (NumPrinceRoundsHalf),
      .UseOldKeySched (1'b0),
      .HalfwayDataReg (1'b1), // instantiate a register halfway in the primitive
      .HalfwayKeyReg  (1'b0)  // no need to instantiate a key register as the key remains static
    ) u_prim_prince (
      .clk_i,
      .rst_ni,
      .valid_i ( gnt_o ),
      // The IV is composed of a nonce and the row address
      //.data_i  ( {nonce_i[k * (64 - AddrWidth) +: (64 - AddrWidth)], addr} ),
      .data_i  ( {data_scr_nonce[k], addr_i} ),
      // All parallel scramblers use the same key
      .key_i,
      // Since we operate in counter mode, this can always be set to encryption mode
      .dec_i   ( 1'b0 ),
      // Output keystream to be XOR'ed
      .data_o  ( keystream[k * 64 +: 64] ),
      .valid_o ( )
    );

    // Unread unused bits from keystream
    if (k == NumParKeystr-1 && (Width % 64) > 0) begin : gen_unread_last
      localparam int UnusedWidth = 64 - (Width % 64);
      logic [UnusedWidth-1:0] unused_keystream;
      assign unused_keystream = keystream[(k+1) * 64 - 1 -: UnusedWidth];
    end
  end

  // Replicate keystream if needed
  logic [Width-1:0] keystream_repl;
  assign keystream_repl = Width'({NumParKeystr{keystream}});

  /////////////////////
  // Data Scrambling //
  /////////////////////

  // Data scrambling is a two step process. First, we XOR the write data with the keystream obtained
  // by operating a reduced-round PRINCE cipher in CTR-mode. Then, we diffuse data within each byte
  // in order to get a limited "avalanche" behavior in case parts of the bytes are flipped as a
  // result of a malicious attempt to tamper with the data in memory. We perform the diffusion only
  // within bytes in order to maintain the ability to write individual bytes. Note that the
  // keystream XOR is performed first for the write path such that it can be performed last for the
  // read path. This allows us to hide a part of the combinational delay of the PRINCE primitive
  // behind the propagation delay of the SRAM macro and the per-byte diffusion step.

  logic [Width-1:0] rdata_scr, rdata;
  logic [Width-1:0] wdata_scr_d, wdata_scr_q, wdata_q;
  for (genvar k = 0; k < (Width + DiffWidth - 1) / DiffWidth; k++) begin : gen_diffuse_data
    // If the Width is not divisible by DiffWidth, we need to adjust the width of the last slice.
    localparam int LocalWidth = (Width - k * DiffWidth >= DiffWidth) ? DiffWidth :
                                                                       (Width - k * DiffWidth);

    // Write path. Note that since this does not fan out into the interconnect, the write path is
    // not as critical as the read path below in terms of timing.
    // Apply the keystream first
    logic [LocalWidth-1:0] wdata_xor;
    assign wdata_xor = wdata_q[k*DiffWidth +: LocalWidth] ^
                       keystream_repl[k*DiffWidth +: LocalWidth];

    // Byte aligned diffusion using a substitution / permutation network
    prim_subst_perm #(
      .DataWidth ( LocalWidth       ),
      .NumRounds ( NumDiffRounds ),
      .Decrypt   ( 0                )
    ) u_prim_subst_perm_enc (
      .data_i ( wdata_xor ),
      .key_i  ( '0        ),
      .data_o ( wdata_scr_d[k*DiffWidth +: LocalWidth] )
    );

    // Read path. This is timing critical. The keystream XOR operation is performed last in order to
    // hide the combinational delay of the PRINCE primitive behind the propagation delay of the
    // SRAM and the byte diffusion.
    // Reverse diffusion first
    logic [LocalWidth-1:0] rdata_xor;
    prim_subst_perm #(
      .DataWidth ( LocalWidth       ),
      .NumRounds ( NumDiffRounds ),
      .Decrypt   ( 1                )
    ) u_prim_subst_perm_dec (
      .data_i ( rdata_scr[k*DiffWidth +: LocalWidth] ),
      .key_i  ( '0        ),
      .data_o ( rdata_xor )
    );

    // Apply Keystream, replicate it if needed
    assign rdata[k*DiffWidth +: LocalWidth] = rdata_xor ^
                                              keystream_repl[k*DiffWidth +: LocalWidth];
  end

  ////////////////////////////////////////////////
  // Scrambled data register and forwarding mux //
  ////////////////////////////////////////////////

  // This is the scrambled data holding register for pending writes. This is needed in order to make
  // back to back patterns of the form WR -> RD -> WR work:
  //
  // cycle:          0   |  1   | 2   | 3   |
  // incoming op:    WR0 |  RD  | WR1 | -   |
  // prince:         -   |  WR0 | RD  | WR1 |
  // memory op:      -   |  RD  | WR0 | WR1 |
  //
  // The read transaction in cycle 1 interrupts the first write transaction which has already used
  // the PRINCE primitive for scrambling. If this sequence is followed by another write back-to-back
  // in cycle 2, we cannot use the PRINCE primitive a second time for the first write, and hence
  // need an additional holding register that can buffer the scrambled data of the first write in
  // cycle 1.

  // Clear this if we can write the memory in this cycle. Set only if the current write cannot
  // proceed due to an incoming read operation.
  mubi4_t write_scr_pending_d;
  assign write_scr_pending_d = (macro_write)  ? MuBi4False :
                               (rw_collision) ? MuBi4True :
                                                write_pending_q;

  // Select the correct scrambled word to be written, based on whether the word in the scrambled
  // data holding register is valid or not. Note that the write_scr_q register could in theory be
  // combined with the wdata_q register. We don't do that here for timing reasons, since that would
  // require another read data mux to inject the scrambled data into the read descrambling path.
  logic [Width-1:0] wdata_scr;
  assign wdata_scr = (mubi4_test_true_loose(write_pending_q)) ? wdata_scr_q : wdata_scr_d;

  mubi4_t rvalid_q;
  logic intg_error_r_q;
  logic [Width-1:0] wmask_q;
  always_comb begin : p_forward_mux
    rdata_o = '0;
    rvalid_o = 1'b0;
    // Kill the read response in case an integrity error was seen.
    if (!intg_error_r_q && mubi4_test_true_loose(rvalid_q)) begin
      rvalid_o = 1'b1;
      // In case of a collision, we forward the valid bytes of the write data from the unscrambled
      // holding register.
      if (mubi4_test_true_loose(addr_collision_q)) begin
        for (int k = 0; k < Width; k++) begin
          if (wmask_q[k]) begin
            rdata_o[k] = wdata_q[k];
          end else begin
            rdata_o[k] = rdata[k];
          end
        end
      // regular reads. note that we just return zero in case
      // an integrity error was signalled.
      end else begin
        rdata_o = rdata;
      end
    end
  end

  ///////////////
  // Registers //
  ///////////////
  logic ram_alert;

  assign alert_o = mubi4_test_invalid(write_en_q) | mubi4_test_invalid(addr_collision_q) |
                   mubi4_test_invalid(write_pending_q) | mubi4_test_invalid(rvalid_q) |
                   ram_alert;

  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_write_en_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(write_en_buf_d)),
    .q_o({write_en_q})
  );

  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_addr_collision_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(addr_collision_d)),
    .q_o({addr_collision_q})
  );

  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_write_pending_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(write_scr_pending_d)),
    .q_o({write_pending_q})
  );

  prim_flop #(
    .Width(MuBi4Width),
    .ResetValue(MuBi4Width'(MuBi4False))
  ) u_rvalid_flop (
    .clk_i,
    .rst_ni,
    .d_i(MuBi4Width'(read_en_buf)),
    .q_o({rvalid_q})
  );

  assign read_en_b = mubi4_test_true_loose(read_en_buf);
  assign write_en_b = mubi4_test_true_loose(write_en_buf_d);

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_wdata_buf
    if (!rst_ni) begin
      intg_error_r_q      <= 1'b0;
      intg_error_w_q      <= 1'b0;
      raddr_q             <= '0;
      waddr_scr_q         <= '0;
      wmask_q             <= '0;
      wdata_q             <= '0;
      wdata_scr_q         <= '0;
    end else begin
      intg_error_r_q      <= intg_error_buf;

      if (read_en_b) begin
        raddr_q <= addr_i;
      end
      if (write_en_b) begin
        waddr_scr_q    <= addr_scr;
        wmask_q        <= wmask_i;
        wdata_q        <= wdata_i;
        intg_error_w_q <= intg_error_buf;
      end
      if (rw_collision) begin
        wdata_scr_q <= wdata_scr_d;
      end
    end
  end

  //////////////////
  // Memory Macro //
  //////////////////

  prim_ram_1p_adv #(
    .Depth(Depth),
    .InstDepth(InstDepth),
    .Width(Width),
    .DataBitsPerMask(DataBitsPerMask),
    .EnableECC(1'b0),
    .EnableParity(EnableParity),
    .EnableInputPipeline(1'b0),
    .EnableOutputPipeline(1'b0)
  ) u_prim_ram_1p_adv (
    .clk_i,
    .rst_ni,
    .req_i    ( macro_req   ),
    .write_i  ( macro_write ),
    .addr_i   ( addr_mux    ),
    .wdata_i  ( wdata_scr   ),
    .wmask_i  ( wmask_q     ),
    .rdata_o  ( rdata_scr   ),
    .rvalid_o ( ),
    .rerror_o,
    .cfg_i,
    .cfg_rsp_o,
    .alert_o  ( ram_alert   )
  );

  `include "prim_util_get_scramble_params.svh"

endmodule : prim_ram_1p_scr
