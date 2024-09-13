;Source:
;void __kernel test(float2 x, uint c,
;                   read_only image2d_t image_in,
;                   write_only image2d_t image_out,
;                   int2 coord,
;                   __global uint* p,
;                   __global ushort* sp,
;                   __global uchar* cp,
;                   __global ulong* lp) {
;    intel_sub_group_shuffle(x, c);
;    intel_sub_group_shuffle_down(x, x, c);
;    intel_sub_group_shuffle_up(x, x, c);
;    intel_sub_group_shuffle_xor(x, c);
;
;    uint2 ui2 = intel_sub_group_block_read2(image_in, coord);
;    intel_sub_group_block_write2(image_out, coord, ui2);
;    ui2 = intel_sub_group_block_read2(p);
;    intel_sub_group_block_write2(p, ui2);
;
;    ushort2 us2 = intel_sub_group_block_read_us2(image_in, coord);
;    intel_sub_group_block_write_us2(image_out, coord, us2);
;    us2 = intel_sub_group_block_read_us2(sp);
;    intel_sub_group_block_write_us2(sp, us2);
;
;    uchar2 uc2 = intel_sub_group_block_read_uc2(image_in, coord);
;    intel_sub_group_block_write_uc2(image_out, coord, uc2);
;    uc2 = intel_sub_group_block_read_uc2(cp);
;    intel_sub_group_block_write_uc2(cp, uc2);
;
;    ulong2 ul2 = intel_sub_group_block_read_ul2(image_in, coord);
;    intel_sub_group_block_write_ul2(image_out, coord, ul2);
;    ul2 = intel_sub_group_block_read_ul2(lp);
;    intel_sub_group_block_write_ul2(lp, ul2);
;
;    uchar16 uc16 = intel_sub_group_block_read_uc16(image_in, coord);
;    intel_sub_group_block_write_uc16(image_out, coord, uc16);
;    uc16 = intel_sub_group_block_read_uc16(cp);
;    intel_sub_group_block_write_uc2(cp, uc16);
;
;    ushort16 us16 = intel_sub_group_block_read_us16(image_in, coord);
;    intel_sub_group_block_write_us16(image_out, coord, us16);
;    us16 = intel_sub_group_block_read_us16(sp);
;    intel_sub_group_block_write_us16(sp, us16);
;}

; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -o - -spirv-text --spirv-ext=+SPV_INTEL_subgroups | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv --spirv-ext=+SPV_INTEL_subgroups
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc --spirv-target-env=SPV-IR
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM-SPIRV
; RUN: llvm-spirv %t.rev.bc -o - -spirv-text --spirv-ext=+SPV_INTEL_subgroups | FileCheck %s --check-prefix=CHECK-SPIRV

; CHECK-SPIRV: Capability SubgroupShuffleINTEL
; CHECK-SPIRV: Capability SubgroupBufferBlockIOINTEL
; CHECK-SPIRV: Capability SubgroupImageBlockIOINTEL
; CHECK-SPIRV: Extension "SPV_INTEL_subgroups"

; CHECK-SPIRV-LABEL: Function
; CHECK-SPIRV-LABEL: Label

; CHECK-SPIRV: SubgroupShuffleINTEL
; CHECK-SPIRV: SubgroupShuffleDownINTEL
; CHECK-SPIRV: SubgroupShuffleUpINTEL
; CHECK-SPIRV: SubgroupShuffleXorINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV: SubgroupImageBlockReadINTEL
; CHECK-SPIRV: SubgroupImageBlockWriteINTEL
; CHECK-SPIRV: SubgroupBlockReadINTEL
; CHECK-SPIRV: SubgroupBlockWriteINTEL

; CHECK-SPIRV-LABEL: Return

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64"

%opencl.image2d_ro_t = type opaque
%opencl.image2d_wo_t = type opaque

