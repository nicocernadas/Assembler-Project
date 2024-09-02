.8086
.model small
.stack 100h
.data
;Cosas que arreglar:
		;LISTO--; si disparas cuando hay una bala en movimiento y te moves, mueve la bala ya existente
		;LISTO--; que se fije los colores y cada enemigo sume diferente
		;LISTO--; hacer efectos de sonido(cuando todas w hace el sonido entonces si lo tocas mucho esta mal)
  		;LISTO--; si tocas disparar muchas veces se bugea y no te deja mas
  		;LISTO--; que las opciones de YOU WIN funcionen
  		;LISTO--; que si te tocan los enemigos pierdas o si llegan al final (line 1639)
  		;LISTO--; pantallas piolas
		;LISTO--; que sea mas rapido cada nivel(menos retardos)
  		;LISTO--; que el score y highscore terminen de cuadrar, porque es medio raro, ej: no se suman al simultaneo, el highscore solo se actualiza cuando termina el nivel, el score cuando comienza un nuevo nivel esta en 0000 pero matas a alguien y salta a 0370 ponele
		;LISTO--; el enemigo secreto (aparece y se va, NO determinantre para que gane el jugador)
  		;LISTO--; se va el pibe y creo que no se puede solucinar porque se mueve cada 2 y el pibe mide 3 ▄█▄ (si hay manera pero me da paja)
  	 ;ANULADO--; poner musica de fondo(horrible)
		;LISTO--; arreglar los 99999
		;LISTO--; arreglar el flickering
		;LISTO--; hacer la int con random para el disparo del boss fijate de hacer las interrupciones que las llames con cosas diferentes no las dos con 80 y fijate de sacar el sonido en las pantallas de boss eso y hace que la musica sea un poco mas rapida, tipo acelerala si podes
		;LISTO--;arregla las pantallas, que no se pueda esc en el boss(que no te deje salir y volver a empezar como en el video que mande), tambien tenes que crear una pantalla tipo gameOverboss que sea igual solo que no este el texto blanco que te ponga esc y space tambien arregla animacion de muerte que ahora termina con J por algun motivo, y poner las pantallas de winBoss que seria la corona rota y sin el space y esc o tipo 	--> 5r€e§ τª# bµ3+º ? [space]    solo eso y la corona arriba posicionar_bala_de_BOSS asi
		;LISTO--; arreglar lo de las pantallas
		;LISTO--; hacerle una interrupcion
 		;LISTO--; que dispare el boss
		;ANULADO--; que se ria re cursed(el que lo tenia que hacer no lo hizo)
		;LISTO--; que no se siga moviento el pj cuando soltas la tecla

;-------------------
; NOTAS:
; tp hecho por : Correa Catalina, Andres Maximiliano, Cossettini Reyes Dana y Cernadas Nicolas

;-------------------fabrica de enemigos
; ▀ █ ▄

;   ▄█▄█▄
;   █▄█▄█
;    ▀ ▀

;   ▄█▄█▄
; █▄█▄█▄█▄█
; ▄█ ▀ ▀ █▄

;     ▄ ▄ ▄
;   ▄█▀█▀█▀█▄
;  ▄███▄█▄███▄
; ▀ ▄▀ ▀ ▀ ▀▄ ▀

;          ██  ██  ██
;        ██████████████
;      ████  ██  ██  ████
;      ██████  ██  ██████
;    ██████████████████████
;  ██    ██  ██  ██  ██    ██
;      ██              ██

;-------------------fabrica de naves

;  ▄█▄

;------------------- WIN
;	▄   █   ▄
;	██▄███▄██
;	█████████

;  ▄   █   ▄
;	 ██▄███▄██
;  █████▄███

;219 █ es el rectanculo , 220 ▄ es el cuadrado abajo , 223 ▀ es el cuadrado arriba
;-------------------------------------------
;Variables de JUGADOR
	columna_Jugador db 38  ;eje x
	renglon_Jugador db 23  ;eje y
   vida_jugador db 3
;-------------------------------------------
;Variables de Enemigos

	columnas_Enemigos db 0,11,22,33,44,55,0,11,22,33,44,55,0,11,22,33,44,55

	renglones_Enemigos db 3,3,3,3,3,3,8,8,8,8,8,8,13,13,13,13,13,13

	colores_Enemigos db 2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4

;-------------------------------------------
;Variables de Enemigo SECRETO (que miedo)
	columna_Enemigo_SECRETO db 0
	renglon_Enemigo_SECRETO db 3
	color_Enemigo_SECRETO db 5 ;(magenta)
	flag_movimiento_SECRETO db 0
	contador_de_desplazamiento_SECRETO dw 0
;-------------------------------------------
;Variables de FINAL BOSS (que PUTO MIEDO) [mide 26 columnas y 7 renglones]
	columna_BOSS db 27
	renglon_BOSS db 0
	color_BOSS db 0fh ;(BLANCO)
	flag_movimiento_BOSS db 0
	vida_BOSS db 28 ; o
	contador_de_desplazamiento_BOSS dw 0

	col_bala_BOSS db 0
	reng_bala_BOSS db 0
	bala_BOSS db 33 ;ascii de la bala
	flag_bala_BOSS db 0
;-------------------------------------------
;Variables de bala
	col_bala db 0
	reng_bala db 22
	bala db 173 ;ascii de la bala
	flag_bala db 0
;-------------------------------------------
;Variables generales
	flag_movimiento db 0
	contador_de_desplazamiento db 0
	enemigos_masacrados db 0
	nivel_de_dificultad db 0  ;Cambiar este numero en funcion del nivel que queres proabar sino en "0" siempre los niveles que hay son (0,1,2,3) y despues el jefe
	nivel_de_dificultad_BOSS db -1
	CurrentKey db 0
;-------------------------------------------
;Variables de puntaje
	textoScore db "SCORE:",24h
	textoHighscore db "  HIGHSCORE: ",24h
	textoHighscoreWin db "  H1+4>C()8e: ",24h
	scoreAscii db "0000",24h
	highscoreAscii db "0000",24h
	scoreFINAL_BOSS db 255 dup (24h),24h
	score db 0
	scoreBOSS db 0
	highscore db 0
	dataDiv db 100,10,1
;-------------------------------------------
;Pantalla de Game_Loop
	bienvenida db "Bienvenidos!",24h
	bienvenida2 db "Presiona cualquier tecla para continuar",24h
	pantallaGame_Loop db "PLAY",0dh,0ah,0dh,0ah
					db 09h,09h,09h,"        SPACE INVADERS",0dh,0ah,0dh,0ah
					db 09h,09h,09h,"      TABLA  DE PUNTAJES",0dh,0ah
					db 09h,09h,09h,09h,"   = ?",0dh,0ah
					db 09h,09h,09h,09h,"   = 30 PUNTOS",0dh,0ah
					db 09h,09h,09h,09h,"   = 20 PUNTOS",0dh,0ah
					db 09h,09h,09h,09h,"   = 10 PUNTOS",0dh,0ah,24h
;-------------------------------------------
;Pantalla de Fin
	finJuegoMensaje db "YOU  WIN!!",0dh,0ah,0dh,0ah
			db 09h,09h,09h,"     Desea seguir jugando?",0dh,0ah
			db 09h,09h,09h,"         Press [Space]",24h
	finJuegoMensaje2 db  " Press [Esc] to Exit ",24h
	finJuegoRetry db " RETRY [Space] ",24h
	VolverAJugarText db " VOLVER A JUGAR [Space] ",24h
	GameOverText db " GAME OVER ",24h
	GameWin db " G4Μ/ 0Ü4R ",24h
	GameOverText2 db " JA1AJ1AJAJJAJ0J10JAJ10 ",24h
	ERRORText db "S4%HA]1F0#&%#=(R%gJkWS$|",24h
	finJuegoMensajeBOSS db "¥0 W?Π!!",24h
	finJuegoMensajeBOSS2 db  " P'?#s [?] +o 6!t¿",24h
;-------------------------------------------
;Pantallas BOSS
	texto1 db "T∑ 5r€e§ τ#n b^3+º? ",24h
	texto2 db "!π5€π¢¡E? jª!ªjA ",24h
	texto3 db ")=π¢!e[√!€¡ ",24h
	texto4 db 229,244,20h,24h
	texto5 db "... ",24h
	texto6 db 244,"º 4&#e. ",24h
	texto7 db "∑ ª#J€. ",24h

.code

;----------------------------------------
main proc
	mov ax, @data
	mov ds, ax

	mov ah, 00h ;set_up video mode
	mov al, 02h ;video mode	(usamos la 02h que tiene solo texto)
	int 10h

	call menuInicial

	;Limpia la pantalla
	mov ah, 0Fh ;Get current video mode
	int 10h
	mov ah, 0
	int 10h

	;limpio los registros para que empiece todo en 0
	xor ax, ax
	xor dx, dx

hora_de_aventura:
	mov enemigos_masacrados, 0
	mov flag_movimiento, 0
	mov contador_de_desplazamiento, 0
	xor si, si
	xor di, di

	mov color_Enemigo_SECRETO, 5 ;Revivo al Malvado
	mov columna_Enemigo_SECRETO, 0
	mov renglon_Enemigo_SECRETO, 3
	mov flag_movimiento_SECRETO, 0
	mov contador_de_desplazamiento_SECRETO, 0

	mov cx, 6
revivir_enemigos_Verde:
	mov colores_Enemigos[si], 2
	mov renglones_Enemigos[di], 3
	inc si
	inc di
loop revivir_enemigos_Verde

	mov cx, 6
