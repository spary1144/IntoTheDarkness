;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of Damned Games 
;;  Copyright (C) 2021 Jorge Marín Ferrándiz, Yeray Mora Sobrino
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

.include "cpctelerafunction.h.s"
.include "entity_manager.h.s"
.include "ia_manager.h.s"
.include "cpctelera.h.s"
.include "collision.h.s"
.include "game_manager.h.s"

f_counter:: .db 00

sys_collision_check_aabb_collisions_ix_vs_iy::
   ;; cargadas las dos posiciones de x de personaje y enemigo
    ;; ============ Colisiones en el eje X ============
    
    ld a, e_x(iy)
    ld b, a
    add e_w(iy)
    dec a 
    ld c, e_x(ix)
    sub c
    ret c

    ld a, c
    add e_w(ix)
    dec a 
    sub b
    ret c
    
;; ============ Colisiones en el eje Y ============

    ld a, e_y(iy)
    ld b, a
    add e_h(iy)
    dec a 
    ld c, e_y(ix)
    sub c
    ret c

    ld a, c
    add e_h(ix)
    dec a 
    sub b

ret 
    
sys_collision_ix_collider_iy_collisionable::

    call sys_collision_check_aabb_collisions_ix_vs_iy
    ret c
    
    ld l, e_col_func+0(ix)
    ld h, e_col_func+1(ix)
    

jp (hl)
    
.globl rendersys_sumarUI
sys_collision_player_with_yesquero::

    call cpct_getRandom_xsp40_u8_asm
    ld a, l
    ld d, #127
    and d
    ld e_y(iy), a

    ld e_x(iy), #70
    call rendersys_sumarUI
    call update_counter
    
ret

sys_collision_player_with_bloq:

    ld a, e_x(iy)
    sub e_x(ix)

    jr c, colidere_bloq

 colizd_bloq:

    ld a, e_x(iy)
    sub e_w(ix)
    add #3

    jr fin_x_bloq

 colidere_bloq:
    
    ld a, e_x(iy)
    add e_w(iy)
    add #3    
 fin_x_bloq:
 
    ld e_x(ix), a

ret

sys_collision_player_with_enemy:
    
    ld a, #00
    ld (f_counter),a
    call man_game_ending
    
ret

sys_collision_player::
    
    ld a, e_type(iy)
    and #e_yesquero ;; 0x40
    cp #e_yesquero
    jp z, _yesquero

    ld a, e_type(iy)
    and #e_bloq ;; 0x10
    cp #e_bloq 
    jp z, _bloq
    
    ld a, e_type(iy)
    and #e_enemy ;; 0x08
    cp #e_enemy
    jp z, _enemy
    
    jp nz, _end_collision

    _bloq:
        call sys_collision_player_with_bloq
        jr _end_collision

    _enemy:
        call sys_collision_player_with_enemy
        jr _end_collision

    _yesquero:
        call sys_collision_player_with_yesquero

    _end_collision:

ret

cmps_collisionable = (e_collisionable)
sys_collision_collider_update:
    
    ld hl, #sys_collision_ix_collider_iy_collisionable
    ld a, #cmps_collisionable
    jp man_entity_forall_matching_iy
    
cmps_collision = (e_collider)
sys_collision_update::

    ld hl, #sys_collision_collider_update
    ld a, #cmps_collision
    jp man_entity_forall_matching

ret

update_counter:
    ld a,(f_counter)
    ld b, #11
    sub b
    jp c, skip2
    ld a, #00
    ld (f_counter),a
    call man_game_win
skip2:
    ld a,(f_counter)
    inc a
    ld (f_counter),a
ret