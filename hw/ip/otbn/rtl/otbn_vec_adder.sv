// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * OTBN vectorized adder block for the bignum vector instruction subset
 *
 * This adder opperates elementwise on two 256-bit vectors which contain 256b / ELEN elements
 * of bitsize ELEN.
 * It is based upon 16 adders which can be carry-chained depending on the element width.
 * For each adder there is a separate carry in and is handled as LSB. Thus the adder performs a
 * 17th bit addition. The output is truncated accordingly.
 *
 * To perform subtraction the input B can inverted and all carries must be set to 1 as:
 *    a - b = a + ~b + 1
 *
 * The carry outs are directly from each adder and are independent of the element length.
 * Selecting the appropriate carry for each element must be handled by the processing entity.
 *
 * Blanking is not applied to the datapath and must be handled in the module using this adder.
 * However, the carry propagation MUX control signals must be provided from the parent module
 * as these must be blankable / these signals may not glitch during operation.
 *
 * A0 = A[15:0], A1 = [31:16], ..., A15 = A[255:240], same for B
 *
 *  {A15,1}  B15       cin[15]          {A1,1}   B1        cin[1]    {A0,1}  B0         cin[0]
 *      |     |            |               |     |            |        |     |            |
        |     |  +----+    |               |     |  +----+    |        |     |  +---------+
        |     |  |    |    |               |     |  |    |    |        |     |  |
        |   +------+  | /|-+               |   +------+  | /|-+        |   +------+
        |   |  {}  |  +-||                 |   |  {}  |  +-||          |   |  {}  |
        |   +------+  | \|-+               |   +------+  | \|-+        |   +------+
        |       |     |    |               |       |     |    |        |       |
 *    +----------------+   |              +----------------+  |       +----------------+
 *  +-|    Adder 15    |   +-  .....    +-|    Adder  1    |  +-----+-|    Adder  0    |
 *  | +----------------+                | +----------------+        | +----------------+
 *  |         |                         |         |                 |         |
 *  |      [16:1]                       |      [16:1]               |      [16:1]
 *  |         |                         |         |                 |         |
 * cout[15]   |                       cout[1]     |               cout[0]     |
 *            |                                   |                           |
 *       sum[255:240]                        sum[31:16]                   sum[15:0]
 */


module otbn_vec_adder
  import otbn_pkg::*;
(
  input  logic [VLEN-1:0]     operand_a_i,
  input  logic [VLEN-1:0]     operand_b_i,
  input  logic                operand_b_invert_i,
  input  logic [NVecProc-1:0] carries_in_i,
  input  logic [NVecProc-1:0] use_ext_carry_i, // controls the carry propagation
  output logic [VLEN-1:0]     sum_o,
  output logic [NVecProc-1:0] carries_out_o
);
  logic [NVecProc-1:0][VChunkLEN+1:0] adders_res;
  logic [NVecProc-1:0]                adders_carry_out;

  for (genvar i_adder = 0; i_adder < NVecProc; i_adder++) begin : g_adders
    logic [VChunkLEN-1:0] op_a;
    logic [VChunkLEN:0]   adder_op_a;
    logic [VChunkLEN-1:0] op_b;
    logic [VChunkLEN:0]   adder_op_b;
    logic                 prev_carry_out;
    logic                 carry_in;

    // Select the carry in depending on the ELEN. Take previous stage or external carry
    assign prev_carry_out = i_adder == 0 ? carries_in_i[0] : adders_carry_out[i_adder - 1];
    assign carry_in = use_ext_carry_i[i_adder] ? carries_in_i[i_adder] : prev_carry_out;

    // Extract and preprocess the operands
    assign op_a = operand_a_i[i_adder*VChunkLEN+:VChunkLEN];
    assign op_b = operand_b_invert_i ? ~operand_b_i[i_adder*VChunkLEN+:VChunkLEN]
                                     :  operand_b_i[i_adder*VChunkLEN+:VChunkLEN];

    // Do the addition and update carry flag
    assign adder_op_a = {op_a, 1'b1};
    assign adder_op_b = {op_b, carry_in};

    assign adders_res[i_adder] = adder_op_a + adder_op_b;
    assign adders_carry_out[i_adder] = adders_res[i_adder][VChunkLEN+1];

    // The LSB is unused
    logic unused_adder_res_lsb;
    assign unused_adder_res_lsb = adders_res[i_adder][0];
  end

  // Assign result and carries to outputs
  for (genvar i_adder = 0; i_adder < NVecProc; i_adder++) begin : g_assign_outputs
    assign sum_o[i_adder*VChunkLEN+:VChunkLEN] = adders_res[i_adder][VChunkLEN:1];
    assign carries_out_o[i_adder] = adders_carry_out[i_adder];
  end
endmodule
