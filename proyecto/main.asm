;--------------------------------
; DISPLAY
	; 3F -> 0111111 -> 0
	; 06 ->	0000110 -> 1
	; 5B -> 1011011 -> 2
	; 4F -> 1001111 -> 3
	; 66 -> 1100110 -> 4
	; 6D -> 1101101 -> 5
	; 7D -> 1111101 -> 6
	; 07 -> 0000111 -> 7
	; 7F -> 1111111 -> 8
	; 67 -> 1100111 -> 9
;---------------------------------

; configuracion del pic
list P=16F877A
include <P16F877A.inc>

; definicion de registros
cblock 0x0c
	counter		; registro para el contador
	seconds		; registro para los segundos
	minutes		; registro para los minutos
	hours		; registro para las horas
	units		; registro para las unidades
	tens		; registro para las decenas
	temp		; registro temporal
endc

; variables definidas
#define BTN_MINUTES PORTC,7 

; inicializacion del pic
org 0x00
goto main

main:
	; configuracion de puertos
	bsf STATUS, RP0		; seleccionar el banco 1
	
	movlw b'00000'
	movwf TRISA			; todos los pines del PORTA como salida
	
	bcf TRISE,0			; RE0 como salida

	movlw b'10000000'	; solo RB7 como entrada
	movwf TRISB			; configurar PORTB

	movlw b'10000000'	; solo RC7 como entrada
	movwf TRISC			; configurar PORTC

	movlw b'10000000'	; solo RD7 como entrada
	movwf TRISD			; configurar PORTD

	bcf STATUS, RP0		; retornamos al banco 0

	; dando valores a los pines de los puertos: A, B, C, D, E
	movlw 0x00			; valor 0 a todos los pines
	movwf PORTA
	movwf PORTB
	movwf PORTC
	movwf PORTD
	movwf PORTE

	; habilitar interrupciones globales y la interrupción del Timer0
    bsf INTCON, GIE
    bsf INTCON, T0IE

	; limpiamos variables
	clrf counter
	clrf seconds
	clrf minutes
	clrf hours
	clrf units
	clrf tens

main_loop:
    call display_minutes2
	goto main_loop

display_minutes:
	return

display_minutes2:
	movf minutes, W
    call bin2_display
	movwf PORTD
	return

clock_off:
	; limpia los pines de los puertos
	clrf PORTA
	clrf PORTB
	clrf PORTC
	clrf PORTD
	clrf PORTE
	
	goto main_loop		; regresa a la funcion main

; tabla para convertir binarios en los segmentos de los display
bin2_display:
	addwf PCL,F		; suma el contenido del registro W al registro PCL (program counter low)
	dt 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

bin2_display_RE0:
	movwf temp
	dt 0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x00,0x01,0x01
end