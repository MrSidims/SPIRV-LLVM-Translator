; This test checks that when a spirv.llvm_umul_with_overflow_* function with an
; implementation body is translated to SPIR-V and back, it doesn't create
; undefined "old_llvm.umul.with.overflow.*" functions.
;
; The bug occurred because the translator would:
; 1. Transform spirv.llvm_umul_with_overflow_* to llvm.umul.with.overflow.*
; 2. Detect it as an intrinsic and rename it to "old_*"
; 3. Create a new function but not translate the body
; 4. Leave calls referencing the undefined "old_*" function
;
; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis %t.rev.bc -o - | FileCheck %s --check-prefix=CHECK-LLVM \
; RUN:   "--implicit-check-not=old_llvm.umul.with.overflow"

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir"

; This function has an explicit implementation that will be lowered during
; LLVM->SPIR-V translation and needs to be properly handled during reverse
; translation without creating "old_llvm.*" functions.
define spir_func { i64, i1 } @spirv.llvm_umul_with_overflow_i64(i64 %a, i64 %b) {
; CHECK-LLVM: define spir_func %{{.*}} @spirv.llvm_umul_with_overflow_i64(i64 %a, i64 %b)
entry:
  %mul = mul i64 %a, %b
  %div = udiv i64 %mul, %a
  %overflow = icmp ne i64 %div, %b
  %agg1 = insertvalue { i64, i1 } poison, i64 %mul, 0
  %agg2 = insertvalue { i64, i1 } %agg1, i1 %overflow, 1
  ret { i64, i1 } %agg2
}

; Function that uses the umul function
define spir_func void @test_umul_i64(i64 %a, i64 %b, ptr %result) {
; CHECK-LLVM: define spir_func void @test_umul_i64(i64 %a, i64 %b, ptr %result)
entry:
  ; This call should reference spirv.llvm_umul_with_overflow_i64, not old_llvm.umul.with.overflow.i64
  %umul = call { i64, i1 } @spirv.llvm_umul_with_overflow_i64(i64 %a, i64 %b)
; CHECK-LLVM: call {{.*}} @spirv.llvm_umul_with_overflow_i64(i64 %a, i64 %b)
  %overflow = extractvalue { i64, i1 } %umul, 1
  %value = extractvalue { i64, i1 } %umul, 0
  %safe_value = select i1 %overflow, i64 0, i64 %value
  store i64 %safe_value, ptr %result, align 8
  ret void
}

; Test with i32 as well
define spir_func { i32, i1 } @spirv.llvm_umul_with_overflow_i32(i32 %a, i32 %b) {
; CHECK-LLVM: define spir_func %{{.*}} @spirv.llvm_umul_with_overflow_i32(i32 %a, i32 %b)
entry:
  %mul = mul i32 %a, %b
  %div = udiv i32 %mul, %a
  %overflow = icmp ne i32 %div, %b
  %agg1 = insertvalue { i32, i1 } poison, i32 %mul, 0
  %agg2 = insertvalue { i32, i1 } %agg1, i1 %overflow, 1
  ret { i32, i1 } %agg2
}

define spir_func void @test_umul_i32(i32 %a, i32 %b, ptr %result) {
; CHECK-LLVM: define spir_func void @test_umul_i32(i32 %a, i32 %b, ptr %result)
entry:
  %umul = call { i32, i1 } @spirv.llvm_umul_with_overflow_i32(i32 %a, i32 %b)
; CHECK-LLVM: call {{.*}} @spirv.llvm_umul_with_overflow_i32(i32 %a, i32 %b)
  %overflow = extractvalue { i32, i1 } %umul, 1
  %value = extractvalue { i32, i1 } %umul, 0
  %safe_value = select i1 %overflow, i32 0, i32 %value
  store i32 %safe_value, ptr %result, align 4
  ret void
}