revivir_enemigos_Cyan:
	mov colores_Enemigos[si], 3
	mov renglones_Enemigos[di], 8
	inc si
	inc di
loop revivir_enemigos_Cyan

	mov cx, 6
revivir_enemigos_Rojo:
	mov colores_Enemigos[si], 4
	mov renglones_Enemigos[di], 13
	inc si
	inc di
loop revivir_enemigos_Rojo

	xor si, si
	mov cx, 3
poner_a_los_enemigos_en_sus_casillas:
	mov columnas_Enemigos[si], 0
	inc si
	mov columnas_Enemigos[si], 11
	inc si
	mov columnas_Enemigos[si], 22
	inc si
	mov columnas_Enemigos[si], 33
	inc si
	mov columnas_Enemigos[si], 44
	inc si
	mov columnas_Enemigos[si], 55
	inc si
loop poner_a_los_enemigos_en_sus_casillas

	mov col_bala, 0
	mov reng_bala, 22 ;reteo la bala para que si murio a medio disparar no este en la pantalla despues
	mov flag_bala, 0
	mov columna_Jugador, 38; pongo al jugador en el medio

Game_Loop:

	call cartelPuntajes
	call fondoEstrellas

;-------------------------------------------
;Modulo de impresion de enemigos

	xor si, si
	mov cx, 18
spawn_de_Enemigos:
	cmp colores_Enemigos[si], 0 ;0 es el negro
 je noImprime_Enemigo
	mov dh, renglones_Enemigos[si]
	mov dl, columnas_Enemigos[si]
	mov bl, colores_Enemigos[si]
	call imprimeEnemigo
 noImprime_Enemigo:
	inc si
loop spawn_de_Enemigos
;-------------------------------------------

;-------------------------------------------
;Modulo de impresion de enemigo secreto
	cmp contador_de_desplazamiento_SECRETO, 130
	jbe noImprime_Enemigo_SECRETO

	cmp color_Enemigo_SECRETO, 0 ;0 es el negro
 je noImprime_Enemigo_SECRETO
	mov dh, renglon_Enemigo_SECRETO
	mov dl, columna_Enemigo_SECRETO
	mov bl, color_Enemigo_SECRETO
	call imprimeEnemigoSECRETO
noImprime_Enemigo_SECRETO:
;-------------------------------------------

;-------------------------------------------
;Modulo para imprimir forma de Jugador(imprimir a el jugador SIEMPRE despues de los enemigos)
	mov dh, renglon_Jugador  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, columna_Jugador  ;en dl recibe la posicion Y
	mov bl, 1                ;en bl el color
	call imprime_Jugador
;-------------------------------------------


;-------------------------------------------
;"Modulo" comprobar si hay pulsaciones    ESTE es el mejor lugar para ponerlo parece
	call pulsacion
;-------------------------------------------


;-------------------------------------------
;Modulo de gameOver (chequea si mata al jugador o sobrepasa el ultimo renglon)
	xor si, si
	mov cx, 18
comprobar_vida_de_Enemigos:
	cmp colores_Enemigos[si], 0
