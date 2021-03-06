; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define i1 @test1(i16* %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 17791
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = and i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @test1_logical(i16* %x) {
; CHECK-LABEL: @test1_logical(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 17791
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %or
}

define <2 x i1> @test1_vector(<2 x i16>* %x) {
; CHECK-LABEL: @test1_vector(
; CHECK-NEXT:    [[LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i16> [[LOAD]], <i16 17791, i16 17791>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %load = load <2 x i16>, <2 x i16>* %x, align 4
  %trunc = trunc <2 x i16> %load to <2 x i8>
  %cmp1 = icmp eq <2 x i8> %trunc, <i8 127, i8 127>
  %and = and <2 x i16> %load, <i16 -256, i16 -256>
  %cmp2 = icmp eq <2 x i16> %and, <i16 17664, i16 17664>
  %or = and <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

define i1 @test2(i16* %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 32581
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %and = and i16 %load, -256
  %cmp1 = icmp eq i16 %and, 32512
  %trunc = trunc i16 %load to i8
  %cmp2 = icmp eq i8 %trunc, 69
  %or = and i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @test2_logical(i16* %x) {
; CHECK-LABEL: @test2_logical(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 32581
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %and = and i16 %load, -256
  %cmp1 = icmp eq i16 %and, 32512
  %trunc = trunc i16 %load to i8
  %cmp2 = icmp eq i8 %trunc, 69
  %or = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %or
}

define <2 x i1> @test2_vector(<2 x i16>* %x) {
; CHECK-LABEL: @test2_vector(
; CHECK-NEXT:    [[LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i16> [[LOAD]], <i16 32581, i16 32581>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %load = load <2 x i16>, <2 x i16>* %x, align 4
  %and = and <2 x i16> %load, <i16 -256, i16 -256>
  %cmp1 = icmp eq <2 x i16> %and, <i16 32512, i16 32512>
  %trunc = trunc <2 x i16> %load to <2 x i8>
  %cmp2 = icmp eq <2 x i8> %trunc, <i8 69, i8 69>
  %or = and <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}
