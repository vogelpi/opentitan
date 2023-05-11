// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES cipher core full key register mux

// Prevent Vivado from performing optimizations on/across this module.
(* DONT_TOUCH = "yes" *)
module aes_cipher_mux_full_key import aes_pkg::*;
(
  input  key_full_sel_e    key_full_sel_i,
  input  logic [7:0][31:0] key_init_i,
  input  logic [7:0][31:0] key_dec_i,
  input  logic [7:0][31:0] key_expand_out_i,
  input  logic     [255:0] prd_clearing_256_i,
  output logic [7:0][31:0] key_full_o
);

  always_comb begin : key_full_mux
    unique case (key_full_sel_i)
      KEY_FULL_ENC_INIT: key_full_o = key_init_i;
      KEY_FULL_DEC_INIT: key_full_o = key_dec_i;
      KEY_FULL_ROUND:    key_full_o = key_expand_out_i;
      KEY_FULL_CLEAR:    key_full_o = prd_clearing_256_i;
      default:           key_full_o = prd_clearing_256_i;
    endcase
  end

endmodule
