;-----------------------------------------------------------------------
; Programa TSR que se instala en el vector de interrupciones 80h
; que suma AX a BX a traves de la int 80h
; Se debe generar el ejecutable .COM con los siguientes comandos:
;	tasm tsr2.asm
;	tlink /t tsr2.obj
;-----------------------------------------------------------------------
.8086
.model tiny		; Definicion para generar un archivo .COM
                ;Tiene todos los segmentos apuntados al mismo lugar, del mismo tamanio
.code
   org 100h		; Definicion para generar un archivo .COM
                ;.COM = Archivo instalable del sistema
start:
   jmp main		; Comienza con un salto para dejar la parte residente primero

;-------------------------------------------------------------------------
;- Part que queda residente en memoria y contine las ISR
;- de las interrupcion capturadas
;-------------------------------------------------------------------------
;   ACA PROGRAMAMOS NOSOTROS
;-------------------------------------------------------------------------
Funcion PROC FAR ;por que esta en otro lado, por eso FAR
   ; La funcion ISR que atendera la interrupcion capturada
    ;Pushear CX y DX antes de llamar a la INT
    ;devuelve en AL un numero aleatorio entre el 0 y el 9
    sti
    mov ah, 2ch
    int 21h
    xor ax, ax
    mov al, dl
    mov cl, 0ah
    div cl
    xor ah, ah
    iret
endp

; Datos usados dentro de la ISR ya que no hay DS dentro de una ISR
DespIntXX dw 0
SegIntXX  dw 0

FinResidente LABEL BYTE		; Marca el fin de la porción a dejar residente
;------------------------------------------------------------------------
; Datos a ser usados por el Instalador
;------------------------------------------------------------------------
Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'

main:
; Se apunta todos los registros de segmentos al mismo lugar CS.
    mov ax,CS
    mov DS,ax
    mov ES,ax

InstalarInt:
    mov AX,3584h        ; Obtiene la ISR (direccion) que esta instalada en la interrupcion
                        ; Servicio 35, interrupcion 80 (a visitar)
    int 21h    
    
    ;Para la desinstalacion
    mov DespIntXX,BX ;IP (desplazamiento desde donde esta ubicada)
    mov SegIntXX,ES  ;CS (segmento)

    mov AX,2584h	; Coloca la nueva ISR en el vector de interrupciones
                    ; Servicio 25, interrupcion 80 (a cambiar) con el CS:IP guardados
    mov DX,Offset Funcion 
    int 21h 

MostrarCartel:
    mov dx, offset Cartel
    mov ah,9
    int 21h
;Permanencia del programa en memoria
DejarResidente:		
    Mov     AX,(15+offset FinResidente) ;1 parrafo: 16 bytes
    Shr     AX,1        ;shift right
    Shr     AX,1        ;Se obtiene la cantidad de paragraphs
    Shr     AX,1
    Shr     AX,1	;ocupado por el codigo
    Mov     DX,AX       ;guarda el valor shifteado en DX, por que el servicio 31 necesita en DX los parrafos a bloquear
    Mov     AX,3100h    ;y termina sin error 0, dejando el
    Int     21h         ;programa residente
end start