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
;;  CABECERA DE LAS FUNCIONES DE RENDERSYS
;;
.globl rendersys_init
.globl rendersys_update
.globl rendersys_update_first
.globl rendersys_chose_update
.globl rendersys_change_screen
.globl change_screen_to8000
.globl change_screen_toC000
.globl rendersys_UI
.globl rendersys_sumarUI
.globl rendersys_loopRestar
;;-----------------------------
;;SPRITES
;;
.globl _sp_e_2_2
.globl _sp_e_2_1
.globl _sp_e_2_0
.globl _sp_e_2
.globl _sp_e_1
.globl _sp_e_0
.globl _sp_char_2
.globl _sp_char_1
.globl _sp_char_0

.globl _barra
.globl _g_palette

.globl _g_palette2
.globl _tronco
.globl _yesquero