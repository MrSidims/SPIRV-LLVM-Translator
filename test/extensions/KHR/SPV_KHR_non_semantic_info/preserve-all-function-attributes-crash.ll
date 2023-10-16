; RUN: llvm-as -opaque-pointers=0 %s -o %t.bc
; RUN: llvm-spirv -opaque-pointers=0 %t.bc --spirv-preserve-auxdata --spirv-text -spirv-allow-unknown-intrinsics=llvm.genx. -o %t.txt
; RUN: llvm-spirv --spirv-preserve-auxdata --spirv-target-env=SPV-IR --spirv-text -r %t.txt -o %t.bc
; RUN: llvm-dis %t.bc -o %t.ll
; RUN: FileCheck < %t.txt %s --check-prefix=CHECK-SPIRV
; RUN: FileCheck < %t.ll %s --check-prefix=CHECK-LLVM

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spir-unknown-unknown"

; CHECK-LLVM: define spir_kernel void @test_array
define spir_kernel void @test_array(i8 addrspace(1)* %in, i8 addrspace(1)* %out) {
  call void @llvm.memmove.p1i8.p1i8.i32(i8 addrspace(1)* %out, i8 addrspace(1)* %in, i32 72, i1 false)
  ret void
}

; Function Attrs: nounwind
declare void @llvm.memmove.p1i8.p1i8.i32(i8 addrspace(1)* nocapture, i8 addrspace(1)* nocapture readonly, i32, i1) #0
; CHECK-SPIRV: Name [[#ID:]] "llvm.memmove.p1i8.p1i8.i32"
; CHECK-LLVM-NOT: llvm.memmove

; CHECK-LLVM: attributes #0 = { nounwind }
attributes #0 = { nounwind }
