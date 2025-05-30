// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_adc_ctrl.h"
#include "sw/device/lib/dif/dif_alert_handler.h"
#include "sw/device/lib/dif/dif_aon_timer.h"
#include "sw/device/lib/dif/dif_clkmgr.h"
#include "sw/device/lib/dif/dif_entropy_src.h"
#include "sw/device/lib/dif/dif_rv_plic.h"
#include "sw/device/lib/dif/dif_sensor_ctrl.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/runtime/irq.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/alert_handler_testutils.h"
#include "sw/device/lib/testing/aon_timer_testutils.h"
#include "sw/device/lib/testing/clkmgr_testutils.h"
#include "sw/device/lib/testing/entropy_src_testutils.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/pwrmgr_testutils.h"
#include "sw/device/lib/testing/rstmgr_testutils.h"
#include "sw/device/lib/testing/rv_plic_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sensor_ctrl_regs.h"
#include "sw/device/lib/testing/autogen/isr_testutils.h"

#define kAlertSet true
#define kAlertClear false
#define kAlertVal7 7
#define kAlertVal8 8
#define kDifNoWakeup 0

OTTF_DEFINE_TEST_CONFIG();

static volatile const uint8_t kNumLowPowerSamples;
static volatile const uint8_t kNumNormalPowerSamples;
static volatile const uint8_t kWakeUpTimeInUs;

static volatile const uint8_t kChannel0MaxLowByte;
static volatile const uint8_t kChannel0MaxHighByte;
static volatile const uint8_t kChannel0MinLowByte;
static volatile const uint8_t kChannel0MinHighByte;

static volatile const uint8_t kChannel1MaxLowByte;
static volatile const uint8_t kChannel1MaxHighByte;
static volatile const uint8_t kChannel1MinLowByte;
static volatile const uint8_t kChannel1MinHighByte;

static dif_sensor_ctrl_t sensor_ctrl;
static dif_alert_handler_t alert_handler;
static dif_aon_timer_t aon_timer;
static dif_rv_plic_t rv_plic;
static dif_pwrmgr_t pwrmgr;
static dif_rstmgr_t rstmgr;
static dif_entropy_src_t entropy_src;

static dif_clkmgr_t clkmgr;
static dif_adc_ctrl_t adc_ctrl;

static const dt_adc_ctrl_t kAdcCtrlDt = 0;
static_assert(kDtAdcCtrlCount == 1, "this test expects a adc_ctrl");
static const dt_clkmgr_t kClkmgrDt = 0;
static_assert(kDtClkmgrCount == 1, "this test expects a clkmgr");
static const dt_rstmgr_t kRstmgrDt = 0;
static_assert(kDtRstmgrCount == 1, "this test expects a rstmgr");
static const dt_pwrmgr_t kPwrmgrDt = 0;
static_assert(kDtPwrmgrCount == 1, "this test expects a pwrmgr");
static_assert(kDtAonTimerCount == 1, "this test expects an aon_timer");
static const dt_aon_timer_t kAonTimerDt = 0;
static_assert(kDtEntropySrcCount == 1, "this test expects an entropy_src");
static const dt_entropy_src_t kEntropySrcDt = 0;
static const dt_alert_handler_t kAlertHandlerDt = 0;
static_assert(kDtAlertHandlerCount == 1,
              "this library expects exactly one alert_handler");
static const dt_rv_plic_t kRvPlicDt = 0;
static_assert(kDtRvPlicCount == 1, "this test expects exactly one rv_plic");
static const dt_sensor_ctrl_t kSensorCtrlDt = 0;
static_assert(kDtSensorCtrlCount >= 1, "this test expects a sensor_ctrl");

static volatile bool interrupt_serviced = false;
static bool first_adc_setup = true;

enum {
  /**
   * The size of the buffer used in firmware to process the entropy bits in
   * firmware override mode.
   */
  kEntropyFifoBufferSize = 16,
};

enum {
  kPowerUpTimeInUs = 30,
};

static uint32_t read_fifo_depth(dif_entropy_src_t *entropy) {
  uint32_t fifo_depth = 0;
  CHECK_DIF_OK(dif_entropy_src_get_fifo_depth(entropy, &fifo_depth));
  return fifo_depth;
}

