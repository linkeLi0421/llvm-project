; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel=0 -march=amdgcn -mcpu=gfx900 -mattr=-unaligned-access-mode < %s | FileCheck %s -check-prefixes=GCN,ALIGNED,ALIGNED-SDAG
; RUN: llc -global-isel=1 -march=amdgcn -mcpu=gfx900 -mattr=-unaligned-access-mode < %s | FileCheck %s -check-prefixes=GCN,ALIGNED,ALIGNED-GISEL
; RUN: llc -global-isel=0 -march=amdgcn -mcpu=gfx900 -mattr=+unaligned-access-mode < %s | FileCheck %s -check-prefixes=GCN,UNALIGNED
; RUN: llc -global-isel=1 -march=amdgcn -mcpu=gfx900 -mattr=+unaligned-access-mode < %s | FileCheck %s -check-prefixes=GCN,UNALIGNED

define amdgpu_kernel void @ds1align1(i8 addrspace(3)* %in, i8 addrspace(3)* %out) {
; GCN-LABEL: ds1align1:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_u8 v0, v0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b8 v1, v0
; GCN-NEXT:    s_endpgm
  %val = load i8, i8 addrspace(3)* %in, align 1
  store i8 %val, i8 addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds2align1(i16 addrspace(3)* %in, i16 addrspace(3)* %out) {
; ALIGNED-LABEL: ds2align1:
; ALIGNED:       ; %bb.0:
; ALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-NEXT:    ds_read_u8 v1, v0
; ALIGNED-NEXT:    ds_read_u8 v0, v0 offset:1
; ALIGNED-NEXT:    v_mov_b32_e32 v2, s1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write_b8 v2, v1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write_b8 v2, v0 offset:1
; ALIGNED-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds2align1:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_u16 v0, v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v1, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b16 v1, v0
; UNALIGNED-NEXT:    s_endpgm
  %val = load i16, i16 addrspace(3)* %in, align 1
  store i16 %val, i16 addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds2align2(i16 addrspace(3)* %in, i16 addrspace(3)* %out) {
; GCN-LABEL: ds2align2:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_u16 v0, v0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b16 v1, v0
; GCN-NEXT:    s_endpgm
  %val = load i16, i16 addrspace(3)* %in, align 2
  store i16 %val, i16 addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @ds4align1(i32 addrspace(3)* %in, i32 addrspace(3)* %out) {
; ALIGNED-LABEL: ds4align1:
; ALIGNED:       ; %bb.0:
; ALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-NEXT:    ds_read_u8 v1, v0
; ALIGNED-NEXT:    ds_read_u8 v2, v0 offset:1
; ALIGNED-NEXT:    ds_read_u8 v3, v0 offset:2
; ALIGNED-NEXT:    ds_read_u8 v0, v0 offset:3
; ALIGNED-NEXT:    v_mov_b32_e32 v4, s1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-NEXT:    ds_write_b8 v4, v1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-NEXT:    ds_write_b8 v4, v2 offset:1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-NEXT:    ds_write_b8 v4, v3 offset:2
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-NEXT:    ds_write_b8 v4, v0 offset:3
; ALIGNED-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds4align1:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b32 v0, v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v1, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b32 v1, v0
; UNALIGNED-NEXT:    s_endpgm
  %val = load i32, i32 addrspace(3)* %in, align 1
  store i32 %val, i32 addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds4align2(i32 addrspace(3)* %in, i32 addrspace(3)* %out) {
; ALIGNED-LABEL: ds4align2:
; ALIGNED:       ; %bb.0:
; ALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-NEXT:    ds_read_u16 v1, v0
; ALIGNED-NEXT:    ds_read_u16 v0, v0 offset:2
; ALIGNED-NEXT:    v_mov_b32_e32 v2, s1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write_b16 v2, v1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write_b16 v2, v0 offset:2
; ALIGNED-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds4align2:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b32 v0, v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v1, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b32 v1, v0
; UNALIGNED-NEXT:    s_endpgm
  %val = load i32, i32 addrspace(3)* %in, align 2
  store i32 %val, i32 addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @ds4align4(i32 addrspace(3)* %in, i32 addrspace(3)* %out) {
; GCN-LABEL: ds4align4:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_b32 v0, v0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b32 v1, v0
; GCN-NEXT:    s_endpgm
  %val = load i32, i32 addrspace(3)* %in, align 4
  store i32 %val, i32 addrspace(3)* %out, align 4
  ret void
}

define amdgpu_kernel void @ds8align1(<2 x i32> addrspace(3)* %in, <2 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds8align1:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v2, v0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v3, v0 offset:1
; ALIGNED-SDAG-NEXT:    ds_read_u8 v4, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u8 v5, v0 offset:3
; ALIGNED-SDAG-NEXT:    ds_read_u8 v6, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u8 v7, v0 offset:5
; ALIGNED-SDAG-NEXT:    ds_read_u8 v8, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_read_u8 v0, v0 offset:7
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v1, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v4 offset:2
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v5 offset:3
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v2
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v3 offset:1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v8 offset:6
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v0 offset:7
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v6 offset:4
; ALIGNED-SDAG-NEXT:    ds_write_b8 v1, v7 offset:5
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds8align1:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-GISEL-NEXT:    ds_read_u8 v2, v0
; ALIGNED-GISEL-NEXT:    ds_read_u8 v3, v0 offset:1
; ALIGNED-GISEL-NEXT:    ds_read_u8 v4, v0 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u8 v5, v0 offset:3
; ALIGNED-GISEL-NEXT:    ds_read_u8 v6, v0 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u8 v7, v0 offset:5
; ALIGNED-GISEL-NEXT:    ds_read_u8 v8, v0 offset:6
; ALIGNED-GISEL-NEXT:    ds_read_u8 v0, v0 offset:7
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v1, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v2
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v3 offset:1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v4 offset:2
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v5 offset:3
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v6 offset:4
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v7 offset:5
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v8 offset:6
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v1, v0 offset:7
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds8align1:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read2_b32 v[0:1], v0 offset1:1
; UNALIGNED-NEXT:    v_mov_b32_e32 v2, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write2_b32 v2, v0, v1 offset1:1
; UNALIGNED-NEXT:    s_endpgm
  %val = load <2 x i32>, <2 x i32> addrspace(3)* %in, align 1
  store <2 x i32> %val, <2 x i32> addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds8align2(<2 x i32> addrspace(3)* %in, <2 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds8align2:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v1, v0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v2, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u16 v3, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u16 v0, v0 offset:6
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v4, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(2)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v4, v2 offset:2
; ALIGNED-SDAG-NEXT:    ds_write_b16 v4, v1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(2)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v4, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_write_b16 v4, v3 offset:4
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds8align2:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v1, v0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v2, v0 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u16 v3, v0 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u16 v0, v0 offset:6
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v4, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v4, v1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v4, v2 offset:2
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v4, v3 offset:4
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v4, v0 offset:6
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds8align2:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read2_b32 v[0:1], v0 offset1:1
; UNALIGNED-NEXT:    v_mov_b32_e32 v2, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write2_b32 v2, v0, v1 offset1:1
; UNALIGNED-NEXT:    s_endpgm
  %val = load <2 x i32>, <2 x i32> addrspace(3)* %in, align 2
  store <2 x i32> %val, <2 x i32> addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @ds8align4(<2 x i32> addrspace(3)* %in, <2 x i32> addrspace(3)* %out) {
; GCN-LABEL: ds8align4:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read2_b32 v[0:1], v0 offset1:1
; GCN-NEXT:    v_mov_b32_e32 v2, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write2_b32 v2, v0, v1 offset1:1
; GCN-NEXT:    s_endpgm
  %val = load <2 x i32>, <2 x i32> addrspace(3)* %in, align 4
  store <2 x i32> %val, <2 x i32> addrspace(3)* %out, align 4
  ret void
}

define amdgpu_kernel void @ds8align8(<2 x i32> addrspace(3)* %in, <2 x i32> addrspace(3)* %out) {
; GCN-LABEL: ds8align8:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_b64 v[0:1], v0
; GCN-NEXT:    v_mov_b32_e32 v2, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b64 v2, v[0:1]
; GCN-NEXT:    s_endpgm
  %val = load <2 x i32>, <2 x i32> addrspace(3)* %in, align 8
  store <2 x i32> %val, <2 x i32> addrspace(3)* %out, align 8
  ret void
}

define amdgpu_kernel void @ds12align1(<3 x i32> addrspace(3)* %in, <3 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds12align1:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v1, v0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v2, v0 offset:1
; ALIGNED-SDAG-NEXT:    ds_read_u8 v3, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u8 v4, v0 offset:3
; ALIGNED-SDAG-NEXT:    ds_read_u8 v5, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u8 v6, v0 offset:5
; ALIGNED-SDAG-NEXT:    ds_read_u8 v7, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_read_u8 v8, v0 offset:7
; ALIGNED-SDAG-NEXT:    ds_read_u8 v9, v0 offset:8
; ALIGNED-SDAG-NEXT:    ds_read_u8 v10, v0 offset:9
; ALIGNED-SDAG-NEXT:    ds_read_u8 v11, v0 offset:10
; ALIGNED-SDAG-NEXT:    ds_read_u8 v0, v0 offset:11
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v12, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v9 offset:8
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v10 offset:9
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v3 offset:2
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v4 offset:3
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v1
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v2 offset:1
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v5 offset:4
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v6 offset:5
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v7 offset:6
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v8 offset:7
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v11 offset:10
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v12, v0 offset:11
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds12align1:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-GISEL-NEXT:    ds_read_u8 v0, v2
; ALIGNED-GISEL-NEXT:    ds_read_u8 v1, v2 offset:1
; ALIGNED-GISEL-NEXT:    ds_read_u8 v3, v2 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u8 v4, v2 offset:3
; ALIGNED-GISEL-NEXT:    ds_read_u8 v5, v2 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u8 v6, v2 offset:5
; ALIGNED-GISEL-NEXT:    ds_read_u8 v7, v2 offset:6
; ALIGNED-GISEL-NEXT:    ds_read_u8 v8, v2 offset:7
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(6)
; ALIGNED-GISEL-NEXT:    v_lshl_or_b32 v0, v1, 8, v0
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-GISEL-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(4)
; ALIGNED-GISEL-NEXT:    v_lshlrev_b32_e32 v3, 24, v4
; ALIGNED-GISEL-NEXT:    v_or3_b32 v0, v0, v1, v3
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(2)
; ALIGNED-GISEL-NEXT:    v_lshl_or_b32 v1, v6, 8, v5
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-GISEL-NEXT:    v_lshlrev_b32_e32 v3, 16, v7
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_lshlrev_b32_e32 v4, 24, v8
; ALIGNED-GISEL-NEXT:    v_or3_b32 v1, v1, v3, v4
; ALIGNED-GISEL-NEXT:    ds_read_u8 v3, v2 offset:8
; ALIGNED-GISEL-NEXT:    ds_read_u8 v4, v2 offset:9
; ALIGNED-GISEL-NEXT:    ds_read_u8 v5, v2 offset:10
; ALIGNED-GISEL-NEXT:    ds_read_u8 v2, v2 offset:11
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v6, 8, v0
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v7, 16, v0
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v9, s1
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v8, 24, v0
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v0
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v6 offset:1
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v7 offset:2
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v8 offset:3
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v0, 8, v1
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v6, 16, v1
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v7, 24, v1
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v1 offset:4
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v0 offset:5
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v6 offset:6
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v7 offset:7
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v3 offset:8
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v4 offset:9
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v5 offset:10
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(11)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v9, v2 offset:11
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds12align1:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b96 v[0:2], v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v3, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b96 v3, v[0:2]
; UNALIGNED-NEXT:    s_endpgm
  %val = load <3 x i32>, <3 x i32> addrspace(3)* %in, align 1
  store <3 x i32> %val, <3 x i32> addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds12align2(<3 x i32> addrspace(3)* %in, <3 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds12align2:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v2, v0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v3, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u16 v4, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u16 v5, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_read_u16 v6, v0 offset:8
; ALIGNED-SDAG-NEXT:    ds_read_u16 v0, v0 offset:10
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v1, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v6 offset:8
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v3 offset:2
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v2
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v4 offset:4
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v5 offset:6
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v0 offset:10
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds12align2:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v1, v0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v3, v0 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u16 v4, v0 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u16 v5, v0 offset:6
; ALIGNED-GISEL-NEXT:    ds_read_u16 v6, v0 offset:8
; ALIGNED-GISEL-NEXT:    ds_read_u16 v7, v0 offset:10
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v2, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(4)
; ALIGNED-GISEL-NEXT:    v_lshl_or_b32 v0, v3, 16, v1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(2)
; ALIGNED-GISEL-NEXT:    v_lshl_or_b32 v1, v5, 16, v4
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v0
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v3 offset:2
; ALIGNED-GISEL-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v1 offset:4
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v0 offset:6
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v6 offset:8
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(5)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v2, v7 offset:10
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds12align2:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b96 v[0:2], v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v3, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b96 v3, v[0:2]
; UNALIGNED-NEXT:    s_endpgm
  %val = load <3 x i32>, <3 x i32> addrspace(3)* %in, align 2
  store <3 x i32> %val, <3 x i32> addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @ds12align4(<3 x i32> addrspace(3)* %in, <3 x i32> addrspace(3)* %out) {
; ALIGNED-LABEL: ds12align4:
; ALIGNED:       ; %bb.0:
; ALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-NEXT:    ds_read2_b32 v[0:1], v2 offset1:1
; ALIGNED-NEXT:    ds_read_b32 v2, v2 offset:8
; ALIGNED-NEXT:    v_mov_b32_e32 v3, s1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write2_b32 v3, v0, v1 offset1:1
; ALIGNED-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-NEXT:    ds_write_b32 v3, v2 offset:8
; ALIGNED-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds12align4:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b96 v[0:2], v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v3, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b96 v3, v[0:2]
; UNALIGNED-NEXT:    s_endpgm
  %val = load <3 x i32>, <3 x i32> addrspace(3)* %in, align 4
  store <3 x i32> %val, <3 x i32> addrspace(3)* %out, align 4
  ret void
}

; TODO: Why does the ALIGNED-SDAG code use ds_write_b64 but not ds_read_b64?
define amdgpu_kernel void @ds12align8(<3 x i32> addrspace(3)* %in, <3 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds12align8:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-SDAG-NEXT:    ds_read2_b32 v[0:1], v2 offset1:1
; ALIGNED-SDAG-NEXT:    ds_read_b32 v2, v2 offset:8
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v3, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    ds_write_b32 v3, v2 offset:8
; ALIGNED-SDAG-NEXT:    ds_write_b64 v3, v[0:1]
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds12align8:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-GISEL-NEXT:    ds_read_b64 v[0:1], v2
; ALIGNED-GISEL-NEXT:    ds_read_b32 v2, v2 offset:8
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v3, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-GISEL-NEXT:    ds_write_b64 v3, v[0:1]
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-GISEL-NEXT:    ds_write_b32 v3, v2 offset:8
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds12align8:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read_b96 v[0:2], v0
; UNALIGNED-NEXT:    v_mov_b32_e32 v3, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write_b96 v3, v[0:2]
; UNALIGNED-NEXT:    s_endpgm
  %val = load <3 x i32>, <3 x i32> addrspace(3)* %in, align 8
  store <3 x i32> %val, <3 x i32> addrspace(3)* %out, align 8
  ret void
}

define amdgpu_kernel void @ds12align16(<3 x i32> addrspace(3)* %in, <3 x i32> addrspace(3)* %out) {
; GCN-LABEL: ds12align16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_b96 v[0:2], v0
; GCN-NEXT:    v_mov_b32_e32 v3, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b96 v3, v[0:2]
; GCN-NEXT:    s_endpgm
  %val = load <3 x i32>, <3 x i32> addrspace(3)* %in, align 16
  store <3 x i32> %val, <3 x i32> addrspace(3)* %out, align 16
  ret void
}

define amdgpu_kernel void @ds16align1(<4 x i32> addrspace(3)* %in, <4 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds16align1:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v1, v0
; ALIGNED-SDAG-NEXT:    ds_read_u8 v2, v0 offset:1
; ALIGNED-SDAG-NEXT:    ds_read_u8 v3, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u8 v4, v0 offset:3
; ALIGNED-SDAG-NEXT:    ds_read_u8 v5, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u8 v6, v0 offset:5
; ALIGNED-SDAG-NEXT:    ds_read_u8 v7, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_read_u8 v8, v0 offset:7
; ALIGNED-SDAG-NEXT:    ds_read_u8 v9, v0 offset:8
; ALIGNED-SDAG-NEXT:    ds_read_u8 v10, v0 offset:9
; ALIGNED-SDAG-NEXT:    ds_read_u8 v11, v0 offset:10
; ALIGNED-SDAG-NEXT:    ds_read_u8 v12, v0 offset:11
; ALIGNED-SDAG-NEXT:    ds_read_u8 v13, v0 offset:12
; ALIGNED-SDAG-NEXT:    ds_read_u8 v14, v0 offset:13
; ALIGNED-SDAG-NEXT:    ds_read_u8 v15, v0 offset:14
; ALIGNED-SDAG-NEXT:    ds_read_u8 v0, v0 offset:15
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v16, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v13 offset:12
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(3)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v14 offset:13
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v3 offset:2
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v4 offset:3
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v1
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v2 offset:1
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v5 offset:4
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v6 offset:5
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v9 offset:8
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v10 offset:9
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v7 offset:6
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v8 offset:7
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v11 offset:10
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v12 offset:11
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v15 offset:14
; ALIGNED-SDAG-NEXT:    ds_write_b8 v16, v0 offset:15
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds16align1:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-GISEL-NEXT:    ds_read_u8 v1, v0
; ALIGNED-GISEL-NEXT:    ds_read_u8 v2, v0 offset:1
; ALIGNED-GISEL-NEXT:    ds_read_u8 v3, v0 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u8 v4, v0 offset:3
; ALIGNED-GISEL-NEXT:    ds_read_u8 v5, v0 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u8 v6, v0 offset:5
; ALIGNED-GISEL-NEXT:    ds_read_u8 v7, v0 offset:6
; ALIGNED-GISEL-NEXT:    ds_read_u8 v8, v0 offset:7
; ALIGNED-GISEL-NEXT:    ds_read_u8 v9, v0 offset:8
; ALIGNED-GISEL-NEXT:    ds_read_u8 v10, v0 offset:9
; ALIGNED-GISEL-NEXT:    ds_read_u8 v11, v0 offset:10
; ALIGNED-GISEL-NEXT:    ds_read_u8 v12, v0 offset:11
; ALIGNED-GISEL-NEXT:    ds_read_u8 v13, v0 offset:12
; ALIGNED-GISEL-NEXT:    ds_read_u8 v14, v0 offset:13
; ALIGNED-GISEL-NEXT:    ds_read_u8 v15, v0 offset:14
; ALIGNED-GISEL-NEXT:    ds_read_u8 v0, v0 offset:15
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v16, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v1
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v2 offset:1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v3 offset:2
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v4 offset:3
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v5 offset:4
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v6 offset:5
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v7 offset:6
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v8 offset:7
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v9 offset:8
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v10 offset:9
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v11 offset:10
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v12 offset:11
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v13 offset:12
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v14 offset:13
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(14)
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v15 offset:14
; ALIGNED-GISEL-NEXT:    ds_write_b8 v16, v0 offset:15
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds16align1:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read2_b64 v[0:3], v0 offset1:1
; UNALIGNED-NEXT:    v_mov_b32_e32 v4, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; UNALIGNED-NEXT:    s_endpgm
  %val = load <4 x i32>, <4 x i32> addrspace(3)* %in, align 1
  store <4 x i32> %val, <4 x i32> addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @ds16align2(<4 x i32> addrspace(3)* %in, <4 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds16align2:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v2, v0
; ALIGNED-SDAG-NEXT:    ds_read_u16 v3, v0 offset:2
; ALIGNED-SDAG-NEXT:    ds_read_u16 v4, v0 offset:4
; ALIGNED-SDAG-NEXT:    ds_read_u16 v5, v0 offset:6
; ALIGNED-SDAG-NEXT:    ds_read_u16 v6, v0 offset:8
; ALIGNED-SDAG-NEXT:    ds_read_u16 v7, v0 offset:10
; ALIGNED-SDAG-NEXT:    ds_read_u16 v8, v0 offset:12
; ALIGNED-SDAG-NEXT:    ds_read_u16 v0, v0 offset:14
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v1, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v8 offset:12
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v3 offset:2
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v2
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v4 offset:4
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v6 offset:8
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v5 offset:6
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v7 offset:10
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-SDAG-NEXT:    ds_write_b16 v1, v0 offset:14
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds16align2:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v0, s0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v2, v0
; ALIGNED-GISEL-NEXT:    ds_read_u16 v3, v0 offset:2
; ALIGNED-GISEL-NEXT:    ds_read_u16 v4, v0 offset:4
; ALIGNED-GISEL-NEXT:    ds_read_u16 v5, v0 offset:6
; ALIGNED-GISEL-NEXT:    ds_read_u16 v6, v0 offset:8
; ALIGNED-GISEL-NEXT:    ds_read_u16 v7, v0 offset:10
; ALIGNED-GISEL-NEXT:    ds_read_u16 v8, v0 offset:12
; ALIGNED-GISEL-NEXT:    ds_read_u16 v0, v0 offset:14
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v1, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v2
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v3 offset:2
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v4 offset:4
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v5 offset:6
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v6 offset:8
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v7 offset:10
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v8 offset:12
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(7)
; ALIGNED-GISEL-NEXT:    ds_write_b16 v1, v0 offset:14
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds16align2:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read2_b64 v[0:3], v0 offset1:1
; UNALIGNED-NEXT:    v_mov_b32_e32 v4, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; UNALIGNED-NEXT:    s_endpgm
  %val = load <4 x i32>, <4 x i32> addrspace(3)* %in, align 2
  store <4 x i32> %val, <4 x i32> addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @ds16align4(<4 x i32> addrspace(3)* %in, <4 x i32> addrspace(3)* %out) {
; ALIGNED-SDAG-LABEL: ds16align4:
; ALIGNED-SDAG:       ; %bb.0:
; ALIGNED-SDAG-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-SDAG-NEXT:    ds_read2_b32 v[0:1], v2 offset1:1
; ALIGNED-SDAG-NEXT:    ds_read2_b32 v[2:3], v2 offset0:2 offset1:3
; ALIGNED-SDAG-NEXT:    v_mov_b32_e32 v4, s1
; ALIGNED-SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-SDAG-NEXT:    ds_write2_b32 v4, v2, v3 offset0:2 offset1:3
; ALIGNED-SDAG-NEXT:    ds_write2_b32 v4, v0, v1 offset1:1
; ALIGNED-SDAG-NEXT:    s_endpgm
;
; ALIGNED-GISEL-LABEL: ds16align4:
; ALIGNED-GISEL:       ; %bb.0:
; ALIGNED-GISEL-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v2, s0
; ALIGNED-GISEL-NEXT:    ds_read2_b32 v[0:1], v2 offset1:1
; ALIGNED-GISEL-NEXT:    ds_read2_b32 v[2:3], v2 offset0:2 offset1:3
; ALIGNED-GISEL-NEXT:    v_mov_b32_e32 v4, s1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-GISEL-NEXT:    ds_write2_b32 v4, v0, v1 offset1:1
; ALIGNED-GISEL-NEXT:    s_waitcnt lgkmcnt(1)
; ALIGNED-GISEL-NEXT:    ds_write2_b32 v4, v2, v3 offset0:2 offset1:3
; ALIGNED-GISEL-NEXT:    s_endpgm
;
; UNALIGNED-LABEL: ds16align4:
; UNALIGNED:       ; %bb.0:
; UNALIGNED-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; UNALIGNED-NEXT:    ds_read2_b64 v[0:3], v0 offset1:1
; UNALIGNED-NEXT:    v_mov_b32_e32 v4, s1
; UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; UNALIGNED-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; UNALIGNED-NEXT:    s_endpgm
  %val = load <4 x i32>, <4 x i32> addrspace(3)* %in, align 4
  store <4 x i32> %val, <4 x i32> addrspace(3)* %out, align 4
  ret void
}

define amdgpu_kernel void @ds16align8(<4 x i32> addrspace(3)* %in, <4 x i32> addrspace(3)* %out) {
; GCN-LABEL: ds16align8:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read2_b64 v[0:3], v0 offset1:1
; GCN-NEXT:    v_mov_b32_e32 v4, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; GCN-NEXT:    s_endpgm
  %val = load <4 x i32>, <4 x i32> addrspace(3)* %in, align 8
  store <4 x i32> %val, <4 x i32> addrspace(3)* %out, align 8
  ret void
}

define amdgpu_kernel void @ds16align16(<4 x i32> addrspace(3)* %in, <4 x i32> addrspace(3)* %out) {
; GCN-LABEL: ds16align16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    ds_read_b128 v[0:3], v0
; GCN-NEXT:    v_mov_b32_e32 v4, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write_b128 v4, v[0:3]
; GCN-NEXT:    s_endpgm
  %val = load <4 x i32>, <4 x i32> addrspace(3)* %in, align 16
  store <4 x i32> %val, <4 x i32> addrspace(3)* %out, align 16
  ret void
}