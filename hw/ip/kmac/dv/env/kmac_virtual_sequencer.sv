// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_virtual_sequencer extends cip_base_virtual_sequencer #(
    .CFG_T(kmac_env_cfg),
    .COV_T(kmac_env_cov)
  );
  `uvm_component_utils(kmac_virtual_sequencer)

  `uvm_component_new

  kmac_app_sequencer kmac_app_sequencer_h[kmac_env_pkg::NUM_APP_INTF];
  key_sideload_sequencer key_sideload_sequencer_h;

endclass
