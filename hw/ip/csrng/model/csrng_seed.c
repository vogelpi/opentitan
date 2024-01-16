// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../aes/model/aes.h"
#include "../../aes/model/crypto.h"

/**
 * Constants
 */
enum {
  kCsrngGenerateLen = 16, // 1 Block
  kCsrngGenerateLenWord = kCsrngGenerateLen / 4,
  kCsrngBlockLen = 16,
  kCsrngBlockLenWord = kCsrngBlockLen / 4,
  kCsrngKeyLen = 32,
  kCsrngKeyLenWord = kCsrngKeyLen / 4,
  kCsrngVLen = 16,
  kCsrngVLenWord = kCsrngVLen / 4,
  kCsrngSeedLen = kCsrngKeyLen + kCsrngVLen,
  kCsrngSeedLenWord = kCsrngSeedLen / 4,
};

const crypto_mode_t mode = kCryptoAesEcb;
const unsigned char iv[kCsrngVLen] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};


// The output seed CSRNG is required to generate.
const unsigned int output_seed_csrng[kCsrngBlockLenWord] = {0xff00ffff, 0xff00ffff, 0xff00ffff, 0xff00ffff};
//{0x00000000, 0x00000000, 0x00000000, 0x00000000};

// CTR_DRBG key AFTER Instantiate command. In FIPS-197 (AES) notation, i.e., least-significant byte first. Can be arbitrarily chosen. 
const unsigned char inst_key[kCsrngKeyLen] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a,
                                              0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15,
                                              0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f};

void convert_v_from_csrng_to_aes(unsigned char * aes, const unsigned int * csrng) {
  // Convert v from FIPS-197 (AES) notation to OT CSRNG notation.
  for (int w = 0; w < kCsrngBlockLenWord; ++w) {
    unsigned int word = csrng[3 - w];
    for (int b = 0; b < 4; ++b) {
      aes[w * 4 + b] = (word >> 8 * (3 - b)) & 0xff;
    }
  }
}

void convert_v_from_aes_to_csrng(const unsigned char * aes, unsigned int * csrng) {
  // Convert v from OpenTitan CSRNG notation to FIPS-197 (AES) notation.
  for (int w = 0; w < kCsrngBlockLenWord; ++w) {
    unsigned int word = 0;
    for (int b = 0; b < 4; ++b) {
      word |= aes[4 * w + b] << 8 * (3 - b);
    }
    csrng[3 - w] = word;
  }
}

void csrng_print_word(const unsigned int *data, const int num_words) {
  for (int i = 0; i < num_words; i++) {
    if ((i > 0) && (i % 4 == 0)) {
      printf("\n");
    }
    printf("0x%08x, ", data[i]);
  }
  printf("\n");
}

