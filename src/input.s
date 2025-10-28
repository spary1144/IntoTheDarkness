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
.include "entity_manager.h.s"

sys_input_init::
ret

sys_input_update::

   ; ld e_vx(ix), #-1
    ld e_vy(ix), #0
        
    call cpct_scanKeyboard_f_asm

    ld hl, #Key_O
    call cpct_isKeyPressed_asm
    jr z, O_NotPressed

O_Pressed:

    ld e_vx(ix), #-2

O_NotPressed:

    ld hl, #Key_P
    call cpct_isKeyPressed_asm
    jr z, P_NotPressed
    
P_Pressed:

    ld e_vx(ix), #2

P_NotPressed:

    ld hl, #Key_Q
    call cpct_isKeyPressed_asm
    jr z, Q_NotPressed

Q_Pressed:

    ld e_vy(ix), #-4

Q_NotPressed:

    ld hl, #Key_A
    call cpct_isKeyPressed_asm
    jr z, A_NotPressed

A_Pressed:

    ld e_vy(ix), #4

A_NotPressed:

    ld hl, #Key_W
    call cpct_isKeyPressed_asm
    jr z, W_Not_Pressed

W_Not_Pressed:

    ld hl, #Joy0_Up
    call cpct_isKeyPressed_asm
    jr z, Joystick_Up_not_Pressed

Joystick_Up:
    
    ld e_vy(ix), #-4

Joystick_Up_not_Pressed:

    ld hl, #Joy0_Down
    call cpct_isKeyPressed_asm
    jr z, Joystick_Down_not_Pressed

Joystick_Down:
    
    ld e_vy(ix), #4

Joystick_Down_not_Pressed:

    ld hl, #Joy0_Left
    call cpct_isKeyPressed_asm
    jr z, Joystick_Left_not_Pressed

Joystick_Left:
    ld e_vx(ix), #-2

Joystick_Left_not_Pressed:

    ld hl, #Joy0_Right
    call cpct_isKeyPressed_asm
    jr z, Joystick_Right_not_Pressed

Joystick_Right:

    ld e_vx(ix), #2

Joystick_Right_not_Pressed:

ret