je No_Existe_Enemigo
	mov dh, renglon_Jugador
	mov dl, columna_Jugador
	mov ah, renglones_Enemigos[si]
	mov al, columnas_Enemigos[si]
	call gameOver
	cmp nivel_de_dificultad, 20 ;nadie va a hacer 20 niveles ni en pedo (si se cambia el numero 20 se tiene que cambiar tambien en ( outatime_muerte )
	jne No_Existe_Enemigo
	jmp reinicio_nivel_dificultad
No_Existe_Enemigo:
	inc si
loop comprobar_vida_de_Enemigos
;-------------------------------------------

;-------------------------------------------
;Modulo para comparar existencia de bala
	cmp flag_bala, 0
	jnz balaDisparada 	;Saltar si no es cero
jmp bala_NOdisparada ;Salta de una porque no tiene que ser condicional como estaba antes
;-------------------------------------------

;-------------------------------------------
;Modulo para imprimir y mover la bala
balaDisparada:
	mov dh, reng_bala
	mov dl, col_bala
	mov bl, 7
	mov al, bala
	mov cx, 1
	call imprime

	mov dl, reng_bala
	call movimiento_bala
	mov reng_bala, dl
;-------------------------------------------

;-------------------------------------------
;Modulo de comprobación de asesinato
	xor si, si
	mov cx, 18
comprobacion_de_asesinato:

	push cx

	cmp colores_Enemigos[si], 0
je noComprueboColision_Enemigo

	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglones_Enemigos[si]
	mov cl, columnas_Enemigos[si]
	mov bl, colores_Enemigos[si]
	call colisionBala
	mov reng_bala, dh

	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo

	mov bl, colores_Enemigos[si]
	mov bh, flag_bala
	mov al, enemigos_masacrados
	call matar_Enemigo
	mov colores_Enemigos[si], bl
	mov flag_bala, bh
	mov enemigos_masacrados, al

;jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente  (R.I.P. ETIQUETA)
noComprueboColision_Enemigo:
	inc si
	pop cx
loop comprobacion_de_asesinato
;-------------------------------------------

;-------------------------------------------
;Modulo de comprobación de asesinato de enemigo secreto
	cmp contador_de_desplazamiento_SECRETO, 130
	jbe noComprueboColision_Enemigo_SECRETO

	xor al, al ;NO SACAR ESTO ES IMPORTANTE

	cmp color_Enemigo_SECRETO, 0
	je noComprueboColision_Enemigo_SECRETO

	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_Enemigo_SECRETO
	mov cl, columna_Enemigo_SECRETO
	mov bl, color_Enemigo_SECRETO
	call colisionBalaSECRETO
	mov reng_bala, dh

	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo_SECRETO

	mov bl, color_Enemigo_SECRETO
	mov bh, flag_bala
	call matar_Enemigo
	mov color_Enemigo_SECRETO, bl
	mov flag_bala, bh
noComprueboColision_Enemigo_SECRETO:
;-------------------------------------------

bala_NOdisparada:

;-------------------------------------------
;"Modulo" de retrasados, digo de retardos ????????????????
	;Solo poner retardos, en cualquier otro lugar no sirven
	cmp nivel_de_dificultad, 0
	je nivel_0
	cmp nivel_de_dificultad, 1
	je nivel_1
	cmp nivel_de_dificultad, 2
	je nivel_2
	cmp nivel_de_dificultad, 3
	je nivel_3

nivel_0:
	mov cl, 05h
   call retard
   mov cl, 06h
   call retard
   mov cl, 06h
   call retard
   mov cl, 06h
   call retard
jmp basta_retardos

nivel_1:
	mov cl, 05h
   call retard
   mov cl, 06h
   call retard
   mov cl, 07h
   call retard
   mov cl, 07h
   call retard
   mov cl, 07h
   call retard
   mov cl, 07h
   call retard
   mov cl, 07h
   call retard
jmp basta_retardos

nivel_2:
	mov cl, 05h
   call retard
jmp basta_retardos

nivel_3:
	mov cl, 06h
   call retard
   mov cl, 06h
   call retard
jmp basta_retardos

basta_retardos:
;-------------------------------------------

;-------------------------------------------
;Modulo para movimiento de enemigos
	xor si, si
	mov cx, 18

	cmp flag_movimiento, 0
	je incrementacion
	cmp flag_movimiento, 1
	je decrementacion

incrementacion:
	inc columnas_Enemigos[si]
	inc si
loop incrementacion

	inc contador_de_desplazamiento
	cmp contador_de_desplazamiento, 20
	je bajar_renglon_flag_1
	jmp no_hacer_nada

decrementacion:
	dec columnas_Enemigos[si]
	inc si
loop decrementacion

	inc contador_de_desplazamiento
	cmp contador_de_desplazamiento, 20
	je bajar_renglon_flag_0
	jmp no_hacer_nada

bajar_renglon_flag_1:
	xor si, si
	mov cx, 18
bajar_renglon:
	inc renglones_Enemigos[si]
	inc si
loop bajar_renglon

	mov contador_de_desplazamiento, 0
	mov flag_movimiento, 1
jmp no_hacer_nada ;estos jmp si que hicieron posicionar_bala_de_BOSS obviamente

bajar_renglon_flag_0:
	;si baja de los dos lados es imposible (pussy) (es imposible)

	mov contador_de_desplazamiento, 0
	mov flag_movimiento, 0
jmp no_hacer_nada

no_hacer_nada:
;-------------------------------------------

;-------------------------------------------
;Modulo para movimiento de enemigo secreto
	inc contador_de_desplazamiento_SECRETO
	cmp contador_de_desplazamiento_SECRETO, 130
	jbe no_hacer_nada_SECRETO

	cmp flag_movimiento_SECRETO, 0
	je incrementacion_Secreto
	jmp decrementacion_Secreto

incrementacion_Secreto:
	inc columna_Enemigo_SECRETO

	cmp contador_de_desplazamiento_SECRETO, 201
	je cambiar_flag_SECRETO
jmp no_hacer_nada_SECRETO

decrementacion_Secreto:
	dec columna_Enemigo_SECRETO

	cmp contador_de_desplazamiento_SECRETO, 273
	je se_fue_el_SECRETO
jmp no_hacer_nada_SECRETO

cambiar_flag_SECRETO:
	mov flag_movimiento_SECRETO, 1
jmp no_hacer_nada_SECRETO

se_fue_el_SECRETO:
	mov color_Enemigo_SECRETO, 0

no_hacer_nada_SECRETO:
;-------------------------------------------
	cmp enemigos_masacrados, 18 ;lo comparas con la cantidad de enemigos que hay, este ponerlo siempre en (18)  <-
	je findelmalditoJuego

;-------------------------------------------
;para sacar el fliquering

   call sacar_fliquering

;-------------------------------------------

	;Limpia la pantalla
	mov ah, 0Fh ;Get current video mode
	int 10h
	mov ah, 0
	int 10h

jmp Game_Loop

findelmalditoJuego: ;No cambiar etiqueta en honor a cata
	call fin_masacre_total

Hasta_que_ponganteclavalida:

	mov ah, 8
	int 21h

	cmp al ,1bh ;(ESC)
	je fin_REAL_del_juego ;No cambiar etiqueta en honor a maxi ¯\_(ツ)_/¯
	cmp al ,20h ;(space)
	je outatime

jmp Hasta_que_ponganteclavalida

outatime:
	inc nivel_de_dificultad
	cmp nivel_de_dificultad, 4 ;este ponerlo siempre en (4)  <-
	je SE_VIENE_el_boss
	jmp hora_de_aventura
reinicio_nivel_dificultad:
	mov nivel_de_dificultad, 0
	jmp hora_de_aventura

SE_VIENE_el_boss:
	call FINAL_BOSS
	mov nivel_de_dificultad_BOSS, -1
	lea bx, scoreAscii
	call limpiarVariableAscii
	cmp nivel_de_dificultad, 20
	je reinicio_nivel_dificultad

	mov score, 0
	jmp hora_de_aventura

fin_REAL_del_juego:

	mov ax, 4c00h
	int 21h

main endp

menuInicial proc

	;primer mensaje de bienvenida
	mov bh, 0 ;pagina
	mov dh, 10 ;renglon
	mov dl, 34 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, bienvenida
	int 21h

	;segundo mensaje
	mov dh, 12 ;renglon
	mov dl, 21 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, bienvenida2
	int 21h

	mov ah, 00h
	int 16h

	;Limpia la pantalla
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	;MENU INICIAL
	call cartelPuntajes

 ; PANTALLA INFO
	mov bh, 0 ;pagina
	mov dh, 8 ;renglon
	mov dl, 37 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, pantallaGame_Loop
	int 21h

  ;ENEMIGOS COLORES
	mov dh, 16  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, 32  ;en dl recibe la posicion Y
	mov bl, 4   ;en bl el color (rojo)
	mov al, 42  ;Ascii a imprimir
	mov cx, 1   ;cantidad de veces que se imprime(Los imprime para la derecha)
	call imprime
	mov dh, 15
	mov dl, 32
	mov bl, 3  ;(cyan)
	mov al, 42
	mov cx, 1
	call imprime
	mov dh, 14
	mov dl, 32
	mov bl, 2  ;(verde)
	mov al, 42
	mov cx, 1
	call imprime
	mov dh, 13
	mov dl, 32
	mov bl, 5  ;(magenta)
	mov al, 42
	mov cx, 1
	call imprime

	;segundo mensaje OTRA VEZ
	mov dh, 20 ;renglon
	mov dl, 21 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, bienvenida2
	int 21h

	mov ah, 00h
	int 16h

ret
menuInicial endp

cartelPuntajes proc

	;Puntajes
	mov dh, 0  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, 25 ;en dl recibe la posicion Y
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoScore
	int 21h

	cmp nivel_de_dificultad_BOSS, -1
	je cartelPuntajes_main

	mov dh, 0
	mov dl, 31
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, scoreFINAL_BOSS
	int 21h

ret
cartelPuntajes_main:

	mov dh, 0
	mov dl, 40
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov dh, 0
	mov dl, 31
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, scoreAscii
	int 21h

	mov dh, 0
	mov dl, 52
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, highscoreAscii
	int 21h

ret
cartelPuntajes endp

imprime proc

	mov bh, 0 	;BH = Page Number
	mov ah, 02h ;set_up cursor position, con los parametros de dh y dl
	int 10h

	mov ah, 09h ;Write character and attribute at cursor position
	int 10h

ret
imprime endp

imprimeEnemigo proc

;   ▄█▄█▄
;   █▄█▄█
;    ▀ ▀

	push cx

	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dh, 1
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dh, 2
	add dl, 1
	mov al, 223
	mov cx, 1
	call imprime
	add dl, 2
	mov al, 223
	mov cx, 1
	call imprime

	pop cx

ret
imprimeEnemigo endp

imprimeEnemigoSECRETO proc

;   ▄█▄█▄
; █▄█▄█▄█▄█
; ▄█ ▀ ▀ █▄

	push cx

	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dh, 1
	sub dl, 2
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 220
	mov cx, 1
	call imprime

	add dh, 2
	sub dl, 2
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 2
	mov al, 223
	mov cx, 1
	call imprime
	add dl, 2
	mov al, 223
	mov cx, 1
	call imprime
	add dl, 2
	mov al, 219
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime

	pop cx

ret
imprimeEnemigoSECRETO endp

imprime_Jugador proc

;  ▄█▄

	push cx

	mov al, 220     ;Ascii a imprimir
	mov cx, 1      	;cantidad de veces que se imprime(Los imprime para la derecha)
	call imprime
	add dl, 2
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 1
	mov al, 219
	mov cx, 1
	call imprime

	pop cx

ret
imprime_Jugador endp

colisionBala proc

	push cx si
	;mov dh, reng_bala
	;mov dl, col_bala
	;mov ch, renglones_Enemigos[si]
	;mov cl, columnas_Enemigos[si]
	;mov bl, colores_Enemigos[si]

	mov ah, ch
	mov al, cl

sigo_comparando:

	mov cx, 5
Game_LoopCompBala:
	cmp dl, al ;comparo las columnas
	je comparaRengBala
	inc al ;sino comparo la proxima
loop Game_LoopCompBala

	mov cx, 5
Game_LoopCompBalaIzq:
	cmp dl, al ;comparo las columnas
	je comparaRengBala
	dec al ;sino comparo la proxima
loop Game_LoopCompBalaIzq

jmp nadaBala

comparaRengBala:
	cmp dh, ah
	je choqueBala
	dec ah
	cmp dh, ah
	je choqueBala
	dec ah
	cmp dh, ah
	je choqueBala
jmp nadaBala

choqueBala:
	mov dh, 22   ;Pongo la bala en la fila original
	mov ah, 0 		;le mando un "flag" en ah si es 0 mata
	call contPuntaje
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	mov cx, 4000
	mov bx, 15
	call sonido
	mov cx, 3500
	mov bx, 15
	call sonido
	mov cx, 3000
	mov bx, 15
	call sonido

	pop si cx

ret

	nadaBala:
	mov ah, 1 		;le mando un "flag" en ah si es 1 no mata

	pop si cx

ret
colisionBala endp

colisionBalaSECRETO proc

	push cx si
	;mov dh, reng_bala
	;mov dl, col_bala
	;mov ch, renglon_Enemigo_SECRETO
	;mov cl, columna_Enemigo_SECRETO
	;mov bl, color_Enemigo_SECRETO
	mov ah, ch
	mov al, cl

sigo_comparandoSECRETO:

	mov cx, 9
Game_LoopCompBalaSECRETO:
	cmp dl, al ;comparo las columnas
	je comparaRengBalaSECRETO
	inc al ;sino comparo la proxima
loop Game_LoopCompBalaSECRETO

	mov cx, 9
Game_LoopCompBalaIzqSECRETO:
	cmp dl, al ;comparo las columnas
	je comparaRengBalaSECRETO
	dec al ;sino comparo la proxima
loop Game_LoopCompBalaIzqSECRETO

jmp nadaBalaSECRETO

comparaRengBalaSECRETO:
	cmp dh, ah
	je choqueBalaSECRETO
	dec ah
	cmp dh, ah
	je choqueBalaSECRETO
	dec ah
	cmp dh, ah
	je choqueBalaSECRETO
jmp nadaBalaSECRETO

choqueBalaSECRETO:
	mov dh, 22   ;Pongo la bala en la fila original
	mov ah, 0 		;le mando un "flag" en ah si es 0 mata
	call contPuntaje
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	mov cx, 4000
	mov bx, 15
	call sonido
	mov cx, 3500
	mov bx, 15
	call sonido
	mov cx, 3000
	mov bx, 15
	call sonido

	pop si cx

ret

	nadaBalaSECRETO:
	mov ah, 1 		;le mando un "flag" en ah si es 1 no mata

	pop si cx

ret
colisionBalaSECRETO endp

matar_Enemigo proc

	mov bl, 0
	mov bh, 0   ;para que no se siga imprimiendo en el proximo ciclo
	inc al

ret
matar_Enemigo endp

pulsacion proc

	push ax

 	mov ah, 01h ; Get the State of the keyboard buffer
   int 16h
   jz no_se_presiono_tecla
   mov ah, 00h ; If a key is found, get it and send it to AL
   int 16h

	mov CurrentKey, al

	;0Ch	Flush input buffer and input
	;mov ax,0C00h  ;<-
	;int 21h

	;address (size): 0x041E (32 bytes)	keyboard buffer (almacena temporalmente datos)
	;cada tecla presionada genera dos bytes (un byte para el Scancode y otro para el ASCII)

wait_for_more_keys:
	mov ah, 01h
  	int 16h
  	jz listo ;solo presiono una vez
  	cmp al, CurrentKey ;si es diferente no me importa
  	jne listo
 	mov ah, 00h ;leo el dato para que desaparezcan
 	int 16h
	jmp wait_for_more_keys
listo:

	cmp CurrentKey, 'w' ;cambio la tecla de disparo al espacio
	je dispara
	cmp CurrentKey, 'W'
	je dispara
	cmp CurrentKey,'A'
	je izquierda
	cmp CurrentKey,'a'
	je izquierda
	cmp CurrentKey,'D'
	je derecha
	cmp CurrentKey,'d'
	je derecha
	cmp CurrentKey, 27 ;decimal: [ESC]
	je toco_ESC
	jmp no_se_presiono_tecla
toco_ESC:
	call fin_con_ERROR_o_ESC
restauro_mov:
	dec columna_Jugador
	jmp margen
margen_derecho:
	inc columna_Jugador
margen:
no_se_presiono_tecla:
	pop ax
ret

dispara:
	cmp flag_bala, 1
	je no_volver_a_mover_de_lugar_la_bala ;se explica sola la etiqueta no?
	mov cx, 10000 ; TONO
	mov bx, 30  ; DURACION
	call sonido

	mov flag_bala, 1 ;cambia el flag de la bala a uno para el proximo ciclo
	mov dl, columna_Jugador
	inc dl
	mov col_bala, dl ;cargo la columna de la bala con la columna del cuadrado azul

no_volver_a_mover_de_lugar_la_bala:
	pop ax
ret

izquierda:
	cmp columna_Jugador, 77 ; si esta en la ultima columna, debemos restarle 1
	je restauro_mov			; Para que vuelva a tener el movimiento de a 2 columnas correcto
	cmp columna_Jugador, 0
	je margen
	sub columna_Jugador, 2

	pop ax
ret

derecha:
	cmp columna_Jugador, 76
	je margen_derecho
	cmp columna_Jugador, 77
	je margen
	add columna_Jugador, 2

	pop ax
ret
pulsacion endp

movimiento_bala proc
;compara si llega arriba de todo
	cmp dl, 0
	je top
jmp subir_bala

top:
	dec flag_bala ;si llega, el flag vuelve a ser cero
	mov dl, 22	  ;y el renglon 22
jmp finalTop

subir_bala:
	sub dl, 1

finalTop:

ret
movimiento_bala endp

gameOver proc
;	dh, renglon_Jugador  ESTA SIEMPRE EN 23
;	dl, columna_Jugador
;	ah, renglon_de_Enemigos_nro_
;	al, columna_Enemigo_
   push cx

   inc dl

   cmp ah, 22
   je empezar_a_comparar
   cmp ah, 23
   je empezar_a_comparar
   cmp ah, 24
   je empezar_a_comparar
   jmp Chequeo_Enemigo_Se_Fue

empezar_a_comparar:
	cmp nivel_de_dificultad_BOSS, -1
	je comparo_enemigos_main
	mov cx, 26
	jmp compara_posiciones

comparo_enemigos_main:
	mov cx, 5
compara_posiciones:
	cmp dl, al ;comparo las columnas
	je Perdio_Alto_Muerto
	inc al ;sino comparo la proxima
loop compara_posiciones

	cmp nivel_de_dificultad_BOSS, -1
	je comparo_enemigos_reves_main
	mov cx, 26
	jmp compara_posiciones_al_reves

comparo_enemigos_reves_main:
	mov cx, 5
compara_posiciones_al_reves:
	cmp dl, al ;comparo las columnas
	je Perdio_Alto_Muerto
	dec al ;sino comparo la proxima
loop compara_posiciones_al_reves


Chequeo_Enemigo_Se_Fue:
	cmp ah, 25  ;cambiar esto para que el juego termina cuando los enemigos pasan cierto renglon
	je Perdio_Alto_Muerto
	jmp Todavia_Vive

Perdio_Alto_Muerto:
	cmp nivel_de_dificultad_BOSS, -1
	je perdio_en_el_main
	pop cx
	call fin_BOSS
ret

perdio_en_el_main:
   pop cx
	call fin_con_ERROR_o_ESC
ret

Todavia_Vive:
   pop cx
ret
gameOver endp

fin_con_ERROR_o_ESC proc

	push ax bx cx dx si

	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	mov dh, 12 ;en dh recibe la posicion Y } Para posicionamiento del cursor
	mov dl, 35 ;en dl recibe la posicion X  }
	mov bl, 4 ;en bl el color
	mov cx, 1 ;cantidad de veces que se imprime(Los imprime para la derecha)
	mov si, 0
