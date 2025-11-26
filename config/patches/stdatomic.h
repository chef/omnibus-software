/*
 * stdatomic.h compatibility shim for SLES12
 * Provides minimal C11 atomic support using GCC __atomic built-ins.
 *
 * Copyright:: Chef Software, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef _COMPAT_STDATOMIC_H
#define _COMPAT_STDATOMIC_H

#include <stdint.h>

/* Atomic types */

typedef int atomic_int;
typedef unsigned int atomic_uint;
typedef int atomic_flag;

/* Initializers */

#define ATOMIC_VAR_INIT(value) (value)
#define ATOMIC_FLAG_INIT           0

/* Atomic flag functions */

static inline int atomic_flag_test_and_set(volatile atomic_flag *obj) {
  return __atomic_test_and_set(obj, __ATOMIC_SEQ_CST);
}

static inline void atomic_flag_clear(volatile atomic_flag *obj) {
  __atomic_clear(obj, __ATOMIC_SEQ_CST);
}

/* Atomic load/store */

static inline int atomic_load_explicit(const atomic_int *obj, int memory_order) {
  (void)memory_order;
  return __atomic_load_n(obj, __ATOMIC_SEQ_CST);
}

static inline void atomic_store_explicit(atomic_int *obj, int val, int memory_order) {
  (void)memory_order;
  __atomic_store_n(obj, val, __ATOMIC_SEQ_CST);
}

/* Atomic compare exchange */

static inline int atomic_compare_exchange_strong_explicit(
    atomic_int *obj, int *expected, int desired,
    int success_memorder, int failure_memorder) {
  (void)success_memorder;
  (void)failure_memorder;
  return __atomic_compare_exchange_n(obj, expected, desired,
                                    0,
                                    __ATOMIC_SEQ_CST,
                                    __ATOMIC_SEQ_CST);
}

#endif /* _COMPAT_STDATOMIC_H */
