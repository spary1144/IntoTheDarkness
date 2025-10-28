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

.include "entity_manager.h.s"
.include "cpctelera.h.s"
.include "cpctelerafunction.h.s"
    
sys_ai_init::
    call entityman_getEntityVector_IX
    ld (_ent_array_ptr_temp_standby), ix
    ld (_ent_array_ptr), ix

ret

sys_ai_stand_by::

_ent_array_ptr_temp_standby = .+2
    ld iy, #0x0000

    ld a, e_ai_aim_x(iy)
    or a
    ret z
    
    ;; MOVE TO PLAYER
    ;; cargo posicion delplayer en target de enemy    
    ld a, e_x(iy)
    ld e_ai_aim_x(ix), a
    ld a, e_y(iy)
    ld e_ai_aim_y(ix), a
    ld e_ai_st(ix), #e_ai_st_move_to

ret

sys_ai_move_to::

    ;;ld e_vy(ix), #0
    ld a, e_ai_aim_x(ix) ;; A = x_obj
    sub e_x(ix)
    jr nc, _objx_greater_or_equal

_objx_lesser:

    ld e_vx(ix), #0
    jr _endif_x

_objx_greater_or_equal:

    jr z, _arrived_x
    ld e_vx(ix), #0
    jr _endif_x

_arrived_x:

    ld e_vx(ix), #0

_endif_x:

    ld a, e_ai_aim_y(ix) ;; A = y_obj
    sub e_y(ix)
    jr nc, _objy_greater_or_equal

_objy_lesser:

    ld e_vy(ix), #-2
    jr _endif_y

_objy_greater_or_equal:

    jr z, _arrived_y
    ld e_vy(ix), #2
    jr _endif_y

_arrived_y:

    ld e_vy(ix), #0
    ld a, e_vx(ix)
    or a
    jr nz, _endif_y

        ld e_ai_st(ix), #e_ai_st_stand_by 

_endif_y:

ret

sys_ai_update::
    ld (_ent_counter), a

_ent_array_ptr = . + 2
    ld ix, #0x0000
_loop: 

    ld a, e_ai_st(ix) 
    cp #e_ai_st_noAI
    jr z, _no_AI_ent

_AI_ent:   

    cp #e_ai_st_stand_by
    call z, sys_ai_stand_by
    cp #e_ai_st_move_to
    call z, sys_ai_move_to
    ;;cp #e_ai_st_escape
    ;;call z, sys_ai_escape

_no_AI_ent:

_ent_counter = . + 1
    ld a, #0
    dec a 
    ret z
    ld (_ent_counter), a

    ld de, #sizeof_e
    add ix, de 
    jr _loop
