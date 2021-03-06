; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck %s -check-prefix=PPC64-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr7 < %s | FileCheck %s -check-prefix=PPC64
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck %s -check-prefix=PPC64-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr7 < %s | FileCheck %s -check-prefix=PPC64
; RUN: llc -verify-machineinstrs -mtriple=powerpc-unknown-linux-gnu < %s | FileCheck %s -check-prefix=PPC32

define i128 @test_abs(ppc_fp128 %x) nounwind  {
; PPC64-P8-LABEL: test_abs:
; PPC64-P8:       # %bb.0: # %entry
; PPC64-P8-NEXT:    mffprd 3, 1
; PPC64-P8-NEXT:    mffprd 4, 2
; PPC64-P8-NEXT:    rldicr 5, 3, 0, 0
; PPC64-P8-NEXT:    xor 3, 3, 5
; PPC64-P8-NEXT:    xor 4, 4, 5
; PPC64-P8-NEXT:    blr
;
; PPC64-LABEL: test_abs:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    stfd 1, -16(1)
; PPC64-NEXT:    stfd 2, -8(1)
; PPC64-NEXT:    ld 3, -16(1)
; PPC64-NEXT:    ld 4, -8(1)
; PPC64-NEXT:    rldicr 5, 3, 0, 0
; PPC64-NEXT:    xor 3, 3, 5
; PPC64-NEXT:    xor 4, 4, 5
; PPC64-NEXT:    blr
;
; PPC32-LABEL: test_abs:
; PPC32:       # %bb.0: # %entry
; PPC32-NEXT:    stwu 1, -32(1)
; PPC32-NEXT:    stfd 1, 24(1)
; PPC32-NEXT:    stfd 2, 16(1)
; PPC32-NEXT:    lwz 3, 24(1)
; PPC32-NEXT:    lwz 5, 16(1)
; PPC32-NEXT:    rlwinm 7, 3, 0, 0, 0
; PPC32-NEXT:    lwz 4, 28(1)
; PPC32-NEXT:    xor 3, 3, 7
; PPC32-NEXT:    lwz 6, 20(1)
; PPC32-NEXT:    xor 5, 5, 7
; PPC32-NEXT:    addi 1, 1, 32
; PPC32-NEXT:    blr
entry:
	%0 = tail call ppc_fp128 @llvm.fabs.ppcf128(ppc_fp128 %x)
	%1 = bitcast ppc_fp128 %0 to i128
	ret i128 %1
}

define i128 @test_neg(ppc_fp128 %x) nounwind  {
; PPC64-P8-LABEL: test_neg:
; PPC64-P8:       # %bb.0: # %entry
; PPC64-P8-NEXT:    li 3, 1
; PPC64-P8-NEXT:    mffprd 4, 2
; PPC64-P8-NEXT:    mffprd 5, 1
; PPC64-P8-NEXT:    rldic 6, 3, 63, 0
; PPC64-P8-NEXT:    xor 4, 4, 6
; PPC64-P8-NEXT:    xor 3, 5, 6
; PPC64-P8-NEXT:    blr
;
; PPC64-LABEL: test_neg:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    stfd 2, -8(1)
; PPC64-NEXT:    stfd 1, -16(1)
; PPC64-NEXT:    li 3, 1
; PPC64-NEXT:    ld 4, -8(1)
; PPC64-NEXT:    ld 5, -16(1)
; PPC64-NEXT:    rldic 6, 3, 63, 0
; PPC64-NEXT:    xor 3, 5, 6
; PPC64-NEXT:    xor 4, 4, 6
; PPC64-NEXT:    blr
;
; PPC32-LABEL: test_neg:
; PPC32:       # %bb.0: # %entry
; PPC32-NEXT:    stwu 1, -32(1)
; PPC32-NEXT:    stfd 1, 24(1)
; PPC32-NEXT:    stfd 2, 16(1)
; PPC32-NEXT:    lwz 5, 16(1)
; PPC32-NEXT:    lwz 3, 24(1)
; PPC32-NEXT:    lwz 4, 28(1)
; PPC32-NEXT:    xoris 5, 5, 32768
; PPC32-NEXT:    lwz 6, 20(1)
; PPC32-NEXT:    xoris 3, 3, 32768
; PPC32-NEXT:    addi 1, 1, 32
; PPC32-NEXT:    blr
entry:
	%0 = fsub ppc_fp128 0xM80000000000000000000000000000000, %x
	%1 = bitcast ppc_fp128 %0 to i128
	ret i128 %1
}

define i128 @test_copysign(ppc_fp128 %x) nounwind  {
; PPC64-P8-LABEL: test_copysign:
; PPC64-P8:       # %bb.0: # %entry
; PPC64-P8-NEXT:    mffprd 3, 1
; PPC64-P8-NEXT:    li 4, 16399
; PPC64-P8-NEXT:    li 5, 3019
; PPC64-P8-NEXT:    rldicr 6, 3, 0, 0
; PPC64-P8-NEXT:    rldic 3, 4, 48, 1
; PPC64-P8-NEXT:    rldic 4, 5, 52, 0
; PPC64-P8-NEXT:    or 3, 6, 3
; PPC64-P8-NEXT:    xor 4, 6, 4
; PPC64-P8-NEXT:    blr
;
; PPC64-LABEL: test_copysign:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    stfd 1, -8(1)
; PPC64-NEXT:    li 4, 16399
; PPC64-NEXT:    li 5, 3019
; PPC64-NEXT:    ld 3, -8(1)
; PPC64-NEXT:    rldicr 6, 3, 0, 0
; PPC64-NEXT:    rldic 3, 4, 48, 1
; PPC64-NEXT:    rldic 4, 5, 52, 0
; PPC64-NEXT:    or 3, 6, 3
; PPC64-NEXT:    xor 4, 6, 4
; PPC64-NEXT:    blr
;
; PPC32-LABEL: test_copysign:
; PPC32:       # %bb.0: # %entry
; PPC32-NEXT:    stwu 1, -32(1)
; PPC32-NEXT:    stfd 1, 24(1)
; PPC32-NEXT:    li 6, 0
; PPC32-NEXT:    lwz 3, 24(1)
; PPC32-NEXT:    rlwinm 4, 3, 0, 0, 0
; PPC32-NEXT:    oris 3, 4, 16399
; PPC32-NEXT:    xoris 5, 4, 48304
; PPC32-NEXT:    li 4, 0
; PPC32-NEXT:    addi 1, 1, 32
; PPC32-NEXT:    blr
entry:
	%0 = tail call ppc_fp128 @llvm.copysign.ppcf128(ppc_fp128 0xM400F000000000000BCB0000000000000, ppc_fp128 %x)
	%1 = bitcast ppc_fp128 %0 to i128
	ret i128 %1
}

declare ppc_fp128 @llvm.fabs.ppcf128(ppc_fp128)
declare ppc_fp128 @llvm.copysign.ppcf128(ppc_fp128, ppc_fp128)
