// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/crypto/drivers/entropy.h"
#include "sw/device/lib/dif/dif_rstmgr.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/flash_ctrl_testutils.h"
#include "sw/device/lib/testing/keymgr_testutils.h"
#include "sw/device/lib/testing/rstmgr_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/lib/testing/test_framework/status.h"
#include "sw/device/silicon_creator/lib/drivers/keymgr.h"
#include "sw/device/silicon_creator/lib/drivers/kmac.h"
#include "sw/device/silicon_creator/lib/otbn_boot_services.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"  // Generated.
#include "otp_ctrl_regs.h"                            // Generated.

OTTF_DEFINE_TEST_CONFIG();

static dif_flash_ctrl_state_t flash_ctrl;
static dif_rstmgr_t rstmgr;

static const keymgr_binding_value_t kBindingValueRom = {
    .data = {0x7c9b2405, 0x1841a738, 0xdb24005d, 0x4dbd6a17, 0x362f1673,
             0x1d8ede70, 0x0104d346, 0x1a0806c2},
};
static const uint32_t kMaxVerRom = 0;

/**
 * Issue a software reset.
 */
static void sw_reset(void) {
  rstmgr_testutils_reason_clear();
  CHECK_DIF_OK(dif_rstmgr_software_device_reset(&rstmgr));
  wait_for_interrupt();
}

status_t expected_pass(void) {
  // Load OTBN boot services application (triggering a secure wipe of I/DMEMs).
  TRY(otbn_boot_app_load());

  // Initialize entropy complex and KMAC for keymgr operations.
  TRY(entropy_complex_init());
  TRY(kmac_keymgr_configure());

  // Crank keymgr to CreatorRootKey.
  TRY(sc_keymgr_state_check(kScKeymgrStateReset));
  sc_keymgr_advance_state();
  TRY(sc_keymgr_state_check(kScKeymgrStateInit));
  sc_keymgr_advance_state();
  TRY(sc_keymgr_state_check(kScKeymgrStateCreatorRootKey));

  return OK_STATUS();
}

status_t expected_fail(void) {
  // Initialize entropy complex and KMAC for keymgr operations.
  TRY(entropy_complex_init());
  TRY(kmac_keymgr_configure());

  // Crank keymgr to CreatorRootKey.
  TRY(sc_keymgr_state_check(kScKeymgrStateReset));
  sc_keymgr_advance_state();
  TRY(sc_keymgr_state_check(kScKeymgrStateInit));
  sc_keymgr_advance_state();
  TRY(sc_keymgr_state_check(kScKeymgrStateCreatorRootKey));

  // Load OTBN boot services application (triggering a secure wipe of I/DMEMs).
  TRY(otbn_boot_app_load());

  return OK_STATUS();
}

