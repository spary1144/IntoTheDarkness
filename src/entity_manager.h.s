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
;;
;;CABECERA DE ENTITYMANAGER
;;
.globl entityman_getEntityVector_IX
.globl entityman_getNumEntities_A
.globl entityman_getPlayerIX_enemyIY
.globl man_entity_getArray
.globl entityman_create
.globl man_entity_new
.globl man_entity_init
.globl man_entity_forall
.globl man_entity_forall_matching
.globl man_entity_forall_matching_iy
.globl entityman_get_elements

;;Macro creacion de entidades
.macro DefineEntityAnnonimous _cmps, _x, _y, _vx, _vy, _w, _h,_animationptr,_prevsprite, _sprite, _prevptr,_prevptr2, _lantern, _aimx, _aist, _colfunc, _type

   .db _cmps
   .db _x
   .db _y
   .db _vx
   .db _vy
   .db _w
   .db _h
   .dw _animationptr
   .dw _prevsprite
   .dw _sprite
   .dw _prevptr
   .dw _prevptr2
   .db _lantern
   .db _aimx, 0x00
   .db _aist
   .dw _colfunc
   .db _type

.endm

.macro DefineEntity _name, _cmps, _x, _y, _vx, _vy, _w, _h,_animationptr,_prevsprite, _sprite, _prevptr, _prevptr2, _lantern, _aimx, _aist, _colfunc, _type
    _name::
        DefineEntityAnnonimous _cmps, _x, _y, _vx, _vy, _w, _h,_animationptr,_prevsprite, _sprite, _prevptr, _prevptr2, _lantern, _aimx, _aist, _colfunc, _type

.endm

.macro DefineEntityArray _name, _N
    _name::
        .rept _N
            DefineEntityAnnonimous 0xDE, 0xAD, 0xDE, 0xAD,0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD,0xDE, 0xAD, 0xDE, 0xAD, 0xAA
        .endm
.endm

e_cmps       = 0
e_x          = 1
e_y          = 2
e_vx         = 3
e_vy         = 4
e_w          = 5
e_h          = 6
e_animptr    = 7
e_prevsprite = 9
e_sprite     = 11
e_prevptr    = 13
e_prevptr2   = 15
e_lantr      = 17
e_ai_aim_x   = 18
e_ai_aim_y   = 19
e_ai_st      = 20
e_col_func   = 21
e_type       = 23
sizeof_e     = 24

doublesizeof_e = 48

;; SISTEMAS DE IA QUE PUEDE TENER UNA ENTIDAD

e_ai_st_noAI     = 0
e_ai_st_stand_by = 1
e_ai_st_move_to  = 2
e_ai_st_escape   = 3

;; TIPOS DE CMPS QUE PUEDE TENER UNA ENTIDAD
e_invalid       = 0x00
e_alive         = 0x80
e_collider      = 0x10 
e_collisionable = 0x08
e_recollectable = 0x02
e_animation     = 0x01
e_UI            = 0xC0
e_physics       = 0x20

;; TIPOS DE ENTIDADES

e_player        = 0x80
e_yesquero      = 0x40
e_bloq          = 0x10
e_enemy         = 0x08
e_destructor    = 0x02