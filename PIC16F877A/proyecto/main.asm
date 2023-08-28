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

LIST P=16F877A
INCLUDE <P16F877A.INC>

;__config _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

CBLOCK 0x0C
	; VARIABLES
	DELAY_COUNTER		; variable para el contador del multiplexor
ENDC

; CONSTANTES
#DEFINE 	DISPLAY_UNITS	PORTB,0
#DEFINE 	DISPLAY_TENS	PORTB,1

	ORG 	0
	GOTO	MAIN

MAIN
	; ir al banco 1
	BSF		STATUS,RP0
	BCF		STATUS,RP1
	
	BSF 	TRISA,0
	BCF		TRISB,0
	BCF 	TRISB,1

	; todos los pines de PORTD son salidas
	CLRF 	TRISD

	; ir al banco 0
	BCF 	STATUS, RP0

	; limpiar pines del PORTD
	CLRF 	PORTD
	
	BCF 	PORTA,0

	BCF		DISPLAY_UNITS		; RB0=0
	BSF		DISPLAY_TENS		; RB1=1, primero se mostraran las decenas

	; LIMPIAMOS VARIABLES
	CLRF 	DELAY_COUNTER

	; asignamos valor a DELAY_COUNTER
	MOVLW 	.255
	MOVWF	DELAY_COUNTER

	MOVLW 0x0c
	MOVWF NUMBER

START
	CALL 	BIT8_CDU

	; imprime las decenas
	MOVF	DEC,W
	CALL 	BIN2_DISPLAY
	MOVWF 	PORTD
	
	; DELAY
	CALL DELAY_MS
	
	; cambia el RB1=0 y RB0=1 para mostrar unidades
	MOVLW 	0x01
	MOVWF	PORTB
	
	; delay
	CALL 	DELAY_MS

	; imprime las unidades
	MOVF 	UNI,W				; carga en NUMBER en W
	CALL 	BIN2_DISPLAY
	MOVWF 	PORTD
	
	; cambia el RB1=1y RB=0 para mostrar las decenas
	MOVLW 	0x02
	MOVWF 	PORTB

	CALL DELAY_MS

	GOTO 	START				; vuelve al inicio

INCREMENT
	INCF 	NUMBER,F
	MOVLW	.100
	SUBWF 	NUMBER,W
	BTFSC	STATUS,Z
	CLRF 	NUMBER
	RETURN

; retardo
DELAY_MS
	MOVLW 	D'250'
	MOVWF 	DELAY_COUNTER

DELAY_LOOP
	DECFSZ 	DELAY_COUNTER,F
	GOTO 	DELAY_LOOP
	RETURN

RESET_DELAY
	MOVLW 	.255
	MOVWF 	DELAY_COUNTER
	RETURN

BIN2_DISPLAY
	ADDWF 	PCL,F
	DT 		0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

INCLUDE <convertir.inc>
END