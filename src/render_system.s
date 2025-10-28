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
;; RENDER SYSTEM
;; El raster es PARALELO por lo que nada lo para. Eso genera los errores de render. Vsync nos hace esperar.include
;; no obstante un ciclo de ejecucion puede tardar menos que un vsync por eso nos daran errores como la linterna (aprox 20 veces puede hacer cosas por vsync)
;; pintar con mascara sera mucho, mucho mas lento + borrado
;;para saber si el raster nos "pilla" podemos toquetear el borde y sus colores
.include "cpctelerafunction.h.s"
.include "entity_manager.h.s"
.include "cpctelera.h.s"
.include "render_system.h.s"
.include "assets/background_z.h.s"
;; C400,  XX 11 00 10 00000000
;; registro, XX C000,  10 (2,x2 =4) C4   000000

;;El doble buffer lo que hace es dibujar en otra zona de memoria como pantalla junto a la zona normal
;;cada iteracion modificamos R12 y R13 que son los punteros a inicio y fin de mem video y los vamos cambiando entre estas dos pantallas
;; basicamente es cambiar entre 2 pantallas cada frame y funciona asi en cualquier maquina

f_offset:: .db 00
f_contador:: .db 8


rendersys_init::

    ;;render BACKGROUND
    ;;copiamos directamente en memoria cambia HL (origen), DE (destino), BC (bytes a cambiar) (320 PIXELES x200 lineas) (16384)

    ;; HL FIN DE FUENTE
;; DE FIN DE ARCHIVO
    ld hl, #_background_z_end
    ld de, #0xBFFF
    call cpct_zx7b_decrunch_s_asm 
;; HL FIN DE FUENTE
;; DE FIN DE ARCHIVO
    ld hl, #_background_z_end
    ld de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm 
    
    ld hl, #rendersys_update_first
    ld (_render_function_ptr),hl
    
    ;;esto consume muchisima memoria a si que en el update/loop no se puede usar
    ;;ld hl, #_pal_main
    ;;ld de, #16
    ;;call cpct_setPalette_asm
    ;;call cpctm_setBorder_asm
ret

_pintarlinterna:
    ld a, e_lantr(ix)
    dec a
    jr z, encendida

    ld a, #0xFF
    call pintarcubo

    ret
    encendida:
    ld a, #0x0F
    call pintarcubo
    ret

;;Llega en A el color
pintarcubo:
    ld c, e_w(ix)
    ld b, e_h(ix)
    call cpct_drawSolidBox_asm
ret


;;INPUT 
;; IX PUNTERO A LA PRIMERA ENTIDAD
;; A NUMERO DE ENTIDADES A RENDERIZAR
rendersys_chose_update::
_render_function_ptr = .+1
    call rendersys_update_first
ret


rendersys_update:: ;; scroll por hardware + pintar fila de pixeles + borrar y pintar pintando encima con 4 de fondo y 3 de arriba redefininedo la paleta
_renloop:
    push af  
    ;;BORRADO DEL FRAME de la OTRA pantalla
    ld e, e_prevptr2+0(ix)
    ld d, e_prevptr2+1(ix)
    ld l, e_animptr+0(ix)
    ld h, e_animptr+1(ix)
    ld c, e_h(ix)
    ld b, e_w(ix)
    push bc
    call cpct_drawSpriteBlended_asm
    
back_buffer = .+1 ;;memdir donde guardamos el numero de memoria, +2 porque es little endian y queremos cambiar solo la parte de CO a 80
    ld de, #0xC230;; ES DECIR aqui decimos,  ld DE, 00 BACK_BUFFER
    ld c, e_x(ix)
    ld b, e_y(ix)
        
    call cpct_getScreenPtr_asm
    
    ;;leo el puntero del fotograma anterior y lo pasamos al de hace 2 conforme dibujamos (guardamos el puntero como fotograma anterior)
    ld a, e_prevptr(ix)
    ld e_prevptr2(ix), a
    ld a, e_prevptr+1(ix)
    ld e_prevptr2+1(ix), a


    ;; guardamos el puntero actual en el fotograma anterior
    ld e_prevptr+0(ix), l
    ld e_prevptr+1(ix), h
    ex de,hl
    pop bc
    ld l, e_sprite+0(ix)
    ld h, e_sprite+1(ix)
    call cpct_drawSpriteBlended_asm
    
   
    pop af

    dec a 
    ret z
    ld bc, #sizeof_e
    add ix, bc
    jr _renloop
ret


rendersys_update_first::
_renloop2:
    push af
    ld de, #0x8000
    ld c, e_x(ix)
    ld b, e_y(ix)
        
    call cpct_getScreenPtr_asm
    
    
    ld e_prevptr+0(ix), l
    ld e_prevptr+1(ix), h
    ex de,hl
    ld l, e_sprite+0(ix)
    ld h, e_sprite+1(ix)
    ld c, e_h(ix)
    ld b, e_w(ix)
    call cpct_drawSpriteBlended_asm
    
    ld de, #0xC000
    ld c, e_x(ix)
    ld b, e_y(ix)
        
    call cpct_getScreenPtr_asm
    
    
    ld e_prevptr2+0(ix), l
    ld e_prevptr2+1(ix), h
    ex de,hl
    ld l, e_prevsprite+0(ix)
    ld h, e_prevsprite+1(ix)
    ld c, e_h(ix)
    ld b, e_w(ix)
    call cpct_drawSpriteBlended_asm
    pop af

    dec a 
    jr z, _change_to_no_first
    ld bc, #sizeof_e
    add ix, bc
    jr _renloop2

