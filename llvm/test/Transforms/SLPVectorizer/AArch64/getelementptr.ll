; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -slp-threshold=-7 -dce -instcombine -pass-remarks-output=%t < %s | FileCheck %s
; RUN: cat %t | FileCheck -check-prefix=YAML %s
; RUN: opt -S -passes='slp-vectorizer,dce,instcombine' -slp-threshold=-7 -pass-remarks-output=%t < %s | FileCheck %s
; RUN: cat %t | FileCheck -check-prefix=YAML %s


target datalayout = "e-m:e-i32:64-i128:128-n32:64-S128"
target triple = "aarch64--linux-gnu"

; These tests check that we remove from consideration pairs of seed
; getelementptrs when they are known to have a constant difference. Such pairs
; are likely not good candidates for vectorization since one can be computed
; from the other. We use an unprofitable threshold to force vectorization.
;
; int getelementptr(int *g, int n, int w, int x, int y, int z) {
;   int sum = 0;
;   for (int i = 0; i < n ; ++i) {
;     sum += g[2*i + w]; sum += g[2*i + x];
;     sum += g[2*i + y]; sum += g[2*i + z];
;   }
;   return sum;
; }
;

; YAML-LABEL: Function:        getelementptr_4x32
; YAML:      --- !Passed
; YAML-NEXT: Pass:            slp-vectorizer
; YAML-NEXT: Name:            VectorizedList
; YAML-NEXT: Function:        getelementptr_4x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '6'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '3'

; YAML:      --- !Passed
; YAML-NEXT: Pass:            slp-vectorizer
; YAML-NEXT: Name:            VectorizedList
; YAML-NEXT: Function:        getelementptr_4x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '6'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '3'

