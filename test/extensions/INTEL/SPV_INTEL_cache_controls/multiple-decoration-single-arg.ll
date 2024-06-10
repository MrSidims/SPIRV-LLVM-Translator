; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv --spirv-ext=+SPV_INTEL_cache_controls -spirv-text %t.bc -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv --spirv-ext=+SPV_INTEL_cache_controls %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv --spirv-target-env=SPV-IR -o - | llvm-dis -o - | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-SPIRV-DAG: Name [[#Func:]] "test"
; CHECK-SPIRV-DAG: TypeInt [[#Int32:]] 32 0
; CHECK-SPIRV-DAG: Constant [[#Int32]] [[#Zero:]] 0
; CHECK-SPIRV-DAG: Decorate [[#GEP:]] CacheControlLoadINTEL 1 1
; CHECK-SPIRV-DAG: Decorate [[#GEP]] CacheControlLoadINTEL 0 3

; CHECK-SPIRV: Function [[#]] [[#Func]]
; CHECK-SPIRV: FunctionParameter [[#]] [[#Buffer:]]
; CHECK-SPIRV: PtrAccessChain [[#]] [[#GEP]] [[#Buffer]] [[#Zero]]
; CHECK-SPIRV: FunctionCall [[#]] [[#]] [[#]] [[#GEP]]

; CHECK-LLVM: define spir_kernel void @test(ptr addrspace(1) %[[Param:[a-z0-9_.]+]])
; CHECK-LLVM: %[[#GEP:]] = getelementptr ptr addrspace(1), ptr addrspace(1) %[[Param]], i32 0, !spirv.Decorations ![[#MD:]]
; CHECK-LLVM: call spir_func void @foo(ptr addrspace(1) %[[#GEP:]])
; CHECK-LLVM: ![[#MD]] = !{![[#Dec1:]], ![[#Dec2:]]}
; CHECK-LLVM: ![[#Dec1]] = !{i32 6442, i32 1, i32 1}
; CHECK-LLVM: ![[#Dec2]] = !{i32 6442, i32 0, i32 3}

target triple = "spir64-unknown-unknown"

define spir_kernel void @test(ptr addrspace(1) %buffer1) {
entry:
  call void @foo(ptr addrspace(1) %buffer1), !spirv.DecorationCacheControlINTEL !3
  ret void
}

declare void @foo(ptr addrspace(1))

!spirv.MemoryModel = !{!0}
!spirv.Source = !{!1}
!opencl.spir.version = !{!2}
!opencl.ocl.version = !{!2}

!0 = !{i32 2, i32 2}
!1 = !{i32 3, i32 102000}
!2 = !{i32 1, i32 2}
!3 = !{!4, !5}
!4 = !{i32 6442, i32 0, i32 3, i32 0}
!5 = !{i32 6442, i32 1, i32 1, i32 0}
