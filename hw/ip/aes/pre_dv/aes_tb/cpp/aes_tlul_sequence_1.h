// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_1_H_
#define OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_1_H_

#include "aes_tlul_sequence_common.h"
#include "crypto.h"

// Example 1 - encrypt/decrypt all key lenghts

static const int num_transactions_max = 1 + 3 * (21 + 8 + 8) + 6
    // Test Case 1
    // setup // tag
    + 26 +   12
    // Test Case 2
    // setup // 1 ciphertext block // tag
    + 26 +   3 + 9 +               12
    // Test Case 4
    // setup // 2 AAD blocks - last incomplete
    + 26  +  7 + 7
    // 4 C blocks - last incomplete // tag
    + 3 + 3 + (4*9) +               12
    // Test Case 4 Decryption
    + 27 + 7 + 7 + 3 + 3 + (4*9) + 12
    // Test Case 4 Save
    + 27 + 7 + 3 + 5 + 2
    // Test Case 4 Restore
    + 27 + 7 + 7 + 3 + 3 + (4*9) + 12;
static const TLI tl_i_transactions[num_transactions_max] = {
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    // AES-128
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 128-bit
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},

    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x33221100, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x77665544, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xBBAA9988, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xFFEEDDCC, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_TRIGGER, 0xF, 0x1, 0, true},  // start
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    // AES-192
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x2 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 192-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x2 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 192-bit
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},

    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x33221100, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x77665544, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xBBAA9988, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xFFEEDDCC, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x2 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 192-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x2 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 192-bit
    {true, 0, 0, 2, 0, AES_TRIGGER, 0xF, 0x1, 0, true},  // start
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    // AES-256
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x4 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 256-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x4 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 256-bit
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},

    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x33221100, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x77665544, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xBBAA9988, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xFFEEDDCC, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x4 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 256-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x1 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x4 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesEcb << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 256-bit
    {true, 0, 0, 2, 0, AES_TRIGGER, 0xF, 0x1, 0, true},  // start
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    // Clear
    {true, 0, 0, 2, 0, AES_TRIGGER, 0xF, 0xE, 0, true},  // clear
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // GCM - Test Case 1 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // GCM - Test Case 2 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x03020100, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x07060504, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0B0A0908, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0F0E0D0C, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x13121110, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x17161514, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x1B1A1918, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x1F1E1D1C, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x80000000, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // GCM - Test Case 4 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x92e9fffe, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x1c736586, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x948f6a6d, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x08833067, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0xbebafeca, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0xaddbcefa, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x88f8cade, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xefbeadde, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xefbeadde, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xd2daadab, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x01020304, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x05060708, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x090a0b0c, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes

    // text, 16 bytes
    // d9313225 f88406e5 a55909c5 aff5269a
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x253231d9, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xe50684f8, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xc50959a5, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x9a26f5af, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    // 86a7a953 1534f7da 2e4c303d 8a318a72
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x53a9a786, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xdaf73415, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x3d304c2e, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x728a318a, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    // 1c3c0c95 95680953 2fcf0e24 49a6b525
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x950c3c1c, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x53096895, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x240ecf2f, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x25b5a649, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes

    // text, 12 bytes
    // b16aedf5 aa0de657 ba637b39
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xf5ed6ab1, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x57e60daa, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x397b63ba, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x01020304, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    // 00000000 000000a0 00000000 000001e0
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xa0000000, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xe0010000, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // GCM - Test Case 4 Decryption
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x2,
     0, true},  // ctrl - decrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x92e9fffe, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x1c736586, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x948f6a6d, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x08833067, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0xbebafeca, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0xaddbcefa, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x88f8cade, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xefbeadde, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xefbeadde, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xd2daadab, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x01020304, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x05060708, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x090a0b0c, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes

    // text, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xc21e8342, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x24747721, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xb721724b, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x9cd4d084, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x2f21aae3, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xe0a4022c, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x237ec135, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x2ea1ac29, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xb214d521, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x1c936654, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x5a6a8f7d, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x05aa84ac, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes

    // text, 12 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x390ba31b, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x97ac0a6a, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x91e0583d, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x01020304, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    // 00000000 000000a0 00000000 000001e0
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xa0000000, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xe0010000, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // GCM - Test Case 4 Save
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x92e9fffe, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x1c736586, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x948f6a6d, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x08833067, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0xbebafeca, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0xaddbcefa, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x88f8cade, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 16 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xefbeadde, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xcefaedfe, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xefbeadde, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x10,
     0, true},  // save
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x10,
     0, true},  // save
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // Clear and reseed
    {true, 0, 0, 2, 0, AES_TRIGGER, 0xF, 0xE, 0, true},  // clear
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},

    // GCM - Test Case 4 Restore
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_CONFIG, 0xF,
     (0x0 << AES_CTRL_MANUAL_OPERATION_OFFSET) |
         (0x1 << AES_CTRL_KEY_LEN_OFFSET) |
         (kCryptoAesGcm << AES_CTRL_MODE_OFFSET) | 0x1,
     0, true},  // ctrl - encrypt, 128-bit
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x1,
     0, true},  // init, 16 bytes
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x00, 0xF, 0x92e9fffe, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x04, 0xF, 0x1c736586, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x08, 0xF, 0x948f6a6d, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x0C, 0xF, 0x08833067, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE0_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x00, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x04, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x08, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x0C, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x10, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x14, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x18, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_KEY_SHARE1_0 + 0x1c, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x0, 0xF, 0xbebafeca, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x4, 0xF, 0xaddbcefa, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0x8, 0xF, 0x88f8cade, 0, true},
    {true, 0, 0, 2, 0, AES_IV_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x2,
     0, true},  // restore, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x2,
     0, true},  // restore, 16 bytes
    //{true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xf8aa56ed, 0, true},
    //{true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x04672da7, 0, true},
    //{true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x2892db9f, 0, true},
    //{true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x2213baed, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xb3b211df, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xa00e629b, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x004067d2, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x3aa7016a, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x4 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x04,
     0, true},  // aad, 4 bytes
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xd2daadab, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x01020304, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x05060708, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x090a0b0c, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 16 bytes

    // text, 16 bytes
    // d9313225 f88406e5 a55909c5 aff5269a
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x253231d9, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xe50684f8, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0xc50959a5, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x9a26f5af, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    // 86a7a953 1534f7da 2e4c303d 8a318a72
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x53a9a786, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xdaf73415, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x3d304c2e, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x728a318a, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    // text, 16 bytes
    // 1c3c0c95 95680953 2fcf0e24 49a6b525
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x950c3c1c, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x53096895, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x240ecf2f, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x25b5a649, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0xC << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x08,
     0, true},  // text, 12 bytes

    // text, 12 bytes
    // b16aedf5 aa0de657 ba637b39
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0xf5ed6ab1, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0x57e60daa, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x397b63ba, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0x01020304, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},

    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    {true, 0, 0, 2, 0, AES_GCM_CONFIG, 0xF,
     (0x10 << AES_GCM_CTRL_NUM_VALID_BYTES_OFFSET) | 0x20,
     0, true},  // tag, 16 bytes
    // 00000000 000000a0 00000000 000001e0
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x4, 0xF, 0xa0000000, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 0, 0, 2, 0, AES_DATA_IN_0 + 0xC, 0xF, 0xe0010000, 0, true},
    {true, 4, 0, 2, 0, AES_STATUS, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x0, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x4, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0x8, 0xF, 0x0, 0, true},
    {true, 4, 0, 2, 0, AES_DATA_OUT_0 + 0xC, 0xF, 0x0, 0, true},
};