ImprimirGameOver:
	cmp si, 24
	je finImprimirGameOVer
	mov al, ERRORText[si] ;forma/figura a imprimir
	call imprime

	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	inc si
jmp ImprimirGameOver

finImprimirGameOVer:
	mov cx, 0

; COLOR BLANCO P/ TEXTO
	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov bl, 0fh
	mov cx, 10
	mov al, 20
	call imprime
	add dh, 2
	mov cx, 11
	call imprime
	add dh, 1
	add dl, 4
	mov cx, 4
	call imprime
	mov dh, 14
	mov dl, 30
	mov cx, 14
	call imprime
	mov dh, 16
	mov dl, 27
	mov cx, 20
	call imprime
; ------------------

	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov ah, 2
	int 10h
	mov cx, 7000 ; TONO
	mov bx, 20   ; DURACION
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 20
	call sonido

	mov ah, 9
	lea dx, GameOverText
	int 21h

	mov dh, 11 ;renglon
	mov dl, 31 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 7000
	mov bx, 20
	call sonido

	mov dh, 12 ;renglon
	mov dl, 36 ;columna
	mov ah, 2
	int 10h

	; flag para cargar highscore
	mov al, 1
	call contPuntaje

	mov ah, 9
	lea dx, highscoreAscii
	int 21h

	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 100
	call sonido
	mov cx, 19000
	mov bx, 250
	call sonido

	mov dh, 14 ;renglon
	mov dl, 30 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoRetry
	int 21h

	mov dh, 16 ;renglon
	mov dl, 27 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensaje2
	int 21h

Hasta_que_ponganteclavalida_muerte:

	mov ah, 8
	int 21h

	cmp al, 1bh ;(ESC)
	je fin_REAL_del_juego_muerte
	cmp al, 20h ;(space)
	je outatime_muerte

jmp Hasta_que_ponganteclavalida_muerte

outatime_muerte:
	mov nivel_de_dificultad, 20
	; flag para cargar highscore
	; para sig nivel
	mov al, 1
	call contPuntaje
	mov score, 0
	lea bx, scoreAscii
	call limpiarVariableAscii

	pop si dx cx bx ax

ret

fin_REAL_del_juego_muerte:

	mov ax, 4c00h
	int 21h

fin_con_ERROR_o_ESC endp

fin_masacre_total proc
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	call imprimeCorona

	mov bh, 0 ;pagina
	mov dh, 10 ;renglon
	mov dl, 35 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensaje
	int 21h
; COLOR VERDE:
	mov dh, 15 ;renglon
	mov dl, 37 ;columna
	mov bl, 2
	mov cx, 6
	mov al, 20
	call imprime
; ---------------
	mov dh, 15 ;renglon
	mov dl, 37 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoScore
	int 21h

	mov dh, 16 ;renglon
	mov dl, 38 ;columna
	mov ah, 2
	int 10h

	mov al, 1
	call contPuntaje

	mov ah, 9
	lea dx, scoreAscii
	int 21h

	mov dh, 18 ;renglon
	mov dl, 30 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensaje2
	int 21h

	call victoria_magistral

ret
fin_masacre_total endp

contPuntaje proc

	push dx ax bx

	mov dl, bl
	lea bx, scoreAscii
	call limpiarVariableAscii

	cmp al, 1
	je asciiHighscore

variables_lvl_x:

	cmp dl, 4   ; ROJO
	je scoreRojo
	cmp dl, 3 ; CYAN
	je scoreCyan
	cmp dl, 2 ; VERDE
	je scoreVerde
	cmp dl, 5  ; MAGENTA
	je scoreMag
	jne ningunColor

	xor dh, dh
scoreRojo:
	add score, 1
	jmp asciiScore
scoreCyan:
	add score, 2
	jmp asciiScore
scoreVerde:
	add score, 3
	jmp asciiScore
scoreMag:
	add score, 5
	jmp asciiScore

asciiHighscore:
	mov dl, score
	cmp dl, highscore
	jbe asciiScore

	mov highscore, dl
	lea bx, highscoreAscii
	call limpiarVariableAscii
	lea bx, highscoreAscii
	call regToAscii
asciiScore:
	lea bx, scoreAscii
	call limpiarVariableAscii
	mov dl, score
	lea bx, scoreAscii
	call regToAscii
ningunColor:

	pop bx ax dx

ret
contPuntaje endp

animacionMuerte proc

	mov cx, 9FFFh
	decrementaAnimacion:
	cmp cx, 0
	je incrementaAnimacion
	dec cx
	jmp decrementaAnimacion
	incrementaAnimacion:
	cmp cx, 9FFFh
	je finDecAnimacion
	inc cx
	jmp incrementaAnimacion

	finDecAnimacion:

ret
animacionMuerte endp

regToAscii proc

    push ax dx cx si bx

    xor si,si
    xor ax, ax
    mov al, dl ;MUEVO EL NUMERO(reg) A al PARA HACER LA DIVISION

    mov cx, 3
rta: ;("Reg.To.Ascii" = rta)
    mov dl, dataDiv[si] ; [si] -> dataDivMul
    div dl
    add [bx],al     ; Se suma porque [bx] es "000", o sea: 30h, 30h, 30h
    xchg al, ah     ;INTERCAMBIA VALORES
    xor ah, ah
    inc bx
    inc si
loop rta

    pop bx si cx dx ax

ret
regToAscii endp

limpiarVariableAscii proc

	push bx cx

	cmp nivel_de_dificultad_BOSS, -1
	jne limpiarScoreBOSS

   mov cx, 4
 limpiarNroAscii:
   mov [bx], byte ptr 30h
   inc bx