static uint32_t get_events(dif_toggle_t fatal) {
  dif_sensor_ctrl_events_t events = 0;
  if (dif_toggle_to_bool(fatal)) {
    CHECK_DIF_OK(dif_sensor_ctrl_get_fatal_events(&sensor_ctrl, &events));
  } else {
    CHECK_DIF_OK(dif_sensor_ctrl_get_recov_events(&sensor_ctrl, &events));
  }
  return events;
}

/**
 *  Clear event trigger and recoverable status.
 */
static void clear_event(uint32_t idx, dif_toggle_t fatal) {
  CHECK_DIF_OK(dif_sensor_ctrl_set_ast_event_trigger(&sensor_ctrl, idx,
                                                     kDifToggleDisabled));
  if (!dif_toggle_to_bool(fatal)) {
    CHECK_DIF_OK(dif_sensor_ctrl_clear_recov_event(&sensor_ctrl, idx));
  }
}

/**
 *  Check alert cause registers are correctly set
 */
static void check_alert_state(dif_toggle_t fatal) {
  bool fatal_cause = false;
  bool recov_cause = false;

  CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonFatalAlert,
      &fatal_cause));

  CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonRecovAlert,
      &recov_cause));

  if (dif_toggle_to_bool(fatal)) {
    CHECK(fatal_cause & !recov_cause,
          "Fatal alert not correctly observed in alert handler");
  } else {
    CHECK(recov_cause & !fatal_cause,
          "Recov alert not correctly observed in alert handler");
  }

  CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonRecovAlert));
  CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonFatalAlert));
}

/**
 *  First configure fatality of the desired event.
 *  Then trigger the event from sensor_ctrl to ast.
 *  Next poll for setting of correct events inside sensor_ctrl status.
 *  When a recoverable event is triggerd, make sure only recoverable
 *  status is seen, likewise for fatal events.
 *  Finally, check for correct capture of cause in alert handler.
 */
static void test_event(uint32_t idx, dif_toggle_t fatal, bool set_event) {
  if (set_event) {
    // Enable the alert on the sensor_ctrl side
    CHECK_DIF_OK(
        dif_sensor_ctrl_set_alert_en(&sensor_ctrl, idx, kDifToggleEnabled));

    // Configure event fatality
    CHECK_DIF_OK(dif_sensor_ctrl_set_alert_fatal(&sensor_ctrl, idx, fatal));

    // Trigger event
    CHECK_DIF_OK(dif_sensor_ctrl_set_ast_event_trigger(&sensor_ctrl, idx,
                                                       kDifToggleEnabled));
    // wait for events to set
    IBEX_SPIN_FOR(get_events(fatal) > 0, 1);

    // Check for the event in ast sensor_ctrl
    // if the event is not set, error
    CHECK(((get_events(fatal) >> idx) & 0x1) == 1,
          "Event %d not observed in AST", idx);

    // check the opposite fatality setting, should not be set
    CHECK(((get_events(!fatal) >> idx) & 0x1) == 0,
          "Event %d observed in AST when it should not be", idx);
  } else {
    // clear event trigger
    clear_event(idx, fatal);

    // check whether alert handler captured the event
    check_alert_state(fatal);

    // Disable the alert on the sensor_ctrl side
    CHECK_DIF_OK(
        dif_sensor_ctrl_set_alert_en(&sensor_ctrl, idx, kDifToggleDisabled));
  }
}

void init_units(void) {
  CHECK_DIF_OK(dif_pwrmgr_init_from_dt(kPwrmgrDt, &pwrmgr));
  CHECK_DIF_OK(dif_rstmgr_init_from_dt(kRstmgrDt, &rstmgr));
  CHECK_DIF_OK(dif_entropy_src_init_from_dt(kEntropySrcDt, &entropy_src));
  CHECK_DIF_OK(dif_aon_timer_init_from_dt(kAonTimerDt, &aon_timer));
  CHECK_DIF_OK(dif_rv_plic_init_from_dt(kRvPlicDt, &rv_plic));
  CHECK_DIF_OK(dif_sensor_ctrl_init_from_dt(kSensorCtrlDt, &sensor_ctrl));
  CHECK_DIF_OK(dif_alert_handler_init_from_dt(kAlertHandlerDt, &alert_handler));
  CHECK_DIF_OK(dif_clkmgr_init_from_dt(kClkmgrDt, &clkmgr));
  CHECK_DIF_OK(dif_adc_ctrl_init_from_dt(kAdcCtrlDt, &adc_ctrl));
}

