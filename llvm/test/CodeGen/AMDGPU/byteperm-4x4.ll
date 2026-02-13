; Test byteperm_4x4 matching in the simple case:
; one source vector node and one destination vector node.

; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 -mattr=+real-true16 < %s | FileCheck -check-prefix=GFX1250-TRUE16 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 -mattr=-real-true16 < %s | FileCheck -check-prefix=GFX1250-FAKE16 %s

define void @byteperm_4x4_single_vec(ptr addrspace(1) %out, ptr addrspace(1) %in) {
; GFX1250-TRUE16-LABEL: byteperm_4x4_single_vec:
; GFX1250-TRUE16:       ; %bb.0:
; GFX1250-TRUE16-COUNT-2: v_swap_b16
; GFX1250-TRUE16-COUNT-4: v_perm_b32
; GFX1250-TRUE16-NOT:    v_lshlrev_b32
; GFX1250-TRUE16-NOT:    v_lshrrev_b32
; GFX1250-TRUE16-NOT:    v_bitop3_b16
; GFX1250-TRUE16:        global_store_b128
; GFX1250-TRUE16:        s_set_pc_i64
;
; GFX1250-FAKE16-LABEL: byteperm_4x4_single_vec:
; GFX1250-FAKE16:       ; %bb.0:
; GFX1250-FAKE16-COUNT-8: v_perm_b32
; GFX1250-FAKE16-NOT:    v_swap_b16
; GFX1250-FAKE16-NOT:    v_lshlrev_b32
; GFX1250-FAKE16-NOT:    v_lshrrev_b32
; GFX1250-FAKE16-NOT:    v_bitop3_b16
; GFX1250-FAKE16:        global_store_b128
; GFX1250-FAKE16:        s_set_pc_i64
  %v = load <16 x i8>, ptr addrspace(1) %in, align 16
  %perm = shufflevector <16 x i8> %v, <16 x i8> poison, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x i8> %perm, ptr addrspace(1) %out, align 16
  ret void
}
