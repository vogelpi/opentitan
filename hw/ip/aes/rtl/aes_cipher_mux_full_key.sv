// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES cipher core full key register mux

// Prevent Vivado from performing optimizations on/across this module.
(* DONT_TOUCH = "yes" *)
module aes_cipher_mux_full_key import aes_pkg::*;
(
  input  logic             clk_i,
  input  logic             rst_ni,
  input  sp2v_e            key_full_we_i,
  input  key_full_sel_e    key_full_sel_i,
  input  logic [7:0][31:0] key_init_i,
  input  logic [7:0][31:0] key_dec_i,
  input  logic [7:0][31:0] key_expand_out_i,
  input  logic     [255:0] prd_clearing_256_i,
  output logic [7:0][31:0] key_full_o
);

  logic [7:0][31:0] key_full_d;
  logic [7:0][31:0] key_full_q;

  always_comb begin : key_full_mux
    unique case (key_full_sel_i)
      KEY_FULL_ENC_INIT: key_full_d = key_init_i;
      KEY_FULL_DEC_INIT: key_full_d = key_dec_i;
      KEY_FULL_ROUND:    key_full_d = key_expand_out_i;
      KEY_FULL_CLEAR:    key_full_d = prd_clearing_256_i;
      default:           key_full_d = prd_clearing_256_i;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : key_full_reg
    if (!rst_ni) begin
      key_full_q <= '{default: '0};
    end else if (key_full_we_i == SP2V_HIGH) begin
      key_full_q <= key_full_d;
    end
  end

  assign key_full_o = key_full_q;

endmodule