loop limpiarNroAscii
jmp finLimpiar

limpiarScoreBOSS:
	mov dl, scoreBOSS
	xor dh, dh
	mov bx, dx
 limpiarNroAsciiBOSS:
 	cmp bx, -1
 	je finLimpiar
   mov scoreFINAL_BOSS[bx], byte ptr 24h
   dec bx
jmp limpiarNroAsciiBOSS

finLimpiar:

	pop cx bx

ret
limpiarVariableAscii endp

imprimeCorona proc

;	▄   █   ▄
;	██▄███▄██
;	█████████

	push dx cx ax bx

	mov dh, 8 ;renglon
	mov dl, 35 ;columna
	mov bl, 0eh ; AMARILLO

	mov al, 219
	mov cx, 9
	call imprime
	sub dh, 1
	mov al, 219
	mov cx, 2
	call imprime
	add dl, 2
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 3
	call imprime
	add dl, 3
	mov al, 220
	mov cx, 1
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 2
	call imprime
	sub dh, 1
	add dl, 1
	mov al, 220
	mov cx, 1
	call imprime
	sub dl, 4
	mov al, 219
	mov cx, 1
	call imprime
	sub dl, 4
	mov al, 220
	mov cx, 1
	call imprime

	pop bx ax cx dx

ret
imprimeCorona endp
;-------------------------
imprimeCoronaGlitch proc

;  ▄   █   ▄
;	 ██▄███▄██
;  █████▄███

	push dx cx ax bx

	mov dh, 8 ;renglon
	mov dl, 35 ;columna

	mov al, 219
	mov cx, 5
	mov bl, 0eH ; AMARILLO
	call imprime
	mov al, 219
	mov cx, 2
	mov bl, 6
	call imprime
	add dl, 5
	mov al, 220
	mov cx, 1
	inc bl
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 3
	inc bl
	call imprime

	sub dh, 1
	sub dl, 5
	mov cx, 2
	add bl, 2
	call imprime
	add dl, 2
	mov al, 220
	mov cx, 1
	mov bl, 5
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 3
	call imprime
	add dl, 3
	mov al, 220
	mov cx, 1
	mov bl, 0eh
	call imprime
	add dl, 1
	mov al, 219
	mov cx, 2
	mov bl, 5
	call imprime

	sub dh, 1
	mov al, 220
	mov cx, 1
	mov bl, 4
	call imprime
	sub dl, 4
	mov al, 219
	mov cx, 1
	dec bl
	call imprime
	sub dl, 4
	mov al, 220
	mov cx, 1
	sub bl, 2
	call imprime

	pop bx ax cx dx

ret
imprimeCoronaGlitch endp
;-----------------------
imprime_Vidas proc
	push dx cx ax bx si

	cmp vida_jugador, 4 ;Solo para saber si es para cartel1 o para el juego.
	je cartel_vida
	jmp vida_gameplay

cartel_vida:
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	mov vida_jugador, 3
	mov dl, vida_jugador
	xor dh,dh
	mov si, dx
	mov dh, 12 ;renglon
	mov dl, 31 ;columna
	mov ah, 2
	int 10h
	mov al, 219
	mov cx, 2
	mov bl, 4 ; ROJO

imprimir_cartel_vida:
	cmp si, 0
	je fin_imprimir_cartel_vida
	add dl, 4
	call imprime
	dec si

	push cx bx

   ; Tono 1
   mov cx, 2600  ; Frecuencia más aguda
   mov bx, 70   ; Duración
   call tonos
   ; Tono 2
   mov cx, 1900  ; Frecuencia intermedia
   mov bx, 50   ; Duración
   call tonos
   ; Tono 3
   mov cx, 1500  ; Frecuencia intermedia-baja
   mov bx, 80   ; Duración más larga
   call tonos

   pop bx cx

	push cx
	mov cl, 01h
	call retard
	pop cx

jmp imprimir_cartel_vida
fin_imprimir_cartel_vida:
	mov ah, 00h
	int 16h
	jmp fin_imprimir_vida

vida_gameplay:
	mov dl, vida_jugador
	xor dh,dh
	mov si, dx
	mov dh, 1 ;renglon ; <- POSICION DE LAS VIDAS
	mov dl, 70 ;columna
	mov ah, 2
	int 10h
	mov al, 220
	mov cx, 1
	mov bl, 4 ; ROJO

imprimir_vida:
	cmp si, 0
	je fin_imprimir_vida

	add dl, 2
	call imprime
	dec si
jmp imprimir_vida
fin_imprimir_vida:

	pop si bx ax cx dx
	ret
imprime_Vidas endp
;-----------------------
fondoEstrellas proc

; .  y  *

	push dx cx ax bx si

	mov dh, 2 ;renglon

comienza_dibujo:
	mov dl, 5 ;columna
	; mov bl, 7 ; LIGHT GRAY
	mov bl, 8 ; DARK GRAY
	mov si, 0
	jmp lineaAsteristos
sumoLinea:
	mov si, 0
	add dh, 3
	sub dl, 78
	cmp dh, 24
	jae finAsteriscos
	lineaAsteristos:
		cmp si, 3
		je sumoLinea
		mov al, 42
		mov cx, 1
		call imprime
		add dl, 35
		cmp dl, 78
		jae sumoLinea
		inc si
	jmp lineaAsteristos
finAsteriscos:

	mov dh, 1 ;renglon
	mov dl, 31 ;columna
	mov bl, 7 ; LIGHT GRAY
	; mov bl, 8 ; DARK GRAY
	mov si, 0
	jmp lineaPuntos
sumoLineaPto:
	mov si, 0
	add dh, 1
	sub dl, 78
	cmp dh, 24
	jae finPuntos
	lineaPuntos:
		mov al, 250
		mov cx, 1
		call imprime
		add dl, 11
		cmp dl, 78
		jae sumoLineaPto
		inc si
	jmp sumoLineaPto
finPuntos:

	mov dh, 5 ;renglon
    mov dl, 72 ;columna
    mov bl, 8 ; DARK GRAY
    mov al, 'M'
    mov cx, 1
    call imprime

    mov dh, 5 ;renglon
    mov dl, 73 ;columna
    mov bl, 8 ; DARK GRAY
    mov al, 'C'
    mov cx, 1
    call imprime

    mov dh, 5 ;renglon
    mov dl, 74 ;columna
    mov bl, 8 ; DARK GRAY
    mov al, 'N'
    mov cx, 1
    call imprime

    mov dh, 5 ;renglon
    mov dl, 75 ;columna
    mov bl, 8 ; DARK GRAY
    mov al, 'D'
    mov cx, 1
    call imprime

	pop si bx ax cx dx

ret
fondoEstrellas endp
; ------------------------------------------------------------------
; http://muruganad.com/8086/8086-assembly-language-program-to-play-sound-using-pc-speaker.html
; os_play_sound -- Play a single tone using the pc speaker
; IN: CX = tone, BX = duration

sonido proc

	push ax cx bx

   mov ax, cx

   ; ACTIVA EL SONIDO
   out 42h, al
   mov al, ah
   out 42h, al
   in al, 61h

   or al, 00000011b
   out 61h, al

pause1:
   mov cx, 65535

pause2:
   dec cx
   jne pause2
   dec bx
   jne pause1

; DESACTIVA EL SONIDO
   in  al, 61h
   and al, 11111100b
   out 61h, al

   pop bx cx ax

ret
sonido endp

victoria_magistral proc
; IN: CX = tone, BX = duration
	push cx bx

	mov cx, 2850
	mov bx, 120
	call tonos
	mov cx, 3000
	mov bx, 10
	call tonos
	mov cx, 2850
	mov bx, 10
	call tonos
	mov cx, 3000
	mov bx, 10
	call tonos
	mov cx, 2250
	mov bx, 120
	call tonos
	mov cx, 3000
	mov bx, 10
	call tonos
	mov cx, 1900
	mov bx, 180
	call tonos
	mov cx, 3000
	mov bx, 10
	call tonos
	mov cx, 2250
	mov bx, 100
	call tonos
	mov cx, 3000
	mov bx, 10
	call tonos
	mov cx, 1900
	mov bx, 350
	call tonos

	pop bx cx

ret
victoria_magistral endp

retard proc
; delay con tiempo predeterminado por los tick=microsegundo, por registro cl
; 1. 1sec:  CX:000fh + DX:4240h
; 2. 500ms: CX:0007h + DX:a120h
; 3. 250ms: CX:0003h + DX:d090h
; 4. 100ms: CX:0001h + DX:86a0h
; 5. 50ms:  CX:0000h + DX:c350h
; 6. 10ms:  CX:0000h + DX:2710h
; 7. 1ms:   CX:0000h + DX:03e8h
; no devuelve valor

	push ax cx dx

	mov al, 00h
	mov ah, 86h

	cmp cl, 01h
	je opcion_retardo_uno
	cmp cl, 02h
	je opcion_retardo_dos
	cmp cl, 03h
	je opcion_retardo_tres
	cmp cl, 04h
	je opcion_retardo_cuatro
	cmp cl, 05h
	je opcion_retardo_cinco
	cmp cl, 06h
	je opcion_retardo_seis
	cmp cl, 07h
	je opcion_retardo_siete
	jmp close

opcion_retardo_uno:
	mov cx, 000fh
	mov dx, 4240h
	jmp set_up
opcion_retardo_dos:
	mov cx, 0007h
	mov dx, 0a120h
	jmp set_up
opcion_retardo_tres:
	mov cx, 0003h
	mov dx, 0d090h
	jmp set_up
