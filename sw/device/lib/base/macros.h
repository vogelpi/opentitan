// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
#define OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_

// This file may be used in .S files, in which case standard library includes
// should be elided.
#if !defined(__ASSEMBLER__) && !defined(NOSTDINC)
#include <assert.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
// The <type_traits> header is required for the C++-only `SignConverter` class.
// See `SignConverter` for an explanation of this `extern "C++"` block.
extern "C++" {
#include <type_traits>
}
#endif
#endif

/**
 * @file
 * @brief Generic preprocessor macros that don't really fit anywhere else.
 */

/**
 * Computes the number of elements in the given array.
 *
 * Note that this can only determine the length of *fixed-size* arrays. Due to
 * limitations of C, it will incorrectly compute the size of an array passed as
 * a function argument, because those automatically decay into pointers. This
 * function can only be used correctly with:
 * - Arrays declared as stack variables.
 * - Arrays declared at global scope.
 * - Arrays that are members of a struct or union.
 *
 * @param array The array expression to measure.
 * @return The number of elements in the array, as a `size_t`.
 */
// This is a sufficiently well-known macro that we don't really need to bother
// with a prefix like the others, and a rename will cause churn.
#define ARRAYSIZE(array) (sizeof(array) / sizeof(array[0]))

/**
 * An annotation that a switch/case fallthrough is the intended behavior.
 */
#define OT_FALLTHROUGH_INTENDED __attribute__((fallthrough))

/**
 * A directive to force the compiler to inline a function.
 */
#define OT_ALWAYS_INLINE __attribute__((always_inline)) inline

/**
 * The `restrict` keyword is C specific, so we provide a C++-portable wrapper
 * that uses the GCC name.
 *
 * It only needs to be used in headers; .c files can use `restrict` directly.
 */
#define OT_RESTRICT __restrict__

/**
 * An argument stringification macro.
 */
#define OT_STRINGIFY(a) OT_STRINGIFY_(a)
#define OT_STRINGIFY_(a) #a

/**
 * A variable-argument macro that expands to the number of arguments passed into
 * it, between 0 and 31 arguments.
 *
 * This macro is based off of a well-known preprocessor trick. This
 * StackOverflow post expains the trick in detail:
 * https://stackoverflow.com/questions/2308243/macro-returning-the-number-of-arguments-it-is-given-in-c
 * TODO #2026: a dummy token is required for this to work correctly.
 *
 * @param dummy a dummy token that is required to be passed for the calculation
 *              to work correctly.
 * @param ... the variable args list.
 */
#define OT_VA_ARGS_COUNT(dummy, ...)                                          \
  OT_SHIFT_N_VARIABLE_ARGS_(dummy, ##__VA_ARGS__, 31, 30, 29, 28, 27, 26, 25, \
                            24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,   \
                            12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)

// Implementation details for `OT_VA_ARGS_COUNT()`.
#define OT_SHIFT_N_VARIABLE_ARGS_(...) OT_GET_NTH_VARIABLE_ARG_(__VA_ARGS__)
#define OT_GET_NTH_VARIABLE_ARG_(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, \
                                 x11, x12, x13, x14, x15, x16, x17, x18, x19, \
                                 x20, x21, x22, x23, x24, x25, x26, x27, x28, \
                                 x29, x30, x31, n, ...)                       \
  n

/**
 * An argument concatenation macro.
 *
 * Because the `##` operator inhibits expansion, we use a level of indirection
 * to create a macro which concatenates without inhibition.
 */
#define OT_CAT(a, ...) OT_PRIMITIVE_CAT(a, __VA_ARGS__)
#define OT_PRIMITIVE_CAT(a, ...) a##__VA_ARGS__

/**
 * A macro which gets the nth arg from a __VA_LIST__
 */
#define OT_GET_ARG(n, ...) OT_CAT(OT_CAT(OT_GET_ARG_, n), _)(__VA_ARGS__)

/**
 * A macro which gets the last arg from a __VA_LIST__
 *
 * Note: we leave out the dummy argument because we want count to
 * give us the number of args minus one so that the created
 * OT_GET_ARG_n token will contain the correct integer.
 */
