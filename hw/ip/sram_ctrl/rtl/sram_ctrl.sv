// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SRAM controller.
//

`include "prim_assert.sv"

module sram_ctrl
  import sram_ctrl_pkg::*;
  import sram_ctrl_reg_pkg::*;
#(
  // Number of words stored in the SRAM.
  parameter int MemSizeRam                                 = 32'h1000,
  parameter int InstSize                                   = MemSizeRam,
  parameter int NumRamInst                                 = 1,
  // Enable asynchronous transitions on alerts.
  parameter logic [NumAlerts-1:0] AlertAsyncOn             = {NumAlerts{1'b1}},
  // Number of cycles a differential skew is tolerated on the alert signal
  parameter int unsigned          AlertSkewCycles          = 1,
  // Enables the execute from SRAM feature.
  parameter bit InstrExec                                  = 1,
  // Number of PRINCE half rounds for the SRAM scrambling feature, can be [1..5].
  // Note that this needs to be low-latency, hence we have to keep the amount of cipher rounds low.
  // PRINCE has 5 half rounds in its original form, which corresponds to 2*5 + 1 effective rounds.
  // Setting this to 3 lowers this to approximately 7 effective rounds.
  parameter int NumPrinceRoundsHalf                        = 3,
  // Number of outstanding TLUL transfers
  parameter int Outstanding                                = 2,
  // Enable single-bit error correction and error logging
  parameter bit                         EccCorrection      = 0,
  // RACL configuration
  parameter bit                         EnableRacl       = 1'b0,
  parameter bit                         RaclErrorRsp     = EnableRacl,
  parameter top_racl_pkg::racl_policy_sel_t RaclPolicySelVecRegs[NumRegsRegs] = '{NumRegsRegs{0}},
  parameter int unsigned                RaclPolicySelNumRangesRam = 1,
  // Random netlist constants
  parameter  otp_ctrl_pkg::sram_key_t   RndCnstSramKey   = RndCnstSramKeyDefault,
  parameter  otp_ctrl_pkg::sram_nonce_t RndCnstSramNonce = RndCnstSramNonceDefault,
  parameter  lfsr_seed_t                RndCnstLfsrSeed  = RndCnstLfsrSeedDefault,
  parameter  lfsr_perm_t                RndCnstLfsrPerm  = RndCnstLfsrPermDefault
) (
  // SRAM Clock
  input  logic                                               clk_i,
  input  logic                                               rst_ni,
  // OTP Clock (for key interface)
  input  logic                                               clk_otp_i,
  input  logic                                               rst_otp_ni,
  // Bus Interface (device) for SRAM
  input  tlul_pkg::tl_h2d_t                                  ram_tl_i,
  output tlul_pkg::tl_d2h_t                                  ram_tl_o,
  // Bus Interface (device) for CSRs
  input  tlul_pkg::tl_h2d_t                                  regs_tl_i,
  output tlul_pkg::tl_d2h_t                                  regs_tl_o,
  // Alert outputs.
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0]          alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0]          alert_tx_o,
  // RACL interface
  input  top_racl_pkg::racl_policy_vec_t                     racl_policies_i,
  output top_racl_pkg::racl_error_log_t                      racl_error_o,
  input  top_racl_pkg::racl_range_t [RaclPolicySelNumRangesRam-1:0] racl_policy_sel_ranges_ram_i,
  // Life-cycle escalation input (scraps the scrambling keys)
  // SEC_CM: LC_ESCALATE_EN.INTERSIG.MUBI
  input  lc_ctrl_pkg::lc_tx_t                                lc_escalate_en_i,
  // SEC_CM: LC_HW_DEBUG_EN.INTERSIG.MUBI
  input  lc_ctrl_pkg::lc_tx_t                                lc_hw_debug_en_i,
  // Otp configuration for sram execution
  // SEC_CM: EXEC.INTERSIG.MUBI
  input  prim_mubi_pkg::mubi8_t                              otp_en_sram_ifetch_i,
  // Key request to OTP (running on clk_fixed)
  // SEC_CM: SCRAMBLE.KEY.SIDELOAD
  output otp_ctrl_pkg::sram_otp_key_req_t                    sram_otp_key_o,
  input  otp_ctrl_pkg::sram_otp_key_rsp_t                    sram_otp_key_i,
  // config
  input   prim_ram_1p_pkg::ram_1p_cfg_t     [NumRamInst-1:0] cfg_i,
  output  prim_ram_1p_pkg::ram_1p_cfg_rsp_t [NumRamInst-1:0] cfg_rsp_o,
  // Error record
  output sram_ctrl_pkg::sram_error_t                         sram_rerror_o
);

  import lc_ctrl_pkg::lc_tx_t;
  import lc_ctrl_pkg::lc_tx_test_true_loose;
  import lc_ctrl_pkg::lc_tx_bool_to_lc_tx;
  import lc_ctrl_pkg::lc_tx_or_hi;
  import lc_ctrl_pkg::lc_tx_inv;
  import lc_ctrl_pkg::lc_to_mubi4;
  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi8_t;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::mubi8_test_true_strict;

  // This is later on pruned to the correct width at the SRAM wrapper interface.
  localparam int unsigned Depth = MemSizeRam >> 2;
  localparam int unsigned InstDepth = InstSize >> 2;
  localparam int unsigned AddrWidth = prim_util_pkg::vbits(Depth);

  `ASSERT_INIT(NumRamInstSameAsComputed_A,
               NumRamInst == prim_util_pkg::ceil_div(MemSizeRam, InstSize))

  `ASSERT_INIT(NonceWidthsLessThanSource_A, NonceWidth + LfsrWidth <= otp_ctrl_pkg::SramNonceWidth)

  top_racl_pkg::racl_error_log_t racl_error[2];
  if (EnableRacl) begin : gen_racl_error_arb
    // Arbitrate between all simultaneously valid error log requests.
    prim_racl_error_arb #(
      .N ( 2 )
    ) u_prim_err_arb (
      .clk_i,
      .rst_ni,
      .error_log_i ( racl_error   ),
      .error_log_o ( racl_error_o )
    );
  end else begin : gen_no_racl_error_arb
    logic unused_signals;
    assign unused_signals = ^{racl_error[0] ^ racl_error[1]};
    assign racl_error_o   = '0;
  end

  /////////////////////////////////////
  // Anchor incoming seeds and constants
  /////////////////////////////////////
  localparam int TotalAnchorWidth = $bits(otp_ctrl_pkg::sram_key_t) +
                                    $bits(otp_ctrl_pkg::sram_nonce_t);

  otp_ctrl_pkg::sram_key_t cnst_sram_key;
  otp_ctrl_pkg::sram_nonce_t cnst_sram_nonce;

  prim_sec_anchor_buf #(
    .Width(TotalAnchorWidth)
  ) u_seed_anchor (
    .in_i({RndCnstSramKey,
           RndCnstSramNonce}),
    .out_o({cnst_sram_key,
            cnst_sram_nonce})
  );


  //////////////////////////
  // CSR Node and Mapping //
  //////////////////////////

  // We've got two bus interfaces + an lc_gate in this module,
  // hence three integ failure sources.
  logic [2:0] bus_integ_error;

  sram_ctrl_regs_reg2hw_t reg2hw;
  sram_ctrl_regs_hw2reg_t hw2reg;

  // SEC_CM: CTRL.CONFIG.REGWEN
  // SEC_CM: EXEC.CONFIG.REGWEN
  // SEC_CM: READBACK.CONFIG.REGWEN
  sram_ctrl_regs_reg_top #(
    .EnableRacl       ( EnableRacl           ),
    .RaclErrorRsp     ( RaclErrorRsp         ),
    .RaclPolicySelVec ( RaclPolicySelVecRegs )
  ) u_reg_regs (
    .clk_i,
    .rst_ni,
    .tl_i             ( regs_tl_i          ),
    .tl_o             ( regs_tl_o          ),
    .reg2hw,
    .hw2reg,
    // RACL interface
    .racl_policies_i  ( racl_policies_i    ),
    .racl_error_o     ( racl_error[0]      ),
    // SEC_CM: BUS.INTEGRITY
    .intg_err_o       ( bus_integ_error[0] )
   );

  // Key and attribute outputs to scrambling device
  logic [otp_ctrl_pkg::SramKeyWidth-1:0]   key_d, key_q;
  logic [otp_ctrl_pkg::SramNonceWidth-1:0] nonce_d, nonce_q;

  // tie-off unused nonce bits
  if (otp_ctrl_pkg::SramNonceWidth > LfsrWidth + NonceWidth) begin : gen_nonce_tieoff
    logic unused_nonce;
    assign unused_nonce = ^nonce_q[otp_ctrl_pkg::SramNonceWidth-1:LfsrWidth + NonceWidth];
  end

  //////////////////
  // Alert Sender //
  //////////////////

  logic alert_test;
  assign alert_test = reg2hw.alert_test.q & reg2hw.alert_test.qe;

  assign hw2reg.status.bus_integ_error.d  = 1'b1;
  assign hw2reg.status.bus_integ_error.de = |bus_integ_error;

  logic init_error;
  assign hw2reg.status.init_error.d  = 1'b1;
  assign hw2reg.status.init_error.de = init_error;

  logic readback_error;
  assign hw2reg.status.readback_error.d  = 1'b1;
  assign hw2reg.status.readback_error.de = readback_error;

  logic sram_alert;
  assign hw2reg.status.sram_alert.d  = 1'b1;
  assign hw2reg.status.sram_alert.de = sram_alert;

  logic alert_req;
  assign alert_req = (|bus_integ_error) | init_error | readback_error | sram_alert;

  prim_alert_sender #(
    .AsyncOn(AlertAsyncOn[0]),
    .SkewCycles(AlertSkewCycles),
    .IsFatal(1)
  ) u_prim_alert_sender_parity (
    .clk_i,
    .rst_ni,
    .alert_test_i  ( alert_test    ),
    .alert_req_i   ( alert_req     ),
    .alert_ack_o   (               ),
    .alert_state_o (               ),
    .alert_rx_i    ( alert_rx_i[0] ),
    .alert_tx_o    ( alert_tx_o[0] )
  );

  /////////////////////////
  // Escalation Triggers //
  /////////////////////////

  lc_tx_t [1:0] escalate_en;
  prim_lc_sync #(
    .NumCopies (2)
  ) u_prim_lc_sync (
    .clk_i,
    .rst_ni,
    .lc_en_i (lc_escalate_en_i),
    .lc_en_o (escalate_en)
  );

  // SEC_CM: KEY.GLOBAL_ESC
  logic escalate;
  assign escalate = lc_tx_test_true_loose(escalate_en[0]);
  assign hw2reg.status.escalated.d  = 1'b1;
  assign hw2reg.status.escalated.de = escalate;

  // SEC_CM: KEY.LOCAL_ESC
  // Aggregate external and internal escalation sources.
  // This is used in countermeasures further below (key reset and transaction blocking).
  logic local_esc, local_esc_reg;
  // This signal only aggregates registered escalation signals and is used for transaction
  // blocking further below, which is on a timing-critical path.
  assign local_esc_reg = reg2hw.status.escalated.q  |
                         reg2hw.status.init_error.q |
                         reg2hw.status.bus_integ_error.q |
                         reg2hw.status.sram_alert.q |
                         reg2hw.status.readback_error.q;
  // This signal aggregates all escalation trigger signals, including the ones that are generated
  // in the same cycle such as init_error, sram alert, and bus_integ_error. It is used for
  // countermeasures that are not on the critical path (such as clearing the scrambling keys).
  assign local_esc = escalate           |
                     init_error         |
                     (|bus_integ_error) |
                     sram_alert         |
                     readback_error     |
                     local_esc_reg;

  // Convert registered, local escalation sources to a multibit signal and combine this with
  // the incoming escalation enable signal before feeding into the TL-UL gate further below.
  lc_tx_t lc_tlul_gate_en;
  assign lc_tlul_gate_en = lc_tx_inv(lc_tx_or_hi(escalate_en[1],
                                                 lc_tx_bool_to_lc_tx(local_esc_reg)));
  ///////////////////////
  // HW Initialization //
  ///////////////////////

  // A write to the init register reloads the LFSR seed, resets the init counter and
  // sets init_q to flag a pending initialization request.
  logic init_trig, init_q;
  assign init_trig = reg2hw.ctrl.init.q &&
                     reg2hw.ctrl.init.qe &&
                     !init_q; // Ignore new requests while memory init is already pending.

  logic init_d, init_done;
  assign init_d = (init_done) ? 1'b0 :
                  (init_trig) ? 1'b1 : init_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_init_reg
    if(!rst_ni) begin
      init_q <= 1'b0;
    end else begin
      init_q <= init_d;
    end
  end

  // This waits until the scrambling keys are actually valid (this allows the SW to trigger
  // key renewal and initialization at the same time).
  logic init_req;
  logic [AddrWidth-1:0] init_cnt;
  logic key_req_pending_d, key_req_pending_q;
  assign init_req  = init_q & ~key_req_pending_q;
  assign init_done = (init_cnt == AddrWidth'(Depth - 1)) & init_req;

  // We employ two redundant counters to guard against FI attacks.
  // If any of the two is glitched and the two counter states do not agree,
  // we trigger an alert.
  // SEC_CM: INIT.CTR.REDUN
  prim_count #(
    .Width(AddrWidth)
  ) u_prim_count (
    .clk_i,
    .rst_ni,
    .clr_i(init_trig),
    .set_i(1'b0),
    .set_cnt_i('0),
    .incr_en_i(init_req),
    .decr_en_i(1'b0),
    .step_i(AddrWidth'(1)),
    .commit_i(1'b1),
    .cnt_o(init_cnt),
    .cnt_after_commit_o(),
    .err_o(init_error)
  );

  // Clear this bit on local escalation.
  assign hw2reg.status.init_done.d  = init_done & ~init_trig & ~local_esc;
  assign hw2reg.status.init_done.de = init_done | init_trig | local_esc;

  ////////////////////////////
  // Scrambling Key Request //
  ////////////////////////////

  // The scrambling key and nonce have to be requested from the OTP controller via a req/ack
  // protocol. Since the OTP controller works in a different clock domain, we have to synchronize
  // the req/ack protocol as described in more details in the OTP controller documentation.
  //
  // This is specialised for different tops that use it but the req/ack protocol is the same in each
  // case. For one example, see
  //
  // https://opentitan.org/book/hw/top_earlgrey/
  //    ip_autogen/otp_ctrl/doc/interfaces.html#interfaces-to-sram-and-otbn-scramblers
  logic key_req, key_ack;
  assign key_req = reg2hw.ctrl.renew_scr_key.q &&
                   reg2hw.ctrl.renew_scr_key.qe &&
                   !key_req_pending_q && // Ignore new requests while a request is already pending.
                   !init_q; // Ignore new requests while memory init is already pending.

  assign key_req_pending_d = (key_req) ? 1'b1 :
                             (key_ack) ? 1'b0 : key_req_pending_q;

  // Clear this bit on local escalation.
  assign hw2reg.status.scr_key_valid.d   = key_ack & ~key_req & ~local_esc;
  assign hw2reg.status.scr_key_valid.de  = key_req | key_ack | local_esc;

  // As opposed to scr_key_valid, SW is responsible for clearing this register.
  // It is not automatically cleared by HW, except when escalating.
  assign hw2reg.scr_key_rotated.d  = (key_ack & ~local_esc) ? MuBi4True : MuBi4False;
  assign hw2reg.scr_key_rotated.de = key_ack | local_esc;

  // Clear this bit on local escalation.
  logic key_seed_valid;
  assign hw2reg.status.scr_key_seed_valid.d  = key_seed_valid & ~local_esc;
  assign hw2reg.status.scr_key_seed_valid.de = key_ack | local_esc;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      key_req_pending_q <= 1'b0;
      // reset case does not use buffered values as the
      // reset value will be directly encoded into flop types
      key_q             <= RndCnstSramKey;
      nonce_q           <= RndCnstSramNonce;
    end else begin
      key_req_pending_q <= key_req_pending_d;
      if (key_ack) begin
        key_q   <= key_d;
        nonce_q <= nonce_d;
      end
      // This scraps the keys.
      // SEC_CM: KEY.GLOBAL_ESC
      // SEC_CM: KEY.LOCAL_ESC
      if (local_esc) begin
        key_q   <= cnst_sram_key;
        nonce_q <= cnst_sram_nonce;
      end
    end
  end

  prim_sync_reqack_data #(
    .Width($bits(otp_ctrl_pkg::sram_otp_key_rsp_t)-1),
    .DataSrc2Dst(1'b0)
  ) u_prim_sync_reqack_data (
    .clk_src_i  ( clk_i              ),
    .rst_src_ni ( rst_ni             ),
    .clk_dst_i  ( clk_otp_i          ),
    .rst_dst_ni ( rst_otp_ni         ),
    .req_chk_i  ( 1'b1               ),
    .src_req_i  ( key_req_pending_q  ),
    .src_ack_o  ( key_ack            ),
    .dst_req_o  ( sram_otp_key_o.req ),
    .dst_ack_i  ( sram_otp_key_i.ack ),
    .data_i     ( {sram_otp_key_i.key,
                   sram_otp_key_i.nonce,
                   sram_otp_key_i.seed_valid} ),
    .data_o     ( {key_d,
                   nonce_d,
                   key_seed_valid} )
  );

  logic unused_csr_sigs;
  assign unused_csr_sigs = ^{reg2hw.status.init_done.q,
                             reg2hw.status.scr_key_seed_valid.q};

  ////////////////////
  // SRAM Execution //
  ////////////////////

  mubi4_t en_ifetch;
  if (InstrExec) begin : gen_instr_ctrl
    lc_tx_t lc_hw_debug_en;
    prim_lc_sync #(
      .NumCopies (1)
    ) u_prim_lc_sync_hw_debug_en (
      .clk_i,
      .rst_ni,
      .lc_en_i (lc_hw_debug_en_i),
      .lc_en_o ({lc_hw_debug_en})
    );

    mubi8_t otp_en_sram_ifetch;
    prim_mubi8_sync #(
      .NumCopies (1)
    ) u_prim_mubi8_sync_otp_en_sram_ifetch (
      .clk_i,
      .rst_ni,
      .mubi_i(otp_en_sram_ifetch_i),
      .mubi_o({otp_en_sram_ifetch})
    );

    mubi4_t lc_ifetch_en;
    mubi4_t reg_ifetch_en;
    // SEC_CM: INSTR.BUS.LC_GATED
    assign lc_ifetch_en = lc_to_mubi4(lc_hw_debug_en);
    // SEC_CM: EXEC.CONFIG.MUBI
    assign reg_ifetch_en = mubi4_t'(reg2hw.exec.q);
    // SEC_CM: EXEC.INTERSIG.MUBI
    assign en_ifetch = (mubi8_test_true_strict(otp_en_sram_ifetch)) ? reg_ifetch_en :
                                                                      lc_ifetch_en;
  end else begin : gen_tieoff
    assign en_ifetch = MuBi4False;

    // tie off unused signals
    logic unused_sigs;
    assign unused_sigs = ^{lc_hw_debug_en_i,
                           reg2hw.exec.q,
                           otp_en_sram_ifetch_i};
  end

  /////////////////////////
  // Initialization LFSR //
  /////////////////////////

  logic [LfsrOutWidth-1:0] lfsr_out;
  prim_lfsr #(
    .LfsrDw      ( LfsrWidth       ),
    .EntropyDw   ( LfsrWidth       ),
    .StateOutDw  ( LfsrOutWidth    ),
    .DefaultSeed ( RndCnstLfsrSeed ),
    .StatePermEn ( 1'b1            ),
    .StatePerm   ( RndCnstLfsrPerm )
  ) u_lfsr (
    .clk_i,
    .rst_ni,
    .lfsr_en_i(init_req),
    .seed_en_i(init_trig),
    .seed_i(nonce_q[NonceWidth +: LfsrWidth]),
    .entropy_i('0),
    .state_o(lfsr_out)
  );

  // Compute the correct integrity alongside for the pseudo-random initialization values.
  logic [DataWidth - 1 :0] lfsr_out_integ;
  tlul_data_integ_enc u_tlul_data_integ_enc (
    .data_i(lfsr_out),
    .data_intg_o(lfsr_out_integ)
  );

  ////////////////////////////
  // SRAM TL-UL Access Gate //
  ////////////////////////////

  logic tl_gate_resp_pending;
  tlul_pkg::tl_h2d_t ram_tl_in_gated;
  tlul_pkg::tl_d2h_t ram_tl_out_gated;

  // SEC_CM: RAM_TL_LC_GATE.FSM.SPARSE
  tlul_lc_gate #(
    .NumGatesPerDirection(2),
    .Outstanding(Outstanding)
  ) u_tlul_lc_gate (
    .clk_i,
    .rst_ni,
    .tl_h2d_i(ram_tl_i),
    .tl_d2h_o(ram_tl_o),
    .tl_h2d_o(ram_tl_in_gated),
    .tl_d2h_i(ram_tl_out_gated),
    .flush_req_i('0),
    .flush_ack_o(),
    .resp_pending_o(tl_gate_resp_pending),
    .lc_en_i (lc_tlul_gate_en),
    .err_o   (bus_integ_error[2])
  );

  /////////////////////////////////
  // SRAM with scrambling device //
  /////////////////////////////////

  logic tlul_req, tlul_gnt, tlul_we;
  logic [AddrWidth-1:0] tlul_addr;
  logic [DataWidth-1:0] tlul_wdata, tlul_wmask;

  logic sram_intg_error, sram_req, sram_gnt, sram_we, sram_rvalid, sram_rvalid_scr;
  logic [1:0] sram_rerror, sram_rerror_scr;
  logic [AddrWidth-1:0] sram_addr, sram_rerror_addr_scr;
  logic [DataWidth-1:0] sram_wdata, sram_wmask, sram_rdata, sram_rdata_scr;
  logic                 sram_wpending, sram_wr_collision;

  logic sram_compound_txn_in_progress;


  // // SEC_CM: MEM.READBACK
  mubi4_t reg_readback_en;
  assign reg_readback_en = mubi4_t'(reg2hw.readback.q);

  tlul_adapter_sram_racl #(
    .SramAw(AddrWidth),
    .SramDw(DataWidth - tlul_pkg::DataIntgWidth),
    .Outstanding(Outstanding),
    .ByteAccess(1),
    .CmdIntgCheck(1),
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(0),
    .EnableDataIntgPt(1), // SEC_CM: MEM.INTEGRITY
    .SecFifoPtr      (1), // SEC_CM: TLUL_FIFO.CTR.REDUN
    .EnableReadback  (1), // SEC_CM: MEM.READBACK
    .EnableRacl(EnableRacl),
    .RaclErrorRsp(RaclErrorRsp),
    .RaclPolicySelNumRanges(RaclPolicySelNumRangesRam)
  ) u_tlul_adapter_sram_racl (
    .clk_i,
    .rst_ni,
    .tl_i                       (ram_tl_in_gated),
    .tl_o                       (ram_tl_out_gated),
    .en_ifetch_i                (en_ifetch),
    .req_o                      (tlul_req),
    .req_type_o                 (),
    .gnt_i                      (tlul_gnt),
    .we_o                       (tlul_we),
    .addr_o                     (tlul_addr),
    .wdata_o                    (tlul_wdata),
    .wmask_o                    (tlul_wmask),
    // SEC_CM: BUS.INTEGRITY
    .intg_error_o               (bus_integ_error[1]),
    .user_rsvd_o                (),
    .rdata_i                    (sram_rdata),
    .rvalid_i                   (sram_rvalid),
    .rerror_i                   (sram_rerror),
    .compound_txn_in_progress_o (sram_compound_txn_in_progress),
    .readback_en_i              (reg_readback_en),
    .readback_error_o           (readback_error),
    .wr_collision_i             (sram_wr_collision),
    .write_pending_i            (sram_wpending),
    // RACL interface
    .racl_policies_i            (racl_policies_i),
    .racl_error_o               (racl_error[1]),
    .racl_policy_sel_ranges_i   (racl_policy_sel_ranges_ram_i)
  );

  logic key_valid;

  // Interposing mux logic for initialization with pseudo random data.
  assign sram_req        = tlul_req | init_req;
  // This grant signal acts more like a ready internally in tlul_adapter_sram. In particular it's
  // fine to assert it when tlul_req is low (it has no effect). So here tlul_gnt is asserted when
  // a request from tlul_req will be granted regardless of whether a request exists. This is done
  // for timing reasons so that the output TL ready isn't combinatorially connected to the incoming
  // TL valid. In particular we must not use `sram_gnt` in the expression to avoid this.
  assign tlul_gnt        = key_valid & ~init_req;
  assign sram_we         = tlul_we | init_req;
  assign sram_intg_error = |bus_integ_error[2:1] & ~init_req;
  assign sram_addr       = (init_req) ? init_cnt          : tlul_addr;
  assign sram_wdata      = (init_req) ? lfsr_out_integ    : tlul_wdata;
  assign sram_wmask      = (init_req) ? {DataWidth{1'b1}} : tlul_wmask;

  if (EccCorrection) begin : gen_ecc_correction
    // Detect ECC errors and decode data. If data is correctable, data is genuine and we
    // can use it further and re-encode
    logic [31:0] dec_data;
    logic [1:0] ecc_error;
    prim_secded_inv_39_32_dec u_dec (
      .data_i     (sram_rdata_scr),
      .data_o     (dec_data),
      .syndrome_o (),
      .err_o      (ecc_error)
    );

    logic [DataWidth-1:0] ecc_enc_data;
    prim_secded_inv_39_32_enc u_enc (
      .data_i(dec_data),
      .data_o(ecc_enc_data)
    );

    logic uncorrectable_error_q;
    prim_flop #(
      .Width(1)
    ) u_flop_uncorr_error (
      .clk_i,
      .rst_ni,
      .d_i(ecc_error[1]),
      .q_o(uncorrectable_error_q)
    );

    // Correctable errors are corrected.
    // Uncorrectable errors are passed through to the requester.
    assign sram_rerror[0] = 1'b0;
    assign sram_rerror[1] = uncorrectable_error_q;

    // Error log if any error happened
    assign sram_rerror_o.valid   = sram_rvalid_scr & |ecc_error;
    assign ecc_error.correctable = sram_rvalid_scr & ~ecc_error[1];

    // Translate word address to byte address and fill remaining bits with 0
    always_comb begin
      sram_rerror_o.address               = '0;
      sram_rerror_o.address[2+:AddrWidth] = sram_rerror_addr_scr;
    end

    prim_flop #(
      .Width(1)
    ) u_flop_rvalid (
      .clk_i,
      .rst_ni,
      .d_i(sram_rvalid_scr),
      .q_o(sram_rvalid)
    );

    prim_flop #(
      .Width(DataWidth)
    ) u_flop_enc_data (
      .clk_i,
      .rst_ni,
      .d_i(ecc_enc_data),
      .q_o(sram_rdata)
    );

    // We don't use the read error from the prim, we re-compute it here
    logic unused_rerror;
    assign unused_rerror = ^sram_rerror_scr;
  end else begin : gen_no_ecc_correction
    assign sram_rdata  = sram_rdata_scr;
    assign sram_rerror = sram_rerror_scr;
    assign sram_rvalid = sram_rvalid_scr;
    // ECC errors are not detected (and thus not reported either) in this configuration.
    assign sram_rerror_o = '0;

    // Error address not used here
    logic unused_rerror_addr;
    assign unused_rerror_addr = ^sram_rerror_addr_scr;
  end

  // The SRAM scrambling wrapper will not accept any transactions while the
  // key req is pending or if we have escalated. Note that we're not using
  // the scr_key_valid CSR here, such that the SRAM can be used right after
  // reset, where the keys are reset to the default netlist constant.
  //
  // If we have escalated, but there is a pending request in the TL gate, we may have a pending
  // read-modify-write transaction or readback in the SRAM adapter. In that case we force key_valid
  // high to enable that to complete so it returns a response, the TL gate won't accept any new
  // transactions and the SRAM keys have been clobbered already.
  assign key_valid =
    (key_req_pending_q)         ? 1'b0 :
    (reg2hw.status.escalated.q) ? (tl_gate_resp_pending & sram_compound_txn_in_progress) : 1'b1;

  // SEC_CM: MEM.SCRAMBLE, ADDR.SCRAMBLE, PRIM_RAM.CTRL.MUBI
  prim_ram_1p_scr #(
    .Width(DataWidth),
    .Depth(Depth),
    .InstDepth(InstDepth),
    .EnableParity(0),
    .DataBitsPerMask(DataWidth),
    .NumPrinceRoundsHalf(NumPrinceRoundsHalf)
  ) u_prim_ram_1p_scr (
    .clk_i,
    .rst_ni,

    .key_valid_i      (key_valid),
    .key_i            (key_q),
    .nonce_i          (nonce_q[NonceWidth-1:0]),

    .req_i            (sram_req),
    .intg_error_i     (sram_intg_error),
    .gnt_o            (sram_gnt),
    .write_i          (sram_we),
    .addr_i           (sram_addr),
    .wdata_i          (sram_wdata),
    .wmask_i          (sram_wmask),
    .rdata_o          (sram_rdata_scr),
    .rvalid_o         (sram_rvalid_scr),
    .rerror_o         (sram_rerror_scr),
    .raddr_o          (sram_rerror_addr_scr),
    .cfg_i,
    .cfg_rsp_o,
    .wr_collision_o   (sram_wr_collision),
    .write_pending_o  (sram_wpending),
    .alert_o          (sram_alert)
  );

  logic unused_sram_gnt;
  // Ignore sram_gnt signal to avoid creating a bad timing path, see comment on `tlul_gnt` above for
  // more details.
  assign unused_sram_gnt = sram_gnt;

  ////////////////
  // Assertions //
  ////////////////

  `ASSERT_KNOWN(RegsTlOutKnown_A,  regs_tl_o)
  `ASSERT_KNOWN(RamTlOutKnown_A,   ram_tl_o.d_valid)
  `ASSERT_KNOWN_IF(RamTlOutPayLoadKnown_A, ram_tl_o, ram_tl_o.d_valid)
  `ASSERT_KNOWN(AlertOutKnown_A,   alert_tx_o)
  `ASSERT_KNOWN(SramOtpKeyKnown_A, sram_otp_key_o)
  `ASSERT_KNOWN(RaclErrorValidKnown_A, racl_error_o.valid)
  `ASSERT_KNOWN(SramRerrorKnown_A, sram_rerror_o)

  // Alert assertions for redundant counters.
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(CntCheck_A,
      u_prim_count, alert_tx_o[0])
  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(LcGateFsmCheck_A,
      u_tlul_lc_gate.u_state_regs, alert_tx_o[0])

  // Alert assertions for reg_we onehot check.
  `ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(RegWeOnehotCheck_A,
      u_reg_regs, alert_tx_o[0])

  // Alert assertions for redundant counters.
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(RspFifoWptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_rspfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_wptr,
      alert_tx_o[0])
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(RspFifoRptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_rspfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_rptr,
      alert_tx_o[0])
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(SramReqFifoWptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_sramreqfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_wptr,
      alert_tx_o[0])
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(SramReqFifoRptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_sramreqfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_rptr,
      alert_tx_o[0])
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(ReqFifoWptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_reqfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_wptr,
      alert_tx_o[0])
  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(ReqFifoRptrCheck_A,
      u_tlul_adapter_sram_racl.tlul_adapter_sram.u_reqfifo.gen_normal_fifo.u_fifo_cnt
        .gen_secure_ptrs.u_rptr,
      alert_tx_o[0])

  // `tlul_gnt` doesn't factor in `sram_gnt` for timing reasons. This assertions checks that
  // `tlul_gnt` is the same as `sram_gnt` when there's an active `tlul_req` that isn't being ignored
  // because the SRAM is initializing.
  `ASSERT(TlulGntIsCorrect_A, tlul_req |-> (sram_gnt & ~init_req) == tlul_gnt)

endmodule : sram_ctrl