opcion_retardo_cuatro:
	mov cx, 0001h
	mov dx, 86a0h
	jmp set_up
opcion_retardo_cinco:
	mov cx, 0000h
	mov dx, 0c350h
	jmp set_up
opcion_retardo_seis:
	mov cx, 0000h
	mov dx, 2710h
	jmp set_up
opcion_retardo_siete:
	mov cx, 0000h
	mov dx, 03e8h
	jmp set_up

set_up:
	int 15h
close:
	pop dx cx ax
ret
retard endp

;=====================================================================================================================(cosas del boss)

FINAL_BOSS proc

	mov nivel_de_dificultad_BOSS, 0
	call limpiarVariableAscii
	mov scoreBOSS, 0
	mov vida_jugador, 3

hora_de_aventura_BOSS:

	;Limpia la pantalla
	mov ah, 0Fh ;Get current video mode
	int 10h
	mov ah, 0
	int 10h

	call cartelFINAL_BOSS
	mov vida_BOSS, 28 ;Revivo al FINAL BOSS
	mov color_BOSS, 0fh
	mov columna_BOSS, 27
	mov renglon_BOSS, 0
	mov flag_movimiento_BOSS, 2
	mov contador_de_desplazamiento_BOSS, 0

	mov col_bala, 0
	mov reng_bala, 22 ;reseteo la bala para que si murio a medio disparar no este en la pantalla despues
	mov flag_bala, 0
	mov columna_Jugador, 38; pongo al jugador en el medio

Game_Loop_BOSS:

	call fondoEstrellas
	call cartelPuntajes
	call imprime_Vidas
;-------------------------------------------
;Modulo de impresion de FINAL BOSS

	cmp color_BOSS, 0 ;0 es el negro
 je noImprime_Enemigo_FINAL
	mov dh, renglon_BOSS
	mov dl, columna_BOSS
	mov bl, color_BOSS
	call imprimeEnemigoFINAL
 noImprime_Enemigo_FINAL:

;-------------------------------------------
;Modulo para imprimir forma de Jugador(imprimir a el jugador SIEMPRE despues de los enemigos)
	mov dh, renglon_Jugador  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, columna_Jugador  ;en dl recibe la posicion Y
	mov bl, 1                ;en bl el color
	call imprime_Jugador
;-------------------------------------------

;-------------------------------------------
;"Modulo" comprobar si hay pulsaciones    ESTE es el mejor lugar para ponerlo parece
	call pulsacion
	cmp nivel_de_dificultad, 20
	jb toco_ESC_en_BOSS
ret
toco_ESC_en_BOSS:
;-------------------------------------------

;-------------------------------------------
;Modulo de gameOver (chequea si mata al jugador o sobrepasa el ultimo renglon)

comprobar_colision_con_FINAL:
	cmp color_BOSS, 0