#define OT_GET_LAST_ARG(...) \
  OT_GET_ARG(OT_VA_ARGS_COUNT(__VA_ARGS__), ##__VA_ARGS__)

/**
 * The following collection of `OT_GET_ARG` macros are used to construct the
 * generic "get nth arg" macro.
 */
#define OT_GET_ARG_0_(x0, ...) x0
#define OT_GET_ARG_1_(x1, x0, ...) x0
#define OT_GET_ARG_2_(x2, x1, x0, ...) x0
#define OT_GET_ARG_3_(x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_4_(x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_5_(x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_6_(x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_7_(x7, x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_8_(x8, x7, x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_9_(x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_10_(x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_11_(x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...) x0
#define OT_GET_ARG_12_(x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, \
                       ...)                                                   \
  x0
#define OT_GET_ARG_13_(x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, \
                       x0, ...)                                                \
  x0
#define OT_GET_ARG_14_(x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, \
                       x2, x1, x0, ...)                                     \
  x0
#define OT_GET_ARG_15_(x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, \
                       x3, x2, x1, x0, ...)                                  \
  x0
#define OT_GET_ARG_16_(x16, x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, \
                       x4, x3, x2, x1, x0, ...)                               \
  x0
#define OT_GET_ARG_17_(x17, x16, x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, \
                       x5, x4, x3, x2, x1, x0, ...)                            \
  x0
#define OT_GET_ARG_18_(x18, x17, x16, x15, x14, x13, x12, x11, x10, x9, x8, \
                       x7, x6, x5, x4, x3, x2, x1, x0, ...)                 \
  x0
#define OT_GET_ARG_19_(x19, x18, x17, x16, x15, x14, x13, x12, x11, x10, x9, \
                       x8, x7, x6, x5, x4, x3, x2, x1, x0, ...)              \
  x0
#define OT_GET_ARG_20_(x20, x19, x18, x17, x16, x15, x14, x13, x12, x11, x10, \
                       x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...)           \
  x0
#define OT_GET_ARG_21_(x21, x20, x19, x18, x17, x16, x15, x14, x13, x12, x11, \
                       x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...)      \
  x0
#define OT_GET_ARG_22_(x22, x21, x20, x19, x18, x17, x16, x15, x14, x13, x12, \
                       x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...) \
  x0
#define OT_GET_ARG_23_(x23, x22, x21, x20, x19, x18, x17, x16, x15, x14, x13, \
                       x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, \
                       ...)                                                   \
  x0
#define OT_GET_ARG_24_(x24, x23, x22, x21, x20, x19, x18, x17, x16, x15, x14,  \
                       x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1, \
                       x0, ...)                                                \
  x0
#define OT_GET_ARG_25_(x25, x24, x23, x22, x21, x20, x19, x18, x17, x16, x15, \
                       x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3,   \
                       x2, x1, x0, ...)                                       \
  x0
#define OT_GET_ARG_26_(x26, x25, x24, x23, x22, x21, x20, x19, x18, x17, x16, \
                       x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4,  \
                       x3, x2, x1, x0, ...)                                   \
  x0
#define OT_GET_ARG_27_(x27, x26, x25, x24, x23, x22, x21, x20, x19, x18, x17, \
                       x16, x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, \
                       x4, x3, x2, x1, x0, ...)                               \
  x0
#define OT_GET_ARG_28_(x28, x27, x26, x25, x24, x23, x22, x21, x20, x19, x18,  \
                       x17, x16, x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, \
                       x5, x4, x3, x2, x1, x0, ...)                            \
  x0
#define OT_GET_ARG_29_(x29, x28, x27, x26, x25, x24, x23, x22, x21, x20, x19, \
                       x18, x17, x16, x15, x14, x13, x12, x11, x10, x9, x8,   \
                       x7, x6, x5, x4, x3, x2, x1, x0, ...)                   \
  x0
#define OT_GET_ARG_30_(x30, x29, x28, x27, x26, x25, x24, x23, x22, x21, x20, \
                       x19, x18, x17, x16, x15, x14, x13, x12, x11, x10, x9,  \
                       x8, x7, x6, x5, x4, x3, x2, x1, x0, ...)               \
  x0
