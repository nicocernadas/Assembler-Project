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
;El juego en total contiene 3579 lineas de codigo, todo en Assembly. Esta es una breve muestra de lo realizado, el juego es totalmente funcional y jugable.
;El codigo completo no esta disponible.