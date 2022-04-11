; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=X64

define <4 x double> @test_broadcast_2f64_4f64(<2 x double> *%p) nounwind {
; X32-LABEL: test_broadcast_2f64_4f64:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_2f64_4f64:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <2 x double>, <2 x double> *%p
 %2 = shufflevector <2 x double> %1, <2 x double> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
 %3 = fadd <4 x double> %2, <double 1.0, double 2.0, double 3.0, double 4.0>
 ret <4 x double> %3
}

define <4 x i64> @test_broadcast_2i64_4i64(<2 x i64> *%p) nounwind {
; X32-LABEL: test_broadcast_2i64_4i64:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_2i64_4i64:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <2 x i64>, <2 x i64> *%p
 %2 = shufflevector <2 x i64> %1, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
 %3 = add <4 x i64> %2, <i64 1, i64 2, i64 3, i64 4>
 ret <4 x i64> %3
}

define <8 x float> @test_broadcast_4f32_8f32(<4 x float> *%p) nounwind {
; X32-LABEL: test_broadcast_4f32_8f32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_4f32_8f32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <4 x float>, <4 x float> *%p
 %2 = shufflevector <4 x float> %1, <4 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = fadd <8 x float> %2, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>
 ret <8 x float> %3
}

define <8 x i32> @test_broadcast_4i32_8i32(<4 x i32> *%p) nounwind {
; X32-LABEL: test_broadcast_4i32_8i32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_4i32_8i32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <4 x i32>, <4 x i32> *%p
 %2 = shufflevector <4 x i32> %1, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = add <8 x i32> %2, <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
 ret <8 x i32> %3
}

define <16 x i16> @test_broadcast_8i16_16i16(<8 x i16> *%p) nounwind {
; X32-LABEL: test_broadcast_8i16_16i16:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_8i16_16i16:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <8 x i16>, <8 x i16> *%p
 %2 = shufflevector <8 x i16> %1, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
 %3  = add <16 x i16> %2, <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15, i16 16>
 ret <16 x i16> %3
}

define <32 x i8> @test_broadcast_16i8_32i8(<16 x i8> *%p) nounwind {
; X32-LABEL: test_broadcast_16i8_32i8:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_16i8_32i8:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-NEXT:    retq
 %1 = load <16 x i8>, <16 x i8> *%p
 %2 = shufflevector <16 x i8> %1, <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
 %3 = add <32 x i8> %2, <i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 16, i8 17, i8 18, i8 19, i8 20, i8 21, i8 22, i8 23, i8 24, i8 25, i8 26, i8 27, i8 28, i8 29, i8 30, i8 31, i8 32>
 ret <32 x i8> %3
}

define <4 x double> @test_broadcast_2f64_4f64_reuse(<2 x double>* %p0, <2 x double>* %p1) {
; X32-LABEL: test_broadcast_2f64_4f64_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovapd %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_2f64_4f64_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovapd %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <2 x double>, <2 x double>* %p0
 %2 = shufflevector <2 x double> %1, <2 x double> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
 %3 = fadd <4 x double> %2, <double 1.0, double 2.0, double 3.0, double 4.0>
 store <2 x double> %1, <2 x double>* %p1
 ret <4 x double> %3
}

define <4 x i64> @test_broadcast_2i64_4i64_reuse(<2 x i64>* %p0, <2 x i64>* %p1) {
; X32-LABEL: test_broadcast_2i64_4i64_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovdqa %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_2i64_4i64_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovdqa %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <2 x i64>, <2 x i64>* %p0
 %2 = shufflevector <2 x i64> %1, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
 %3 = add <4 x i64> %2, <i64 1, i64 2, i64 3, i64 4>
 store <2 x i64> %1, <2 x i64>* %p1
 ret <4 x i64> %3
}

define <8 x float> @test_broadcast_4f32_8f32_reuse(<4 x float>* %p0, <4 x float>* %p1) {
; X32-LABEL: test_broadcast_4f32_8f32_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovaps %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_4f32_8f32_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovaps %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <4 x float>, <4 x float>* %p0
 %2 = shufflevector <4 x float> %1, <4 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = fadd <8 x float> %2, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>
 store <4 x float> %1, <4 x float>* %p1
 ret <8 x float> %3
}

define <8 x i32> @test_broadcast_4i32_8i32_reuse(<4 x i32>* %p0, <4 x i32>* %p1) {
; X32-LABEL: test_broadcast_4i32_8i32_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovdqa %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_4i32_8i32_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovdqa %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <4 x i32>, <4 x i32>* %p0
 %2 = shufflevector <4 x i32> %1, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = add <8 x i32> %2, <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
 store <4 x i32> %1, <4 x i32>* %p1
 ret <8 x i32> %3
}

define <16 x i16> @test_broadcast_8i16_16i16_reuse(<8 x i16> *%p0, <8 x i16> *%p1) nounwind {
; X32-LABEL: test_broadcast_8i16_16i16_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovdqa %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_8i16_16i16_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovdqa %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <8 x i16>, <8 x i16> *%p0
 %2 = shufflevector <8 x i16> %1, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
 %3  = add <16 x i16> %2, <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15, i16 16>
 store <8 x i16> %1, <8 x i16>* %p1
 ret <16 x i16> %3
}

define <32 x i8> @test_broadcast_16i8_32i8_reuse(<16 x i8> *%p0, <16 x i8> *%p1) nounwind {
; X32-LABEL: test_broadcast_16i8_32i8_reuse:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X32-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm0
; X32-NEXT:    vmovdqa %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: test_broadcast_16i8_32i8_reuse:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = mem[0,1,0,1]
; X64-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-NEXT:    vmovdqa %xmm1, (%rsi)
; X64-NEXT:    retq
 %1 = load <16 x i8>, <16 x i8> *%p0
 %2 = shufflevector <16 x i8> %1, <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
 %3 = add <32 x i8> %2, <i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 16, i8 17, i8 18, i8 19, i8 20, i8 21, i8 22, i8 23, i8 24, i8 25, i8 26, i8 27, i8 28, i8 29, i8 30, i8 31, i8 32>
 store <16 x i8> %1, <16 x i8>* %p1
 ret <32 x i8> %3
}

define <8 x i32> @PR29088(<4 x i32>* %p0, <8 x float>* %p1) {
; X32-LABEL: PR29088:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X32-NEXT:    vmovaps %ymm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: PR29088:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    vmovaps %ymm1, (%rsi)
; X64-NEXT:    retq
  %ld = load <4 x i32>, <4 x i32>* %p0
  store <8 x float> zeroinitializer, <8 x float>* %p1
  %shuf = shufflevector <4 x i32> %ld, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <8 x i32> %shuf
}