int main() {

  int ret_len;
  unsigned char output_seed[kCsrngBlockLen];
  unsigned char update_temp[kCsrngSeedLen];

  // Convert output_seed to FIPS-197 notation.
  convert_v_from_csrng_to_aes(output_seed, output_seed_csrng);

  // Compute CTR_DRBG v AFTER Instantiate command. Based on inst_key and output_seed.
  unsigned char inst_v[kCsrngVLen];
  ret_len =
      crypto_decrypt(inst_v, iv, output_seed, kCsrngVLen, inst_key, kCsrngKeyLen, mode);
  if (ret_len != kCsrngVLen) {
    printf("ERROR: ret_len = %i, expected %i. Aborting now\n", ret_len, kCsrngVLen);
    return 1;
  }

  // Subtract 1 from v - This is added as part of the Generate command.
  if (inst_v[15] == 0) {
    printf("ERROR: Cannot perform subtraction in inst_v\n");
    return 1;
  }
  inst_v[15]--;

  ////////////////////////////////////////////
  // Compute seed material for Instantiate. //
  ////////////////////////////////////////////

  unsigned char inst_seed_material[kCsrngSeedLen];
  unsigned int inst_seed_material_csrng[kCsrngSeedLenWord];
  unsigned int inst_key_csrng[kCsrngKeyLenWord];
  unsigned int inst_v_csrng[kCsrngVLenWord];

  // Start Key and V for CTR_DRBG.
  unsigned char key[kCsrngKeyLen] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
  unsigned char v[kCsrngVLen] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

  // Block_Encrypt()
  for (int i = 0; i < kCsrngSeedLen / kCsrngVLen; ++i) {
    // V + 1.
    v[15]++;
    
    // Block_Encrypt(Key, V)
    ret_len =
      crypto_encrypt(&update_temp[i * kCsrngVLen], iv, v, kCsrngVLen, key, kCsrngKeyLen, mode);
      if (ret_len != kCsrngVLen) {
        printf("ERROR: ret_len = %i, expected %i. Aborting now\n", ret_len, kCsrngVLen);
        return 1;
      }
  }

  // XOR inst_key / inst_v to get the seed material.
  for (int i = 0; i < kCsrngKeyLen; ++i) {
    inst_seed_material[i] = update_temp[i] ^ inst_key[i];
  }
  for (int i = 0; i < kCsrngVLen; ++i) {
    inst_seed_material[i + kCsrngKeyLen] = update_temp[i + kCsrngKeyLen] ^ inst_v[i];
  }

  ////////////////////////////////////////
  // Compute Key and IV AFTER Generate. //
  ////////////////////////////////////////

  unsigned char gen_key[kCsrngKeyLen];
  unsigned char gen_v[kCsrngVLen];
  unsigned int gen_key_csrng[kCsrngKeyLenWord];
  unsigned int gen_v_csrng[kCsrngVLenWord];

  // Initialize Key and V to state after Instantiate.
  for (int i = 0; i < kCsrngKeyLen; ++i) {
    gen_key[i] = inst_key[i];
  }
  for (int i = 0; i < kCsrngVLen; ++i) {
    gen_v[i] = inst_v[i];
  }

  // We do a Block_Encrypt(Key, V+1) to generate output_seed.
  gen_v[15]++;

  // Afterwards, perform an Update(Key, V) where V is V+1 from above.
  // Block_Encrypt()
  for (int i = 0; i < kCsrngSeedLen / kCsrngVLen; ++i) {
    // V + 1.
    gen_v[15]++;
    
    // Block_Encrypt(Key, V)
    ret_len =
      crypto_encrypt(&update_temp[i * kCsrngVLen], iv, gen_v, kCsrngVLen, gen_key, kCsrngKeyLen, mode);
      if (ret_len != kCsrngVLen) {
        printf("ERROR: ret_len = %i, expected %i. Aborting now\n", ret_len, kCsrngVLen);
        return 1;
      }
  }

  // Get the new Key and V.
  for (int i = 0; i < kCsrngKeyLen; ++i) {
    gen_key[i] = update_temp[i];
  }
  for (int i = 0; i < kCsrngVLen; ++i) {
    gen_v[i] = update_temp[i + kCsrngKeyLen];
  }

  ///////////////////////////////////////
  // Compute seed material for Reseed. //
  ///////////////////////////////////////
  // After the reseed, we must again be back at inst_key, inst_v.
  
  unsigned char res_seed_material[kCsrngSeedLen];
  unsigned int res_seed_material_csrng[kCsrngSeedLenWord];
  unsigned char res_key[kCsrngKeyLen];
  unsigned char res_v[kCsrngVLen];

  // Initialize Key and V to state after Generate.
  for (int i = 0; i < kCsrngKeyLen; ++i) {
    res_key[i] = gen_key[i];
  }
  for (int i = 0; i < kCsrngVLen; ++i) {
    res_v[i] = gen_v[i];
  }

  // Perform an Update(Key, V).
  // Block_Encrypt()
  for (int i = 0; i < kCsrngSeedLen / kCsrngVLen; ++i) {
    // V + 1.
    res_v[15]++;
    
    // Block_Encrypt(Key, V)
    ret_len =
      crypto_encrypt(&update_temp[i * kCsrngVLen], iv, res_v, kCsrngVLen, res_key, kCsrngKeyLen, mode);
      if (ret_len != kCsrngVLen) {
        printf("ERROR: ret_len = %i, expected %i. Aborting now\n", ret_len, kCsrngVLen);
        return 1;
      }
  }

  // XOR inst_key / inst_v to get the seed material.
  for (int i = 0; i < kCsrngKeyLen; ++i) {
    res_seed_material[i] = update_temp[i] ^ inst_key[i];
  }
  for (int i = 0; i < kCsrngVLen; ++i) {
    res_seed_material[i + kCsrngKeyLen] = update_temp[i + kCsrngKeyLen] ^ inst_v[i];
  }

  //////////////
  // Printing //
  //////////////
  printf("In FIPS-197 (AES) notation:\n");
  printf("Desired output seed:\t\t");
  aes_print_block(output_seed, kCsrngVLen);
  printf("Key after Instantiate (chosen):\t");
  aes_print_block(inst_key, kCsrngKeyLen);
  printf(" V  after Instantiate:\t\t");
  aes_print_block(inst_v, kCsrngVLen);
  printf("seed material for Instantiate:\t");
  aes_print_block(inst_seed_material, kCsrngSeedLen);
  printf("Key after Generate:\t\t");
  aes_print_block(gen_key, kCsrngKeyLen);
  printf(" V  after Generate:\t\t");
  aes_print_block(gen_v, kCsrngVLen);
  printf("seed material for Reseed:\t");
  aes_print_block(res_seed_material, kCsrngSeedLen);

  // Conversions
  for (int i = 0; i < kCsrngSeedLenWord / 4; ++i) {
    convert_v_from_aes_to_csrng(&inst_seed_material[i * kCsrngBlockLen], &inst_seed_material_csrng[(2 - i) * kCsrngBlockLenWord]);
  }
  for (int i = 0; i < kCsrngKeyLenWord / 4; ++i) {
    convert_v_from_aes_to_csrng(&inst_key[i * kCsrngBlockLen], &inst_key_csrng[(1 - i) * kCsrngBlockLenWord]);
  }
  convert_v_from_aes_to_csrng(inst_v, inst_v_csrng);
  for (int i = 0; i < kCsrngKeyLenWord / 4; ++i) {
    convert_v_from_aes_to_csrng(&gen_key[i * kCsrngBlockLen], &gen_key_csrng[(1 - i) * kCsrngBlockLenWord]);
  }
  convert_v_from_aes_to_csrng(gen_v, gen_v_csrng);
  for (int i = 0; i < kCsrngSeedLenWord / 4; ++i) {
    convert_v_from_aes_to_csrng(&res_seed_material[i * kCsrngBlockLen], &res_seed_material_csrng[(2 - i) * kCsrngBlockLenWord]);
  }

  printf("\n");
  printf("In OpenTitan CSRNG notation:\n");
  printf("Desired output seed:\t\t");
  csrng_print_word(output_seed_csrng, kCsrngGenerateLenWord);
  printf("Instantiate seed material:\n\n");
  csrng_print_word(inst_seed_material_csrng, kCsrngSeedLenWord);
  printf("\n");
  printf("Key after Instantiate (chosen):\n\n");
  csrng_print_word(inst_key_csrng, kCsrngKeyLenWord);
  printf("\n");
  printf(" V  after Instantiate:\n\n");
  csrng_print_word(inst_v_csrng, kCsrngVLenWord);
  printf("\n");
  printf("Key after Generate:\n\n");
  csrng_print_word(gen_key_csrng, kCsrngKeyLenWord);
  printf("\n");
  printf(" V  after Generate:\n\n");
  csrng_print_word(gen_v_csrng, kCsrngVLenWord);
  printf("\n");
  printf("Reseed seed material:\n\n");
  csrng_print_word(res_seed_material_csrng, kCsrngSeedLenWord);
  printf("\n");
  return 0;
}