/**
 *  configure adc module
 */
static void configure_adc_ctrl(const dif_adc_ctrl_t *adc_ctrl) {
  uint32_t wake_up_time_aon_cycles = 0;
  uint32_t power_up_time_aon_cycles = 0;

  CHECK_STATUS_OK(aon_timer_testutils_get_aon_cycles_32_from_us(
      kPowerUpTimeInUs, &power_up_time_aon_cycles));
  CHECK_STATUS_OK(aon_timer_testutils_get_aon_cycles_32_from_us(
      kWakeUpTimeInUs, &wake_up_time_aon_cycles));
  CHECK_DIF_OK(dif_adc_ctrl_set_enabled(adc_ctrl, kDifToggleDisabled));
  CHECK_DIF_OK(dif_adc_ctrl_reset(adc_ctrl));
  CHECK_DIF_OK(dif_adc_ctrl_configure(
      adc_ctrl,
      (dif_adc_ctrl_config_t){
          .mode = kDifAdcCtrlLowPowerScanMode,
          .num_low_power_samples = kNumLowPowerSamples,
          .num_normal_power_samples = kNumNormalPowerSamples,
          .power_up_time_aon_cycles = (uint8_t)power_up_time_aon_cycles + 1,
          .wake_up_time_aon_cycles = wake_up_time_aon_cycles}));
}

static void en_plic_irqs(dif_rv_plic_t *plic) {
  top_earlgrey_plic_irq_id_t plic_irqs[] = {
      kTopEarlgreyPlicIrqIdAdcCtrlAonMatchPending};

  for (uint32_t i = 0; i < ARRAYSIZE(plic_irqs); ++i) {
    CHECK_DIF_OK(dif_rv_plic_irq_set_enabled(
        plic, plic_irqs[i], kTopEarlgreyPlicTargetIbex0, kDifToggleEnabled));

    // Assign a default priority
    CHECK_DIF_OK(dif_rv_plic_irq_set_priority(plic, plic_irqs[i], 0x1));
  }

  // Enable the external IRQ at Ibex.
  irq_global_ctrl(true);
  irq_external_ctrl(true);
}

void adc_setup(bool first_adc_setup) {
  // Enable adc interrupts.
  CHECK_DIF_OK(dif_adc_ctrl_irq_set_enabled(
      &adc_ctrl, kDifAdcCtrlIrqMatchPending, kDifToggleEnabled));

  uint16_t channel0_filter0_max =
      ((uint16_t)(kChannel0MaxHighByte << 8)) | kChannel0MaxLowByte;
  uint16_t channel0_filter0_min =
      ((uint16_t)(kChannel0MinHighByte << 8)) | kChannel0MinLowByte;
  uint16_t channel1_filter0_max =
      ((uint16_t)(kChannel1MaxHighByte << 8)) | kChannel1MaxLowByte;
  uint16_t channel1_filter0_min =
      ((uint16_t)(kChannel1MinHighByte << 8)) | kChannel1MinLowByte;

  if (first_adc_setup) {
    // Setup ADC configuration.
    configure_adc_ctrl(&adc_ctrl);
  } else {
    CHECK_DIF_OK(dif_adc_ctrl_reset(&adc_ctrl));
  }

  en_plic_irqs(&rv_plic);
  // Setup ADC filters. There is one filter for each channel.
  CHECK_DIF_OK(dif_adc_ctrl_configure_filter(
      &adc_ctrl, kDifAdcCtrlChannel0,
      (dif_adc_ctrl_filter_config_t){.filter = kDifAdcCtrlFilter0,
                                     .generate_irq_on_match = true,
                                     .generate_wakeup_on_match = true,
                                     .in_range = true,
                                     .max_voltage = channel0_filter0_max,
                                     .min_voltage = channel0_filter0_min},
      kDifToggleDisabled));
  CHECK_DIF_OK(dif_adc_ctrl_configure_filter(
      &adc_ctrl, kDifAdcCtrlChannel1,
      (dif_adc_ctrl_filter_config_t){.filter = kDifAdcCtrlFilter0,
                                     .generate_irq_on_match = true,
                                     .generate_wakeup_on_match = true,
                                     .in_range = true,
                                     .max_voltage = channel1_filter0_max,
                                     .min_voltage = channel1_filter0_min},
      kDifToggleDisabled));

  // enable filters.
  CHECK_DIF_OK(dif_adc_ctrl_filter_set_enabled(
      &adc_ctrl, kDifAdcCtrlChannel0, kDifAdcCtrlFilter0, kDifToggleEnabled));
  CHECK_DIF_OK(dif_adc_ctrl_filter_set_enabled(
      &adc_ctrl, kDifAdcCtrlChannel1, kDifAdcCtrlFilter0, kDifToggleEnabled));

  if (first_adc_setup) {
    CHECK_DIF_OK(dif_adc_ctrl_set_enabled(&adc_ctrl, kDifToggleEnabled));
  }
}