_change_to_no_first:
    ld hl, #rendersys_update
    ld (_render_function_ptr), hl
ret


rendersys_change_screen::
    ld a,(f_offset)
    ld b, #0x28
    sub b
    jp c, not_end
    ld a, #00
    ld (f_offset), a ;;enviar a changescreen no a not end
    jp skip;
not_end:
    ld a,(f_offset)
    inc a
    ld (f_offset), a
skip:
f_change_screen = .+1
    jp change_screen_toC000 ;;usamos jp porque al compilar hay una diferencia porque vienen 2 bytes detras a donde queremos saltar
                            ;;esto nos aporta utilidad porque con 2 bytes en vez de 1
ret

change_screen_to8000::;Al final esto cambia a C000 y el otro a 8000 pero no queria marear mucho y cambiarle los nombres por si las moscas
    ld l, #0x30
    call cpct_setVideoMemoryPage_asm ;; ahora mostramos de 8000 -> BFFF
    
    ld a, (f_offset)
    ld l, a
    call cpct_setVideoMemoryOffset_asm
    push hl
     ld hl, #0x8230 ;; cambiamos el dibujado a fuera de la pantalla, a 40(00)
    ld a,(f_offset)
    ld b, a
    add a, b
    add a, l
    ld l,a
    ld (back_buffer), hl

    ld hl, #change_screen_toC000
    ld (f_change_screen),hl ;; metemos en f_change la direccion a la que apunta JP para que salte, y viceversa
    pop hl

    
ret

change_screen_toC000:: 
    ;ld b, #0b11000000 ;;cambiamos registro 12 (C), cambiamos un 2 (10, 8000) y un 0 (00)
    ;ld c, #12 ;;cambiamos registro 12 (C), cambiamos un 2 (10, 8000) y un 0 (00)
    ld l, #0x20
    call cpct_setVideoMemoryPage_asm ;; ahora mostramos de C000 -> nosequeFFFF

    ld a, (f_offset)
    ld l, a
    call cpct_setVideoMemoryOffset_asm
  
    ld hl, #0xC230 ;; cambiamos el dibujado a fuera de la pantalla, a 40(00)
    ld a,(f_offset)
    ld b, a
    add a, b
    add a, l
    ld l,a
    ld (back_buffer), hl
    
    ld hl, #change_screen_to8000
    ld (f_change_screen),hl ;; metemos en f_change la direccion a la que apunta JP para que salte, y viceversa

ret

    cmps_UI = (e_UI)
rendersys_UI::

    ld hl, #update_UI
    ld a, #cmps_UI
    jp man_entity_forall_matching
ret

update_UI: ;;usaremos LINTERNA como contador de la UI para dibujar pixelencios y eso    
    ld de, (back_buffer)
    ld c, #6
    ld b, #155 ;;y
    call cpct_getScreenPtr_asm
    ;
    ex de, hl
    ld a, #0x00 ;;en nuestra paleta, color algo
    ld c, e_lantr(ix)
    ld b, #0x05
    call cpct_drawSolidBox_asm
    
    ld de, (back_buffer)
    ld c, #10
    ld b, #155 ;;y
    call cpct_getScreenPtr_asm
    
    ld a, e_lantr(ix)
    ld b, #02
    sub b
    jp c, lantern_empty
    ;;si no esta vacia
    ex de, hl
    ld a, #0x0F ;;en nuestra paleta, color algo
    ld c, e_lantr(ix)
    ld b, #0x05
    call cpct_drawSolidBox_asm
    jp skip5
lantern_empty:
    ex de, hl
    ld a, #0x00 ;;en nuestra paleta, color algo
    ld c, e_lantr(ix)
    ld b, #0x05
    call cpct_drawSolidBox_asm
    ;;FALTA COMPROBAR SI LANTR ES 0 Y SI ES ASI PINTAR EN NEGRO
skip5:
ret

rendersys_sumarUI::
    ld hl, #sumarUI
    ld a, #cmps_UI
    jp man_entity_forall_matching
ret

sumarUI:
    ld a, e_lantr(ix)
    ld b, #05
    add a,b ;; sumamos a la barra un incremento
    ld c, a ;; guardamos en C a por si aca
    ld b, #14
    sub b
    jp c, less_14 ;; si el incremento es < 14
    ld a, #14   ;;si es >14
    ld e_lantr(ix), a ;; lo dejamos en max value
    jp skip2;
less_14:
    ld a, c ;; si es <14, metemos lo sumado en a 
    ld e_lantr(ix), a
skip2:
ret




rendersys_restarUI: ;;igual pero restando, sabes?
    ld a, e_lantr(ix)
    ld b, #02
    sub b
    jp c, less_1
    ld a, e_lantr(ix)
    dec a
    ld e_lantr(ix), a
    call entityman_getEntityVector_IX
    ld e_vx(ix), #-1
    jp skip3
less_1:
    ld a, #01
    ld e_lantr(ix), a

    call entityman_getEntityVector_IX
    ld e_vx(ix), #-3
skip3:
ret

rendersys_loopRestar::
    ld a,(f_contador)
    ld b, #0x04
    sub b
    jp c, not_end2
    ld a, #01
    ld (f_contador), a ;;enviar a changescreen no a not end
    
    ld hl, #rendersys_restarUI
    ld a, #cmps_UI
    jp man_entity_forall_matching
    jp skip4

not_end2:
    ld a,(f_contador)
    inc a
    ld (f_contador), a
skip4:

ret