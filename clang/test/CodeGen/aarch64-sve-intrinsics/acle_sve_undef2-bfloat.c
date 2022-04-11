// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -target-feature +bf16 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -target-feature +bf16 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - -x c++ %s | FileCheck %s -check-prefix=CPP-CHECK
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -fsyntax-only -verify -verify-ignore-unexpected=error -verify-ignore-unexpected=note %s

// REQUIRES: aarch64-registered-target || arm-registered-target

#include <arm_sve.h>

// CHECK-LABEL: @test_svundef2_bf16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret <vscale x 16 x bfloat> undef
//
// CPP-CHECK-LABEL: @_Z18test_svundef2_bf16v(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    ret <vscale x 16 x bfloat> undef
//
svbfloat16x2_t test_svundef2_bf16()
{
  // expected-warning@+1 {{implicit declaration of function 'svundef2_bf16'}}
  return svundef2_bf16();
}