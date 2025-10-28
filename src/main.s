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
.include "cpctelera.h.s"
.include "cpctelerafunction.h.s"
.include "render_system.h.s"
.include "entity_manager.h.s"
.include "game_manager.h.s"

.include "assets/startscreen_z.h.s"
.include "assets/endingscreen_z.h.s"
.include "assets/winscreen_z.h.s"
;;Main con dos entidades 
;;Player y Enemy
.area _DATA
.area _CODE

.globl _song

.globl _ending
.globl _win

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

_main::

   ;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm
   ld sp, #0x7FFF
   ld l, #0x20
   call cpct_setVideoMemoryPage_asm
   ld c, #0x00
    call cpct_setVideoMode_asm
    ld hl, #_g_palette
    ld de, #16
    call cpct_setPalette_asm
   ld hl, #_startscreen_z_end
   ld de, #0xBFFF
   call cpct_zx7b_decrunch_s_asm 
   jr skip
_ending::
   call cpct_akp_stop_asm
   ld hl, #_endingscreen_z_end
   ld de, #0xBFFF
   call cpct_zx7b_decrunch_s_asm 
   jr skip
_win::
   call cpct_akp_stop_asm
   ld hl, #_g_palette2
    ld de, #16
    call cpct_setPalette_asm
   ld hl, #_winscreen_z_end
   ld de, #0xBFFF
   call cpct_zx7b_decrunch_s_asm 

skip:
   ld hl, #Key_Space
  call presstostart
ld hl, #_g_palette
ld de, #16
call cpct_setPalette_asm

   call man_game_init
   call man_entity_getArray
   ld de, #_song
   call cpct_akp_musicInit_asm

loop:
   ;; Loop forever

   call cpct_akp_musicPlay_asm
   
   call cpct_waitVSYNC_asm
   call man_entity_getArray
   call man_game_update
   ;;call cpct_waitVSYNC_asm
   ;;cpctm_setBorder_asm HW_WHITE
   call man_game_render
   cpctm_setBorder_asm HW_BLUE

   jr    loop