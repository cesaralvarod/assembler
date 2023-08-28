list P=16F877A
include <P16F877A.inc>

;__config _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

cblock 0x0c
	; registros o variables
endc

#DEFINE 	TIME 	d'100'
#DEFINE 	LED		PORTD,0

; TMR0 -> 0 a 255
; TMR = 256 - (tiempo_deseado *FOSC)/(prescaler*4)

org 	0
goto 	main

org 	0x04
goto 	tmr0_int

main
	; seleccionamos banco 1
	bsf	 	STATUS,RP0
	bcf 	STATUS,RP1

	; configurando registro OPTION_REG
	bcf 	OPTION_REG,T0CS			; Internal instruction cycle
	bcf 	OPTION_REG,T0SE
	bcf		OPTION_REG,PSA			; prescaler
	; configurando prescaler -> 1:32	
	bsf 	OPTION_REG,PS2
	bcf		OPTION_REG,PS1
	bcf 	OPTION_REG,PS0

	; configurando pines
	bcf 	TRISD,0
	
	; saliendo al banco 0
	bcf 	STATUS,RP0

	; TMR0 <- d'100'
	movlw	TIME
	movwf 	TMR0
	
	; configurando interrupciones
	bsf 	INTCON,GIE
	bsf		INTCON,TMR0IE
	bcf		INTCON,TMR0IF			; flag
	
	; configurando pines del PORTD
	bcf 	PORTD,0
start
	goto 	start
tmr0_int
	movlw 	TIME
	movwf 	TMR0
	BTFSC 	LED
	bsf 	LED
	goto 	turn_off
	bsf 	LED
	goto 	int_end
turn_off
	BCF 	LED
int_end
	bcf 	INTCON,TMR0IF
	retfie
end