define i32 @getelementptr_4x32(i32* nocapture readonly %g, i32 %n, i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @getelementptr_4x32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP31:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP31]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> <i32 0, i32 poison>, i32 [[X:%.*]], i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[Y:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i32> [[TMP1]], i32 [[Z:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD16:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM_032:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[ADD16]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[T4:%.*]] = shl nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x i32> poison, i32 [[T4]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <2 x i32> [[TMP3]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <2 x i32> [[TMP4]], [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x i32> [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = zext i32 [[TMP6]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[G:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[T6:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD1:%.*]] = add nsw i32 [[T6]], [[SUM_032]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i32> [[TMP5]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP9]]
; CHECK-NEXT:    [[T8:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[ADD1]], [[T8]]
; CHECK-NEXT:    [[TMP10:%.*]] = add nsw <2 x i32> [[TMP4]], [[TMP2]]
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x i32> [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP11]] to i64
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP12]]
; CHECK-NEXT:    [[T10:%.*]] = load i32, i32* [[ARRAYIDX10]], align 4
; CHECK-NEXT:    [[ADD11:%.*]] = add nsw i32 [[ADD6]], [[T10]]
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x i32> [[TMP10]], i32 1
; CHECK-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP14]]
; CHECK-NEXT:    [[T12:%.*]] = load i32, i32* [[ARRAYIDX15]], align 4
; CHECK-NEXT:    [[ADD16]] = add nsw i32 [[ADD11]], [[T12]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INDVARS_IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp31 = icmp sgt i32 %n, 0
  br i1 %cmp31, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add16, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %indvars.iv = phi i32 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %sum.032 = phi i32 [ 0, %for.body.preheader ], [ %add16, %for.body ]
  %t4 = shl nsw i32 %indvars.iv, 1
  %t5 = add nsw i32 %t4, 0
  %arrayidx = getelementptr inbounds i32, i32* %g, i32 %t5
  %t6 = load i32, i32* %arrayidx, align 4
  %add1 = add nsw i32 %t6, %sum.032
  %t7 = add nsw i32 %t4, %x
  %arrayidx5 = getelementptr inbounds i32, i32* %g, i32 %t7
  %t8 = load i32, i32* %arrayidx5, align 4
  %add6 = add nsw i32 %add1, %t8
  %t9 = add nsw i32 %t4, %y
  %arrayidx10 = getelementptr inbounds i32, i32* %g, i32 %t9
  %t10 = load i32, i32* %arrayidx10, align 4
  %add11 = add nsw i32 %add6, %t10
  %t11 = add nsw i32 %t4, %z
  %arrayidx15 = getelementptr inbounds i32, i32* %g, i32 %t11
  %t12 = load i32, i32* %arrayidx15, align 4
  %add16 = add nsw i32 %add11, %t12
  %indvars.iv.next = add nuw nsw i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next , %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

; YAML-LABEL: Function:        getelementptr_2x32
; YAML:      --- !Passed
; YAML-NEXT: Pass:            slp-vectorizer
; YAML-NEXT: Name:            VectorizedList
; YAML-NEXT: Function:        getelementptr_2x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '6'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '3'

define i32 @getelementptr_2x32(i32* nocapture readonly %g, i32 %n, i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @getelementptr_2x32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP31:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP31]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> poison, i32 [[Y:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> [[TMP0]], i32 [[Z:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD16:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM_032:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[ADD16]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[T4:%.*]] = shl nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[T4]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[G:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[T6:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD1:%.*]] = add nsw i32 [[T6]], [[SUM_032]]
; CHECK-NEXT:    [[T7:%.*]] = or i32 [[T4]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[T7]] to i64
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP3]]
; CHECK-NEXT:    [[T8:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[ADD1]], [[T8]]
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x i32> poison, i32 [[T4]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i32> [[TMP4]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = add nsw <2 x i32> [[TMP5]], [[TMP1]]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i32> [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = sext i32 [[TMP7]] to i64
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP8]]
; CHECK-NEXT:    [[T10:%.*]] = load i32, i32* [[ARRAYIDX10]], align 4
; CHECK-NEXT:    [[ADD11:%.*]] = add nsw i32 [[ADD6]], [[T10]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[TMP6]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = sext i32 [[TMP9]] to i64
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP10]]
; CHECK-NEXT:    [[T12:%.*]] = load i32, i32* [[ARRAYIDX15]], align 4
; CHECK-NEXT:    [[ADD16]] = add nsw i32 [[ADD11]], [[T12]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i32 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INDVARS_IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp31 = icmp sgt i32 %n, 0
  br i1 %cmp31, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add16, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %indvars.iv = phi i32 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %sum.032 = phi i32 [ 0, %for.body.preheader ], [ %add16, %for.body ]
  %t4 = shl nsw i32 %indvars.iv, 1
  %t5 = add nsw i32 %t4, 0
  %arrayidx = getelementptr inbounds i32, i32* %g, i32 %t5
  %t6 = load i32, i32* %arrayidx, align 4
  %add1 = add nsw i32 %t6, %sum.032
  %t7 = add nsw i32 %t4, 1
  %arrayidx5 = getelementptr inbounds i32, i32* %g, i32 %t7
  %t8 = load i32, i32* %arrayidx5, align 4
  %add6 = add nsw i32 %add1, %t8
  %t9 = add nsw i32 %t4, %y
  %arrayidx10 = getelementptr inbounds i32, i32* %g, i32 %t9
  %t10 = load i32, i32* %arrayidx10, align 4
  %add11 = add nsw i32 %add6, %t10
  %t11 = add nsw i32 %t4, %z
  %arrayidx15 = getelementptr inbounds i32, i32* %g, i32 %t11
  %t12 = load i32, i32* %arrayidx15, align 4
  %add16 = add nsw i32 %add11, %t12
  %indvars.iv.next = add nuw nsw i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next , %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

@global = internal global { i32* } zeroinitializer, align 8

; Make sure we vectorize to maximize the load with when loading i16 and
; extending it for compute operations.
define void @test_i16_extend(i16* %p.1, i16* %p.2, i32 %idx.i32) {
; CHECK-LABEL: @test_i16_extend(
; CHECK-NEXT:    [[P_0:%.*]] = load i32*, i32** getelementptr inbounds ({ i32* }, { i32* }* @global, i64 0, i32 0), align 8
; CHECK-NEXT:    [[IDX_0:%.*]] = zext i32 [[IDX_I32:%.*]] to i64
; CHECK-NEXT:    [[T53:%.*]] = getelementptr inbounds i16, i16* [[P_1:%.*]], i64 [[IDX_0]]
; CHECK-NEXT:    [[T56:%.*]] = getelementptr inbounds i16, i16* [[P_2:%.*]], i64 [[IDX_0]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[T53]] to <8 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[TMP3:%.*]] = zext <8 x i16> [[TMP2]] to <8 x i32>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i16* [[T56]] to <8 x i16>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <8 x i16>, <8 x i16>* [[TMP4]], align 2
; CHECK-NEXT:    [[TMP6:%.*]] = zext <8 x i16> [[TMP5]] to <8 x i32>
; CHECK-NEXT:    [[TMP7:%.*]] = sub nsw <8 x i32> [[TMP3]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <8 x i32> [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[T60:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP9]]
; CHECK-NEXT:    [[L_1:%.*]] = load i32, i32* [[T60]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <8 x i32> [[TMP7]], i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = sext i32 [[TMP10]] to i64
; CHECK-NEXT:    [[T71:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP11]]
; CHECK-NEXT:    [[L_2:%.*]] = load i32, i32* [[T71]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <8 x i32> [[TMP7]], i32 2
; CHECK-NEXT:    [[TMP13:%.*]] = sext i32 [[TMP12]] to i64
; CHECK-NEXT:    [[T82:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP13]]
; CHECK-NEXT:    [[L_3:%.*]] = load i32, i32* [[T82]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <8 x i32> [[TMP7]], i32 3
; CHECK-NEXT:    [[TMP15:%.*]] = sext i32 [[TMP14]] to i64
; CHECK-NEXT:    [[T93:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP15]]
; CHECK-NEXT:    [[L_4:%.*]] = load i32, i32* [[T93]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <8 x i32> [[TMP7]], i32 4
; CHECK-NEXT:    [[TMP17:%.*]] = sext i32 [[TMP16]] to i64
; CHECK-NEXT:    [[T104:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP17]]
; CHECK-NEXT:    [[L_5:%.*]] = load i32, i32* [[T104]], align 4
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <8 x i32> [[TMP7]], i32 5
; CHECK-NEXT:    [[TMP19:%.*]] = sext i32 [[TMP18]] to i64
; CHECK-NEXT:    [[T115:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP19]]
; CHECK-NEXT:    [[L_6:%.*]] = load i32, i32* [[T115]], align 4
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <8 x i32> [[TMP7]], i32 6
; CHECK-NEXT:    [[TMP21:%.*]] = sext i32 [[TMP20]] to i64
; CHECK-NEXT:    [[T126:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP21]]
; CHECK-NEXT:    [[L_7:%.*]] = load i32, i32* [[T126]], align 4
; CHECK-NEXT:    [[TMP22:%.*]] = extractelement <8 x i32> [[TMP7]], i32 7
; CHECK-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; CHECK-NEXT:    [[T137:%.*]] = getelementptr inbounds i32, i32* [[P_0]], i64 [[TMP23]]
; CHECK-NEXT:    [[L_8:%.*]] = load i32, i32* [[T137]], align 4
; CHECK-NEXT:    call void @use(i32 [[L_1]], i32 [[L_2]], i32 [[L_3]], i32 [[L_4]], i32 [[L_5]], i32 [[L_6]], i32 [[L_7]], i32 [[L_8]])
; CHECK-NEXT:    ret void
;
  %g = getelementptr inbounds { i32*}, { i32 *}* @global, i64 0, i32 0
  %p.0 = load i32*, i32** %g, align 8

  %idx.0 = zext i32 %idx.i32 to i64
  %idx.1 = add nsw i64 %idx.0, 1
  %idx.2 = add nsw i64 %idx.0, 2
  %idx.3 = add nsw i64 %idx.0, 3
  %idx.4 = add nsw i64 %idx.0, 4
  %idx.5 = add nsw i64 %idx.0, 5
  %idx.6 = add nsw i64 %idx.0, 6
  %idx.7 = add nsw i64 %idx.0, 7

  %t53 = getelementptr inbounds i16, i16* %p.1, i64 %idx.0
  %op1.l = load i16, i16* %t53, align 2
  %op1.ext = zext i16 %op1.l to i64
  %t56 = getelementptr inbounds i16, i16* %p.2, i64 %idx.0
  %op2.l = load i16, i16* %t56, align 2
  %op2.ext = zext i16 %op2.l to i64
  %sub.1 = sub nsw i64 %op1.ext, %op2.ext

  %t60 = getelementptr inbounds i32, i32* %p.0, i64 %sub.1
  %l.1 = load i32, i32* %t60, align 4

  %t64 = getelementptr inbounds i16, i16* %p.1, i64 %idx.1
  %t65 = load i16, i16* %t64, align 2
  %t66 = zext i16 %t65 to i64
  %t67 = getelementptr inbounds i16, i16* %p.2, i64 %idx.1
  %t68 = load i16, i16* %t67, align 2
  %t69 = zext i16 %t68 to i64
  %sub.2 = sub nsw i64 %t66, %t69

  %t71 = getelementptr inbounds i32, i32* %p.0, i64 %sub.2
  %l.2 = load i32, i32* %t71, align 4

  %t75 = getelementptr inbounds i16, i16* %p.1, i64 %idx.2
  %t76 = load i16, i16* %t75, align 2
  %t77 = zext i16 %t76 to i64
  %t78 = getelementptr inbounds i16, i16* %p.2, i64 %idx.2
  %t79 = load i16, i16* %t78, align 2
  %t80 = zext i16 %t79 to i64
  %sub.3 = sub nsw i64 %t77, %t80

  %t82 = getelementptr inbounds i32, i32* %p.0, i64 %sub.3
  %l.3 = load i32, i32* %t82, align 4

  %t86 = getelementptr inbounds i16, i16* %p.1, i64 %idx.3
  %t87 = load i16, i16* %t86, align 2
  %t88 = zext i16 %t87 to i64
  %t89 = getelementptr inbounds i16, i16* %p.2, i64 %idx.3
  %t90 = load i16, i16* %t89, align 2
  %t91 = zext i16 %t90 to i64
  %sub.4 = sub nsw i64 %t88, %t91

  %t93 = getelementptr inbounds i32, i32* %p.0, i64 %sub.4
  %l.4 = load i32, i32* %t93, align 4

  %t97 = getelementptr inbounds i16, i16* %p.1, i64 %idx.4
  %t98 = load i16, i16* %t97, align 2
  %t99 = zext i16 %t98 to i64
  %t100 = getelementptr inbounds i16, i16* %p.2, i64 %idx.4
  %t101 = load i16, i16* %t100, align 2
  %t102 = zext i16 %t101 to i64
  %sub.5 = sub nsw i64 %t99, %t102

  %t104 = getelementptr inbounds i32, i32* %p.0, i64 %sub.5
  %l.5 = load i32, i32* %t104, align 4

  %t108 = getelementptr inbounds i16, i16* %p.1, i64 %idx.5
  %t109 = load i16, i16* %t108, align 2
  %t110 = zext i16 %t109 to i64
  %t111 = getelementptr inbounds i16, i16* %p.2, i64 %idx.5
  %t112 = load i16, i16* %t111, align 2
  %t113 = zext i16 %t112 to i64
  %sub.6 = sub nsw i64 %t110, %t113

  %t115 = getelementptr inbounds i32, i32* %p.0, i64 %sub.6
  %l.6 = load i32, i32* %t115, align 4

  %t119 = getelementptr inbounds i16, i16* %p.1, i64 %idx.6
  %t120 = load i16, i16* %t119, align 2
  %t121 = zext i16 %t120 to i64
  %t122 = getelementptr inbounds i16, i16* %p.2, i64 %idx.6
  %t123 = load i16, i16* %t122, align 2
  %t124 = zext i16 %t123 to i64
  %sub.7 = sub nsw i64 %t121, %t124

  %t126 = getelementptr inbounds i32, i32* %p.0, i64 %sub.7
  %l.7 = load i32, i32* %t126, align 4

  %t130 = getelementptr inbounds i16, i16* %p.1, i64 %idx.7
  %t131 = load i16, i16* %t130, align 2
  %t132 = zext i16 %t131 to i64
  %t133 = getelementptr inbounds i16, i16* %p.2, i64 %idx.7
  %t134 = load i16, i16* %t133, align 2
  %t135 = zext i16 %t134 to i64
  %sub.8 = sub nsw i64 %t132, %t135

  %t137 = getelementptr inbounds i32, i32* %p.0, i64 %sub.8
  %l.8 = load i32, i32* %t137, align 4

  call void @use(i32 %l.1, i32 %l.2, i32 %l.3, i32 %l.4, i32 %l.5, i32 %l.6, i32 %l.7, i32 %l.8)
  ret void
}

declare void @use(i32, i32, i32, i32, i32, i32, i32, i32)