je No_Existe_Enemigo_FINAL
	mov dh, renglon_Jugador
	mov dl, columna_Jugador
	mov ah, renglon_BOSS
	mov al, columna_BOSS
	call gameOver
	cmp nivel_de_dificultad_BOSS, 20 ;nadie va a hacer 20 niveles ni en pedo (si se cambia el numero 20 se tiene que cambiar tambien en ( outatime_muerte )
	jne No_Existe_Enemigo_FINAL
	jmp reinicio_nivel_dificultad_BOSS
No_Existe_Enemigo_FINAL:

;-------------------------------------------

;-------------------------------------------
;Modulo para comparar existencia de bala
	cmp flag_bala, 0
	jnz balaDisparada_en_el_BOSS 	;Saltar si no es cero
jmp bala_NOdisparada_en_el_BOSS ;Salta de una porque no tiene que ser condicional como estaba antes
;-------------------------------------------

;-------------------------------------------
;Modulo para imprimir y mover la bala
balaDisparada_en_el_BOSS:
	mov dh, reng_bala
	mov dl, col_bala
	mov bl, 7
	mov al, bala
	mov cx, 1
	call imprime

	mov dl, reng_bala
	call movimiento_bala
	mov reng_bala, dl
;-------------------------------------------

;-------------------------------------------
;Modulo de comprobación de asesinato del BOSS

	xor al, al ;NO SACAR ESTO ES IMPORTANTE
	cmp color_BOSS, 0
je noComprueboColision_Enemigo_BOSS

	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_BOSS
	mov cl, columna_BOSS
	mov bl, color_BOSS
	call colisionBalaFINAL
	mov reng_bala, dh

	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo_BOSS

	mov bl, color_BOSS
	mov bh, flag_bala
	mov al, vida_BOSS
	call matar_Enemigo_FINAL
	mov color_BOSS, bl
	mov flag_bala, bh
	mov vida_BOSS, al

;jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente  (R.I.P. ETIQUETA)
noComprueboColision_Enemigo_BOSS:
;-------------------------------------------

bala_NOdisparada_en_el_BOSS:

;-------------------------------------------
;modulo para el disparo del BOSS random

	cmp flag_bala_BOSS, 1
	je NO_posicionar_bala_de_BOSS
	jmp hacer_random

hacer_random:
;la int 84h devuelve numero random en al

	push cx dx
	int 84h
	pop dx cx

	cmp al, 0 		;disminuir este nuemero para que el boss dispare menos  (entre el 0 y el 9)
	jbe posicionar_bala_de_BOSS
	jmp NO_posicionar_bala_de_BOSS

posicionar_bala_de_BOSS:
	inc flag_bala_BOSS

	mov cx, 11000
	mov bx, 15
	call tonos
	mov cx, 15000
	mov bx, 30
	call tonos


	mov dh, renglon_BOSS
	add dh, 1
	mov reng_bala_BOSS, dh

	mov dl, columna_BOSS
	add dl, 13
	mov col_bala_BOSS, dl

NO_posicionar_bala_de_BOSS:

;-------------------------------------------

;-------------------------------------------
;Modulo para comparar existencia de bala de BOSS
	cmp flag_bala_BOSS, 0
	jnz balaDisparada_por_BOSS 	;Saltar si no es cero
jmp bala_NOdisparada_por_BOSS  ;Salta de una porque no tiene que ser condicional como estaba antes
;-------------------------------------------

;-------------------------------------------
;Modulo para imprimir y mover la bala de BOSS
balaDisparada_por_BOSS:
	mov dh, reng_bala_BOSS
	mov dl, col_bala_BOSS
	mov bl, color_BOSS ;color
	mov al, bala_BOSS
	mov cx, 1
	call imprime

	mov dl, reng_bala_BOSS
	call movimiento_bala_BOSS
	mov reng_bala_BOSS, dl
;-------------------------------------------

;-------------------------------------------
;Modulo de comprobación de asesinato del JUGADOR por el BOSS

	mov dh, reng_bala_BOSS
	mov dl, col_bala_BOSS
	mov ch, renglon_Jugador
	mov cl, columna_Jugador
	call colisionBala_BOSS_con_JUGADOR

;-------------------------------------------

bala_NOdisparada_por_BOSS:


;-------------------------------------------
;"Modulo" de retrasados, digo de retardos ????????????????
	;Solo poner retardos, en cualquier otro lugar no sirven
	cmp nivel_de_dificultad_BOSS, 0
	je nivel_0_BOSS
	cmp nivel_de_dificultad_BOSS, 1
	je nivel_1_BOSS
	cmp nivel_de_dificultad_BOSS, 2
	je nivel_2_BOSS
	cmp nivel_de_dificultad_BOSS, 3
	jae nivel_3_BOSS

nivel_0_BOSS:
	mov cl, 06h
   call retard
   mov cl, 06h
   call retard
   mov cl, 06h
   call retard
    mov cl, 06h
   call retard
jmp basta_retardos_BOSS

nivel_1_BOSS:
	mov cl, 06h
   call retard
   mov cl, 06h
   call retard
   mov cl, 06h
   call retard
jmp basta_retardos_BOSS


nivel_2_BOSS:
	mov cl, 06h
	call retard
   mov cl, 06h
   call retard
jmp basta_retardos_BOSS


nivel_3_BOSS:
   mov cl, 06h
   call retard
jmp basta_retardos_BOSS


basta_retardos_BOSS:
;-------------------------------------------

;-------------------------------------------
;Modulo para movimiento de FINAL BOSS
	cmp flag_movimiento_BOSS, 2
	je baja_el_BOSS
	jmp izq_der_BOSS

baja_el_BOSS:
	inc renglon_BOSS
	cmp renglon_BOSS, 7
	je empieza_izq_der
	jmp no_hacer_NO_posicion_BOSS
empieza_izq_der:
	mov flag_movimiento_BOSS, 0
	cmp nivel_de_dificultad_BOSS, 4
	jb izq_der_BOSS
	jmp mov_final_BOSS
izq_der_BOSS:
	cmp flag_movimiento_BOSS, 0
	je incrementacion_BOSS ;columna
	cmp flag_movimiento_BOSS, 1
	je decrementacion_BOSS ;columna

incrementacion_BOSS:
	inc columna_BOSS

	inc contador_de_desplazamiento_BOSS
	cmp columna_BOSS, 54
	je bajar_renglon_flag_1_BOSS
	jmp no_hacer_NO_posicion_BOSS

decrementacion_BOSS:
	dec columna_BOSS

	inc contador_de_desplazamiento_BOSS
	cmp columna_BOSS, 0
	je bajar_renglon_flag_0_BOSS
	jmp no_hacer_NO_posicion_BOSS

bajar_renglon_flag_1_BOSS:

bajar_renglon_BOSS:
	inc renglon_BOSS

	mov contador_de_desplazamiento_BOSS, 0
	mov flag_movimiento_BOSS, 1
jmp no_hacer_NO_posicion_BOSS ;estos jmp si que hicieron posicionar_bala_de_BOSS obviamente

bajar_renglon_flag_0_BOSS:
	inc renglon_BOSS
	;si baja de los dos lados es imposible (pussy) (es imposible)
	mov contador_de_desplazamiento_BOSS, 0
	mov flag_movimiento_BOSS, 0
jmp no_hacer_NO_posicion_BOSS

mov_final_BOSS:
	call THELASTDANCE

no_hacer_NO_posicion_BOSS:
;-------------------------------------------

;-------------------------------------------

	cmp vida_BOSS, 0 ;lo comparas con la cantidad de veces que le pegaste
	je findelmalditoJuegoBOSS

;-------------------------------------------
;para sacar el fliquering

   call sacar_fliquering

;-------------------------------------------

	;Limpia la pantalla
	mov ah, 0Fh ;Get current video mode
	int 10h
	mov ah, 0  ;
	int 10h

jmp Game_Loop_BOSS

findelmalditoJuegoBOSS: ;No cambiar etiqueta en honor a cata

	call fin_masacre_BOSS

Hasta_que_ponganteclavalidaBOSS:

	mov ah, 8
	int 21h

	cmp al ,20h ;(space)
	je outatime_FINAL

jmp Hasta_que_ponganteclavalidaBOSS

outatime_FINAL:
	inc nivel_de_dificultad_BOSS
	jmp hora_de_aventura_BOSS
reinicio_nivel_dificultad_BOSS:
	mov al, 0

ret
FINAL_BOSS endp

colisionBalaFINAL proc

	push cx
	push si

	mov ah, ch
	mov al, cl

	mov cx, 26
Game_LoopCompBalaBOSS:
	cmp dl, al ;comparo las columnas
	je comparaRengBalaBOSS
	inc al ;sino comparo la proxima
loop Game_LoopCompBalaBOSS

	mov cx, 26
Game_LoopCompBalaIzqBOSS:
	cmp dl, al ;comparo las columnas
	je comparaRengBalaBOSS
	dec al ;sino comparo la proxima
loop Game_LoopCompBalaIzqBOSS

jmp nadaBala_EN_BOSS

comparaRengBalaBOSS:
	cmp dh, ah
	je choqueBalaBOSS
	dec ah
	cmp dh, ah
	je choqueBalaBOSS
	dec ah
	cmp dh, ah
	je choqueBalaBOSS
jmp nadaBala_EN_BOSS

choqueBalaBOSS:
	mov dh, 22   ;Pongo la bala en la fila original
	mov ah, 0 		;le mando un "flag" en ah si es 0 mata
	call contPuntaje_BOSS
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	mov cx, 4000
	mov bx, 15
	call sonido
	mov cx, 3500
	mov bx, 15
	call sonido
	mov cx, 3000
	mov bx, 15
	call sonido

	pop si
	pop cx
ret

	nadaBala_EN_BOSS:
	mov ah, 1 		;le mando un "flag" en ah si es 1 no mata

	pop si
	pop cx
ret
colisionBalaFINAL endp

movimiento_bala_BOSS proc
;compara si llega abajo de todo
	cmp dl, 25
	je bottom
jmp bajar_bala_boss

bottom:
	dec flag_bala_BOSS ;si llega, el flag vuelve a ser cero
jmp finalbottom

bajar_bala_boss:
	add dl, 1

finalbottom:

ret
movimiento_bala_BOSS endp

colisionBala_BOSS_con_JUGADOR proc

	push cx si
	;mov dh, reng_bala_BOSS
	;mov dl, col_bala_BOSS
	;mov ch, renglon_Jugador
	;mov cl, columna_Jugador
	;call colisionBala_BOSS_con_JUGADOR
	;mov reng_bala, dh

	mov al, cl
	mov ah, ch

	mov cx, 3
Game_LoopCompBala_con_jugador:
	cmp dl, al ;comparo las columnas
	je comparaRengBala_DEL_BOSS_conjugador
	inc al ;sino comparo la proxima
loop Game_LoopCompBala_con_jugador

	mov cx, 3
Game_LoopCompBalaGame_LoopCompBala_con_jugadorIzq:
	cmp dl, al ;comparo las columnas
	je comparaRengBala_DEL_BOSS_conjugador
	dec al ;sino comparo la proxima
loop Game_LoopCompBalaGame_LoopCompBala_con_jugadorIzq

jmp nadaBala_DEL_BOSS

comparaRengBala_DEL_BOSS_conjugador:
	cmp dh, ah
	je choqueBala_DEL_BOSS
jmp nadaBala_DEL_BOSS

choqueBala_DEL_BOSS:
	push dx bx
	mov dh, renglon_Jugador  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, columna_Jugador  ;en dl recibe la posicion Y
	mov bl, 4               ;en bl el color
	call imprime_Jugador
	pop bx dx

	mov cx, 25000
	mov bx, 40
	call sonido
	mov cx, 20000  ;tiene un poco de pausa para que te des cuenta que te dio
	mov bx, 40
	call sonido
	mov cx, 15000
	mov bx, 40
	call sonido

	dec vida_jugador
	cmp vida_jugador, 0
	je murio_jugador_BOSS
	jmp nadaBala_DEL_BOSS

murio_jugador_BOSS:
	call fin_BOSS
ret

	nadaBala_DEL_BOSS:

	pop si cx

ret
colisionBala_BOSS_con_JUGADOR endp

matar_Enemigo_FINAL proc

	mov bh, 0   ;para que no se siga imprimiendo en el proximo ciclo (bala)
	dec al ; VIDA DEL BOSS

	cmp al, 0
	je salir ; Fallecio el BOSS

	dec bl
	cmp bl, 0
	je esNegro
	jmp salir

	esNegro:
	mov bl, 0eh

salir:
ret
matar_Enemigo_FINAL endp

cartelFINAL_BOSS proc
	push si
	push cx
	push bx

	mov bl, 0fh

	cmp nivel_de_dificultad_BOSS, 0
	je cartel0
	cmp nivel_de_dificultad_BOSS, 1
	je cartel1
	cmp nivel_de_dificultad_BOSS, 2
	je cartel2
	jmp cartel3

cartel0:
	mov dh, 12 ;renglon
	mov dl, 27 ;columna
	mov ah, 2
	int 10h
	mov si, 0
empiezacartel0:
	cmp texto1[si], 24h
	je fincartel0
	mov al, texto1[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 04h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel0
fincartel0:
	mov ah, 00h
	int 16h
	mov vida_jugador, 4
	call imprime_Vidas
	jmp fin_carteles
;--------------
cartel1:
	mov dh, 12 ;renglon
	mov dl, 27 ;columna
	mov ah, 2
	int 10h
	mov si, 0
empiezacartel1:
	cmp texto2[si], 24h
	je fincartel1
	mov al, texto2[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 05h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel1
fincartel1:
	mov ah, 00h
	int 16h
	jmp fin_carteles
;--------------
cartel2:
	mov dh, 12 ;renglon
	mov dl, 29 ;columna
	mov ah, 2
	int 10h
	mov si, 0
empiezacartel2:
	cmp texto3[si], 24h
	je fincartel2
	mov al, texto3[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 05h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel2
fincartel2:
	mov ah, 00h
	int 16h

	mov dh, 14 ;renglon
	mov dl, 37 ;columna
	mov ah, 2
	int 10h
	mov si, 0
empiezacartel22:
	cmp texto4[si], 24h
	je fincartel22
	mov al, texto4[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 05h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel22
fincartel22:
	mov ah, 00h
	int 16h
	jmp fin_carteles
;--------------
cartel3:
	mov dh, 12 ;renglon
	mov dl, 38 ;columna
	mov ah, 2
	int 10h

	mov si, 0
empiezacartel3:
	cmp texto5[si], 24h
	je fincartel3
	mov al, texto5[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 05h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel3
fincartel3:
	mov ah, 00h
	int 16h
	jmp fin_carteles

fin_carteles:
	;Limpia la pantalla
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	pop bx
	pop cx
	pop si
ret
cartelFINAL_BOSS endp

fin_masacre_BOSS proc
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	call imprimeCoronaGlitch

	mov bh, 0 ;pagina
	mov dh, 10 ;renglon
	mov dl, 35 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensajeBOSS
	int 21h
; COLOR VERDE:
	mov dh, 15 ;renglon
	mov dl, 37 ;columna
	mov bl, 2
	mov cx, 6
	mov al, 20
	call imprime
; ---------------
	mov dh, 15 ;renglon
	mov dl, 37 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoScore
	int 21h

	mov dh, 16 ;renglon
	mov dl, 38 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, scoreFINAL_BOSS
	int 21h

	mov dh, 18 ;renglon
	mov dl, 30 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensajeBOSS2
	int 21h

	call victoria_magistral_cursed

ret
fin_masacre_BOSS endp

THELASTDANCE proc

BOSS_sigue_bajando:
	mov dh, renglon_BOSS
	mov dl, columna_BOSS
	mov bl, color_BOSS
	call imprimeEnemigoFINAL

	mov cl, 04h
   call retard

	;Limpia la pantalla
	mov ah, 0Fh ;Get current video mode
	int 10h
	mov ah, 0
	int 10h

	cmp renglon_BOSS, 11
	je BOSS_para
	inc renglon_BOSS
	jmp BOSS_sigue_bajando

BOSS_para:
	mov dh, renglon_BOSS
	mov dl, 27 ;medio de la pantalla
	mov bl, color_BOSS
	call imprimeEnemigoFINAL
	mov cl, 03h
   call retard
   mov ah, 00h
	int 16h

   mov dh, 14 ;renglon
	mov dl, 36 ;columna
	mov ah, 2
	mov bl, 0fh
	int 10h
	mov si, 0
	; texto6 db 244,"º 4&#e. ",24h
	; texto7 db "∑ ª#J€. ",24h
empiezacartel6:
	cmp texto6[si] , 24h
	je fincartel6
	mov al, texto6[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 04h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel6
fincartel6:

	mov ah, 00h
	int 16h

	mov dh, 16 ;renglon
	mov dl, 35 ;columna
	mov ah, 2
	int 10h
mov si, 0
empiezacartel7:
	cmp texto7[si], 24h
	je fincartel7
	mov al, texto7[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 04h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartel7
fincartel7:

	mov ah, 00h
	int 16h

	mov dh, 18 ;renglon
	mov dl, 28 ;columna
	mov ah, 2
	int 10h
mov si, 0
empiezacartelError:
	cmp si, 24
	je fincartelError
	mov al, ERRORText[si] ;forma/figura a imprimir
	mov cx, 1
	call imprime
	inc dl
	inc si
	mov cl, 05h

	push cx bx
	mov cx, 4500 ; TONO
	mov bx, 15   ; DURACION
	call sonido
	pop bx cx

   call retard
jmp empiezacartelError
fincartelError:
	mov ah, 00h
	int 16h
	call fin_FINAL_POSTA

ret
THELASTDANCE endp

fin_BOSS proc
;CUANDO NOS MATA EL BOSS
	push ax bx cx dx si

	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	mov dh, 12 ;en dh recibe la posicion Y } Para posicionamiento del cursor
	mov dl, 35 ;en dl recibe la posicion X  }
	mov bl, 4 ;en bl el color
	mov cx, 1 ;cantidad de veces que se imprime(Los imprime para la derecha)
	mov si, 0
ImprimirGameOverBOSS:
	cmp si, 24
	je finImprimirGameOverBOSS
	mov al, ERRORText[si] ;forma/figura a imprimir
	call imprime
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	inc si
jmp ImprimirGameOverBOSS

finImprimirGameOverBOSS:
	mov cx, 0
	push si
; COLOR BLANCO P/ TEXTO
	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov bl, 0fh
	mov cx, 11
	mov al, 0
	call imprime
	add dh, 2
	mov cx, 11
	call imprime
	add dh, 1
	add dl, 4
	mov al, scoreBOSS
	xor ah, ah
	mov si, ax
	mov al, 0
	mov cx, si
	call imprime
	pop si
; ------------------

	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov ah, 2
	int 10h
	mov cx, 7000 ; TONO
	mov bx, 20   ; DURACION
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 20
	call sonido

	mov ah, 9
	lea dx, GameOverText
	int 21h

	mov dh, 11 ;renglon
	mov dl, 31 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 7000
	mov bx, 20
	call sonido

	mov dh, 12 ;renglon
	mov dl, 36 ;columna
	mov ah, 2
	int 10h

	mov al, 1
	call contPuntaje_BOSS

	mov ah, 9
	lea dx, scoreFINAL_BOSS
	int 21h

	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 100
	call sonido
	mov cx, 19000
	mov bx, 250
	call sonido

	mov dh, 15 ;renglon
	mov dl, 26 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, GameOverText2
	int 21h

	mov ax, 4c00h
	int 21h

fin_BOSS endp

fin_FINAL_POSTA proc

	push ax bx cx dx si

	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	mov dh, 12 ;en dh recibe la posicion Y } Para posicionamiento del cursor
	mov dl, 35 ;en dl recibe la posicion X  }
	mov bl, 4 ;en bl el color
	mov cx, 1 ;cantidad de veces que se imprime(Los imprime para la derecha)
	mov si, 0
ImprimirERRORTEXT:
	cmp si, 24
	jne cicloError
	jmp finImprimirERRORTEXT
cicloError:
	mov al, ERRORText[si] ;forma/figura a imprimir
	call imprime

	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	inc bl
	call animacionMuerte
	; inc dl
	inc si
jmp ImprimirERRORTEXT

finImprimirERRORTEXT:
	mov cx, 0
	push si
; COLOR BLANCO P/ TEXTO
	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov bl, 0fh
	mov cx, 12
	mov al, 0
	call imprime
	add dh, 2
	mov cx, 12
	call imprime
	add dh, 1
	add dl, 4
	mov al, scoreBOSS
	xor ah, ah
	mov si, ax
	mov al, 0
	mov cx, si
	call imprime
	pop si
; ------------------

	mov dh, 9 ; posicion Y
	mov dl, 32 ; posicion X
	mov ah, 2
	int 10h
	mov cx, 7000 ; TONO
	mov bx, 20   ; DURACION
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 20
	call sonido

	mov ah, 9
	lea dx, GameWin
	int 21h

	mov dh, 11 ;renglon
	mov dl, 31 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscoreWin
	int 21h

	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 7000
	mov bx, 20
	call sonido

	mov dh, 12 ;renglon
	mov dl, 36 ;columna
	mov ah, 2
	int 10h

	mov al, 1
	call contPuntaje_BOSS

	mov ah, 9
	lea dx, scoreFINAL_BOSS
	int 21h

	mov cx, 7500
	mov bx, 20
	call sonido
	mov cx, 8000
	mov bx, 20
	call sonido
	mov cx, 8500
	mov bx, 20
	call sonido
	mov cx, 9000
	mov bx, 20
	call sonido
	mov cx, 9500
	mov bx, 20
	call sonido
	mov cx, 10000
	mov bx, 100
	call sonido
	mov cx, 19000
	mov bx, 250
	call sonido


	mov ax, 4c00h
	int 21h

	pop si dx cx bx ax

ret
fin_FINAL_POSTA endp

contPuntaje_BOSS proc

	push dx ax bx

	mov dl, bl

	cmp al, 1
	je noHayHit

sumoHit:
	mov dl, scoreBOSS
	xor dh, dh
	mov bx, dx
	mov scoreFINAL_BOSS[bx], 39h
	inc scoreBOSS
noHayHit:

	pop bx ax dx

ret
contPuntaje_BOSS endp

imprimeEnemigoFINAL proc
; dl: columna  -  dh: renglon
;          ██  ██  ██
;        ██████████████
;      ████  ██  ██  ████
;      ██████  ██  ██████
;    ██████████████████████
;  ██    ██  ██  ██  ██    ██
;      ██              ██
; MIDE: 26 columnas - 7 renglones
; piecitos: columnas 4,5 y 20,21
	push cx

	mov al, 219
	mov cx, 2
	call imprime
	add dl, 6
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime
	add dl, 6
	mov cx, 2
	call imprime

	dec dh
	sub dl, 22
	mov cx, 22
	call imprime

	dec dh
	add dl, 2
	mov cx, 6
	call imprime
	add dl, 8
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 6
	call imprime

	dec dh
	sub dl, 12
	mov cx, 4
	call imprime
	add dl, 6
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 4
	call imprime

	dec dh
	sub dl, 12
	mov cx, 14
	call imprime

	dec dh
	add dl, 2
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime
	add dl, 4
	mov cx, 2
	call imprime

	add dh, 6
	sub dl, 12
	mov cx, 2
	call imprime
	add dl, 16
	mov cx, 2
	call imprime

	pop cx

ret
imprimeEnemigoFINAL endp

victoria_magistral_cursed proc
; IN: CX = tone, BX = duration
	push cx bx

	mov cx, 7125
	mov bx, 120
	call tonos
	mov cx, 7500
	mov bx, 10
	call tonos
	mov cx, 7125
	mov bx, 10
	call tonos
	mov cx, 7500
	mov bx, 10
	call tonos
	mov cx, 5625
	mov bx, 120
	call tonos
	mov cx, 7500
	mov bx, 10
	call tonos
	mov cx, 4750
	mov bx, 180
	call tonos
	mov cx, 7500
	mov bx, 10
	call tonos
	mov cx, 5625
	mov bx, 100
	call tonos
	mov cx, 7500
	mov bx, 10
	call tonos
	mov cx, 4750
	mov bx, 350
	call tonos

	pop bx cx

ret
victoria_magistral_cursed endp

tonos proc ;idem 'sonido proc' pero con int

	push ax

	xor ax, ax
	int 80h

	pop ax
ret
tonos endp

;=====================================================================================================================(cosas del boss)

;sacar_fliquering se usa en el main y en el boss
sacar_fliquering proc
;hay que sincronizar la ejecución del programa con el período de "vertical retrace" del monitor
	push dx ax

wait_For_New_VR:
	mov dx, 3dah      ; DX se carga con el puerto de entrada para el registro de estado de entrada #1 del adaptador VGA. devuelve en valor en al
							; Esperar a que el bit 3 sea cero (no en retrace vertical).
esperar_a_que_termine:
 	in al, dx         			; Leer el estado actual del registro de entrada #1 en AL.
 	test al, 08h      			; Probar el bit 3 (vertical retrace bit).
 	jnz esperar_a_que_termine  ; Si el bit 3 está en 1 (el retrace vertical está en progreso), salta de nuevo a esperar_a_que_termine.

; Esperar a que el bit 3 sea uno (en retrace vertical).
esperar_al_nuevo:
	in al, dx         		; Leer el estado actual del registro de entrada #1 en AL.
	test al, 08h      		; Probar el bit 3 (vertical retrace bit).
	jz esperar_al_nuevo     ; Si el bit 3 está en 0 (no en retrace vertical), salta de nuevo a esperar_al_nuevo.

	pop ax dx

ret
sacar_fliquering endp

end