void ast_enter_sleep_states_and_check_functionality(
    dif_pwrmgr_domain_config_t pwrmgr_config, uint32_t alert_idx) {
  bool deepsleep;
  uint32_t read_fifo_depth_val = 0;
  uint32_t unhealthy_fifos, errors, alerts;

  const dif_edn_t edn0 = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_EDN0_BASE_ADDR)};
  const dif_edn_t edn1 = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_EDN1_BASE_ADDR)};

  if ((pwrmgr_config & (~kDifPwrmgrDomainOptionUsbClockInActivePower)) == 0) {
    deepsleep = true;
  } else {
    deepsleep = false;
  }

  dif_pwrmgr_request_sources_t adc_ctrl_wakeup_sources;
  CHECK_DIF_OK(dif_pwrmgr_find_request_source(
      &pwrmgr, kDifPwrmgrReqTypeWakeup, dt_adc_ctrl_instance_id(kAdcCtrlDt),
      kDtAdcCtrlWakeupWkupReq, &adc_ctrl_wakeup_sources));

  if (UNWRAP(pwrmgr_testutils_is_wakeup_reason(&pwrmgr, kDifNoWakeup)) ==
      true) {
    // Make sure ENTROPY_SRC is enabled and then empty the observe FIFO to
    // restart the entropy collection. Note that this is more efficient than
    // restarting the entire block.
    CHECK_DIF_OK(dif_entropy_src_set_enabled(&entropy_src, kDifToggleEnabled));
    CHECK_STATUS_OK(entropy_src_testutils_drain_observe_fifo(&entropy_src));

    // Verify that the FIFO depth is non-zero via SW - indicating the reception
    // of data over the AST RNG interface.
    IBEX_SPIN_FOR(read_fifo_depth(&entropy_src) > 0, 1000);

    // test recoverable event
    test_event(alert_idx, kDifToggleDisabled, kAlertSet);

    // Enable all the AON interrupts used in this test.
    rv_plic_testutils_irq_range_enable(
        &rv_plic, kTopEarlgreyPlicTargetIbex0,
        kTopEarlgreyPlicIrqIdAdcCtrlAonMatchPending,
        kTopEarlgreyPlicIrqIdAdcCtrlAonMatchPending);
    CHECK_DIF_OK(dif_pwrmgr_irq_set_enabled(&pwrmgr, 0, kDifToggleEnabled));

    // Setup low power.
    CHECK_STATUS_OK(rstmgr_testutils_pre_reset(&rstmgr));

    if (!deepsleep) {
      // read fifo depth before enter sleep mode
      read_fifo_depth_val = read_fifo_depth(&entropy_src);
    }

    // Configure ADC
    adc_setup(first_adc_setup);

    // set sleep mode
    CHECK_STATUS_OK(pwrmgr_testutils_enable_low_power(
        &pwrmgr, adc_ctrl_wakeup_sources, pwrmgr_config));

    // Enter low power mode.
    LOG_INFO("Issued WFI to enter sleep.");

    wait_for_interrupt();

    // Interrupt should have been serviced.
    CHECK(interrupt_serviced);

    interrupt_serviced = false;

  } else if (UNWRAP(pwrmgr_testutils_is_wakeup_reason(
                 &pwrmgr, adc_ctrl_wakeup_sources))) {
    if (deepsleep) {
      first_adc_setup = false;
      // Configure ADC after deep sleep
      adc_setup(first_adc_setup);
    }

    // Make sure ENTROPY_SRC is enabled and then empty the observe FIFO to
    // restart the entropy collection. Note that this is more efficient than
    // restarting the entire block.
    CHECK_DIF_OK(dif_entropy_src_set_enabled(&entropy_src, kDifToggleEnabled));
    CHECK_STATUS_OK(entropy_src_testutils_drain_observe_fifo(&entropy_src));

    IBEX_SPIN_FOR(read_fifo_depth(&entropy_src) > 0, 1000);
  }

  if (!deepsleep) {
    if (read_fifo_depth_val >= read_fifo_depth(&entropy_src))
      LOG_ERROR(
          "read_fifo_depth after exit from idle=%0d should be equal/greater "
          "than previous read value (%0d)",
          read_fifo_depth(&entropy_src), read_fifo_depth_val);
  }

  IBEX_SPIN_FOR(read_fifo_depth(&entropy_src) > 0, 1000);

  test_event(alert_idx, kDifToggleDisabled, kAlertClear);

  CHECK_DIF_OK(dif_pwrmgr_wakeup_reason_clear(&pwrmgr));

  // test event after exit from low power
  test_event(alert_idx, kDifToggleDisabled, kAlertSet);
  test_event(alert_idx, kDifToggleDisabled, kAlertClear);

  // verify there are no any edn alerts/errors
  CHECK_DIF_OK(dif_edn_get_errors(&edn0, &unhealthy_fifos, &errors));
  CHECK_DIF_OK(dif_edn_get_recoverable_alerts(&edn0, &alerts));
  if (unhealthy_fifos != 0 || errors != 0 || alerts != 0)
    LOG_ERROR("edn0: error=0x%x, unhealthy_fifos=0x%x, alerts=0x%x", errors,
              unhealthy_fifos, alerts);

  CHECK_DIF_OK(dif_edn_get_errors(&edn1, &unhealthy_fifos, &errors));
  CHECK_DIF_OK(dif_edn_get_recoverable_alerts(&edn1, &alerts));
  if (unhealthy_fifos != 0 || errors != 0 || alerts != 0)
    LOG_ERROR("edn1: error=0x%x, unhealthy_fifos=0x%x, alerts=0x%x", errors,
              unhealthy_fifos, alerts);
}

