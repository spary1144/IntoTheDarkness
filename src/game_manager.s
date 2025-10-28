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
.include "render_system.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "animation_manager.h.s"
.include "ia_manager.h.s"
.include "collision.h.s"
.include "cpctelera.h.s"
.include "cpctelerafunction.h.s"
.include "assets/endingscreen_z.h.s"
.include "assets/winscreen_z.h.s"
.include "assets/startscreen_z.h.s"

;;_x, _y, _vx, _vy, _w bytes, _h pixels, _color, _prevptr, _lantern

;;e_invalid       = 0x00
;;e_alive         = 0x80
;;e_render        = 0x40
;;e_physics       = 0x20
;;e_collider      = 0x10 
;;e_collisionable = 0x08
;;e_animable      = 0x01


;;e_player        = 0x80
;;e_yesquero      = 0x40
;;e_bloq          = 0x10
;;e_enemy         = 0x08

e_cmp_player    = (e_collider      | e_animation | e_physics)
e_cmp_enemy     = (e_collisionable | e_animation | e_physics)
e_cmp_log       = (e_collisionable | e_physics)
e_cmp_yesqueros = (e_collisionable | e_physics)
e_cmp_UI        = (e_UI)

DefineEntity player,   e_cmp_player, 50,  50,  -1, 0,  16,  32, _sp_char_0, _sp_char_1, _sp_char_2 , 0x8000, 0x8000,  0, 1, e_ai_st_noAI,     sys_collision_player , e_player
DefineEntity enemy,    e_cmp_enemy,   5,  20,   0, 0,  16,  32, _sp_e_2_0   , _sp_e_2_1   , _sp_e_2_2    , 0x8000, 0x8000,  0, 0, e_ai_st_move_to,  0x0000               , e_enemy
DefineEntity bloc ,    e_cmp_log,    30,  30,  -1, 0,   4,  24, _tronco   , _tronco   , _tronco    , 0xC000, 0xC000,  0, 0, e_ai_st_noAI,     0x0000               , e_bloq
DefineEntity bloc2,    e_cmp_log,    50,  90,  -1, 0,   4,  24, _tronco   , _tronco   , _tronco    , 0xC000, 0xC000,  0, 0, e_ai_st_noAI,     0x0000               , e_bloq
DefineEntity yesquero, e_cmp_log,    20,  50,  -1, 0,   4,  14, _yesquero , _yesquero , _yesquero  , 0xC000, 0xC000,  0, 0, e_ai_st_noAI,     0x0000               , e_yesquero
DefineEntity barra,     e_cmp_UI,     5, 152,   0, 0,  20,  10, _barra    , _barra    , _barra     , 0xC000, 0xC000, 14, 0, e_ai_st_noAI,     0x0000               , e_yesquero

man_game_init::
    
    call sys_ai_init
    call man_entity_init

    call rendersys_init
    
    ld hl, #player
    call entityman_create
    
    ld hl, #enemy
    call entityman_create
    
    ld hl, #bloc
    call entityman_create

    ld hl, #bloc2
    call entityman_create
    
    ld hl, #yesquero
    call entityman_create
    
    ld hl, #barra
    call entityman_create

ret

man_game_update::


    call entityman_getEntityVector_IX
    call sys_input_update

    call man_entity_getArray
    call sys_ai_update
    ;;cpctm_setBorder_asm HW_WHITE
    call man_entity_getArray
    call sys_physics_update
    ;;cpctm_setBorder_asm HW_BLUE
    call sys_collision_update
   
ret

man_game_render::
    ;;cpctm_setBorder_asm FW_BLACK

    call rendersys_UI
    call man_entity_getArray
    call rendersys_chose_update
    call rendersys_change_screen

    call animationsys_update
    call rendersys_loopRestar
    ;;cpctm_setBorder_asm HW_WHITE ;;para saber cuanto tarda en dibujar entidades
ret
.globl _ending
man_game_ending::
    call cpct_akp_stop_asm

    ld l, #0x20
   call cpct_setVideoMemoryPage_asm
   ld l, #0x00
    call cpct_setVideoMemoryOffset_asm
   call _ending
ret 
.globl _win
man_game_win::
   ld l, #0x20
   call cpct_setVideoMemoryPage_asm
   ld l, #0x00
    call cpct_setVideoMemoryOffset_asm
   call _win
ret

;;mangame inicio a lo mejor?


presstostart:

   push hl
   call cpct_scanKeyboard_f_asm
   pop hl
   push hl
   call cpct_isKeyPressed_asm
   pop hl
   jr nz, presstostart

loop2:

   push hl
   call cpct_scanKeyboard_f_asm
   pop hl
   push hl
   call cpct_isKeyPressed_asm
   pop hl
   jr z, loop2

ret