; LLVM checks were generated by update_test_checks.py using opt without any passes.
; Function Attrs: convergent nounwind
define spir_kernel void @test(<2 x float> %x, i32 %c, ptr addrspace(1) %image_in, ptr addrspace(1) %image_out, <2 x i32> %coord, ptr addrspace(1) %p, ptr addrspace(1) %sp, ptr addrspace(1) %cp, ptr addrspace(1) %lp) local_unnamed_addr #0 !kernel_arg_addr_space !1 !kernel_arg_access_qual !2 !kernel_arg_type !3 !kernel_arg_base_type !4 !kernel_arg_type_qual !5 !kernel_arg_name !6 {
; CHECK-LLVM-LABEL: @test(
; CHECK-LLVM-NEXT:  entry:
; CHECK-LLVM-NEXT:    [[CALL:%.*]] = call spir_func <2 x float> @_Z23intel_sub_group_shuffleDv2_fj(<2 x float> [[X:%.*]], i32 [[C:%.*]])
; CHECK-LLVM-NEXT:    [[CALL1:%.*]] = call spir_func <2 x float> @_Z28intel_sub_group_shuffle_downDv2_fS_j(<2 x float> [[X]], <2 x float> [[X]], i32 [[C]])
; CHECK-LLVM-NEXT:    [[CALL2:%.*]] = call spir_func <2 x float> @_Z26intel_sub_group_shuffle_upDv2_fS_j(<2 x float> [[X]], <2 x float> [[X]], i32 [[C]])
; CHECK-LLVM-NEXT:    [[CALL3:%.*]] = call spir_func <2 x float> @_Z27intel_sub_group_shuffle_xorDv2_fj(<2 x float> [[X]], i32 [[C]])
; CHECK-LLVM-NEXT:    [[CALL4:%.*]] = call spir_func <2 x i32> @_Z27intel_sub_group_block_read214ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN:%.*]], <2 x i32> [[COORD:%.*]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z28intel_sub_group_block_write214ocl_image2d_woDv2_iDv2_j(ptr addrspace(1) [[IMAGE_OUT:%.*]], <2 x i32> [[COORD]], <2 x i32> [[CALL4]])
; CHECK-LLVM-NEXT:    [[CALL5:%.*]] = call spir_func <2 x i32> @_Z27intel_sub_group_block_read2PU3AS1Kj(ptr addrspace(1) [[P:%.*]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z28intel_sub_group_block_write2PU3AS1jDv2_j(ptr addrspace(1) [[P]], <2 x i32> [[CALL5]])
; CHECK-LLVM-NEXT:    [[CALL6:%.*]] = call spir_func <2 x i16> @_Z30intel_sub_group_block_read_us214ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN]], <2 x i32> [[COORD]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_us214ocl_image2d_woDv2_iDv2_t(ptr addrspace(1) [[IMAGE_OUT]], <2 x i32> [[COORD]], <2 x i16> [[CALL6]])
; CHECK-LLVM-NEXT:    [[CALL7:%.*]] = call spir_func <2 x i16> @_Z30intel_sub_group_block_read_us2PU3AS1Kt(ptr addrspace(1) [[SP:%.*]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_us2PU3AS1tDv2_t(ptr addrspace(1) [[SP]], <2 x i16> [[CALL7]])
; CHECK-LLVM-NEXT:    [[CALL8:%.*]] = call spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc214ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN]], <2 x i32> [[COORD]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_uc214ocl_image2d_woDv2_iDv2_h(ptr addrspace(1) [[IMAGE_OUT]], <2 x i32> [[COORD]], <2 x i8> [[CALL8]])
; CHECK-LLVM-NEXT:    [[CALL9:%.*]] = call spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc2PU3AS1Kh(ptr addrspace(1) [[CP:%.*]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_uc2PU3AS1hDv2_h(ptr addrspace(1) [[CP]], <2 x i8> [[CALL9]])
; CHECK-LLVM-NEXT:    [[CALL10:%.*]] = call spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul214ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN]], <2 x i32> [[COORD]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_ul214ocl_image2d_woDv2_iDv2_m(ptr addrspace(1) [[IMAGE_OUT]], <2 x i32> [[COORD]], <2 x i64> [[CALL10]])
; CHECK-LLVM-NEXT:    [[CALL11:%.*]] = call spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul2PU3AS1Km(ptr addrspace(1) [[LP:%.*]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z31intel_sub_group_block_write_ul2PU3AS1mDv2_m(ptr addrspace(1) [[LP]], <2 x i64> [[CALL11]])
; CHECK-LLVM-NEXT:    [[CALL12:%.*]] = call spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc1614ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN]], <2 x i32> [[COORD]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z32intel_sub_group_block_write_uc1614ocl_image2d_woDv2_iDv16_h(ptr addrspace(1) [[IMAGE_OUT]], <2 x i32> [[COORD]], <16 x i8> [[CALL12]])
; CHECK-LLVM-NEXT:    [[CALL13:%.*]] = call spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc16PU3AS1Kh(ptr addrspace(1) [[CP]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z32intel_sub_group_block_write_uc16PU3AS1hDv16_h(ptr addrspace(1) [[CP]], <16 x i8> [[CALL13]])
; CHECK-LLVM-NEXT:    [[CALL14:%.*]] = call spir_func <16 x i16> @_Z31intel_sub_group_block_read_us1614ocl_image2d_roDv2_i(ptr addrspace(1) [[IMAGE_IN]], <2 x i32> [[COORD]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z32intel_sub_group_block_write_us1614ocl_image2d_woDv2_iDv16_t(ptr addrspace(1) [[IMAGE_OUT]], <2 x i32> [[COORD]], <16 x i16> [[CALL14]])
; CHECK-LLVM-NEXT:    [[CALL15:%.*]] = call spir_func <16 x i16> @_Z31intel_sub_group_block_read_us16PU3AS1Kt(ptr addrspace(1) [[SP]])
; CHECK-LLVM-NEXT:    call spir_func void @_Z32intel_sub_group_block_write_us16PU3AS1tDv16_t(ptr addrspace(1) [[SP]], <16 x i16> [[CALL15]])
; CHECK-LLVM-NEXT:    ret void

; CHECK-LLVM-SPIRV: call spir_func <2 x float> @_Z28__spirv_SubgroupShuffleINTELDv2_fj(
; CHECK-LLVM-SPIRV: call spir_func <2 x float> @_Z32__spirv_SubgroupShuffleDownINTELDv2_fS_j(
; CHECK-LLVM-SPIRV: call spir_func <2 x float> @_Z30__spirv_SubgroupShuffleUpINTELDv2_fS_j(
; CHECK-LLVM-SPIRV: call spir_func <2 x float> @_Z31__spirv_SubgroupShuffleXorINTELDv2_fj(
; CHECK-LLVM-SPIRV: call spir_func <2 x i32> @_Z41__spirv_SubgroupImageBlockReadINTEL_Rint2PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv2_j(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <2 x i32> @_Z36__spirv_SubgroupBlockReadINTEL_Rint2PU3AS1Kj(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1jDv2_j(
; CHECK-LLVM-SPIRV: call spir_func <2 x i16> @_Z43__spirv_SubgroupImageBlockReadINTEL_Rshort2PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv2_t(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <2 x i16> @_Z38__spirv_SubgroupBlockReadINTEL_Rshort2PU3AS1Kt(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1tDv2_t(
; CHECK-LLVM-SPIRV: call spir_func <2 x i8> @_Z42__spirv_SubgroupImageBlockReadINTEL_Rchar2PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv2_h(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <2 x i8> @_Z37__spirv_SubgroupBlockReadINTEL_Rchar2PU3AS1Kh(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1hDv2_h(
; CHECK-LLVM-SPIRV: call spir_func <2 x i64> @_Z42__spirv_SubgroupImageBlockReadINTEL_Rlong2PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv2_m(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <2 x i64> @_Z37__spirv_SubgroupBlockReadINTEL_Rlong2PU3AS1Km(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1mDv2_m(

; CHECK-LLVM-SPIRV: call spir_func <16 x i8> @_Z43__spirv_SubgroupImageBlockReadINTEL_Rchar16PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv16_h(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <16 x i8> @_Z38__spirv_SubgroupBlockReadINTEL_Rchar16PU3AS1Kh(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1hDv16_h(
; CHECK-LLVM-SPIRV: call spir_func <16 x i16> @_Z44__spirv_SubgroupImageBlockReadINTEL_Rshort16PU3AS133__spirv_Image__void_1_0_0_0_0_0_0Dv2_i(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 0)
; CHECK-LLVM-SPIRV: call spir_func void @_Z36__spirv_SubgroupImageBlockWriteINTELPU3AS133__spirv_Image__void_1_0_0_0_0_0_1Dv2_iDv16_t(target("spirv.Image", void, 1, 0, 0, 0, 0, 0, 1)
; CHECK-LLVM-SPIRV: call spir_func <16 x i16> @_Z39__spirv_SubgroupBlockReadINTEL_Rshort16PU3AS1Kt(
; CHECK-LLVM-SPIRV: call spir_func void @_Z31__spirv_SubgroupBlockWriteINTELPU3AS1tDv16_t(


entry:
  %call = tail call spir_func <2 x float> @_Z23intel_sub_group_shuffleDv2_fj(<2 x float> %x, i32 %c) #2
  %call1 = tail call spir_func <2 x float> @_Z28intel_sub_group_shuffle_downDv2_fS_j(<2 x float> %x, <2 x float> %x, i32 %c) #2
  %call2 = tail call spir_func <2 x float> @_Z26intel_sub_group_shuffle_upDv2_fS_j(<2 x float> %x, <2 x float> %x, i32 %c) #2
  %call3 = tail call spir_func <2 x float> @_Z27intel_sub_group_shuffle_xorDv2_fj(<2 x float> %x, i32 %c) #2

  %call4 = tail call spir_func <2 x i32> @_Z27intel_sub_group_block_read214ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z28intel_sub_group_block_write214ocl_image2d_woDv2_iDv2_j(ptr addrspace(1) %image_out, <2 x i32> %coord, <2 x i32> %call4) #2
  %call5 = tail call spir_func <2 x i32> @_Z27intel_sub_group_block_read2PU3AS1Kj(ptr addrspace(1) %p) #2
  tail call spir_func void @_Z28intel_sub_group_block_write2PU3AS1jDv2_j(ptr addrspace(1) %p, <2 x i32> %call5) #2

  %call6 = tail call spir_func <2 x i16> @_Z30intel_sub_group_block_read_us214ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_us214ocl_image2d_woDv2_iDv2_t(ptr addrspace(1) %image_out, <2 x i32> %coord, <2 x i16> %call6) #2
  %call7 = tail call spir_func <2 x i16> @_Z30intel_sub_group_block_read_us2PU3AS1Kt(ptr addrspace(1) %sp) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_us2PU3AS1tDv2_t(ptr addrspace(1) %sp, <2 x i16> %call7) #2

  %call8 = tail call spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc214ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_uc214ocl_image2d_woDv2_iDv2_h(ptr addrspace(1) %image_out, <2 x i32> %coord, <2 x i8> %call8) #2
  %call9 = tail call spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc2PU3AS1Kh(ptr addrspace(1) %cp) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_uc2PU3AS1hDv2_h(ptr addrspace(1) %cp, <2 x i8> %call9) #2

  %call10 = tail call spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul214ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_ul214ocl_image2d_woDv2_iDv2_m(ptr addrspace(1) %image_out, <2 x i32> %coord, <2 x i64> %call10) #2
  %call11 = tail call spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul2PU3AS1Km(ptr addrspace(1) %lp) #2
  tail call spir_func void @_Z31intel_sub_group_block_write_ul2PU3AS1mDv2_m(ptr addrspace(1) %lp, <2 x i64> %call11) #2
  
  %call12 = tail call spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc1614ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z32intel_sub_group_block_write_uc1614ocl_image2d_woDv2_iDv16_h(ptr addrspace(1) %image_out, <2 x i32> %coord, <16 x i8> %call12) #2
  %call13 = tail call spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc16PU3AS1Kh(ptr addrspace(1) %cp) #2
  tail call spir_func void @_Z32intel_sub_group_block_write_uc16PU3AS1hDv16_h(ptr addrspace(1) %cp, <16 x i8> %call13) #2
  
  %call14 = tail call spir_func <16 x i16> @_Z31intel_sub_group_block_read_us1614ocl_image2d_roDv2_i(ptr addrspace(1) %image_in, <2 x i32> %coord) #2
  tail call spir_func void @_Z32intel_sub_group_block_write_us1614ocl_image2d_woDv2_iDv16_t(ptr addrspace(1) %image_out, <2 x i32> %coord, <16 x i16> %call14) #2
  %call15 = tail call spir_func <16 x i16> @_Z31intel_sub_group_block_read_us16PU3AS1Kt(ptr addrspace(1) %sp) #2
  tail call spir_func void @_Z32intel_sub_group_block_write_us16PU3AS1tDv16_t(ptr addrspace(1) %sp, <16 x i16> %call15) #2

  ret void
}

; Function Attrs: convergent
declare spir_func <2 x float> @_Z23intel_sub_group_shuffleDv2_fj(<2 x float>, i32) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x float> @_Z28intel_sub_group_shuffle_downDv2_fS_j(<2 x float>, <2 x float>, i32) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x float> @_Z26intel_sub_group_shuffle_upDv2_fS_j(<2 x float>, <2 x float>, i32) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x float> @_Z27intel_sub_group_shuffle_xorDv2_fj(<2 x float>, i32) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i32> @_Z27intel_sub_group_block_read214ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z28intel_sub_group_block_write214ocl_image2d_woDv2_iDv2_j(ptr addrspace(1), <2 x i32>, <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i32> @_Z27intel_sub_group_block_read2PU3AS1Kj(ptr addrspace(1)) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z28intel_sub_group_block_write2PU3AS1jDv2_j(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i16> @_Z30intel_sub_group_block_read_us214ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_us214ocl_image2d_woDv2_iDv2_t(ptr addrspace(1), <2 x i32>, <2 x i16>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i16> @_Z30intel_sub_group_block_read_us2PU3AS1Kt(ptr addrspace(1)) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_us2PU3AS1tDv2_t(ptr addrspace(1), <2 x i16>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc214ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_uc214ocl_image2d_woDv2_iDv2_h(ptr addrspace(1), <2 x i32>, <2 x i8>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i8> @_Z30intel_sub_group_block_read_uc2PU3AS1Kh(ptr addrspace(1)) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_uc2PU3AS1hDv2_h(ptr addrspace(1), <2 x i8>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul214ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_ul214ocl_image2d_woDv2_iDv2_m(ptr addrspace(1), <2 x i32>, <2 x i64>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <2 x i64> @_Z30intel_sub_group_block_read_ul2PU3AS1Km(ptr addrspace(1)) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z31intel_sub_group_block_write_ul2PU3AS1mDv2_m(ptr addrspace(1), <2 x i64>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc1614ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) #1

; Function Attrs: convergent
declare spir_func void @_Z32intel_sub_group_block_write_uc1614ocl_image2d_woDv2_iDv16_h(ptr addrspace(1), <2 x i32>, <16 x i8>) #1

; Function Attrs: convergent
declare spir_func <16 x i8> @_Z31intel_sub_group_block_read_uc16PU3AS1Kh(ptr addrspace(1)) #1

; Function Attrs: convergent
declare spir_func void @_Z32intel_sub_group_block_write_uc16PU3AS1hDv16_h(ptr addrspace(1), <16 x i8>) #1

; Function Attrs: convergent
declare spir_func <16 x i16> @_Z31intel_sub_group_block_read_us1614ocl_image2d_roDv2_i(ptr addrspace(1), <2 x i32>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z32intel_sub_group_block_write_us1614ocl_image2d_woDv2_iDv16_t(ptr addrspace(1), <2 x i32>, <16 x i16>) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func <16 x i16> @_Z31intel_sub_group_block_read_us16PU3AS1Kt(ptr addrspace(1)) local_unnamed_addr #1

; Function Attrs: convergent
declare spir_func void @_Z32intel_sub_group_block_write_us16PU3AS1tDv16_t(ptr addrspace(1), <16 x i16>) local_unnamed_addr #1

attributes #0 = { convergent nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "denorms-are-zero"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="128" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "uniform-work-group-size"="true" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { convergent "correctly-rounded-divide-sqrt-fp-math"="false" "denorms-are-zero"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { convergent nounwind }

!opencl.ocl.version = !{!0}
!opencl.spir.version = !{!0}

!0 = !{i32 1, i32 2}
!1 = !{i32 0, i32 0, i32 1, i32 1, i32 0, i32 1, i32 1, i32 1, i32 1}
!2 = !{!"none", !"none", !"read_only", !"write_only", !"none", !"none", !"none", !"none", !"none"}
!3 = !{!"float2", !"uint", !"image2d_t", !"image2d_t", !"int2", !"uint*", !"ushort*", !"uchar*", !"ulong*"}
!4 = !{!"float __attribute__((ext_vector_type(2)))", !"uint", !"image2d_t", !"image2d_t", !"int __attribute__((ext_vector_type(2)))", !"uint*", !"ushort*", !"uchar*", !"ulong*"}
!5 = !{!"", !"", !"", !"", !"", !"", !"", !"", !""}
!6 = !{!"x", !"c", !"image_in", !"image_out", !"coord", !"p", !"sp", !"cp", !"lp"}