#define OT_GET_ARG_31_(x31, x30, x29, x28, x27, x26, x25, x24, x23, x22, x21, \
                       x20, x19, x18, x17, x16, x15, x14, x13, x12, x11, x10, \
                       x9, x8, x7, x6, x5, x4, x3, x2, x1, x0, ...)           \
  x0

/**
 * A macro that expands to an assertion for the offset of a struct member.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param offset Expected offset of the member.
 */
#define OT_ASSERT_MEMBER_OFFSET(type, member, offset)       \
  static_assert(offsetof(type, member) == UINT32_C(offset), \
                "Unexpected offset for " #type "." #member)

/**
 * A macro that expands to an assertion for the offset of a struct member.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param enum_offset Expected offset of the member as an enum constant.
 */
#define OT_ASSERT_MEMBER_OFFSET_AS_ENUM(type, member, enum_offset) \
  static_assert(offsetof(type, member) == enum_offset,             \
                "Unexpected offset for " #type "." #member)

/**
 * A macro that expands to an assertion for the size of a struct member.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param size Expected size of the type.
 */
#define OT_ASSERT_MEMBER_SIZE(type, member, size)             \
  static_assert(sizeof(((type){0}).member) == UINT32_C(size), \
                "Unexpected size for " #type)

/**
 * A macro that expands to an assertion for the size of a struct member.
 *
 * Identical to `OT_ASSERT_MEMBER_SIZE`, except the size parameter is provided
 * as an enum constant.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param enum_size Expected size of the type as an enum constant.
 */
#define OT_ASSERT_MEMBER_SIZE_AS_ENUM(type, member, enum_size) \
  static_assert(sizeof(((type){0}).member) == enum_size,       \
                "Unexpected size for " #type)

/**
 * A macro that expands to an assertion for the size of a type.
 *
 * @param type A type.
 * @param size Expected size of the type.
 */
#define OT_ASSERT_SIZE(type, size) \
  static_assert(sizeof(type) == UINT32_C(size), "Unexpected size for " #type)

/**
 * A macro that expands to an assertion for an expected enum value.
 *
 * @param var An enum entry.
 * @param expected_value Expected enum value.
 */
#define OT_ASSERT_ENUM_VALUE(var, expected_value) \
  static_assert(var == expected_value, "Unexpected value for " #var)

/**
 * A variable-argument macro that expands to the number of arguments passed into
 * it, between 1 and 32 arguments (1 action and 0-31 others).
 *
 * This macro accepts a macro name and a variable list of items, and will then
 * expand to sequentially call the macro with each provided item in order. This
 * can be useful for performing compile-time checks on arguments in variadic
 * functions defined via macros.
 *
 * For example, OT_VAR_FOR_EACH(TEST, 5, 19, 32, 1, 4) would expand to be
 * `do {TEST(5); TEST(19); TEST(32); TEST(1); TEST(4);} while (false)`
 *
 * @param action The name of the macro to invoke with each item individually.
 * @param ... The variable args list to call the macro on.
 */
#define OT_VA_FOR_EACH(action, ...)                                        \
  do {                                                                     \
    OT_CAT(OT_CAT(OT_VA_FOR_EACH_, OT_VA_ARGS_COUNT(0, ##__VA_ARGS__)), _) \
    (action, ##__VA_ARGS__)                                                \
  } while (false)

/**
 * The following collection of `OT_VA_FOR_EACH` macros are used to construct
 * the generic "for each" `OT_VA_FOR_EACH` macro.
 */
#define OT_VA_FOR_EACH_0_(action)
#define OT_VA_FOR_EACH_1_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_0_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_2_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_1_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_3_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_2_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_4_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_3_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_5_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_4_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_6_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_5_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_7_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_6_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_8_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_7_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_9_(action, item, ...) \
  action(item);                              \
  OT_VA_FOR_EACH_8_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_10_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_9_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_11_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_10_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_12_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_11_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_13_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_12_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_14_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_13_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_15_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_14_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_16_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_15_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_17_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_16_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_18_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_17_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_19_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_18_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_20_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_19_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_21_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_20_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_22_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_21_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_23_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_22_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_24_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_23_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_25_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_24_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_26_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_25_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_27_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_26_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_28_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_27_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_29_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_28_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_30_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_29_(action, ##__VA_ARGS__)
#define OT_VA_FOR_EACH_31_(action, item, ...) \
  action(item);                               \
  OT_VA_FOR_EACH_30_(action, ##__VA_ARGS__)

/**
 * A macro that checks whether a specified argument is not a standard C integer
 * type with a width of 64 bits. Useful when assuming that variable arguments
 * are 32 bits integers.
 *
 * @param arg An argument/expression
 */
#define OT_CHECK_NOT_INT64(arg) \
  _Generic((arg), int64_t: false, uint64_t: false, default: true)

/**
 * A macro that expands to an assertion that wraps the `OT_CHECK_NOT_INT64`
 * macro, failing with a relevant error message if the provided argument is a
 * standard C integer type with a width of 64 bits.
 *
 * @param arg An argument/expression to check
 * @param func_name The name of the macro/functionality being invoked, to be
 * printed in a relevant error if the assertion fails.
 */
#define OT_FAIL_IF_64_BIT(arg, func_name)                          \
  do {                                                             \
    static_assert(OT_CHECK_NOT_INT64(arg),                         \
                  "Argument '" #arg "' passed to the " #func_name  \
                  " function must be no wider than 32 bits. "      \
                  "Hint: maybe cast with '(uint32_t) " #arg "'?"); \
  } while (0)

/**
 * A macro representing the OpenTitan execution platform.
 */
#if __riscv_xlen == 32
#define OT_PLATFORM_RV32 1
#endif

/**
 * A macro indicating whether software should assume reduced hardware
 * support (for the `top_englishbreakafst` toplevel).
 */
#ifdef OT_IS_ENGLISH_BREAKFAST_REDUCED_SUPPORT_FOR_INTERNAL_USE_ONLY_
#define OT_IS_ENGLISH_BREAKFAST 1
#endif

/**
 * Attribute for functions which return errors that must be acknowledged.
 *
 * This attribute must be used to mark all DIFs which return an error value of
 * some kind, to ensure that callers do not accidentally drop the error on the
 * ground.
 *
 * Normally, the standard way to drop such a value on the ground explicitly is
 * with the syntax `(void)expr;`, in analogy with the behavior of C++'s
 * `[[nodiscard]]` attribute.
 * However, GCC does not implement this, so the idiom `if (expr) {}` should be
 * used instead, for the time being.
 * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=25509.
 */
#define OT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))

/**
 * Attribute for weak functions that can be overridden, e.g., ISRs.
 */
#define OT_WEAK __attribute__((weak))

/**
 * Attribute to construct functions without prologue/epilogue sequences.
 *
 * Only basic asm statements can be safely included in naked functions.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Function-Attributes.html
 * #RISC-V-Function-Attributes
 */
#define OT_NAKED __attribute__((naked))

/**
 * Attribute to place symbols into particular sections.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
 * #Common-Function-Attributes
 */
#define OT_SECTION(name) __attribute__((section(name)))

/**
 * Pragma meant to place symbols into a NOBITS section with a specified name.
 *
 * This should only be used for zero-initialized globals (including
 * implicitly zero-initialized ones, when the initializer is missing). The
 * pragma won't affect variables that do not go into the bss section.
 *
 * Example:
 *
 * OT_SET_BSS_SECTION(".foo",
 *   uint32_t x;      // emitted in section .foo instead of .bss
 *   uint32_t y = 42; // emitted in regular .data section (but don't do this)
 * )
 */
#define OT_SET_BSS_SECTION(name, ...)           \
  OT_SET_BSS_SECTION_(clang section bss = name) \
  __VA_ARGS__                                   \
  _Pragma("clang section bss = \"\"")
#define OT_SET_BSS_SECTION_(section) _Pragma(#section)

/**
 * Attribute to suppress the inlining of a function at its call sites.
 *
 * See https://clang.llvm.org/docs/AttributeReference.html#noinline.
 */
#define OT_NOINLINE __attribute__((noinline))

/**
 * Returns the address of the current function stack frame.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Return-Address.html.
 */
#define OT_FRAME_ADDR() __builtin_frame_address(0)

/**
 * Hints to the compiler that some point is not reachable.
 *
 * One use case could be a function that never returns.
 *
 * Please not that if the control flow reaches the point of the
 * __builtin_unreachable, the program is undefined.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html.
 */
#define OT_UNREACHABLE() __builtin_unreachable()

/**
 * Attribute for weak alias that can be overridden, e.g., Mock overrides in
 * DIFs.
 */
#define OT_ALIAS(name) __attribute__((alias(name)))

/**
 * Defines a local symbol named `kName_` whose address resolves to the
 * program counter value an inline assembly block at this location would
 * see.
 *
 * The primary intention of this macro is to allow for peripheral tests to be
 * written that want to assert that a specific program counter reported by the
 * hardware corresponds to actual code that executed.
 *
 * For example, suppose that we're waiting for an interrupt to fire, and want
 * to verify that it fired in a specific region. We have two volatile globals:
 * `irq_happened`, which the ISR sets before returning, and `irq_pc`, which
 * the ISR sets to whatever PC the hardware reports it came from. The
 * code below tests that the reported PC matches expectations.
 *
 * ```
 * OT_ADDRESSABLE_LABEL(kIrqWaitStart);
 * enable_interrupts();
 * while(!irq_happened) {
 *   wait_for_interrupt();
 * }
 * OT_ADDRESSABLE_LABEL(kIrqWaitEnd);
 *
 * CHECK(irq_pc >= &kIrqWaitStart && irq_pc < &IrqWaitEnd);
 * ```
 *
 * Note that this only works if all functions called between the two labels
 * are actually inlined; if the interrupt fires inside of one of those two
 * functions, it will appear to not have the right PC, even though it is
 * logically inside the pair of labels.
 *
 * # Volatile Semantics
 *
 * This has the same semantics as a `volatile` inline assembly block: it
 * may be reordered with respect to all operations except other volatile
 * operations (i.e. volatile assembly and volatile read/write, such as
 * MMIO). For example, in the following code, `kBefore` and `kAfter` can
 * wind up having the same address:
 *
 * ```
 * OT_ADDRESSABLE_LABEL(kBefore);
 * x += 5;
 * OT_ADDRESSABLE_LABEL(kAfter);
 * ```
 *
 * Because it can be reordered and the compiler is free to emit whatever
 * instructions it likes, comparing a program counter value obtained from
 * the hardware with a symbol emitted by this macro is brittle (and,
 * ultimately, futile). Instead, it should be used in pairs to create a
 * range of addresses that a value can be checked for being within.
 *
 * For this primitive to work correctly there must be something that counts as
 * a volatile operation between the two labels. These include:
 *
 * - Direct reads or writes to MMIO registers or CSRs.
 * - A volatile assembly block with at least one instruction.
 * - Any DIF or driver call that may touch an MMIO register or a CSR.
 * - `LOG`ging, `printf`ing, or `CHECK`ing.
 * - `wait_for_interrupt()`.
 * - `barrier32()`, but NOT `launder32()`.
 *
 * This macro should not be used on the host side. It will compile, but will
 * probably not provide any meaningful values. In the future, it may start
 * producing a garbage value on the host side.
 *
 * # Symbol Access
 *
 * The symbol reference `kName_` will only be scoped to the current block
 * in a function, but it can be redeclared in the same file with
 *
 * ```
 * extern const char kName_[];
 * ```
 *
 * if needed elsewhere (although this should be avoided for readability's sake).
 * The name of the constant is global to the current `.c` file only.
 *
 * # Example Uses
 */
#define OT_ADDRESSABLE_LABEL(kName_)                                         \
  extern const char kName_[];                                                \
  asm volatile(".local " #kName_ "; " #kName_ ":;");                         \
  /* Force this to be at function scope. It could go at global scope, but it \
   * would give a garbage value dependent on the whims of the linker. */     \
  do {                                                                       \
  } while (false)

/**
 * Evaluates and discards `expr_`.
 *
 * This is needed because ‘(void)expr;` does not work for gcc.
 */
#define OT_DISCARD(expr_) \
  if (expr_) {            \
  }

/**
 * An attribute used for static variables indicating that they should be
 * retained in the object file, even if they are seemingly unreferenced.
 */
#define OT_USED __attribute__((used))

/**
 * An attribute used to indicate that a character array variable is not intended
 * to be treated as a null-terminated string.
 */
#if defined(__clang__) && __clang_major__ >= 21
#define OT_NONSTRING __attribute__((nonstring))
#elif defined(__GNUC__) && !defined(__clang__)
#define OT_NONSTRING __attribute__((nonstring))
#else
#define OT_NONSTRING
#endif

/**
 * OT_BUILD_FOR_STATIC_ANALYZER indicates whether we are compiling for the
 * purpose of static analysis. Currently, this macro only detects
 * Clang-Analyzer, which is used as a backend by Clang-Tidy.
 */
#ifdef __clang_analyzer__
#define OT_BUILD_FOR_STATIC_ANALYZER 1
#else
#define OT_BUILD_FOR_STATIC_ANALYZER 0
#endif

/**
 *  This macro is used to align an offset to point to a 32b value.
 */
#define OT_ALIGN_MEM(x) (uint32_t)(4 + (((uintptr_t)(x)-1) & ~3u))

#if !defined(__ASSEMBLER__) && !defined(NOSTDINC) && \
    !defined(RUST_PREPROCESSOR_EMIT)
#ifndef __cplusplus
struct OtSignConversionUnsupportedType {
  char err;
};

/**
 * This macro converts a given unsigned integer value to its signed counterpart.
 */
#define OT_SIGNED(value)          \
  _Generic((value),               \
      uint8_t: (int8_t)(value),   \
      uint16_t: (int16_t)(value), \
      uint32_t: (int32_t)(value), \
      uint64_t: (int64_t)(value), \
      default: (struct OtSignConversionUnsupportedType){.err = 1})

/**
 * This macro converts a given signed integer value to its unsigned counterpart.
 */
#define OT_UNSIGNED(value)        \
  _Generic((value),               \
      int8_t: (uint8_t)(value),   \
      int16_t: (uint16_t)(value), \
      int32_t: (uint32_t)(value), \
      int64_t: (uint64_t)(value), \
      default: (struct OtSignConversionUnsupportedType){.err = 1})
#else  // __cplusplus
// Templates require "C++" linkage. Even though this block is only reachable
// when __cplusplus is defined, it's possible that we are in the middle of an
// `extern "C"` block. In case that is true, we explicitly set the linkage to
// "C++" for the coming C++ templates.
extern "C++" {
namespace {
template <typename T>
class SignConverter {
 public:
  using SignedT = typename std::make_signed<T>::type;
  using UnsignedT = typename std::make_unsigned<T>::type;
  static constexpr SignedT as_signed(T value) {
    return static_cast<SignedT>(value);
  }
  static constexpr UnsignedT as_unsigned(T value) {
    return static_cast<UnsignedT>(value);
  }
};
}  // namespace
}
#define OT_SIGNED(value) (SignConverter<__typeof__(value)>::as_signed((value)))
#define OT_UNSIGNED(value) \
  (SignConverter<__typeof__(value)>::as_unsigned((value)))
#endif  // __cplusplus
#endif  // !defined(__ASSEMBLER__) && !defined(NOSTDINC) &&
        // !defined(RUST_PREPROCESSOR_EMIT)

// This routine makes sure that a condition that can be changed by IRQs
// is evaluated inside a critical session. It executes a `wfi` between
// evaluations.
#define ATOMIC_WAIT_FOR_INTERRUPT(_volatile_condition) \
  while (true) {                                       \
    irq_global_ctrl(false);                            \
    if ((_volatile_condition)) {                       \
      break;                                           \
    }                                                  \
    wait_for_interrupt();                              \
    irq_global_ctrl(true);                             \
  }                                                    \
  irq_global_ctrl(true)

/**
 * Macros for implementing OT ISRs.
 */
#define OT_WORD_SIZE 4
#define OT_HALF_WORD_SIZE (OT_WORD_SIZE / 2)
// The ISR context size is 30 words.  There are 32 cpu registers; 30 of them
// need to be saved.  The two that do not are `sp` and `gp` (x2 and x3).
#define OT_CONTEXT_SIZE (OT_WORD_SIZE * 30)

#endif  // OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
