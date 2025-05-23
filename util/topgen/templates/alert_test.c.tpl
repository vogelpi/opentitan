// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// clang-format off

${gencmd}
<%
## TODO: Darjeeling contains peripherals which expose IRQs/Alerts to the RV
## PLIC and Alert Handler respectively, but are not accessible from the hart
## address space and thus cannot be tested directly (via the IRQ_TEST and
## ALERT_TEST registers). While this issue remains, we specifically hard-code
## for excluding these Alerts from the test.
IGNORE_PERIPHERALS = [("ac_range_check", "darjeeling"), ("racl_ctrl", "darjeeling")]
alert_peripherals = [p for p in helper.alert_peripherals[addr_space]
                     if (p.inst_name, top["name"]) not in IGNORE_PERIPHERALS]

alert_peripheral_names = sorted({p.name for p in alert_peripherals})
%>\
#include "sw/device/lib/arch/boot_stage.h"
#include "sw/device/lib/base/mmio.h"
% for n in sorted(alert_peripheral_names + ["alert_handler"]):
#include "sw/device/lib/dif/autogen/dif_${n}_autogen.h"
% endfor
#include "sw/device/lib/testing/alert_handler_testutils.h"
#include "sw/device/lib/testing/test_framework/FreeRTOSConfig.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_test_config.h"

#include "alert_handler_regs.h"  // Generated.
#include "hw/top_${top["name"]}/sw/autogen/top_${top["name"]}.h"

OTTF_DEFINE_TEST_CONFIG();

static dif_alert_handler_t alert_handler;
% for p in alert_peripherals:
static dif_${p.name}_t ${p.inst_name};
% endfor

/**
 * Initialize the peripherals used in this test.
 */
static void init_peripherals(void) {
  mmio_region_t base_addr;
  base_addr = mmio_region_from_addr(TOP_${top["name"].upper()}_ALERT_HANDLER_BASE_ADDR);
  CHECK_DIF_OK(dif_alert_handler_init(base_addr, &alert_handler));

  % for p in alert_peripherals:
  base_addr = mmio_region_from_addr(${p.base_addr_name});
  CHECK_DIF_OK(dif_${p.name}_init(base_addr, &${p.inst_name}));

  % endfor
}

/**
 * Configure the alert handler to escalate on alerts upto phase 1 (i.e. wipe
 * secret) but not trigger reset. Then CPU can check if alert_handler triggers the correct
 * alert_cause register.
 */
static void alert_handler_config(void) {
  dif_alert_handler_alert_t alerts[ALERT_HANDLER_PARAM_N_ALERTS];
  dif_alert_handler_class_t alert_classes[ALERT_HANDLER_PARAM_N_ALERTS];

  // Enable all incoming alerts and configure them to classa.
  // This alert should never fire because we do not expect any incoming alerts.
  for (dif_alert_handler_alert_t i = 0; i < ALERT_HANDLER_PARAM_N_ALERTS; ++i) {
    alerts[i] = i;
    alert_classes[i] = kDifAlertHandlerClassA;
  }

  dif_alert_handler_escalation_phase_t esc_phases[] = {
      {.phase = kDifAlertHandlerClassStatePhase0,
       .signal = 0,
       .duration_cycles = 2000}};

  dif_alert_handler_class_config_t class_config = {
      .auto_lock_accumulation_counter = kDifToggleDisabled,
      .accumulator_threshold = 0,
      .irq_deadline_cycles = 10000,
      .escalation_phases = esc_phases,
      .escalation_phases_len = ARRAYSIZE(esc_phases),
      .crashdump_escalation_phase = kDifAlertHandlerClassStatePhase1,
  };

  dif_alert_handler_class_config_t class_configs[] = {class_config,
                                                      class_config};

  dif_alert_handler_class_t classes[] = {kDifAlertHandlerClassA,
                                         kDifAlertHandlerClassB};
  dif_alert_handler_config_t config = {
      .alerts = alerts,
      .alert_classes = alert_classes,
      .alerts_len = ARRAYSIZE(alerts),
      .classes = classes,
      .class_configs = class_configs,
      .classes_len = ARRAYSIZE(class_configs),
      .ping_timeout = 1000,
  };

 CHECK_STATUS_OK(alert_handler_testutils_configure_all(&alert_handler, config,
                                        kDifToggleEnabled));
}

// Trigger alert for each module by writing one to `alert_test` register.
// Then check alert_handler's alert_cause register to make sure the correct alert reaches
// alert_handler.
static void trigger_alert_test(void) {
  bool is_cause;
  dif_alert_handler_alert_t exp_alert;
  % for p in alert_peripherals:

    % if p.name == "otp_ctrl":
<% indent = "  " %>\
  // TODO(lowrisc/opentitan#20348): Enable otp_ctrl when this is fixed.
  if (kBootStage != kBootStageOwner) {
    % else:
<% indent = "" %>\
    % endif
${indent}  // Write ${p.name}'s alert_test reg and check alert_cause.
${indent}  for (dif_${p.name}_alert_t i = 0; i < ${p.num_alerts}; ++i) {
${indent}    CHECK_DIF_OK(dif_${p.name}_alert_force(&${p.inst_name}, ${p.dif_alert_name} + i));

${indent}    // Verify that alert handler received it.
${indent}    exp_alert = ${p.top_alert_name} + i;
${indent}    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
${indent}        &alert_handler, exp_alert, &is_cause));
${indent}    CHECK(is_cause, "Expect alert %d!", exp_alert);

${indent}    // Clear alert cause register
${indent}    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
${indent}        &alert_handler, exp_alert));
    % if p.name == "otp_ctrl":
${indent}  }
    % endif
  }
  % endfor
}

bool test_main(void) {
  init_peripherals();
  alert_handler_config();
  trigger_alert_test();
  return true;
}
