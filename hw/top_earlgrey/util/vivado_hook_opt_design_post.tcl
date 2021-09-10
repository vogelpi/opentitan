# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Hook to check BRAM implementation for Boot ROM. This is required for Boot ROM splicing.
send_msg "Designcheck 2-1" INFO "Checking if Boot ROM is mapped to BRAM."

if {[catch [get_cells -hierarchical -filter { NAME =~  "*u_rom_ctrl*u_rom*rdata_o_reg_0" && PRIMITIVE_TYPE =~ BMEM.*.* }]]\
 && [catch [get_cells -hierarchical -filter { NAME =~  "*u_rom_ctrl*u_rom*rdata_o_reg_1" && PRIMITIVE_TYPE =~ BMEM.*.* }]]\
 && [catch [get_cells -hierarchical -filter { NAME =~  "*u_rom_ctrl*u_rom*rdata_o_reg_2" && PRIMITIVE_TYPE =~ BMEM.*.* }]]\
 && [catch [get_cells -hierarchical -filter { NAME =~  "*u_rom_ctrl*u_rom*rdata_o_reg_3" && PRIMITIVE_TYPE =~ BMEM.*.* }]]\
 && [catch [get_cells -hierarchical -filter { NAME =~  "*u_rom_ctrl*u_rom*rdata_o_reg_4" && PRIMITIVE_TYPE =~ BMEM.*.* }]] } {
  send_msg "Designcheck 2-2" INFO "BRAM implementation found for Boot ROM."
} else {
  send_msg "Designcheck 2-3" ERROR "BRAM implementation not found for Boot ROM."
}

# Force replication of some high fanout nets.
set_property -name {FORCE_MAX_FANOUT} -value {400} -objects [get_nets {top_earlgrey/u_otbn/u_imem/u_prim_ram_1p_adv/u_mem/gen_generic.u_impl_generic/rf_bignum_wr_addr[*]}]
