// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//==================================================
// This file contains the Excluded objects
// Generated By User: gdessouky
// Format Version: 2
// Date: Wed Aug  7 13:33:09 2024
// ExclMode: default
//==================================================
CHECKSUM: "3387628951 1792109872"
INSTANCE: tb.dut.u_reg.u_wake_events_cdc.u_src_to_dst_req
ANNOTATION: "VC_COV_UNR"
Condition 1 "2359369666" "(src_level ^ src_pulse_i) 1 -1" (3 "10")
CHECKSUM: "2629070671 4199846824"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_in_pe
ANNOTATION: "VC_COV_UNR"
Condition 8 "2275772612" "((in_xact_state == StSendData) && tx_data_get_i) 1 -1" (1 "01")
CHECKSUM: "3215070453 3446030929"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_sramreqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Block 19 "4019242409" "wptr_wrap_cnt_q <= (wptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
ANNOTATION: "VC_COV_UNR"
Block 28 "1113085816" "rptr_wrap_cnt_q <= (rptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
CHECKSUM: "3215070453 3446030929"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_rspfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Block 19 "4019242409" "wptr_wrap_cnt_q <= (wptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
ANNOTATION: "VC_COV_UNR"
Block 28 "1113085816" "rptr_wrap_cnt_q <= (rptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
CHECKSUM: "3215070453 3446030929"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_reqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Block 19 "4019242409" "wptr_wrap_cnt_q <= (wptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
ANNOTATION: "VC_COV_UNR"
Block 28 "1113085816" "rptr_wrap_cnt_q <= (rptr_wrap_cnt_q + {{(WrapPtrW - 1) {1'b0}}, 1'b1});"
CHECKSUM: "2422748304 4058302001"
INSTANCE: tb.dut.usbdev_impl.u_usbdev_linkstate
ANNOTATION: "VC_COV_UNR"
Block 45 "3824467478" "link_state_d = LinkDisconnected;"
ANNOTATION: "VC_COV_UNR"
Block 64 "1515454339" "link_rst_state_d = NoRst;"
ANNOTATION: "VC_COV_UNR"
Block 83 "3162102996" "link_inac_state_d = Active;"
CHECKSUM: "3366248665 2379607661"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_tx
ANNOTATION: "VC_COV_UNR"
Block 50 "2865494160" "state_d = Idle;"
ANNOTATION: "VC_COV_UNR"
Block 84 "1129912420" "out_state_d = OsIdle;"
CHECKSUM: "1206032831 4011300726"
INSTANCE: tb.dut.usbdev_impl
ANNOTATION: "VC_COV_UNR"
Block 22 "3369720822" "wdata_d[7:0] = out_ep_data;"
CHECKSUM: "2629070671 675897418"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_in_pe
ANNOTATION: "VC_COV_UNR"
Block 34 "2490421007" "in_xact_state_next = StWaitAckStart;"
ANNOTATION: "VC_COV_UNR"
Block 52 "2498383491" "in_xact_state_next = StIdle;"
CHECKSUM: "2829124083 2534056014"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_out_pe
ANNOTATION: "VC_COV_UNR"
Block 59 "2995797590" "out_xact_state_next = StIdle;"
CHECKSUM: "1249231444 3329409487"
INSTANCE: tb.dut.u_reg.u_wake_events_cdc
ANNOTATION: "VC_COV_UNR"
Condition 1 "2345700748" "((src_busy_q && src_ack) || (src_update && ((!busy)))) 1 -1" (3 "10")
ANNOTATION: "VC_COV_UNR"
Condition 2 "833137803" "(src_busy_q && src_ack) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 2 "833137803" "(src_busy_q && src_ack) 1 -1" (3 "11")
ANNOTATION: "VC_COV_UNR"
Condition 3 "566298183" "(src_update && ((!busy))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 5 "2123224275" "(src_busy_q & ((!src_ack))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 5 "2123224275" "(src_busy_q & ((!src_ack))) 1 -1" (3 "11")
CHECKSUM: "2629070671 2432947071"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_in_pe
Fsm in_xact_state "2432947071"
ANNOTATION: "VC_COV_UNR"
Transition StSendData->StWaitAckStart "2->4"
CHECKSUM: "2551375121 3386447066"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_rx
ANNOTATION: "VC_COV_UNR"
Condition 15 "3993770507" "(token_payload_done && pkt_is_token) 1 -1" (2 "10")
CHECKSUM: "2422748304 1897192179"
INSTANCE: tb.dut.usbdev_impl.u_usbdev_linkstate
ANNOTATION: "VC_COV_UNR"
Condition 2 "4200481268" "(see_pwr_sense & usb_pullup_en_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "4200481268" "(see_pwr_sense & usb_pullup_en_i) 1 -1" (2 "10")
CHECKSUM: "4228571573 631566033"
INSTANCE: tb.dut
ANNOTATION: "VC_COV_UNR"
Condition 26 "711018649" "(reg2hw.rxfifo.ep.re | reg2hw.rxfifo.setup.re | reg2hw.rxfifo.size.re | reg2hw.rxfifo.buffer.re) 1 -1" (2 "0001")
ANNOTATION: "VC_COV_UNR"
Condition 26 "711018649" "(reg2hw.rxfifo.ep.re | reg2hw.rxfifo.setup.re | reg2hw.rxfifo.size.re | reg2hw.rxfifo.buffer.re) 1 -1" (3 "0010")
ANNOTATION: "VC_COV_UNR"
Condition 26 "711018649" "(reg2hw.rxfifo.ep.re | reg2hw.rxfifo.setup.re | reg2hw.rxfifo.size.re | reg2hw.rxfifo.buffer.re) 1 -1" (4 "0100")
ANNOTATION: "VC_COV_UNR"
Condition 26 "711018649" "(reg2hw.rxfifo.ep.re | reg2hw.rxfifo.setup.re | reg2hw.rxfifo.size.re | reg2hw.rxfifo.buffer.re) 1 -1" (5 "1000")
ANNOTATION: "VC_COV_UNR"
Condition 30 "4133145744" "(reg2hw.out_data_toggle.status.qe & reg2hw.out_data_toggle.mask.qe) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 30 "4133145744" "(reg2hw.out_data_toggle.status.qe & reg2hw.out_data_toggle.mask.qe) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 31 "251117446" "(reg2hw.in_data_toggle.status.qe & reg2hw.in_data_toggle.mask.qe) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 31 "251117446" "(reg2hw.in_data_toggle.status.qe & reg2hw.in_data_toggle.mask.qe) 1 -1" (2 "10")
CHECKSUM: "1746381268 1271541636"
INSTANCE: tb.dut.u_reg.u_socket
ANNOTATION: "VC_COV_UNR"
Condition 3 "118253128" "(tl_t_o.a_valid & tl_t_i.a_ready) 1 -1" (1 "01")
CHECKSUM: "74367784 3785313510"
INSTANCE: tb.dut.u_reg.u_reg_if
ANNOTATION: "VC_COV_UNR"
Condition 18 "3340270436" "(addr_align_err | malformed_meta_err | tl_err | instr_error | intg_error) 1 -1" (5 "01000")
CHECKSUM: "2815520955 4109606122"
INSTANCE: tb.dut.u_reg.u_wake_events_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 7 "2602167579" "(dst_update_i & (dst_qs_o != dst_ds_i)) 1 -1" (1 "01")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_intr_state_pkt_received
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_intr_state_pkt_sent
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_intr_state_av_out_empty
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_intr_state_rx_full
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_intr_state_av_setup_empty
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_wake_events_module_active
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_wake_events_disconnected
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_wake_events_bus_reset
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "4255502330 3274445021"
INSTANCE: tb.dut.u_reg.u_wake_events_bus_not_idle
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "2203170140 405589182"
INSTANCE: tb.dut.u_ctr_out
ANNOTATION: "VC_COV_UNR"
Condition 2 "274091365" "((ep_i < 4'(NEndpoints)) ? endpoints[ep_i] : 1'b0) 1 -1" (1 "0")
CHECKSUM: "2203170140 405589182"
INSTANCE: tb.dut.u_ctr_in
ANNOTATION: "VC_COV_UNR"
Condition 2 "274091365" "((ep_i < 4'(NEndpoints)) ? endpoints[ep_i] : 1'b0) 1 -1" (1 "0")
CHECKSUM: "2203170140 405589182"
INSTANCE: tb.dut.u_ctr_nodata_in
ANNOTATION: "VC_COV_UNR"
Condition 2 "274091365" "((ep_i < 4'(NEndpoints)) ? endpoints[ep_i] : 1'b0) 1 -1" (1 "0")
CHECKSUM: "2203170140 3717373046"
INSTANCE: tb.dut.u_ctr_errors
ANNOTATION: "VC_COV_UNR"
Condition 1 "2105047783" "(((|((ev_enables & event_i) & (~event_q)))) & ep_enabled) 1 -1" (2 "10")
CHECKSUM: "3576666508 1200292870"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram
ANNOTATION: "VC_COV_UNR"
Condition 4 "3638058042" "(rspfifo_rdata.error | reqfifo_rdata.error) 1 -1" (3 "10")
ANNOTATION: "VC_COV_UNR"
Condition 8 "3066913128" "(intg_error | rsp_fifo_error | sramreqfifo_error | reqfifo_error | intg_error_q) 1 -1" (2 "00001")
ANNOTATION: "VC_COV_UNR"
Condition 21 "3623514242" "(d_valid & reqfifo_rvalid & rspfifo_rvalid & (reqfifo_rdata.op == OpRead)) 1 -1" (1 "0111")
ANNOTATION: "VC_COV_UNR"
Condition 21 "3623514242" "(d_valid & reqfifo_rvalid & rspfifo_rvalid & (reqfifo_rdata.op == OpRead)) 1 -1" (2 "1011")
ANNOTATION: "VC_COV_UNR"
Condition 21 "3623514242" "(d_valid & reqfifo_rvalid & rspfifo_rvalid & (reqfifo_rdata.op == OpRead)) 1 -1" (4 "1110")
ANNOTATION: "VC_COV_UNR"
Condition 24 "1059982851" "(vld_rd_rsp & ((~d_error))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 25 "2807788926" "((vld_rd_rsp && reqfifo_rdata.error) ? error_blanking_integ : (vld_rd_rsp ? rspfifo_rdata.data_intg : prim_secded_pkg::SecdedInv3932ZeroEcc)) 1 -1" (2 "1")
ANNOTATION: "VC_COV_UNR"
Condition 26 "561780173" "(vld_rd_rsp && reqfifo_rdata.error) 1 -1" (3 "11")
ANNOTATION: "VC_COV_UNR"
Condition 34 "201396280" "(d_valid && d_error) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 35 "3680494467" "((gnt_i | missed_err_gnt_q) & reqfifo_wready & sramreqfifo_wready & sramreqaddrfifo_wready) 1 -1" (3 "1101")
ANNOTATION: "VC_COV_UNR"
Condition 37 "2164803938" "(tl_i_int.a_valid & reqfifo_wready & ((~error_internal))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 43 "721931741" "(rvalid_i & reqfifo_rvalid) 1 -1" (2 "10")
ANNOTATION: "vcs_gen_start:i=0:vcs_gen_end:VC_COV_UNR"
Condition 47 "1163750833" "(((|wmask_intg)) & ((|wdata_intg))) 1 -1" (1 "01")
CHECKSUM: "7115036 2825631531"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_sramreqfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "7115036 2432857915"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_rspfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 6 "4208363759" "(gen_normal_fifo.fifo_empty && wvalid_i) 1 -1" (1 "01")
CHECKSUM: "7115036 3660765074"
INSTANCE: tb.dut.usbdev_avsetupfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "7115036 3660765074"
INSTANCE: tb.dut.usbdev_avoutfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "7115036 3923796707"
INSTANCE: tb.dut.usbdev_rxfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "7115036 3923796707"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_reqfifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 3 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 4 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "3643792208 1147758610"
INSTANCE: tb.dut.u_reg.u_wake_events_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "3215070453 33318353"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_reqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Condition 1 "2532211833" "(incr_wptr_i & (wptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "2597027294" "(incr_rptr_i & (rptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 8 "1599734576" "((wptr_wrap_msb == rptr_wrap_msb) ? ((1'(wptr_o) - 1'(rptr_o))) : (((1'(Depth) - 1'(rptr_o)) + 1'(wptr_o)))) 1 -1" (1 "0")
ANNOTATION: "VC_COV_UNR"
Condition 9 "446195871" "(wptr_wrap_msb == rptr_wrap_msb) 1 -1" (1 "0")
CHECKSUM: "3215070453 33318353"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_sramreqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Condition 1 "2532211833" "(incr_wptr_i & (wptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "2597027294" "(incr_rptr_i & (rptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 8 "1599734576" "((wptr_wrap_msb == rptr_wrap_msb) ? ((1'(wptr_o) - 1'(rptr_o))) : (((1'(Depth) - 1'(rptr_o)) + 1'(wptr_o)))) 1 -1" (1 "0")
ANNOTATION: "VC_COV_UNR"
Condition 9 "446195871" "(wptr_wrap_msb == rptr_wrap_msb) 1 -1" (1 "0")
CHECKSUM: "3215070453 33318353"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_rspfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Condition 1 "2532211833" "(incr_wptr_i & (wptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 3 "2597027294" "(incr_rptr_i & (rptr_o == 1'((Depth - 1)))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 8 "1599734576" "((wptr_wrap_msb == rptr_wrap_msb) ? ((1'(wptr_o) - 1'(rptr_o))) : (((1'(Depth) - 1'(rptr_o)) + 1'(wptr_o)))) 1 -1" (1 "0")
ANNOTATION: "VC_COV_UNR"
Condition 9 "446195871" "(wptr_wrap_msb == rptr_wrap_msb) 1 -1" (1 "0")
CHECKSUM: "2629070671 1575945479"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_in_pe
ANNOTATION: "VC_COV_UNR"
Branch 1 "631187576" "in_xact_state" (7) "in_xact_state StSendData ,-,-,-,-,1,0,1,-,-,-,-,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 1 "631187576" "in_xact_state" (20) "in_xact_state default,-,-,-,-,-,-,-,-,-,-,-,-,-,-"
CHECKSUM: "2829124083 11221466"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_nb_out_pe
ANNOTATION: "VC_COV_UNR"
Branch 3 "1318794972" "out_xact_state" (17) "out_xact_state default,-,-,-,-,-,-,-,-,-,-,-,-"
CHECKSUM: "3366248665 981789331"
INSTANCE: tb.dut.usbdev_impl.u_usb_fs_nb_pe.u_usb_fs_tx
ANNOTATION: "VC_COV_UNR"
Branch 6 "3692372780" "state_q" (18) "state_q default,-,-,-,-,-,-,-,-,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 12 "3476938316" "out_state_q" (6) "out_state_q default,-,-,-"
CHECKSUM: "1206032831 770330853"
INSTANCE: tb.dut.usbdev_impl
ANNOTATION: "VC_COV_UNR"
Branch 8 "87426669" "out_ep_put_addr[1:0]" (4) "out_ep_put_addr[1:0] default"
CHECKSUM: "2422748304 2960503212"
INSTANCE: tb.dut.usbdev_impl.u_usbdev_linkstate
ANNOTATION: "VC_COV_UNR"
Branch 1 "2905358650" "((!see_pwr_sense) || (!usb_pullup_en_i))" (2) "((!see_pwr_sense) || (!usb_pullup_en_i)) 0,LinkDisconnected ,0,-,-,-,-,-,-,-,-,-,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 1 "2905358650" "((!see_pwr_sense) || (!usb_pullup_en_i))" (21) "((!see_pwr_sense) || (!usb_pullup_en_i)) 0,default,-,-,-,-,-,-,-,-,-,-,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 3 "2411977692" "link_rst_state_q" (8) "link_rst_state_q default,-,-,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 5 "1387831816" "link_inac_state_q" (8) "link_inac_state_q default,-,-,-,-,-"
CHECKSUM: "1746381268 3161287359"
INSTANCE: tb.dut.u_reg.u_socket
ANNOTATION: "VC_COV_UNR"
Branch 4 "3202860295" "(!rst_ni)" (2) "(!rst_ni) 0,1,0,-"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_intr_state_pkt_received
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_intr_state_pkt_sent
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_intr_state_av_out_empty
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_intr_state_rx_full
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_intr_state_av_setup_empty
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_wake_events_module_active
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_wake_events_disconnected
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_wake_events_bus_reset
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "4255502330 3554514034"
INSTANCE: tb.dut.u_reg.u_wake_events_bus_not_idle
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "2203170140 3043321356"
INSTANCE: tb.dut.u_ctr_out
ANNOTATION: "VC_COV_UNR"
Branch 0 "2609099084" "(ep_i < 4'(NEndpoints))" (1) "(ep_i < 4'(NEndpoints)) 0"
CHECKSUM: "2203170140 3043321356"
INSTANCE: tb.dut.u_ctr_in
ANNOTATION: "VC_COV_UNR"
Branch 0 "2609099084" "(ep_i < 4'(NEndpoints))" (1) "(ep_i < 4'(NEndpoints)) 0"
CHECKSUM: "2203170140 3043321356"
INSTANCE: tb.dut.u_ctr_nodata_in
ANNOTATION: "VC_COV_UNR"
Branch 0 "2609099084" "(ep_i < 4'(NEndpoints))" (1) "(ep_i < 4'(NEndpoints)) 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1367129303" "(!rst_ni)" (4) "(!rst_ni) 0,-,0"
CHECKSUM: "2203170140 521126612"
INSTANCE: tb.dut.u_ctr_errors
ANNOTATION: "VC_COV_UNR"
Branch 0 "1367129303" "(!rst_ni)" (2) "(!rst_ni) 0,0,-"
CHECKSUM: "3576666508 1924774061"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram
ANNOTATION: "VC_COV_UNR"
Branch 2 "1058271942" "(vld_rd_rsp && reqfifo_rdata.error)" (0) "(vld_rd_rsp && reqfifo_rdata.error) 1,-"
CHECKSUM: "3215070453 1827096802"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_reqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Branch 0 "721764659" "full_o" (2) "full_o 0,0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "2417346495" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
ANNOTATION: "VC_COV_UNR"
Branch 2 "456961687" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
CHECKSUM: "3215070453 1827096802"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_sramreqfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Branch 0 "721764659" "full_o" (2) "full_o 0,0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "2417346495" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
ANNOTATION: "VC_COV_UNR"
Branch 2 "456961687" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
CHECKSUM: "3215070453 1827096802"
INSTANCE: tb.dut.gen_no_stubbed_memory.u_tlul2sram.u_rspfifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Branch 0 "721764659" "full_o" (2) "full_o 0,0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "2417346495" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
ANNOTATION: "VC_COV_UNR"
Branch 2 "456961687" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
