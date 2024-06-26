// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// ---------------------------------------------
// TileLink sequence item with all protocol related constraint disabled
// ---------------------------------------------
class xbar_seq_err_item extends cip_tl_seq_item;

  `uvm_object_utils(xbar_seq_err_item)
  `uvm_object_new

  function void pre_randomize();
    disable_a_chan_protocol_constraint();
    no_d_error_c.constraint_mode(0);
  endfunction

  // Remove modification on a_user, so it's freely randomized
  function void post_randomize();
  endfunction
endclass
