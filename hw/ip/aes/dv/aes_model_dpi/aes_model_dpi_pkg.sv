// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package aes_model_dpi_pkg;
  import aes_pkg::*;

  // DPI-C imports
  import "DPI-C" context function void c_dpi_aes_crypt_block(
    input  bit                impl_i,    // 0 = C model, 1 = OpenSSL/BoringSSL
    input  bit                op_i,      // 0 = encrypt, 1 = decrypt
    input  bit          [6:0] mode_i,    // 7'b000_0001 = ECB, 7'000_b0010 = CBC, 7'b000_0100 = CFB,
                                         // 7'b000_1000 = OFB, 7'b001_0000 = CTR, 7'b010_0000 = GCM,
                                         // 7'b100_0000 = NONE
    input  bit[3:0][3:0][7:0] iv_i,
    input  bit          [2:0] key_len_i, // 3'b001 = 128b, 3'b010 = 192b, 3'b100 = 256b
    input  bit    [7:0][31:0] key_i,
    input  bit[3:0][3:0][7:0] data_i,
    input  bit[3:0][3:0][7:0] aad_i,
    input  bit[3:0][3:0][7:0] tag_i,
    output bit[3:0][3:0][7:0] data_o,
    output bit[3:0][3:0][7:0] tag_o
  );

  import "DPI-C" context function void c_dpi_aes_crypt_message(
    input  bit              impl_i,    // 0 = C model, 1 = OpenSSL/BoringSSL
    input  bit              op_i,      // 0 = encrypt, 1 = decrypt
    input  bit        [6:0] mode_i,    // 7'b000_0001 = ECB, 7'000_b0010 = CBC, 7'b000_0100 = CFB,
                                       // 7'b000_1000 = OFB, 7'b001_0000 = CTR, 7'b010_0000 = GCM,
                                       // 7'b100_0000 = NONE
    input  bit  [3:0][31:0] iv_i,
    input  bit        [2:0] key_len_i, // 3'b001 = 128b, 3'b010 = 192b, 3'b100 = 256b
    input  bit  [7:0][31:0] key_i,
    input  bit        [7:0] data_i[],
    input  bit        [7:0] aad_i[],
    input  bit  [3:0][31:0] tag_i,
    output bit        [7:0] data_o[],
    output bit  [3:0][31:0] tag_o
  );

  import "DPI-C" context function void c_dpi_aes_sub_bytes(
    input  bit                op_i, // 0 = encrypt, 1 = decrypt
    input  bit[3:0][3:0][7:0] data_i,
    output bit[3:0][3:0][7:0] data_o
  );

  import "DPI-C" context function void c_dpi_aes_shift_rows(
    input  bit                op_i, // 0 = encrypt, 1 = decrypt
    input  bit[3:0][3:0][7:0] data_i,
    output bit[3:0][3:0][7:0] data_o
  );

  import "DPI-C" context function void c_dpi_aes_mix_columns(
    input  bit                op_i, // 0 = encrypt, 1 = decrypt
    input  bit[3:0][3:0][7:0] data_i,
    output bit[3:0][3:0][7:0] data_o
  );

  import "DPI-C" context function void c_dpi_aes_key_expand(
    input  bit            op_i,      // 0 = encrypt, 1 = decrypt
    input  bit      [7:0] rcon_i,
    input  bit      [3:0] round_i,
    input  bit      [2:0] key_len_i, // 3'b001 = 128b, 3'b010 = 192b, 3'b100 = 256b
    input  bit[7:0][31:0] key_i,
    output bit[7:0][31:0] key_o
  );

  // wrapper function that converts from register format (4x32bit)
  // to the 4x4x8 format of the c functions and back
  // this ensures that RTL and refence models have same input and output format.
  function automatic void sv_dpi_aes_crypt_block(
    input  bit             impl_i,    // 0 = C model, 1 = OpenSSL/BoringSSL
    input  bit             op_i,      // 0 = encrypt, 1 = decrypt
    input  bit       [6:0] mode_i,    // 7'b000_0001 = ECB, 7'000_b0010 = CBC, 7'b000_0100 = CFB,
                                      // 7'b000_1000 = OFB, 7'b001_0000 = CTR, 7'b010_0000 = GCM,
                                      // 7'b100_0000 = NONE
    input  bit [3:0][31:0] iv_i,
    input  bit       [2:0] key_len_i, // 3'b001 = 128b, 3'b010 = 192b, 3'b100 = 256b
    input  bit [7:0][31:0] key_i,
    input  bit [3:0][31:0] data_i,
    input  bit [3:0][31:0] aad_i,
    input  bit [3:0][31:0] tag_i,
    output bit [3:0][31:0] data_o,
    output bit [3:0][31:0] tag_o);

    bit [3:0][3:0][7:0] iv_in, data_in, aad_in, tag_in, data_out, tag_out;
    data_in = aes_transpose({<<8{data_i}});
    aad_in = aes_transpose({<<8{aad_i}});
    tag_in = aes_transpose({<<8{tag_i}});
    iv_in   = aes_transpose(iv_i);
    key_i   = {<<8{key_i}};
    c_dpi_aes_crypt_block(impl_i, op_i, mode_i, iv_in, key_len_i, key_i, data_in, aad_in, tag_in,
      data_out, tag_out);
    data_o  = aes_transpose(data_out);
    data_o  = {<<8{data_o}};
    tag_o  = aes_transpose(tag_out);
    tag_o  = {<<8{tag_o}};
    return;
  endfunction // sv_dpi_aes_crypt_block
endpackage
