;;;
;; ANIMATION MANAGER
;;;
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
;; tenemos un vector de punteros con las animaciones + indicar que acaba con un nullptr + referencia inicio

.include "render_system.h.s"
.include "entity_manager.h.s"

nullptr = 0x0000

cmps_animation = (e_animation)
animationsys_update::
ld hl, #foreach_update
ld a, #cmps_animation
jp man_entity_forall_matching


foreach_update:
    push hl
    ld l, e_sprite(ix) ;; 3
    ld h, e_sprite+1(ix) ;; 3
    ld e, e_prevsprite(ix) ;; 2
    ld d, e_prevsprite+1(ix) ;; 2
    ld b, e_animptr(ix) ;; 1
    ld c, e_animptr+1(ix) ;; 1

    ld e_sprite(ix), b ;; 3 copiamos 1
    ld e_sprite+1(ix), c
    ld e_prevsprite(ix), l ;; 2 copiamos 3
    ld e_prevsprite+1(ix), h
    ld e_animptr(ix), e ;; 1 copiamos 2
    ld e_animptr+1(ix), d
    pop hl
;;    ld l, e_animptr+0(ix)
;;    ld h, e_animptr+1(ix) ;; DE punter a animacion de donde esta el jugador
;;_reset: 
;;    ld c, (hl) ;; 
;;    inc hl
;;    ld b, (hl) ;;
;;    inc hl ;; hl ---> next sprite
;;    
;;
;;    ld a, c             ;; si bc nullptr, reseteamos
;;    cp #0
;;    jr z, _resetanimation
;;
;;    ;;si bc gucci, copiamos
;;    ld e_animptr(ix),l
;;    ld e_animptr+1(ix),h
;;
;;    ld l, e_sprite(ix)
;;    ld h, e_sprite+1(ix)
;;
;;    ld e_prevsprite(ix), l
;;    ld e_prevsprite+1(ix), h
;;
;;    ld e_sprite(ix), c
;;    ld e_sprite+1(ix), b
;;   
;;
;;    ld l, e_sprite(ix)
;;    ld h, e_sprite+1(ix)
;;
;;    ld e_prevsprite(ix), l
;;    ld e_prevsprite+1(ix), h
;;    jr _end
;;
;;_resetanimation:
;;    ld a, (hl)
;;    inc hl
;;    ld h,(hl)
;;    ld l, a
;;    jr _reset 
;;_end:
ret