bool test_main(void) {
  // Initialize peripherals.
  CHECK_DIF_OK(dif_flash_ctrl_init_state(
      &flash_ctrl,
      mmio_region_from_addr(TOP_EARLGREY_FLASH_CTRL_CORE_BASE_ADDR)));
  CHECK_DIF_OK(dif_rstmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_RSTMGR_AON_BASE_ADDR), &rstmgr));

  // Get reset reason.
  dif_rstmgr_reset_info_bitfield_t reason;
  reason = rstmgr_testutils_reason_get();

  if (reason & kDifRstmgrResetInfoPor) {
    LOG_INFO("Coming out of Power-on Reset.");

    // Initialize flash info pages 1 & 2.
    CHECK_STATUS_OK(flash_ctrl_testutils_wait_for_init(&flash_ctrl));
    CHECK_STATUS_OK(keymgr_testutils_flash_init(&flash_ctrl, &kCreatorSecret,
                                                &kOwnerSecret));

    // Generate entropy to simulate OTP SECRET1 provisioning operations.
    // See code this models in:
    // `personalize.c:manuf_personalize_device_secret1()`
    uint64_t
        flash_addr_scrambling_seed[OTP_CTRL_PARAM_FLASH_ADDR_KEY_SEED_SIZE /
                                   sizeof(uint64_t)];
    uint64_t
        flash_data_scrambling_seed[OTP_CTRL_PARAM_FLASH_DATA_KEY_SEED_SIZE /
                                   sizeof(uint64_t)];
    uint64_t sram_data_scrambling_seed[OTP_CTRL_PARAM_SRAM_DATA_KEY_SEED_SIZE /
                                       sizeof(uint64_t)];
    CHECK_STATUS_OK(entropy_complex_init());
    CHECK_STATUS_OK(
        entropy_csrng_instantiate(/*disable_trng_input=*/kHardenedBoolFalse,
                                  /*seed_material=*/NULL));
    CHECK_STATUS_OK(
        entropy_csrng_reseed(/*disable_trng_inpu=*/kHardenedBoolFalse,
                             /*seed_material=*/NULL));
    CHECK_STATUS_OK(entropy_csrng_generate(
        /*seed_material=*/NULL, (uint32_t *)flash_addr_scrambling_seed,
        OTP_CTRL_PARAM_FLASH_ADDR_KEY_SEED_SIZE / sizeof(uint32_t),
        /*fips_check=*/kHardenedBoolTrue));
    CHECK_STATUS_OK(
        entropy_csrng_reseed(/*disable_trng_inpu=*/kHardenedBoolFalse,
                             /*seed_material=*/NULL));
    CHECK_STATUS_OK(entropy_csrng_generate(
        /*seed_material=*/NULL, (uint32_t *)flash_data_scrambling_seed,
        OTP_CTRL_PARAM_FLASH_DATA_KEY_SEED_SIZE / sizeof(uint32_t),
        /*fips_check=*/kHardenedBoolTrue));
    CHECK_STATUS_OK(
        entropy_csrng_reseed(/*disable_trng_inpu=*/kHardenedBoolFalse,
                             /*seed_material=*/NULL));
    CHECK_STATUS_OK(entropy_csrng_generate(
        /*seed_material=*/NULL, (uint32_t *)sram_data_scrambling_seed,
        OTP_CTRL_PARAM_SRAM_DATA_KEY_SEED_SIZE / sizeof(uint32_t),
        /*fips_check=*/kHardenedBoolTrue));
    CHECK_STATUS_OK(entropy_csrng_uninstantiate());
    sw_reset();

    // Generate entropy to simulate OTP SECRET2 provisioning operations.
    // See code this models in:
    // `personalize.c:manuf_personalize_device_secrets()`
    uint32_t seed[10];
    CHECK_STATUS_OK(entropy_complex_init());
    for (size_t i = 0; i < 8; ++i) {
      CHECK_STATUS_OK(
          entropy_csrng_instantiate(/*disable_trng_input=*/kHardenedBoolFalse,
                                    /*seed_material=*/NULL));
      CHECK_STATUS_OK(entropy_csrng_generate(/*seed_material=*/NULL, seed,
                                             ARRAYSIZE(seed),
                                             /*fips_check*/ kHardenedBoolTrue));
      CHECK_STATUS_OK(entropy_csrng_uninstantiate());
    }
    CHECK_STATUS_OK(
        entropy_csrng_instantiate(/*disable_trng_input=*/kHardenedBoolFalse,
                                  /*seed_material=*/NULL));
    for (size_t i = 0; i < 3; ++i) {
      CHECK_STATUS_OK(entropy_csrng_generate(/*seed_material=*/NULL, seed,
                                             ARRAYSIZE(seed),
                                             /*fips_check*/ kHardenedBoolTrue));
      CHECK_STATUS_OK(
          entropy_csrng_reseed(/*disable_trng_input=*/kHardenedBoolFalse,
                               /*seed_material=*/NULL));
    }
    CHECK_STATUS_OK(entropy_csrng_uninstantiate());

    sw_reset();
  } else {
    LOG_INFO("Coming out of SW Reset.");

    // Initialize keymgr binding state (since we are running with the test ROM).
    sc_keymgr_sw_binding_set(&kBindingValueRom, &kBindingValueRom);
    sc_keymgr_creator_max_ver_set(kMaxVerRom);

    // Run tests.
    // CHECK_STATUS_OK(expected_pass());
    CHECK_STATUS_OK(expected_fail());
  }

  return true;
}
