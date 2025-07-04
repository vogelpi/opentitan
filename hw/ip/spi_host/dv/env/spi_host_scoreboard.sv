// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class spi_host_scoreboard extends cip_base_scoreboard #(
    .CFG_T(spi_host_env_cfg),
    .RAL_T(spi_host_reg_block),
    .COV_T(spi_host_env_cov)
  );
  `uvm_component_utils(spi_host_scoreboard)
  `uvm_component_new

  virtual spi_if  spi_vif;

  // TLM fifos hold the transactions sent from monitor
  uvm_tlm_analysis_fifo #(spi_item) plain_data_fifo;

  // hold expected transactions
  spi_segment_item                  host_wr_segment;
  spi_segment_item                  host_rd_segment;
  spi_item                          plain_item;

  // local variables
  // queues hold expected read and write transactions issued by tl_ul
  local spi_segment_item            write_segment_q[$];
  // Just a data queue, not any other fields from spi_segment_item apart from
  // 'spi_segment_item.spi_data' are used.
  local spi_segment_item            read_segment_q[$];
  local bit [7:0]                   rx_data_q[$];
  // state of the last segment CSAAT field. It's used to check CSB lines behaved correctly
  // after each segment:
  local bit                         csaat = 0;
  // The configured half period in ps on the SPI bus
  local int                         spi_clk_half_period;

  // interrupt bit vector
  local bit [NumSpiHostIntr-1:0]    intr_state = 2'b00;
  local bit [NumSpiHostIntr-1:0]    intr_enable = 2'b00;
  local bit [NumSpiHostIntr-1:0]    intr_test = 2'b00;

  // Capture DUT register contents during TL accesses
  // > Mostly used for coverage.
  local spi_host_command_t          spi_cmd_reg;
  local spi_host_ctrl_t             spi_ctrl_reg;
  local spi_host_status_t           spi_status_reg;
  local spi_host_error_enable_t     spi_error_enable_reg;
  local spi_host_error_status_t     spi_error_status_reg;
  local spi_host_event_enable_t     spi_event_enable_reg;
  local spi_host_intr_state_t       spi_intr_state_reg;
  local spi_host_intr_enable_t      spi_intr_enable_reg;
  local spi_host_intr_test_t        spi_intr_test_reg;
  // Holds latest written value
  spi_host_configopts_t             spi_configopts;
  // Holds value modelling FSM in case reg is re-configured during in-flight spi txn
  spi_host_configopts_t             curr_spi_configopts;
  // Flag used to control when 'curr_spi_configopts' is updated in case there is a SPI-txn
  // in flight when the configopts register is written
  bit                               initialise_configopts = 1;

  // Tally-Counters
  int                               in_tx_seg_cnt      = 0;
  int                               checked_tx_seg_cnt = 0;
  int                               in_rx_seq_cnt      = 0;
  int                               checked_rx_seq_cnt = 0;
  // flag used used for SB when spi tx data is programmed later than command
  local bit commit_exp_txn_at_txfifo_write = 0;
  // events
  event event_sw_rst;


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    plain_data_fifo  = new("plain_data_fifo", this);
    host_wr_segment = spi_segment_item::type_id::create("host_wr_segment");
    host_rd_segment = spi_segment_item::type_id::create("host_rd_segment");
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // cfg.en_scb currently does not change mid-test
    wait (cfg.en_scb == 1);
    forever begin
      wait(cfg.clk_rst_vif.rst_n && !spi_ctrl_reg.sw_rst);
      // Wait until CSB signal has the enable set
      wait (cfg.spi_passthrough_vif.cio_csb_en_o === 1);
      `DV_SPINWAIT_EXIT(
        fork
          compare_tx_trans();
          compare_rx_trans();
          get_plain_txn();
          check_csn_lead();
          check_csn_idle();
        join,
        @(negedge cfg.clk_rst_vif.rst_n or event_sw_rst)
      )
      `uvm_info(`gfn, "Restarting scoreboard checking due to reset event now.", UVM_LOW)
    end
  endtask : run_phase

  // Checks the minimum time between commands CSB stays high - which should equate
  // to configopts.csnidle + 1
  virtual task check_csn_idle();
    int unsigned time_high, time_low;
    int unsigned quarter_period;
    int unsigned num_quarter_cycles;

    `uvm_info(`gfn, $sformatf("%m - After reset"), UVM_DEBUG)
    forever begin

      wait (spi_ctrl_reg.sw_rst === 0);
      @(posedge cfg.m_spi_agent_cfg.vif.csb[0]);

      if (cfg.force_spi_fsm_vif.fast_mode == 1)
        continue;
      // Using quarter period for greater granularity
      num_quarter_cycles = (curr_spi_configopts.csnidle + 1) * 2;
      quarter_period = spi_clk_half_period / 2;
      // Spec says 'configot.idle' is the minimum amount of half SCK cycles before the next command
      for(int i = 0; i < num_quarter_cycles; i++) begin
        #(quarter_period * 1ps);
        if (cfg.m_spi_agent_cfg.vif.csb[0] === 0) begin
          `uvm_error(`gfn, {$sformatf("(CONFIGOPTS.csnidle*2=%0d) > %0d 1/4 cycles since CSB=0x1.",
                                      num_quarter_cycles, i),
                            "... and CSB has just being deasserted which is against the spec"})
        end
      end
      // After the time above, is ok for the RTL to set CSB low anytime
    end // forever begin
  endtask : check_csn_idle


  virtual task check_csn_lead();
    time start_time, end_time;
    int unsigned quarter_period;

    `uvm_info(`gfn, $sformatf("%m - After reset and CSB output enable"), UVM_DEBUG)
    // Just a delay to ensure the X -> set/unset in clock is not detected after
    // 'cio_csb_en_o' just becomes active.
    cfg.clk_rst_vif.wait_clks(1);

    // Threads set timestamps of moments in which CSB became active and first spi cycle.
    // We then check the amount of spi half cycles isn't greater than the CSNLEAD register value
    forever begin
      @(negedge cfg.m_spi_agent_cfg.vif.csb[0]);
      `uvm_info(`gfn, "CSB went low", UVM_DEBUG)
      if (cfg.force_spi_fsm_vif.fast_mode == 1)
        continue;
      fork : iso_fork
        begin
          fork
            begin
              start_time = $time;
              `uvm_info(`gfn, $sformatf("%m - NEGEDGE of CSB"), UVM_DEBUG)
              @(posedge cfg.m_spi_agent_cfg.vif.csb[0]);
              `uvm_info(`gfn, $sformatf("%m - POSEDGE of CSB: exiting thread"), UVM_DEBUG)
            end
            begin
              wait_start_sck_edge();
              // Wait a quarter period to ensure the sampled CSB value is correct with no races
              quarter_period = spi_clk_half_period / 2;
              #(quarter_period * 1ps);
              end_time = $time;
              `uvm_info(`gfn, $sformatf("%m - After clock tick. Exiting thread"), UVM_DEBUG)
            end
          join_any
          disable fork;
        end
      join  : iso_fork

      // Only interested for cases where there's been SCK cycles with the chip select being active
      if (end_time > start_time) begin
        int unsigned actual_clk_ticks = (end_time - start_time) / spi_clk_half_period;
        if (actual_clk_ticks > (curr_spi_configopts.csnlead + 1)) begin
          `uvm_fatal(`gfn, {"Since CSB become active, There's been",
                            $sformatf(" %0d half SCKs ",
                                      (end_time - start_time) / spi_clk_half_period ),
                            $sformatf("VS (configopts.csnlead+1)=%0d",
                                      curr_spi_configopts.csnlead + 1)})
        end
      end
      else
        `uvm_fatal(`gfn, "SPI Clock was ticking before CSB went low")

    end
  endtask : check_csn_lead

  // SPI clock may "tick", as in being set to 0/1 depending on phase/polarity settings
  // The clock driven in neg-edge if phase != polarity
  task wait_start_sck_edge();
    if (spi_configopts.cpol == spi_configopts.cpha)
      @(negedge cfg.m_spi_agent_cfg.vif.sck);
    else
      @(posedge cfg.m_spi_agent_cfg.vif.sck);
  endtask

  // RX spi raw txn. The monitor sampled the spi bus raw, and the data gets decoded in
  // 'compare_tx_trans' according to the segment configuration.
  virtual task get_plain_txn();
    forever begin
      plain_data_fifo.get(plain_item);
      // Each time CSB goes low, SCB receives a "plain data txn"
      `uvm_info(`gfn, $sformatf("Received: plain_item=\n%s", plain_item.sprint), UVM_DEBUG)
    end
  endtask : get_plain_txn

  // Receives spi_segment_item - this is then compared with the value on the bus which is extracted
  // in compare_tx_trans
  virtual task compare_rx_trans();
    spi_segment_item   tl_segment = spi_segment_item::type_id::create("tl_segment");
    string             txt = "";
    bit [7:0]          read_data;

    forever begin
      wait (read_segment_q.size() > 0);
      tl_segment = read_segment_q.pop_front();
      // always read 4 bytes that is the minimum read size
      txt = "\n\t byte      SPI Bus     TL Bus";
      if (rx_data_q.size == 0)
        `uvm_fatal(`gfn, "'rx_data_q.size' is empty - hence can't compare TXN")
      for ( int i = 0; i < 4; i++) begin
        read_data = rx_data_q.pop_back();
        if (read_data != tl_segment.spi_data[i]) begin
          txt = {txt, $sformatf("\n \t [%0d] \t %2h \t %2h",
                                i, read_data, tl_segment.spi_data[i])};
          `uvm_fatal(`gfn,
                     $sformatf("\n\tREAD:  SPI bus data %0h did not match TL data %0h \n len %d %s",
                              read_data, tl_segment.spi_data[i], tl_segment.command_reg.len+1, txt))
        end else begin
          txt = {txt, $sformatf("\n \t [%0d] \t %2h \t %2h", i,
                                read_data, tl_segment.spi_data[i])};
        end
      end
      `uvm_info(`gfn, $sformatf("\n successfully compared read transaction of %d ",
                                tl_segment.command_reg.len+1), UVM_DEBUG)
    end // forever begin
  endtask : compare_rx_trans

  virtual task  extract_data_for_segment(spi_host_command_t  command_info,
                                         output bit[7:0] host_data, output bit [7:0] device_data);
    bit [3:0] bus_cycle;
    int unsigned idx, loop_jump;

    if (plain_item == null)
      `uvm_fatal(`gfn, "Something's wrong: 'plain_item =  null'")

    case (command_info.direction)
      None: begin
        wait(plain_item.plain_data_q.size >= 1);
        `uvm_info(`gfn,
                  $sformatf("Dummy_cycle: Popping 1 item from 'plain_item.plain_data_q': \n%s",
                            plain_item.sprint),
                  UVM_DEBUG)
        void'(plain_item.plain_data_q.pop_front());
      end
      default: begin
        // RX/TX/Bidir
        case (command_info.mode)
          // Comparison against TX/RX fifo is carried out on a per-byte basis:
          Standard : loop_jump = 1;
          Dual     : loop_jump = 2;
          Quad     : loop_jump = 4;
          default  : `uvm_fatal(`gfn, $sformatf("Wrong command.speed: %s",command_info.mode.name()))
        endcase // case (command_info.mode)
        wait(plain_item.plain_data_q.size >= (8 / loop_jump) );

        for (int i = 0; i < 8; i = i + loop_jump) begin
          bit bit_dir = (command_info.direction != RxOnly ?
                         cfg.m_spi_agent_cfg.host_bit_dir : cfg.m_spi_agent_cfg.device_bit_dir);
          idx = bit_dir ? i : (7 - i);

          bus_cycle = plain_item.plain_data_q.pop_front();
          case (command_info.mode)
            Standard: begin
              host_data[idx]   = bus_cycle[0];
              device_data[idx] = bus_cycle[1];
            end
            Dual: begin
              host_data[idx -: 2] = bus_cycle[1:0];
              device_data[idx -: 2] = bus_cycle[1:0];
            end
            Quad: begin
              host_data[idx -: 4] = bus_cycle[3:0];
              device_data[idx -: 4] = bus_cycle[3:0];
            end
            default: `uvm_fatal(`gfn, "Command.mode = Reserved")
          endcase
        end

        `uvm_info(`gfn, $sformatf("[%s] - Extracted byte-> host: 0x%0x | device: 0x%0x",
                                  command_info.mode.name, host_data, device_data), UVM_DEBUG)
      end
    endcase

  endtask : extract_data_for_segment

  // Receives spi_segment_item - this is then compared with the value on the bus which is extracted
  // If the written segment's direction is RxOnly or Bidir, this then also populate the `rx_data_q`
  // for further RX comparison in compare_rx_trans
  virtual task compare_tx_trans();
    spi_segment_item   exp_segment = spi_segment_item::type_id::create("exp_segment");

    // indication that this is a new transaction
    string             txt = "";
    bit [7:0]          host_data, device_data, extracted_data;

    forever begin
      // Get predicted item
      wait (write_segment_q.size > 0);
      exp_segment = write_segment_q.pop_front();
      in_tx_seg_cnt += 1;
      // get bytes from the spi monitor
      txt = "\n\t byte      actual     expected";
      for (int i=0; i < exp_segment.command_reg.len+1; i++) begin

        wait(&cfg.m_spi_agent_cfg.vif.csb == 0);
        // After the sampling edge the plain_item should've been populated
        cfg.m_spi_agent_cfg.wait_sck_edge(SamplingEdge, cfg.m_spi_agent_cfg.vif.get_active_csb());

        // Extract data based on segment: task below blocks if data has not yet been fully sampled
        extract_data_for_segment(exp_segment.command_reg, host_data, device_data);

        // process tx part of the transaction
        if (exp_segment.command_reg.direction inside {TxOnly, Bidir}) begin
          if (host_data != exp_segment.spi_data[i]) begin
            txt = {txt, $sformatf("\n \t [%d] \t\t\t      %0h  \t\t\t %0h",
                                  i, host_data, exp_segment.spi_data[i])};
            `uvm_fatal(`gfn,
                       $sformatf("\n\t WRITE: actual data did not match exp data \n len %d %s",
                                 exp_segment.command_reg.len+1, txt))
          end else begin
            txt = {txt, $sformatf("\n \t [%d] \t\t\t %0h \t\t\t %0h",
                                  i, host_data, exp_segment.spi_data[i])};
          end
        end

        // process rx part of transaction
        // sorting step - will drop everything that is not stored in rx fifo
        if (exp_segment.command_reg.direction inside {RxOnly, Bidir}) begin
          rx_data_q.push_front(device_data);
        end
      end // for (int i=0; i < exp_segment.command_reg.len+1; i++)
      // zero-pad bytes to complete 32 bytes rx fifo read
      if ((exp_segment.command_reg.direction inside {RxOnly, Bidir})
          && ((exp_segment.command_reg.len+1)%4 != 0)) begin
        for (int n=0; n<(4-(exp_segment.command_reg.len+1)%4); n++) begin
          rx_data_q.push_front(8'h00);
        end
      end

      // store CSAAT so we now if we are starting a new transaction
      csaat = exp_segment.command_reg.csaat;

      // Disable checks due to the internal counter being increased more quickly
      if (cfg.force_spi_fsm_vif.fast_mode == 0) begin
        fork
          begin
            check_csaat(.csaat(csaat));
          end
        join_none
      end
      // update number of ok segments
      checked_tx_seg_cnt += 1;
      `uvm_info(`gfn, $sformatf("\n successfully compared write transaction of %d ",
                                exp_segment.command_reg.len+1), UVM_HIGH)


    end // forever begin
  endtask : compare_tx_trans

  // This task checks if the CSB line matches the value written in the command (command.csaat
  // negated).
  // Spec states the number of half cycles will be 'curr_spi_configopts.csntrail + 1'
  // we add extra 1 because depending on phase and polarity, the monitor sometimes sends data
  // 1/2 cycle earlier.
  // 'num_times' is scaled to account for sys_clk cycles (plus 1 extra), otherwise the check may
  // miss some spi_en or stalling conditions if the spi_clk is too slow.
  //
  // Note: Only 1 csb line is currently supported, hence checks reference csb as "vif.CSB[0]"
  virtual task check_csaat(bit csaat);
    int num_times = ((curr_spi_configopts.csntrail + 1 + 1) *
                      (curr_spi_configopts.clkdiv + 1)) + 1;
    spi_host_status_t status;
    `uvm_info(`gfn, $sformatf("%m - carrying out CSAAT (%0d) check", csaat), UVM_DEBUG)

    fork begin : iso_fork
      fork
        begin : csntrail_check
          bit stall_flag;
          // The loop below waits for configopts.csntrail spi half cycles (accounted as their
          // corresponding sys cycles) to see if the CSB line goes up as expected based on
          // the command.CSAAT
          for (int i=0; i < num_times; i++) begin
            // Backdoor read to see if the RTL is stalling due to TX / RX buffer being
            // empty / full respectively
            csr_rd(.ptr(ral.status), .value(status), .backdoor(1'b1));

            if (spi_ctrl_reg.spien==0) begin
              // IF control.Spien unset, we block until the block is re-enabled
              `uvm_info(`gfn, $sformatf("%m - Blocked at spien"), UVM_DEBUG)
              wait (spi_ctrl_reg.spien === 1);
              if (i > 0) begin
                // Taking an extra cycle if we're blocked during spien
                // Otherwise, if spien=0x1 mid spi-cycle then we may fail the CSB check
                stall_flag = 1;
              end
            end
            else if (status.txstall || status.rxstall) begin
              // If we're stalling we ignore the current clock cycle
              stall_flag = 1;
              `uvm_info(`gfn, { "SPI processing is stalled: ",
                        $sformatf("status.txstall=%0d, status.rxstall=%0d",
                                  status.txstall, status.rxstall)}, UVM_DEBUG)
            end

            if (cfg.m_spi_agent_cfg.vif.csb[0] !== csaat) begin
              break;
            end
            // Consuming the delays programmed into configopts.CSNTRAIL as a factor of sys cycles
            cfg.clk_rst_vif.wait_clks(1);

            if (stall_flag)
              i--; // Ignoring current clk_cycle when stalling (due to spien=0 or tx/rxstall flags)
          end

          csr_rd(.ptr(ral.status), .value(status), .backdoor(1'b1));

          if (spi_ctrl_reg.spien === 0) begin
            wait (spi_ctrl_reg.spien === 1);
            // Extra delay if spien=0, just to allow for CSB to become 1
            #(spi_clk_half_period/2 * 1ps);
          end
          // We just delay by 1/4 of a period in case there was a race in sampling CSB
          #(spi_clk_half_period/2 * 1ps);

          // Checking after the number of half SCK cycles the CSB line is at the expected value
          if (cfg.m_spi_agent_cfg.vif.csb[0] === csaat) begin
            `uvm_fatal(`gfn, {"CSB still low since last data sent",
                       $sformatf("There's been %0d half SCK cycles (time, no ticks)",num_times)})
          end
        end
        begin
          int max_scks_edges = 2;

          repeat(max_scks_edges)
            @(cfg.m_spi_agent_cfg.vif.sck);

          // Blocking here if csaat is not 0, so the fork is not killed early
          wait (csaat == 0);
          `uvm_fatal(`gfn, $sformatf("%m - Clock kept ticking"))
        end
        begin
          wait (cfg.m_spi_agent_cfg.vif.csb[0] === 1);
          `uvm_info(`gfn, $sformatf("%m - CSB has been set to 1 - killing CSAAT check"), UVM_DEBUG)
        end
      join_any
      disable fork;
    end join

  endtask // check_csaat

  // Use to control the 'current' configopts.lead/idle/trail values, in case the RTL is configured
  // mid spi transaction
  virtual task update_configopts(spi_host_configopts_t next_spi_configopts);

    `uvm_info(`gfn, $sformatf("CONFIGOPTS written - %p\nValue will be updated on CSB change",
                              next_spi_configopts),UVM_DEBUG)
    // Wait for CSB to be low to update the current value
    if (!initialise_configopts && cfg.m_spi_agent_cfg.vif.csb[0] === 0) begin
      @(cfg.m_spi_agent_cfg.vif.csb[0]);
      `uvm_info(`gfn, "CSB changed, wait delay ebfore updating configopts", UVM_DEBUG)
      // Delay before updating the config to avoid colliding with the ongoing
      // idle/trail/lead checks
      cfg.clk_rst_vif.wait_clks(1);
    end
    initialise_configopts = 0;

    curr_spi_configopts = next_spi_configopts;
    spi_clk_half_period = (curr_spi_configopts.clkdiv + 1) * cfg.clk_rst_vif.clk_period_ps;
    `uvm_info(`gfn, $sformatf("TB updated Configopts to %p",curr_spi_configopts), UVM_DEBUG)
  endtask // update_configopts

  // The SPI_HOST hwip block TL-UL interface contains a set of CSRs plus windows into two
  // fifos (RXFIFO and TXFIFO).
  virtual task process_tl_access(tl_seq_item item, tl_channels_e channel, string ral_name);
    uvm_reg csr;
    string csr_name = "";
    bit write = item.is_write();
    bit [TL_AW-1:0] csr_addr_mask = ral.get_addr_mask();
    uvm_reg_addr_t csr_addr = ral.get_word_aligned_addr(item.a_addr);
    spi_segment_item rd_segment;
    spi_segment_item wr_segment;

    bit cmd_phase_write =  (write && channel == AddrChannel);
    bit data_phase_read = (!write && channel == DataChannel);
    // If the access was inside the TXFIFO window...
    if ((csr_addr & csr_addr_mask) inside {[SPI_HOST_TX_FIFO_START :
                                            SPI_HOST_TX_FIFO_END]}) begin
      bit [7:0] tl_byte[TL_DBW] = {<< 8{item.a_data}};

      if (!is_valid_mask(item.a_mask, 1)) begin
        `uvm_info(`gfn, $sformatf("TX-FIFO: Wrong mask (%0d) ... Returning, data is ignored",
                                  item.a_mask),UVM_DEBUG)
        return;
      end


      if (cfg.en_cov) begin
        spi_host_status_t status;
        csr_rd(.ptr(ral.status), .value(status), .backdoor(1'b1));
        cov.tx_fifo_overflow_cg.sample(status);
      end
      // Store all write-data into the local transaction item.
      if (cmd_phase_write) begin
        foreach (tl_byte[i]) begin
          if (item.a_mask[i]) begin
            host_wr_segment.spi_data.push_back(tl_byte[i]);
            `uvm_info(`gfn, $sformatf("Write to TXFIFO: 0x%0x",tl_byte[i]), UVM_DEBUG)
          end
        end
      end
      // Based on the value of cfg.tx_stall_check, we push this data into the
      // expected queue (write_segment_q) for checking by compare_tx_trans() at
      // one of two times:
      //   1'b0 - Push when we write to the COMMAND csr (which starts the DUT).
      //   1'b1 - Push when we write to TXFIFO.
      // This behaviour allows us to test TX stalling behaviour, which requires
      // the DUT to be attempting a write operation with no data to be popped off
      // the TXFIFO.
      if (commit_exp_txn_at_txfifo_write) begin
        commit_exp_txn_at_txfifo_write = 1'b0;
        // If cfg.tx_stall_check == 1'b1, this writes the stimulus to the expected queue
        // only after a write to the COMMAND csr.
        `downcast(wr_segment, host_wr_segment.clone());
        `uvm_info(`gfn, $sformatf("Pushed segment:\n%s \nonto 'write_segment_q'",
                                  wr_segment.convert2string), UVM_DEBUG)
        write_segment_q.push_back(wr_segment);
        host_wr_segment = spi_segment_item::type_id::create("host_wr_segment");
      end

      return;

    // If the access was inside the RXFIFO window...
    end else if ((csr_addr & csr_addr_mask) inside {[SPI_HOST_RX_FIFO_START :
                                                     SPI_HOST_RX_FIFO_END]}) begin
      bit [7:0] tl_byte[$] = {<< 8{item.d_data}};

      if (cfg.en_cov) begin
        spi_host_status_t status;
        csr_rd(.ptr(ral.status), .value(status), .backdoor(1'b1));
        cov.rx_fifo_underflow_cg.sample(status);
        cov.unaligned_data_cg.sample(item.a_mask);
      end

      // Store all data that comes out of the RXFIFO into the queue (read_segment_q) for
      // checking in compare_rx_trans().
      if (data_phase_read) begin
        foreach (tl_byte[i]) host_rd_segment.spi_data.push_back(tl_byte[i]);
        `downcast(rd_segment, host_rd_segment.clone());
        `uvm_info(`gfn, $sformatf("Pushed segment:\n%s \nonto 'read_segment_q'",
                                  rd_segment.convert2string()), UVM_DEBUG)
        read_segment_q.push_back(rd_segment);
        host_rd_segment = spi_segment_item::type_id::create("host_rd_segment");
      end

      return;

    // Process the csr req
    // For writes, update local variables and fifo at address phase
    // For reads, update prediction at address phase and compare at data phase
    end else if (csr_addr inside {cfg.ral_models[ral_name].csr_addrs}) begin
      // If access was to a valid csr, get the csr handle
      csr = ral.default_map.get_reg_by_offset(csr_addr);
      `DV_CHECK_NE_FATAL(csr, null)
      // If incoming access is a write to a valid csr, then make updates right away
      if (cmd_phase_write) begin
        void'(csr.predict(.value(item.a_data), .kind(UVM_PREDICT_WRITE), .be(item.a_mask)));
      end
      csr_name = csr.get_name();

    end else `uvm_fatal(`gfn, $sformatf("\n  scb: access unexpected addr 0x%0h", csr_addr))

    `uvm_info(`gfn, $sformatf("%m - csr_name = %s, write = %0d, channel = %s",
                              csr_name, write, channel.name), UVM_DEBUG)


    if (cmd_phase_write) begin
      `uvm_info(`gfn, $sformatf("Accessing CSR: %s - data = 0x%0x / mask = 0x%0x",
                                csr_name, item.a_data, item.a_mask), UVM_DEBUG)
      case (csr_name)
        default:; // Do nothing
        "control": begin
          bit active;
          csr_rd(.ptr(ral.status.active), .value(active), .backdoor(1'b1));
          spi_ctrl_reg.spien        = get_field_val(ral.control.spien,      item.a_data);
          spi_ctrl_reg.sw_rst       = get_field_val(ral.control.sw_rst,     item.a_data);
          spi_ctrl_reg.output_en    = get_field_val(ral.control.output_en,  item.a_data);
          spi_ctrl_reg.tx_watermark = get_field_val(ral.control.tx_watermark, item.a_data);
          spi_ctrl_reg.rx_watermark = get_field_val(ral.control.rx_watermark, item.a_data);
          if (cfg.en_cov) begin
            cov.control_cg.sample(spi_ctrl_reg, active);
          end
          if (spi_ctrl_reg.sw_rst) begin
            `uvm_info(`gfn, "CONTROL.sw_rst has been set", UVM_DEBUG)
            if (active) begin
              // Zero the checked segment counters here.
              // 'in_tx_seg_cnt' updates when we drive the stimulus, but 'checked_tx_seg_cnt' only
              // increments when the monitor sees the transaction on the bus. If the sw_rst is
              // mid-transaction, the second count will not be updated.
              // NB. As the segment counter values are only checked at the end of the simulation
              // (in the check_phase()), if we reset mid-test then all previous transactions will
              // not be captured in this final count. If the final transaction resets the counters,
              // they are not very useful. A better solution would be to disable the counters for
              // tests where they are not valuable, or improve the way we increment them such that
              // they remain in-sync across a SW_RESET event.
              // TODO(#18886)
              // As described above, consider improving segment_cnt check for tests with resets
              in_tx_seg_cnt = 0;
              checked_tx_seg_cnt = 0;
            end
            // Reset the scoreboard state.
            reset();
            ->event_sw_rst;
          end
        end

        "configopts": begin
          spi_configopts.cpol     = get_field_val(ral.configopts.cpol, item.a_data);
          spi_configopts.cpha     = get_field_val(ral.configopts.cpha, item.a_data);
          spi_configopts.fullcyc  = get_field_val(ral.configopts.fullcyc, item.a_data);
          spi_configopts.csnlead  = get_field_val(ral.configopts.csnlead, item.a_data);
          spi_configopts.csnidle  = get_field_val(ral.configopts.csnidle, item.a_data);
          spi_configopts.clkdiv   = get_field_val(ral.configopts.clkdiv, item.a_data);
          spi_configopts.csntrail = get_field_val(ral.configopts.csntrail, item.a_data);
          update_configopts(spi_configopts);
          if (cfg.en_cov) begin
            cov.config_opts_cg.sample(spi_configopts);
          end
        end

        "command": begin
          spi_cmd_reg.direction = spi_dir_e'(get_field_val(ral.command.direction, item.a_data));
          spi_cmd_reg.mode      = spi_mode_e'(get_field_val(ral.command.speed, item.a_data));
          spi_cmd_reg.csaat     = get_field_val(ral.command.csaat, item.a_data);
          spi_cmd_reg.len       = get_field_val(ral.command.len, item.a_data);

          // add global spi settings to individual transaction
          host_wr_segment.command_reg.len       = spi_cmd_reg.len;
          host_wr_segment.command_reg.direction = spi_cmd_reg.direction;
          host_wr_segment.command_reg.mode      = spi_cmd_reg.mode;
          host_wr_segment.command_reg.csaat     = spi_cmd_reg.csaat;
          if (write) begin
            `downcast(wr_segment, host_wr_segment.clone());

            // If cfg.tx_stall_check, we only push the expected transaction into the queue
            // when the write to the TXFIFO occurs.
            if (cfg.tx_stall_check) commit_exp_txn_at_txfifo_write = 1'b1;
            else begin
              // Push the expected transaction into the queue now.
              write_segment_q.push_back(wr_segment);
              `uvm_info(`gfn, $sformatf("Pushed wr_segment: \n%s onto 'write_segment_q'",
                                          wr_segment.convert2string()), UVM_DEBUG)
              `uvm_info(`gfn, $sformatf("\n  created expeted wr_segment item %s",
                                          wr_segment.convert2string()), UVM_LOW)
              host_wr_segment = spi_segment_item::type_id::create("host_wr_segment");
            end
          end
          if (cfg.en_cov) begin
            cov.duplex_cg.sample(spi_cmd_reg.direction);
            cov.command_cg.sample(spi_cmd_reg);
            cov.command_segment_cg.sample(spi_cmd_reg);
          end
        end
        "intr_enable": begin
          spi_intr_enable_reg.spi_event  = bit'(get_field_val(ral.intr_enable.spi_event,
                                                              item.a_data));
          spi_intr_enable_reg.error      = bit'(get_field_val(ral.intr_enable.error, item.a_data));
        end
        "intr_test": begin
          spi_intr_test_reg.spi_event  = bit'(get_field_val(ral.intr_test.spi_event, item.a_data));
          spi_intr_test_reg.error      = bit'(get_field_val(ral.intr_test.error, item.a_data));
          if (cfg.en_cov) begin
            bit [TL_DW-1:0] intr_en = `gmv(ral.intr_enable);
            bit [NumSpiHostIntr-1:0] intr_exp = item.a_data | `gmv(ral.intr_state);
            void'(ral.intr_state.predict(.value(intr_exp), .kind(UVM_PREDICT_DIRECT)));
            // sample coverage
            if (cfg.en_cov) begin
              foreach (intr_exp[i]) begin
                cov.intr_test_cg.sample(i, item.a_data[i], intr_en[i], intr_exp[i]);
              end
            end
          end
        end
        "csid": begin
          spi_ctrl_reg.csid = item.a_data;
          if (cfg.en_cov) begin
            cov.csid_cg.sample(spi_ctrl_reg);
          end
        end
        "error_enable": begin
          spi_error_enable_reg.csidinval     = bit'(get_field_val(ral.error_enable.csidinval,
                                                                  item.a_data));
          spi_error_enable_reg.cmdinval      = bit'(get_field_val(ral.error_enable.cmdinval,
                                                                  item.a_data));
          spi_error_enable_reg.underflow     = bit'(get_field_val(ral.error_enable.underflow,
                                                                  item.a_data));
          spi_error_enable_reg.overflow      = bit'(get_field_val(ral.error_enable.overflow,
                                                                  item.a_data));
          spi_error_enable_reg.cmdbusy       = bit'(get_field_val(ral.error_enable.cmdbusy,
                                                                  item.a_data));
          if (cfg.en_cov) begin
            cov.error_en_cg.sample(spi_error_enable_reg);
          end
        end
        "event_enable": begin
          spi_event_enable_reg.idle      = bit'(get_field_val(ral.event_enable.idle,
                                                              item.a_data));
          spi_event_enable_reg.ready     = bit'(get_field_val(ral.event_enable.ready,
                                                              item.a_data));
          spi_event_enable_reg.txwm      = bit'(get_field_val(ral.event_enable.txwm,
                                                              item.a_data));
          spi_event_enable_reg.rxwm      = bit'(get_field_val(ral.event_enable.rxwm,
                                                              item.a_data));
          spi_event_enable_reg.txempty   = bit'(get_field_val(ral.event_enable.txempty,
                                                              item.a_data));
          spi_event_enable_reg.rxfull    = bit'(get_field_val(ral.event_enable.rxfull,
                                                              item.a_data));
          if (cfg.en_cov) begin
            cov.event_en_cg.sample(spi_event_enable_reg);
          end
        end
      endcase
    end
    if (data_phase_read) begin
      case (csr_name)
        default:; // Do nothing
        "intr_state": begin
           spi_intr_state_reg.spi_event  = bit'(get_field_val(ral.intr_state.spi_event,
                                                              item.a_data));
           spi_intr_state_reg.error      = bit'(get_field_val(ral.intr_state.error, item.a_data));
           if (cfg.en_cov) begin
             bit [TL_DW-1:0]          intr_en  = `gmv(ral.intr_enable);
             bit [NumSpiHostIntr-1:0] intr_exp = `gmv(ral.intr_state);
             foreach (intr_exp[i]) begin
               cov.intr_cg.sample(i, intr_en[i], item.d_data);
               cov.intr_pins_cg.sample(i, cfg.intr_vif.pins[i]);
             end
           end
         end
        "error_status": begin
          spi_error_status_reg.accessinval   = bit'(get_field_val(ral.error_status.accessinval,
                                                                  item.a_data));
          spi_error_status_reg.csidinval     = bit'(get_field_val(ral.error_status.csidinval,
                                                                  item.a_data));
          spi_error_status_reg.cmdinval      = bit'(get_field_val(ral.error_status.cmdinval,
                                                                  item.a_data));
          spi_error_status_reg.underflow     = bit'(get_field_val(ral.error_status.underflow,
                                                                  item.a_data));
          spi_error_status_reg.overflow      = bit'(get_field_val(ral.error_status.overflow,
                                                                  item.a_data));
          spi_error_status_reg.cmdbusy       = bit'(get_field_val(ral.error_status.cmdbusy,
                                                                  item.a_data));
          if (cfg.en_cov) begin
            cov.error_status_cg.sample(spi_error_status_reg, spi_error_enable_reg);
          end
        end
        "status": begin
          spi_status_reg.ready       =  get_field_val(ral.status.ready, item.a_data);
          spi_status_reg.active      =  get_field_val(ral.status.active, item.a_data);
          spi_status_reg.txfull      =  get_field_val(ral.status.txfull, item.a_data);
          spi_status_reg.txempty     =  get_field_val(ral.status.txempty, item.a_data);
          spi_status_reg.txstall     =  get_field_val(ral.status.txstall, item.a_data);
          spi_status_reg.tx_wm       =  get_field_val(ral.status.txwm, item.a_data);
          spi_status_reg.rxfull      =  get_field_val(ral.status.rxfull, item.a_data);
          spi_status_reg.rxempty     =  get_field_val(ral.status.rxempty, item.a_data);
          spi_status_reg.rxstall     =  get_field_val(ral.status.rxstall, item.a_data);
          spi_status_reg.byteorder   =  get_field_val(ral.status.byteorder, item.a_data);
          spi_status_reg.rx_wm       =  get_field_val(ral.status.rxwm, item.a_data);
          spi_status_reg.cmd_qd      =  get_field_val(ral.status.cmdqd, item.a_data);
          spi_status_reg.rx_qd       =  get_field_val(ral.status.rxqd, item.a_data);
          spi_status_reg.tx_qd       =  get_field_val(ral.status.txqd, item.a_data);
          if (cfg.en_cov) begin
            cov.status_cg.sample(spi_status_reg);
          end
        end
      endcase
    end
  endtask : process_tl_access


  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    // reset local fifos queues and variables
    plain_data_fifo.flush();
    write_segment_q.delete();
    read_segment_q.delete();
    rx_data_q.delete();
    host_wr_segment = spi_segment_item::type_id::create("host_wr_segment");
    host_rd_segment = spi_segment_item::type_id::create("host_rd_segment");
    initialise_configopts = 1;
  endfunction : reset

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    // post test checks - ensure that all local fifos and queues are empty
    if (in_tx_seg_cnt != checked_tx_seg_cnt)
      `uvm_fatal(`gfn, $sformatf("Didn't check all segments - expected %0d actual %0d",
                                  in_tx_seg_cnt, checked_tx_seg_cnt))

    `DV_EOT_PRINT_Q_CONTENTS(spi_segment_item, write_segment_q)
    `DV_EOT_PRINT_Q_CONTENTS(spi_segment_item, read_segment_q)
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(spi_item, plain_data_fifo)
    if ((rx_data_q.size() != 0))
      `uvm_fatal(`gfn,
                 $sformatf("ERROR - RX FIFO in DUT still has data to be read! (rx_data_q = %0d)",
                           rx_data_q.size()))
  endfunction : check_phase

endclass : spi_host_scoreboard