static const int num_responses_max = 1 + 18 + 18 + 5
    // Test Case 1
    + 2 + 6
    // Test Case 2
    + 2 + 1 + 5 + 6
    // Test Case 4
    + 2 + 2 + 1 + 1 + 4*5 + 6
    // Test Case 4 Decryption
    + 2 + 2 + 1 + 1 + 4*5 + 6
    // Test Case 4 Save
    + 2 + 1 + 1 + 1 + 4
    // Clear
    + 1
    // Test Case 4 Restore
    + 2 + 2 + 1 + 1 + 4*5 + 6;
static const EXP_RESP tl_o_exp_resp[num_responses_max] = {
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xD8E0C469},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x30047B6A},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x80B7CDD8},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5AC5B470},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xA47CA9DD},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xE0DF4C86},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xA070AF6E},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x91710DEC},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {0x0, 0x0},                             // don't care
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xCAB7A28E},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xBF456751},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x9049FCEA},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x8960494B},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     0},  // status shows output valid no longer valid

    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {0x0, 0x0},                     // data_out0 cleared to random value
    {0x0, 0x0},                     // data_out1 cleared to random value
    {0x0, 0x0},                     // data_out2 cleared to random value
    {0x0, 0x0},                     // data_out3 cleared to random value

    // GCM - Test Case 1 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xCEFCE258},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x61307EFA},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x571D7F36},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5A45E7A4},

    // GCM - Test Case 2 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xceda8803},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x92a3b660},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb9c228f3},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x78feb271},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xd4476eab},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xbd13ec2c},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb2673af5},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xdfbd5712},

    // GCM - Test Case 4 from
    // https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-spec.pdf
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - setup
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - iv
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 1
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 2
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 1
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 42831ec2 21777424 4b7221b7 84d0d49c
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xc21e8342},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x24747721},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb721724b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x9cd4d084},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // e3aa212f 2c02a4e0 35c17e23 29aca12e
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2f21aae3},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xe0a4022c},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x237ec135},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2ea1ac29},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 21d514b2 5466931c 7d8f6a5a ac84aa05
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb214d521},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x1c936654},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5a6a8f7d},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x05aa84ac},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 4
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 1ba30b39 6a0aac97 3d58e091
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x390ba31b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x97ac0a6a},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x91e0583d},
    {CHECK_DATA_OUT ? 0x0        : 0x0, 0x01020304},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - tag
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 5bc94fbc 3221a5db 94fae95a e7121a47
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xbc4fc95b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xdba52132},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5ae9fa94},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x471a12e7},

    // GCM - Test Case 4 Decryption
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - setup
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - iv
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 1
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 2
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 1
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x253231d9},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xe50684f8},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xc50959a5},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x9a26f5af},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x53a9a786},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xdaf73415},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x3d304c2e},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x728a318a},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x950c3c1c},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x53096895},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x240ecf2f},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x25b5a649},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 4
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xf5ed6ab1},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x57e60daa},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x397b63ba},
    {CHECK_DATA_OUT ? 0x0        : 0x0, 0x01020304},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - tag
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 5bc94fbc 3221a5db 94fae95a e7121a47
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xbc4fc95b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xdba52132},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5ae9fa94},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x471a12e7},

    // GCM - Test Case 4 Save
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - setup
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - iv
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 1
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - save
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    //{CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xf8aa56ed},
    //{CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x04672da7},
    //{CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2892db9f},
    //{CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2213baed},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb3b211df},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xa00e629b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x004067d2},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x3aa7016a},

    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - clear

    // GCM - Test Case 4 Restore
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - setup
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - iv
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - restore
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - aad 2
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 1
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 42831ec2 21777424 4b7221b7 84d0d49c
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xc21e8342},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x24747721},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb721724b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x9cd4d084},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // e3aa212f 2c02a4e0 35c17e23 29aca12e
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2f21aae3},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xe0a4022c},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x237ec135},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x2ea1ac29},
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 21d514b2 5466931c 7d8f6a5a ac84aa05
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xb214d521},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x1c936654},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5a6a8f7d},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x05aa84ac},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - text 4
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 1ba30b39 6a0aac97 3d58e091
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x390ba31b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x97ac0a6a},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x91e0583d},
    {CHECK_DATA_OUT ? 0x0        : 0x0, 0x01020304},
    {1 << AES_STATUS_IDLE_OFFSET,
     1 << AES_STATUS_IDLE_OFFSET},  // status shows idle - tag
    {1 << AES_STATUS_OUTPUT_VALID_OFFSET,
     1 << AES_STATUS_OUTPUT_VALID_OFFSET},  // status shows output valid
    // 5bc94fbc 3221a5db 94fae95a e7121a47
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xbc4fc95b},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0xdba52132},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x5ae9fa94},
    {CHECK_DATA_OUT ? 0xFFFFFFFF : 0x0, 0x471a12e7},
};

#endif  // OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_1_H_
