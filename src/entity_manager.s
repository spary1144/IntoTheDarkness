;;
;; ENTITY MANAGER
;;
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
.include "cpctelerafunction.h.s"
.include "render_system.h.s"
.include "cpctelera.h.s"
.include "game_manager.h.s"

max_entities == 7

_num_entities::  .db 0
_last_elem_ptr:: .dw _entity_array


DefineEntityArray _entity_array, max_entities
last:: .db 0

entityman_getEntityVector_IX::

    ld ix, #_entity_array
    
ret

entityman_getEnemy_IY::

    ld iy, #_entity_array + sizeof_e
    
ret

entityman_get_elements::

    ld ix, #_entity_array + doublesizeof_e

ret

entityman_getPlayerIX_enemyIY::
    call entityman_getEntityVector_IX
    call entityman_getEnemy_IY
ret

entityman_getNumEntities_A::
    ld a, (_num_entities)
ret

man_entity_getArray::
    ld ix, #_entity_array
    ld a, (_num_entities)

ret

man_entity_init::
    xor a
    ld (_num_entities), a
    
    ld hl, #_entity_array
    ld (_last_elem_ptr), hl

ret

man_entity_new::

    ld hl, #_num_entities ;; Incremento el numero de entidades
    inc (hl)
    
    ld hl, (_last_elem_ptr)
    ld d, h
    ld e, l
    ld bc, #sizeof_e ;; cargo una entidad del tamano de una entidad
    add hl, bc
    ld (_last_elem_ptr), hl ;;Lo anado al vector

ret

entityman_create::

    push hl
    call man_entity_new ;;Cargo una nueva entidad al vector

    ld__ixh_d
    ld__ixl_e

    pop hl
    
    ldir 

ret

man_entity_forall::

ld ix, #_entity_array 
    push af
    ld a, (_num_entities)
    ld (_ent_counter_forall), a
    pop af
    
    _check_entity_forall:
        ld c, a
        ld a, e_cmps(ix)
        cp #e_invalid
        ld a, c
        jr z, final_update_forall

        push af
        ld (_function_forall), hl
        _function_forall = . + 1
        call _function_forall
        pop af

    _iterar_forall:
        push af
        _ent_counter_forall = . + 1
        ld a, #_ent_counter_forall
        dec a
        jr z, final_update_pop
        ld (_ent_counter_forall), a
        pop af
        ld de, #sizeof_e
        add ix, de
        jr  _check_entity_forall

    final_update_pop_forall:
        pop af
    final_update_forall:
ret

;; COMPRUEBA QUE UNA ENTIDAD TENGA LAS COMPONENTES INDICADAS EN A

;; PASOS:
;; 1. Guardo la entidad en ix y cargo cmps de ix en b
;; 2. Compruebo si el contenido de b coincide con a (CMPS a comprobar)
;; 3. Si coinciden lanzo la funcion, else salto a la siguiente entidad

;; Comentario: Este man_entity_forall_matching es un poco cutre. Hay que llevar cuidado con lo que haces con "a"
;; en la función a la que llames para esta entidad, ya que se modifica y puedes perder el tipo de entidad que quieres que ejecute
;; el man_entity_forall_matching. Para ello se usa el Push Pop antes de la llamada a la función

;; Coment: The following man_entity_forall_matching could be better implemented. You must take care what you're doing with "a"
;; while executing the desired function to be called, as it modifies "a" and the type of entity you want to execute man_entity_forall_matching can be lost
;; Thus Push Pop is used in the call of the function

man_entity_forall_matching::
    ld ix, #_entity_array 
    push af
    ld a, (_num_entities)
    ld (_ent_counter), a
    pop af
    
    _check_entity:
        ld c, a
        ld a, e_cmps(ix)
        cp #e_invalid
        ld a, c
        jr z, final_update
        ;;Llevar cuidado con el orden de las entidades
        ;; Si una entidad se queda invalida por en medio del array de entidades esto puede dejar de funcionar
        ;; Si se da el caso cambiar el jr z, final_update por jr z, _iterar
        ;;Comprobar si la entidad tiene los bits que llegan en registro a

        ld d, a
        and a, e_cmps(ix)
        cp d
        ld a, d
        jr nz, _iterar

        push af
        push hl
        ld (_function), hl
        _function = . + 1
        call _function
        pop hl
        pop af

    _iterar:
        push af
        _ent_counter = . + 1
        ld a, #_ent_counter
        dec a
        jr z, final_update_pop
        ld (_ent_counter), a
        pop af
        ld de, #sizeof_e
        add ix, de
        jr  _check_entity

    final_update_pop:
        pop af
    final_update:
   
ret

man_entity_forall_matching_iy::
    ld iy, #_entity_array

    push af
    ld a, (_num_entities)
    ld (_ent_counter_iy), a
    pop af

    _check_entity_iy:
        ld c, a
        ld a, e_cmps(iy)
        cp #e_invalid
        ld a, c
        jr z, final_update_iy
        
        ;;Comprobar si la entidad tiene los bits que llegan en registro a
        ld d, a
        and a, e_cmps(iy)
        
        cp d
        ld a, d
        jr nz, iterar_iy

        push af
        push hl
        ld (_funcion), hl
        _funcion = . + 1
        call _funcion
        pop hl
        pop af
        
        ;;saltar sizeof_e para llegar a la siguiente entidad
        
    iterar_iy:
    
        push af
        _ent_counter_iy = . + 1
        ld a, #_ent_counter_iy
        dec a
        jr z, final_update_pop_iy
        ld (_ent_counter_iy), a
        pop af
        ld de, #sizeof_e
        add iy, de 
        jr  _check_entity_iy

    final_update_pop_iy:
        pop af
    final_update_iy:
ret