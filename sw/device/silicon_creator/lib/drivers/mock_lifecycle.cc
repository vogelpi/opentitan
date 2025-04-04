// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/silicon_creator/lib/drivers/mock_lifecycle.h"

namespace rom_test {
extern "C" {
lifecycle_state_t lifecycle_state_get(void) {
  return MockLifecycle::Instance().State();
}

uint32_t lifecycle_raw_state_get(void) {
  return MockLifecycle::Instance().RawState();
}

void lifecycle_device_id_get(lifecycle_device_id_t *device_id) {
  MockLifecycle::Instance().DeviceId(device_id);
}

void lifecycle_hw_rev_get(lifecycle_hw_rev_t *hw_rev) {
  MockLifecycle::Instance().HwRev(hw_rev);
}

hardened_bool_t lifecycle_din_eq(lifecycle_device_id_t *id, uint32_t *din) {
  if (id->device_id[1] == din[0] && id->device_id[2] == din[1])
    return kHardenedBoolTrue;
  return kHardenedBoolFalse;
}
}  // extern "C"
}  // namespace rom_test
