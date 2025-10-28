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

screen_width  = 82
screen_height = 142

sys_physics_update::
    ld b, a
    
    _update_loop:

        ld a, #screen_width +1
        sub e_w(ix)
        ld c, a

        ld a, e_x(ix)
        add e_vx(ix)
        cp c
        jr nc, invalid_x

    valid_x:

        ld e_x(ix), a
        jr endif_x

    invalid_x:

        ld e_x(ix), #65
        
    endif_x:

        ld a, #screen_height + 1
        sub e_h(ix)
        ld c, a

        ld a, e_y(ix)
        add e_vy(ix)
        cp c
        jr nc, invalid_y

    valid_y:

        ld e_y(ix), a
        jr endif_y

    invalid_y:

        ld a, e_vy(ix)
        neg
        ld e_vy(ix), a

    endif_y:
    
        dec b
        ret z
        ld de, #sizeof_e
        add ix, de
        jr _update_loop

ret