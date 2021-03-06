; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @vpsel_i8(<16 x i8> %mask, <16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: vpsel_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmp.i8 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <16 x i8> %mask, zeroinitializer
  %1 = select <16 x i1> %0, <16 x i8> %src1, <16 x i8> %src2
  ret <16 x i8> %1
}

define arm_aapcs_vfpcc <8 x i16> @vpsel_i16(<8 x i16> %mask, <8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: vpsel_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <8 x i16> %mask, zeroinitializer
  %1 = select <8 x i1> %0, <8 x i16> %src1, <8 x i16> %src2
  ret <8 x i16> %1
}

define arm_aapcs_vfpcc <4 x i32> @vpsel_i32(<4 x i32> %mask, <4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: vpsel_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmp.i32 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <4 x i32> %mask, zeroinitializer
  %1 = select <4 x i1> %0, <4 x i32> %src1, <4 x i32> %src2
  ret <4 x i32> %1
}

define arm_aapcs_vfpcc <2 x i64> @vpsel_i64(<2 x i64> %mask, <2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: vpsel_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    vmov r2, r3, d0
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    orrs.w r1, r2, r3
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    vbic q2, q2, q0
; CHECK-NEXT:    vand q0, q1, q0
; CHECK-NEXT:    vorr q0, q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <2 x i64> %mask, zeroinitializer
  %1 = select <2 x i1> %0, <2 x i64> %src1, <2 x i64> %src2
  ret <2 x i64> %1
}

define arm_aapcs_vfpcc <8 x half> @vpsel_f16(<8 x i16> %mask, <8 x half> %src1, <8 x half> %src2) {
; CHECK-LABEL: vpsel_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <8 x i16> %mask, zeroinitializer
  %1 = select <8 x i1> %0, <8 x half> %src1, <8 x half> %src2
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <4 x float> @vpsel_f32(<4 x i32> %mask, <4 x float> %src1, <4 x float> %src2) {
; CHECK-LABEL: vpsel_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmp.i32 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <4 x i32> %mask, zeroinitializer
  %1 = select <4 x i1> %0, <4 x float> %src1, <4 x float> %src2
  ret <4 x float> %1
}

define arm_aapcs_vfpcc <2 x double> @vpsel_f64(<2 x i64> %mask, <2 x double> %src1, <2 x double> %src2) {
; CHECK-LABEL: vpsel_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    vmov r2, r3, d0
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    orrs.w r1, r2, r3
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    vbic q2, q2, q0
; CHECK-NEXT:    vand q0, q1, q0
; CHECK-NEXT:    vorr q0, q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp ne <2 x i64> %mask, zeroinitializer
  %1 = select <2 x i1> %0, <2 x double> %src1, <2 x double> %src2
  ret <2 x double> %1
}

define arm_aapcs_vfpcc <4 x i32> @foo(<4 x i32> %vec.ind) {
; CHECK-LABEL: foo:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov.i32 q2, #0x1
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vand q2, q0, q2
; CHECK-NEXT:    vcmp.i32 eq, q2, zr
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp = and <4 x i32> %vec.ind, <i32 1, i32 1, i32 1, i32 1>
  %tmp1 = icmp eq <4 x i32> %tmp, zeroinitializer
  %tmp2 = select <4 x i1> %tmp1, <4 x i32> %vec.ind, <4 x i32> zeroinitializer
  ret <4 x i32> %tmp2
}
