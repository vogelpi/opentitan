// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// basic smoke test vseq
class ${module_instance_name}_smoke_vseq extends ${module_instance_name}_base_vseq;
  `uvm_object_utils(${module_instance_name}_smoke_vseq)

  `uvm_object_new

  rand bit [NUM_ALERT_CLASSES-1:0]                       intr_en;
  rand bit [NUM_ALERT_CLASSES-1:0]                       clr_regwen;
  rand bit [NUM_ALERT_CLASSES-1:0]                       class_regwen;
  rand bit [NUM_ALERT_CLASSES-1:0]                       clr_en;
  rand bit [NUM_ALERT_CLASSES-1:0]                       lock_bit_en;
  rand bit [NUM_ALERT_CLASSES-1:0]                       class_en;
  rand bit [NUM_ALERTS-1:0]                              alert_regwen;
  rand bit [NUM_ALERTS-1:0]                              alert_trigger;
  rand bit [NUM_ALERTS-1:0]                              alert_int_err;
  rand bit [NUM_ALERTS-1:0]                              alert_en;
  rand bit [NUM_ALERTS-1:0]                              alert_ping_timeout;
  rand bit [NUM_ALERTS-1:0][NUM_ALERT_CLASSES-1:0]       alert_class_map;
  rand bit [NUM_LOCAL_ALERTS-1:0]                        local_alert_regwen;
  rand bit [NUM_LOCAL_ALERTS-1:0]                        local_alert_en;
  rand bit [NUM_LOCAL_ALERTS-1:0][NUM_ALERT_CLASSES-1:0] local_alert_class_map;
  rand bit [NUM_ESCS-1:0]                                esc_int_err;
  rand bit [NUM_ESCS-1:0]                                esc_standalone_int_err;
  rand bit [NUM_ESCS-1:0]                                esc_ping_timeout;

  rand bit ping_timer_regwen;
  rand bit do_clr_esc;
  rand bit do_wr_phases_cyc;
  rand bit do_esc_intr_timeout;
  rand bit do_lock_config;
  rand bit [TL_DW-1:0] ping_timeout_cyc;
  rand bit [TL_DW-1:0] max_phase_cyc;
  rand bit [TL_DW-1:0] intr_timeout_cyc [NUM_ALERT_CLASSES];
  rand bit [TL_DW-1:0] accum_thresh     [NUM_ALERT_CLASSES];

  int max_wait_phases_cyc = MIN_CYCLE_PER_PHASE * NUM_ESC_PHASES;
  int max_intr_timeout_cyc;

  uvm_verbosity verbosity = UVM_LOW;

  constraint lock_bit_c {
    do_lock_config dist {1 := 1, 0 := 49};
  }

  constraint clr_and_lock_en_c {
    lock_bit_en dist {0 :/ 6, [1:'b1111] :/ 4};
  }

  constraint regwen_c {
    clr_regwen         dist {[0:'1-1'b1] :/ 4, '1 :/ 6};
    class_regwen       dist {[0:'1-1'b1] :/ 4, '1 :/ 6};
    alert_regwen       dist {[0:'1-1'b1] :/ 4, '1 :/ 6};
    local_alert_regwen dist {[0:'1-1'b1] :/ 4, '1 :/ 6};
    ping_timer_regwen  dist { 0 :/ 4         ,  1 :/ 6};
  }

  constraint enable_one_alert_c {
    $onehot(alert_en);
  }

  constraint max_phase_cyc_c {
    max_phase_cyc inside {[0:1_000]};
  }

  // Set min to 120 cycles to avoid alert ping timeout due to random delay.
  // The max delay after ping request is 10 cycles plus 2 cycles async delay.
  // Also the alert_sender and alert_handlers are in different clock domains, with a max 10 times
  // difference in clock frequency.
  constraint ping_timeout_cyc_c {
    ping_timeout_cyc inside {[120:MAX_PING_TIMEOUT_CYCLE]};
  }

  constraint enable_classa_only_c {
    alert_class_map == 0; // all the alerts assign to classa
    local_alert_class_map == 0; // all local alerts assign to classa
    class_en dist {1 :/ 8, 0 :/ 1, [2:'1-1'b1] :/ 1};
  }

  // constraint to trigger escalation
  constraint esc_accum_thresh_c {
    foreach (accum_thresh[i]) {soft accum_thresh[i] inside {[0:1]};}
  }

  constraint esc_intr_timeout_c {
    foreach (intr_timeout_cyc[i]) {intr_timeout_cyc[i] inside {[1:1_000]};}
  }

  constraint sig_int_c {
    alert_int_err          == 0;
    esc_int_err            == 0;
    esc_standalone_int_err == 0;
  }

  constraint ping_fail_c {
    alert_ping_timeout == 0;
    esc_ping_timeout   == 0;
  }

   task pre_start();
    super.pre_start();
    // This is the input for a nonblocking sequence. The value won't be changed until the
    // nonblockings sequence end.
    esc_ping_timeout.rand_mode(0);
    esc_int_err.rand_mode(0);
  endtask

  task body();
    fork
      begin : isolation_fork
        trigger_non_blocking_seqs();
        run_smoke_seq();
        disable fork; // disable non-blocking seqs for stress_all tests
      end // end fork
    join
  endtask : body

  virtual task trigger_non_blocking_seqs();
    `uvm_info(`gfn, $sformatf("esc_int_err %0h esc_ping_timeout %0h",
              esc_int_err, esc_ping_timeout), UVM_LOW);
    run_esc_rsp_seq_nonblocking(esc_int_err, esc_ping_timeout);
  endtask

  virtual task run_smoke_seq();
    `uvm_info(`gfn, $sformatf("num_trans=%0d", num_trans), UVM_LOW)
    if (verbosity != UVM_LOW) begin
      `uvm_info(`gfn,
          $sformatf("Config: intr_en=%0b, alert=%0b, alert_en=%0b, loc_alert_en=%0b",
          intr_en, alert_trigger, alert_en, local_alert_en), UVM_LOW)
    end

    for (int i = 1; i <= num_trans; i++) begin
      `DV_CHECK_RANDOMIZE_FATAL(this)

      // Assign ping timeout value to each alert agent.
      foreach (cfg.alert_host_cfg[i]) cfg.alert_host_cfg[i].ping_timeout = alert_ping_timeout[i];

      `uvm_info(`gfn, $sformatf(
          "start seq %0d/%0d: intr_en=0x%0h, alert=0x%0h, alert_en=0x%0h, loc_alert_en=0x%0h",
          i, num_trans, intr_en, alert_trigger, alert_en, local_alert_en), verbosity)

      // write initial settings (enable and mapping csrs)
      alert_handler_init(.intr_en(intr_en),
                         .alert_en(alert_en),
                         .alert_class(alert_class_map),
                         .loc_alert_en(local_alert_en),
                         .loc_alert_class(local_alert_class_map));

      // write class_ctrl
      alert_handler_rand_wr_class_ctrl(lock_bit_en, class_en);

      // randomize crashdump triggered phases
      alert_handler_crashdump_phases();

      // randomly write phase cycle registers
      // always set phase_cycle for the first iteration, in order to pass stress_all test
      if (do_wr_phases_cyc || i == 1) wr_phases_cycle(max_phase_cyc);

      // randomly write interrupt timeout resigers and accumulative threshold registers
      if (do_esc_intr_timeout) wr_intr_timeout_cycle(intr_timeout_cyc);
      wr_class_accum_threshold(accum_thresh);
      wr_ping_timeout_cycle(ping_timeout_cyc);

      // when all configuration registers are set, write lock register
      lock_config(do_lock_config);

      // once all above configs are written, lock them with regwen
      alert_handler_wr_regwen_regs(clr_regwen, alert_regwen, local_alert_regwen, ping_timer_regwen,
                                   class_regwen);

      // if config is not locked, update max_intr_timeout and max_wait_phases cycles
      if (!config_locked) begin
        bit [TL_DW-1:0] max_intr_timeout_cyc;
        bit [TL_DW-1:0] max_q[$] = intr_timeout_cyc.max();
        max_intr_timeout_cyc = max_q[0];
        max_wait_phases_cyc = max2(max_wait_phases_cyc, max_phase_cyc * NUM_ESC_PHASES);
        if (do_lock_config) config_locked = 1;
      end

      // drive esc standalone responses and alerts
      if (esc_standalone_int_err) drive_esc_rsp(esc_standalone_int_err);
      drive_alert(alert_trigger, alert_int_err);

      if (do_esc_intr_timeout) begin
        cfg.clk_rst_vif.wait_clks(max_intr_timeout_cyc);
        // this task checks three sets of registers related to alert/esc status:
        // alert_accum_cnt, esc_cnt, class_state
        read_esc_status();
      end
      // only check interrupt when no esc_int_err, otherwise clear interrupt might happen the
      // same cycle as interrupt triggered by esc_int_err
      if ((esc_int_err == 0) && (esc_ping_timeout == 0)) check_alert_interrupts();

      // if ping timeout enabled, wait for ping timeout done before checking escalation phases
      if ((esc_int_err | alert_ping_timeout) > 0) begin
        cfg.clk_rst_vif.wait_clks(MAX_PING_TIMEOUT_CYCLE);
      end

      // wait escalation done, and random interrupt with clear_esc
      wait_alert_esc_done();

      read_alert_cause();
      read_esc_status();
      if (do_clr_esc) clear_esc();
      check_alert_interrupts();
    end
  endtask

  virtual task wait_alert_esc_done();
    wait_alert_handshake_done();
    if ($urandom_range(0, 1) && (esc_int_err == 0)) begin
      cfg.clk_rst_vif.wait_clks($urandom_range(0, max_wait_phases_cyc));
      clear_esc();
    end
    wait_esc_handshake_done();
  endtask

endclass : ${module_instance_name}_smoke_vseq
