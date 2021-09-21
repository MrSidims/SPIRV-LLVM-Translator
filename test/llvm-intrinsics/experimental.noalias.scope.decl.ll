; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; CHECK-NOT: llvm.experimental.noalias.scope.decl
declare void @llvm.experimental.noalias.scope.decl(metadata)

; Function Attrs: nounwind
define spir_kernel void @foo() {
entry:
  call void @llvm.experimental.noalias.scope.decl(metadata !1)
  ret void
}

!opencl.enable.FP_CONTRACT = !{}

!1 = !{!2}
!2 = distinct !{!2, !3}
!3 = distinct !{!3}
