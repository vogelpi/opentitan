// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES GHASH implementation for AES-GCM
//
// This module implements the GHASH core including hash state and hash key register required for
// AES-GCM.

`include "prim_assert.sv"

module aes_ghash import aes_pkg::*;
#(
  parameter bit         SecMasking   = 0,
  parameter sbox_impl_e SecSBoxImpl  = SBoxImplLut,

  localparam int        NumShares    = SecMasking ? 2 : 1 // derived parameter
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,

  // Input handshake signals
  input  sp2v_e                in_valid_i,
  output sp2v_e                in_ready_o,

  // Output handshake signals
  output sp2v_e                out_valid_o,
  input  sp2v_e                out_ready_i,

  // Control signals
  input  aes_op_e              op_i,
  input  gcm_phase_e           gcm_phase_i,
  input  logic [4:0]           num_valid_bytes_i,
  input  sp2v_e                load_hash_subkey_i,
  input  logic                 alert_fatal_i,
  output logic                 alert_o,

  // Pseudo-random data for register clearing
  input  logic [GCMDegree-1:0] prd_clearing_i [NumShares],

  // I/O data signals
  input  logic [GCMDegree-1:0] cipher_state_init_i [NumShares], // Masked cipher core input
                                                                // For GCM_RESTORE
  input  logic [GCMDegree-1:0] data_in_prev_i,                  // Ciphertext for decryption, AAD
  input  logic [GCMDegree-1:0] data_out_i,                      // Ciphertext for encryption
  input  logic [GCMDegree-1:0] cipher_state_done_i [NumShares], // Masked cipher core output
  output logic [GCMDegree-1:0] ghash_state_done_o [NumShares]
);

  // Parameters
  // The number of cycles must be a power of two and ideally matches the minimum latency of the
  // cipher core which is 56 clock cycles (masked) or 12 clock cycles (unmasked) for AES-128.
  localparam int unsigned GFMultCycles = SecMasking ? 32 : 8;

  // Signals
  logic [GCMDegree-1:0] s_d [NumShares];
  logic [GCMDegree-1:0] s_q [NumShares];
  sp2v_e                s_we;
  s_sel_e               s_sel;
  logic [15:0][7:0]     ghash_in;
  logic [15:0][7:0]     ghash_in_valid;
  ghash_in_sel_e        ghash_in_sel;
  logic [GCMDegree-1:0] ghash_state_d [NumShares];
  logic [GCMDegree-1:0] ghash_state_q [NumShares];
  logic [GCMDegree-1:0] ghash_state_zero [NumShares];
  logic [GCMDegree-1:0] ghash_state_load [NumShares];
  logic [GCMDegree-1:0] ghash_state_add [NumShares];
  sp2v_e                ghash_state_we;
  ghash_state_sel_e     ghash_state_sel;
  logic [GCMDegree-1:0] ghash_state_mult [NumShares];
  logic [GCMDegree-1:0] hash_subkey_d [NumShares];
  logic [GCMDegree-1:0] hash_subkey_q [NumShares];
  sp2v_e                hash_subkey_we;
  hash_subkey_sel_e     hash_subkey_sel;
  logic                 gf_mult_req;
  logic                 gf_mult_ack;
  aes_ghash_e           aes_ghash_ns, aes_ghash_cs;

  ////////////////////
  // S = AES_K(J_0) //
  ////////////////////
  // The initial counter block J_0 encrypted using the encryption key K. For the unmasked
  // implementation this is only used at the very end. For the masked implementaion, it is used
  // multiple times and in various forms throughout the computation of the authentication tag.
  always_comb begin : s_mux
    unique case (s_sel)
      S_LOAD:  s_d = cipher_state_done_i;
      S_CLEAR: s_d = prd_clearing_state_i;
      default: s_d = prd_clearing_state_i;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : s_reg
    if (!rst_ni) begin
      s_q <= '{default: '0};
    end else if (s_we == SP2V_HIGH) begin
      s_q <= s_d;
    end
  end

  /////////////////
  // GHASH Input //
  /////////////////
  // Select the cipher text for encryptio
  always_comb begin : ghash_in_mux
    unique case (ghash_in_sel)
      GHASH_IN_DATA_IN_PREV: ghash_in = data_in_prev_i;
      GHASH_IN_DATA_OUT:     ghash_in = data_out_i;
      GHASH_IN_S:            ghash_in = s_q;
      default:               ghash_in = data_in_prev_i;
    endcase
  end

  // Mask invalid bytes.
  always_comb begin
    for (int i = 0; i < 16; i++) begin
      ghash_in_valid[i] = num_valid_bytes_i > i ? ghash_in[i] : 8'b0;
    end
  end

  /////////////////
  // GHASH State //
  /////////////////
  if (!SecMasking) begin : gen_ghash_state_zero_unmasked
    assign ghash_state_zero[0] = '0;
  end else begin : gen_ghash_state_zero_unmasked
    assign ghash_state_zero[0] = prd_clearing_i[1];
    assign ghash_state_zero[1] = prd_clearing_i[1];
  end

  // Add the GHASH input to the current state.
  assign ghash_state_add[0] = ghash_state_q[0] ^ ghash_in_valid;
  if (SecMasking) begin : gen_ghash_state_share_1
    assign ghash_state_add[1] = ghash_state_q[1];
    assign ghash_state_mult[1] = ghash_state_q[1];
  end

  always_comb begin : ghash_state_mux
    unique case (ghash_state_sel)
      GHASH_STATE_RESTORE: ghash_state_d = cipher_state_init_i;
      GHASH_STATE_ZERO:    ghash_state_d = ghash_state_zero;
      GHASH_STATE_ADD:     ghash_state_d = ghash_state_add;
      GHASH_STATE_MULT:    ghash_state_d = ghash_state_mult;
      GHASH_STATE_CLEAR:   ghash_state_d = prd_clearing_i;
      default:             ghash_state_d = prd_clearing_i;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : ghash_state_reg
    if (!rst_ni) begin
      ghash_state_q <= '{default: '0};
    end else if (ghash_state_we == SP2V_HIGH) begin
      ghash_state_q <= ghash_state_d;
    end
  end

  /////////////////
  // Hash Subkey //
  /////////////////
  always_comb begin : hash_subkey_mux
    unique case (hash_subkey_sel)
      HASH_SUBKEY_LOAD:  hash_subkey_d = cipher_state_done_i;
      HASH_SUBKEY_CLEAR: hash_subkey_d = prd_clearing_i;
      default:           hash_subkey_d = prd_clearing_i;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : hash_subkey_reg
    if (!rst_ni) begin
      hash_subkey_q <= '{default: '0};
    end else if (hash_subkey_we == SP2V_HIGH) begin
      hash_subkey_q <= hash_subkey_d;
    end
  end

  //////////////////////////
  // GF(2^128) Multiplier //
  //////////////////////////

  prim_gf_mult #(
    .Width         (GCMDegree),
    .StagesPerCycle(GCMDegree / 8),
    .IPoly         (GCMIPoly),
  ) u_gf_mult (
    .clk_i (clk_i),
    .rst_ni(rst_ni),

    .req_i(gf_mult_req),
    .ack_o(gf_mult_ack),

    .operand_a_i(ghash_state_q[0]), // The A input is scanned.
    .operand_b_i(hash_subkey_q[0]), // The B input is not scanned.

    .prod_o(ghash_state_mult[0])
  );

  /////////////////
  // Control FSM //
  /////////////////

  always_comb begin : aes_ghash_fsm

    // Handshake signals
    in_ready_o  = SP2V_LOW;
    out_valid_o = SP2V_LOW;

    // Data path
    s_sel = S_CLEAR;
    s_we  = SP2V_LOW;

    ghash_in_sel = GHASH_IN_DATA_IN_PREV;

    ghash_state_sel = GHASH_STATE_CLEAR;
    ghash_state_we  = SP2V_LOW;

    hash_subkey_sel = HASH_SUBKEY_CLEAR;
    hash_subkey_we  = SP2V_LOW;

    gf_mult_req = 1'b0;

    // FSM
    aes_ghash_ns = aes_ghash_cs;

    // Alert
    alert_o = 1'b0;

    unique case (aes_ghash_cs)

      // load key: input handshake only
      //           - wait for GHASH ready in main FSM state after CTRL_PRNG_UPDATE
      // load s: input handshake only
      //         - wait for GHASH ready in main FSM state after CTRL_PRNG_UPDATE
      // aad: add + mult, handshake between main FSM and GHASH only, no cipher op
      //          - wait for GHASH ready in main FSM state after CTRL_PRNG_UPDATE
      //          - perform handshake similar as for decrypt
      // encrypt: add + mult, handshake between main FSM, cipher and GHASH
      //          - don't wait for GHASH ready in main FSM IDLE
      //          - wait for GHASH ready in main FSM FINISH, use finish signal
      //            ghash_ready -> ghash_valid, can wait in cycle before FINISH
      //            by adding a new state after CTRL_PRNG_UPDATE, before CTRL_FINISH
      //            we know that GHASH will be ready to consume the cipher output in the next cycle
      // decrypt: add + mult, handshake between main FSM, cipher and GHASH
      //          - wait for GHASH ready in main FSM FINISH, use finish signal
      //            ghash_ready -> ghash_valid, can wait in cycle before FINISH
      //            by adding a new state after CTRL_PRNG_UPDATE, perform before CTRL_FINISH
      // save & tag: wait for GHASH ready after CTRL_PRNG_UPDATE, clear internal state with output handshake
      //             - output handshake in CTRL FINISH
      // clear: input handshake only
      //        - wait for GHASH ready in main FSM state after CTRL_PRNG_UPDATE

      GHASH_IDLE: begin
        in_ready_o = SP2V_HIGH;
        if (in_valid_i == SP2V_HIGH) begin
          if (clear_i) begin
            // Clearing has highest priority.
            s_we            = SP2V_HIGH;
            ghash_state_we  = SP2V_HIGH;
            hash_subkey_sel = SP2V_HIGH;

          end else if (gcm_phase_i == GCM_INIT) begin
            if (load_hash_subkey_i == SP2V_HIGH) begin
              // Load the hash subkey and zero the state.
              hash_subkey_sel = HASH_SUBKEY_LOAD;
              hash_subkey_we  = SP2V_HIGH;
              ghash_state_sel = GHASH_STATE_ZERO;
              ghash_state_we  = SP2V_HIGH;
            end else begin
              // Load S.
              s_sel = S_LOAD;
              s_we  = SP2V_HIGH;
            end

          end else if (gcm_phase_i == GCM_RESTORE) begin
            // Restore a previously loaded GHASH state.
            ghash_state_sel = GHASH_STATE_RESTORE;
            ghash_state_we  = SP2V_HIGH;

          end else if (gcm_phase_i == GCM_AAD ||
                       gcm_phase_i == GCM_TEXT ||
                       gcm_phase_i == GCM_LEN) begin
            // Select the proper input for the addition.
            ghash_in_sel    =
                (gcm_phase_i == GCM_AAD)                     ? GHASH_IN_DATA_IN_PREV :
                (gcm_phase_i == GCM_TEXT && op_i == AES_DEC) ? GHASH_IN_DATA_IN_PREV :
                (gcm_phase_i == GCM_TEXT && op_i == AES_ENC) ? GHASH_IN_DATA_OUT     :
                (gcm_phase_i == GCM_LEN)                     ? GHASH_IN_DATA_OUT     :
                                                               GHASH_IN_DATA_IN_PREV;

            // Add the current input to the GHASH state to start the multiplication in the next
            // clock cycle.
            ghash_state_sel = GHASH_STATE_ADD;
            ghash_state_we  = SP2V_HIGH;

            aes_ghash_ns = GHASH_MULT;

          end else if (gcm_phase_i == GCM_SAVE) begin
            // Get ready to output the current GHASH state.
            aes_ghash_ns = GHASH_OUT;

          end else if (gcm_phase_i == GCM_TAG) begin
            // Add S to the GHASH state and then get ready to output the final tag.
            ghash_in_sel    = GHASH_IN_S;
            ghash_state_sel = GHASH_STATE_ADD;
            ghash_state_we  = SP2V_HIGH;

            aes_ghash_ns = GHASH_OUT;
          end else begin
            // Handshake without a valid command. We should never get here. If we do (e.g. via a
            // malicious glitch), error out immediately.
            aes_ghash_ns = GHASH_ERROR;
          end
        end
      end

      GHASH_MULT: begin
        // Perform the multiplication and update the state.
        gf_mult_req = 1'b1;
        if (gf_mult_ack) begin
          ghash_state_sel = GHASH_STATE_MULT;
          ghash_state_we  = SP2V_HIGH;
          aes_ghash_ns    = GHASH_IDLE;
        end
      end

      GHASH_OUT: begin
        // Perform output handshake and clear all internal state with pseudo-random data.
        out_valid_o = SP2V_HIGH;
        if (out_ready_i == SP2V_HIGH) begin
          s_we            = SP2V_HIGH;
          ghash_state_we  = SP2V_HIGH;
          hash_subkey_sel = SP2V_HIGH;
          aes_ghash_ns    = GHASH_IDLE;
        end
      end

      GHASH_ERROR: begin
        // Terminal error state
        alert_o = 1'b1;
      end

      // We should never get here. If we do (e.g. via a malicious glitch), error out immediately.
      default: begin
        aes_ghash_ns = GHASH_ERROR;
        alert_o = 1'b1;
      end
    endcase

    // Unconditionally jump into the terminal error state if a fatal alert has been triggered.
    if (alert_fatal_i) begin
      aes_ghash_ns = GHASH_ERROR;
    end
  end

  // SEC_CM: GHASH.FSM.SPARSE
  `PRIM_FLOP_SPARSE_FSM(u_state_regs, aes_ghash_ns,
      aes_ghash_cs, aes_ghash_e, GHASH_IDLE)

  /////////////
  // Outputs //
  /////////////

  assign ghash_state_done_o = ghash_state_q;

endmodule
