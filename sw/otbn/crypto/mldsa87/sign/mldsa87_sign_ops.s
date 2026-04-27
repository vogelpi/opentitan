/* Copyright lowRISC contributors (OpenTitan project). */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/* High-level operations for ML-DSA-87 sign. */

.globl compute_w

.text

/**
 * Compute the commitment vector W = A * Y.
 *
 * Calculate a matrix-vector multiplication of a 8x7 matrix A and a 7x1 vector
 * Y to produce the commitment vector W (2 * 8192 bytes). The individual
 * polynomials of both A and Y are generated on-the-fly through `expand_a` and
 * `expand_mask` respectively. `expand_a` requires a 34-byte seed RHO (in a
 * 64-byte region) and `expand_mask` requires a Boolean-shared 66-byte seed
 * RHO_PRIME (in a 96-byte region). Furthermore, three polynomial slots are
 * required for the storage of intermediate results.
 *
 * @param[in] x2: DMEM address of first share of the commitment vector W.
 * @param[in] x3: DMEM address of second share of the commitment vector W.
 * @param[in] x4: DMEM address of the matrix seed RHO.
 * @param[in] x5: DMEM address of the first share of the vector seed RHO_PRIME.
 * @param[in] x6: DMEM address of the second share of the vector seed RHO_PRIME.
 * @param[in] x7: DMEM address of polynomial slot 0 (1024 bytes).
 * @param[in] x8: DMEM address of polynomial slot 1 (1024 bytes).
 * @param[in] x9: DMEM address of polynomial slot 2 (1024 bytes).
 */
compute_w:
  /* Prepare DMEM address registers. */
  addi x10, x2, 0 /* W0 (W share 0) */
  addi x11, x3, 0 /* W1 (W share 1) */
  addi x12, x4, 0 /* RHO */
  addi x13, x5, 0 /* RHO_PRIME_0 (RHO_PRIME share 0) */
  addi x14, x6, 0 /* RHO_PRIME_1 (RHO_PRIME share 1) */
  addi x15, x7, 0 /* Slot 0 */
  addi x16, x8, 0 /* Slot 1 */
  addi x17, x9, 0 /* Slot 2 */

  /* Zeroize the output DMEM locations just to be safe. */
  addi x20, x10, 0
  addi x21, x0, 256
  jal x1, zeroize

  addi x20, x11, 0
  addi x21, x0, 256
  jal x1, zeroize

  /* Loop indices for the `expand_a` and `expand_mask`. */
  addi x18, x0, 0 /* r */
  addi x19, x0, 0 /* s */

  /*
   * The matrix-vector multiplication proceeds in column-major order:
   *
   * for s in [0, 6]:
   *   Y0[s], Y1[s] = expand_mask(RHO_PRIME_0, RHO_PRIME_1, s)
   *   Y0[s], Y1[s] = NTT(Y0[s]), NTT(Y1[s])
   *   for r in [0, 7]:
   *     A[r][s] = expand_a(RHO, r, s)
   *     W0[r] += A[r][s] * Y0[s]
   *     W1[r] += A[r][s] * Y1[s]
   *   end for
   * end for
   */
  loopi 7, 37
    /* Expand polynomials Y0[s] and Y1[s] and store them in slots 1 and 2. */
    addi x2, x16, 0
    addi x3, x17, 0
    addi x4, x13, 0
    addi x5, x14, 0
    addi x6, x19, 0
    jal x1, expand_mask

    /* Compute NTT(Y0[s]). */
    addi x2, x16, 0
    addi x3, x16, 0
    jal x1, ntt

    /* Compute NTT(Y1[s]). */
    addi x2, x17, 0
    addi x3, x17, 0
    jal x1, ntt

    loopi 8, 18
      /* Expand polynomial A[r][s] and store it at slot 0. */
      addi x2, x15, 0
      addi x3, x12, 0
      addi x4, x18, 0
      addi x5, x19, 0
      jal x1, expand_a

      /* W0[r] += A[r][s] * NTT(Y0[s]). */
      addi x2, x15, 0
      addi x3, x16, 0
      addi x4, x10, 0
      addi x5, x10, 0
      jal x1, poly_mul_add

      /* W1[r] += A[r][s] * NTT(Y1[s]). */
      addi x2, x15, 0
      addi x3, x17, 0
      addi x4, x11, 0
      addi x5, x11, 0
      jal x1, poly_mul_add

      /* Increment r and advance output addresses. */
      addi x18, x18, 1
      addi x10, x10, 1024
      addi x11, x11, 1024
      /* End of loop */

    /* Reset r and increment s. */
    addi x18, x0, 0
    addi x19, x19, 1

    /* Reset the output addresses, i.e., subtract 8192. */
    addi x20, x0, 1024
    slli x20, x20, 3
    sub x10, x10, x20
    sub x11, x11, x20
    /* End of loop */

  /* Map the result polynomials back to the time domain. */
  loopi 8, 8
    /* W0[r] = INTT(W0[r]). */
    addi x2, x10, 0
    addi x3, x10, 0
    jal x1, intt

    /* W1[r] = INTT(W1[r]). */
    addi x2, x11, 0
    addi x3, x11, 0
    jal x1, intt

    addi x10, x10, 1024
    addi x11, x11, 1024
    /* End of loop */

  ret
