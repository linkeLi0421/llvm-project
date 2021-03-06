// RUN: mlir-opt %s  -split-input-file -loop-invariant-code-motion | FileCheck %s

func @nested_loops_both_having_invariant_code() {
  %m = memref.alloc() : memref<10xf32>
  %cf7 = arith.constant 7.0 : f32
  %cf8 = arith.constant 8.0 : f32

  affine.for %arg0 = 0 to 10 {
    %v0 = arith.addf %cf7, %cf8 : f32
    affine.for %arg1 = 0 to 10 {
      %v1 = arith.addf %v0, %cf8 : f32
      affine.store %v0, %m[%arg0] : memref<10xf32>
    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %[[CST0:.*]] = arith.constant 7.000000e+00 : f32
  // CHECK-NEXT: %[[CST1:.*]] = arith.constant 8.000000e+00 : f32
  // CHECK-NEXT: %[[ADD0:.*]] = arith.addf %[[CST0]], %[[CST1]] : f32
  // CHECK-NEXT: arith.addf %[[ADD0]], %[[CST1]] : f32
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.store

  return
}

// -----

func @nested_loops_code_invariant_to_both() {
  %m = memref.alloc() : memref<10xf32>
  %cf7 = arith.constant 7.0 : f32
  %cf8 = arith.constant 8.0 : f32

  affine.for %arg0 = 0 to 10 {
    affine.for %arg1 = 0 to 10 {
      %v0 = arith.addf %cf7, %cf8 : f32
    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %cst = arith.constant 7.000000e+00 : f32
  // CHECK-NEXT: %cst_0 = arith.constant 8.000000e+00 : f32
  // CHECK-NEXT: %1 = arith.addf %cst, %cst_0 : f32

  return
}

// -----

func @single_loop_nothing_invariant() {
  %m1 = memref.alloc() : memref<10xf32>
  %m2 = memref.alloc() : memref<10xf32>
  affine.for %arg0 = 0 to 10 {
    %v0 = affine.load %m1[%arg0] : memref<10xf32>
    %v1 = affine.load %m2[%arg0] : memref<10xf32>
    %v2 = arith.addf %v0, %v1 : f32
    affine.store %v2, %m1[%arg0] : memref<10xf32>
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %1 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: affine.for %arg0 = 0 to 10 {
  // CHECK-NEXT: %2 = affine.load %0[%arg0] : memref<10xf32>
  // CHECK-NEXT: %3 = affine.load %1[%arg0] : memref<10xf32>
  // CHECK-NEXT: %4 = arith.addf %2, %3 : f32
  // CHECK-NEXT: affine.store %4, %0[%arg0] : memref<10xf32>

  return
}

// -----

func @invariant_code_inside_affine_if() {
  %m = memref.alloc() : memref<10xf32>
  %cf8 = arith.constant 8.0 : f32

  affine.for %arg0 = 0 to 10 {
    %t0 = affine.apply affine_map<(d1) -> (d1 + 1)>(%arg0)
    affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %t0) {
        %cf9 = arith.addf %cf8, %cf8 : f32
        affine.store %cf9, %m[%arg0] : memref<10xf32>

    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %cst = arith.constant 8.000000e+00 : f32
  // CHECK-NEXT: affine.for %arg0 = 0 to 10 {
  // CHECK-NEXT: %1 = affine.apply #map(%arg0)
  // CHECK-NEXT: affine.if #set(%arg0, %1) {
  // CHECK-NEXT: %2 = arith.addf %cst, %cst : f32
  // CHECK-NEXT: affine.store %2, %0[%arg0] : memref<10xf32>
  // CHECK-NEXT: }


  return
}

// -----

func @invariant_affine_if() {
  %m = memref.alloc() : memref<10xf32>
  %cf8 = arith.constant 8.0 : f32
  affine.for %arg0 = 0 to 10 {
    affine.for %arg1 = 0 to 10 {
      affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
          %cf9 = arith.addf %cf8, %cf8 : f32
      }
    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %[[CST:.*]] = arith.constant 8.000000e+00 : f32
  // CHECK-NEXT: affine.for %[[ARG:.*]] = 0 to 10 {
  // CHECK-NEXT: }
  // CHECK-NEXT: affine.for %[[ARG:.*]] = 0 to 10 {
  // CHECK-NEXT: affine.if #set(%[[ARG]], %[[ARG]]) {
  // CHECK-NEXT: arith.addf %[[CST]], %[[CST]] : f32
  // CHECK-NEXT: }

  return
}

// -----

func @invariant_affine_if2() {
  %m = memref.alloc() : memref<10xf32>
  %cf8 = arith.constant 8.0 : f32
  affine.for %arg0 = 0 to 10 {
    affine.for %arg1 = 0 to 10 {
      affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
          %cf9 = arith.addf %cf8, %cf8 : f32
          affine.store %cf9, %m[%arg1] : memref<10xf32>
      }
    }
  }

  // CHECK: memref.alloc
  // CHECK-NEXT: arith.constant
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.if
  // CHECK-NEXT: arith.addf
  // CHECK-NEXT: affine.store
  // CHECK-NEXT: }
  // CHECK-NEXT: }

  return
}

// -----

func @invariant_affine_nested_if() {
  %m = memref.alloc() : memref<10xf32>
  %cf8 = arith.constant 8.0 : f32
  affine.for %arg0 = 0 to 10 {
    affine.for %arg1 = 0 to 10 {
      affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
          %cf9 = arith.addf %cf8, %cf8 : f32
          affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
            %cf10 = arith.addf %cf9, %cf9 : f32
          }
      }
    }
  }

  // CHECK: memref.alloc
  // CHECK-NEXT: arith.constant
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.if
  // CHECK-NEXT: arith.addf
  // CHECK-NEXT: affine.if
  // CHECK-NEXT: arith.addf
  // CHECK-NEXT: }
  // CHECK-NEXT: }
  // CHECK-NEXT: }


  return
}

// -----

func @invariant_affine_nested_if_else() {
  %m = memref.alloc() : memref<10xf32>
  %cf8 = arith.constant 8.0 : f32
  affine.for %arg0 = 0 to 10 {
    affine.for %arg1 = 0 to 10 {
      affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
          %cf9 = arith.addf %cf8, %cf8 : f32
          affine.store %cf9, %m[%arg0] : memref<10xf32>
          affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
            %cf10 = arith.addf %cf9, %cf9 : f32
          } else {
            affine.store %cf9, %m[%arg1] : memref<10xf32>
          }
      }
    }
  }

  // CHECK: memref.alloc
  // CHECK-NEXT: arith.constant
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.for
  // CHECK-NEXT: affine.if
  // CHECK-NEXT: arith.addf
  // CHECK-NEXT: affine.store
  // CHECK-NEXT: affine.if
  // CHECK-NEXT: arith.addf
  // CHECK-NEXT: } else {
  // CHECK-NEXT: affine.store
  // CHECK-NEXT: }
  // CHECK-NEXT: }
  // CHECK-NEXT: }


  return
}

// -----

func @invariant_loop_dialect() {
  %ci0 = arith.constant 0 : index
  %ci10 = arith.constant 10 : index
  %ci1 = arith.constant 1 : index
  %m = memref.alloc() : memref<10xf32>
  %cf7 = arith.constant 7.0 : f32
  %cf8 = arith.constant 8.0 : f32
  scf.for %arg0 = %ci0 to %ci10 step %ci1 {
    scf.for %arg1 = %ci0 to %ci10 step %ci1 {
      %v0 = arith.addf %cf7, %cf8 : f32
    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: %cst = arith.constant 7.000000e+00 : f32
  // CHECK-NEXT: %cst_0 = arith.constant 8.000000e+00 : f32
  // CHECK-NEXT: %1 = arith.addf %cst, %cst_0 : f32

  return
}

// -----

func @variant_loop_dialect() {
  %ci0 = arith.constant 0 : index
  %ci10 = arith.constant 10 : index
  %ci1 = arith.constant 1 : index
  %m = memref.alloc() : memref<10xf32>
  scf.for %arg0 = %ci0 to %ci10 step %ci1 {
    scf.for %arg1 = %ci0 to %ci10 step %ci1 {
      %v0 = arith.addi %arg0, %arg1 : index
    }
  }

  // CHECK: %0 = memref.alloc() : memref<10xf32>
  // CHECK-NEXT: scf.for
  // CHECK-NEXT: scf.for
  // CHECK-NEXT: arith.addi

  return
}

// -----

func @parallel_loop_with_invariant() {
  %c0 = arith.constant 0 : index
  %c10 = arith.constant 10 : index
  %c1 = arith.constant 1 : index
  %c7 = arith.constant 7 : i32
  %c8 = arith.constant 8 : i32
  scf.parallel (%arg0, %arg1) = (%c0, %c0) to (%c10, %c10) step (%c1, %c1) {
      %v0 = arith.addi %c7, %c8 : i32
      %v3 = arith.addi %arg0, %arg1 : index
  }

  // CHECK-LABEL: func @parallel_loop_with_invariant
  // CHECK: %c0 = arith.constant 0 : index
  // CHECK-NEXT: %c10 = arith.constant 10 : index
  // CHECK-NEXT: %c1 = arith.constant 1 : index
  // CHECK-NEXT: %c7_i32 = arith.constant 7 : i32
  // CHECK-NEXT: %c8_i32 = arith.constant 8 : i32
  // CHECK-NEXT: arith.addi %c7_i32, %c8_i32 : i32
  // CHECK-NEXT: scf.parallel (%arg0, %arg1) = (%c0, %c0) to (%c10, %c10) step (%c1, %c1)
  // CHECK-NEXT:   arith.addi %arg0, %arg1 : index
  // CHECK-NEXT:   yield
  // CHECK-NEXT: }
  // CHECK-NEXT: return

  return
}