/**
 *  set edn auto mode
 */
void set_edn_auto_mode(void) {
  const dif_csrng_t csrng = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_CSRNG_BASE_ADDR)};
  const dif_edn_t edn0 = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_EDN0_BASE_ADDR)};
  const dif_edn_t edn1 = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_EDN1_BASE_ADDR)};

  // Disable the entropy complex
  CHECK_STATUS_OK(entropy_testutils_stop_all());

  // Configure ENTROPY_SRC in Firmware Override: Observe mode and enable it.
  // In this mode, the entropy received from the RNG inside AST gets collected
  // in the Observe FIFO AND continues to flow through the hardware pipeline to
  // eventually reach the hardware interface.
  const dif_entropy_src_fw_override_config_t fw_override_config = {
      .entropy_insert_enable = false,
      .buffer_threshold = kEntropyFifoBufferSize,
  };
  CHECK_DIF_OK(dif_entropy_src_fw_override_configure(
      &entropy_src, fw_override_config, kDifToggleEnabled));
  CHECK_STATUS_OK(entropy_testutils_entropy_src_init());

  // Enable CSRNG
  CHECK_DIF_OK(dif_csrng_configure(&csrng));

  // Enable EDNs in auto request mode
  // Re-enable EDN0 in auto mode.
  const dif_edn_auto_params_t edn0_params = {
      // EDN0 provides lower-quality entropy.  Let one generate command return 8
      // blocks, and reseed every 32 generates.
      .instantiate_cmd =
          {
              .cmd = 0x00000001 |  // Reseed from entropy source only.
                     kMultiBitBool4False << 8,
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .reseed_cmd =
          {
              .cmd = 0x00008002 |  // One generate returns 8 blocks, reseed
                                   // from entropy source only.
                     kMultiBitBool4False << 8,
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .generate_cmd =
          {
              .cmd = 0x00008003,  // One generate returns 8 blocks.
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .reseed_interval = 32,  // Reseed every 32 generates.
  };
  CHECK_DIF_OK(dif_edn_set_auto_mode(&edn0, edn0_params));

  // Re-enable EDN1 in auto mode.
  const dif_edn_auto_params_t edn1_params = {
      // EDN1 provides highest-quality entropy.  Let one generate command
      // return 1 block, and reseed after every generate.
      .instantiate_cmd =
          {
              .cmd = 0x00000001 |  // Reseed from entropy source only.
                     kMultiBitBool4False << 8,
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .reseed_cmd =
          {
              .cmd = 0x00001002 |  // One generate returns 1 block, reseed
                                   // from entropy source only.
                     kMultiBitBool4False << 8,
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .generate_cmd =
          {
              .cmd = 0x00001003,  // One generate returns 1 block.
              .seed_material =
                  {
                      .len = 0,
                  },
          },
      .reseed_interval = 4,  // Reseed after every 4 generates.
  };
  CHECK_DIF_OK(dif_edn_set_auto_mode(&edn1, edn1_params));

  // The Observe FIFO has already been filled while producing the seeds for the
  // EDNs. Empty the FIFO to restart the collection for the actual test.
  CHECK_STATUS_OK(entropy_src_testutils_drain_observe_fifo(&entropy_src));
}

void ottf_external_isr(uint32_t *exc_info) {
  plic_isr_ctx_t plic_ctx = {.rv_plic = &rv_plic,
                             .hart_id = kTopEarlgreyPlicTargetIbex0};

  adc_ctrl_isr_ctx_t adc_ctrl_ctx = {
      .adc_ctrl = &adc_ctrl,
      .plic_adc_ctrl_start_irq_id = kTopEarlgreyPlicIrqIdAdcCtrlAonMatchPending,
      .expected_irq = 0,
      .is_only_irq = true};

  top_earlgrey_plic_peripheral_t peripheral;
  dif_adc_ctrl_irq_t adc_ctrl_irq;
  isr_testutils_adc_ctrl_isr(plic_ctx, adc_ctrl_ctx, false, &peripheral,
                             &adc_ctrl_irq);

  CHECK(peripheral == kTopEarlgreyPlicPeripheralAdcCtrlAon);
  CHECK(adc_ctrl_irq == kDifAdcCtrlIrqMatchPending);
  interrupt_serviced = true;
}

bool test_main(void) {
  dif_pwrmgr_domain_config_t pwrmgr_config;

  init_units();

  set_edn_auto_mode();
  CHECK_DIF_OK(dif_clkmgr_jitter_set_enabled(&clkmgr, kDifToggleEnabled));

  // Enable both recoverable and fatal alerts
  CHECK_DIF_OK(dif_alert_handler_configure_alert(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonRecovAlert,
      kDifAlertHandlerClassA, kDifToggleEnabled, kDifToggleEnabled));
  CHECK_DIF_OK(dif_alert_handler_configure_alert(
      &alert_handler, kTopEarlgreyAlertIdSensorCtrlAonFatalAlert,
      kDifAlertHandlerClassA, kDifToggleEnabled, kDifToggleEnabled));

  LOG_INFO("1 test alert/rng after Deep sleep 1");
  pwrmgr_config = kDifPwrmgrDomainOptionUsbClockInActivePower;
  ast_enter_sleep_states_and_check_functionality(pwrmgr_config, kAlertVal7);

  LOG_INFO("2 test alert/rng after regular sleep (usb clk enabled)");
  LOG_INFO("force new adc conv set");
  pwrmgr_config = kDifPwrmgrDomainOptionUsbClockInActivePower |
                  kDifPwrmgrDomainOptionUsbClockInLowPower |
                  kDifPwrmgrDomainOptionMainPowerInLowPower;
  ast_enter_sleep_states_and_check_functionality(pwrmgr_config, kAlertVal8);

  LOG_INFO("3 test alert/rng after regular sleep (all clk disabled in lp)");
  LOG_INFO("force new adc conv set");
  pwrmgr_config = kDifPwrmgrDomainOptionMainPowerInLowPower |
                  kDifPwrmgrDomainOptionUsbClockInActivePower;
  ast_enter_sleep_states_and_check_functionality(pwrmgr_config, kAlertVal7);

  LOG_INFO("c code is finished");

  return true;
}
