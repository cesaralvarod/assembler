list P=16F84A
include <P16F84A.inc>

cblock 0x0c
	counter;
	val1;
	val2;
endc

org 0;

bsf STATUS, RP0; banco 1

bsf TRISA, 0; RA0 como entrada

movlw b'00000000'; RB0-RB7 como salida
movwf TRISB

bcf STATUS, RP0; banco 0

; limpiamo
clrf PORTB
clrf counter
clrf val1
clrf val2

main:
	btfss PORTA, 0
	goto main
	goto loop

loop:
	call TABLE
	movwf PORTB
	incf counter, W
	movwf counter
	call delay
	goto loop

TABLE
	movf counter, W
	addwf PCL, F
	dt b'00000001', b'00000010', b'00000100', b'00001000', b'00010000', b'00100000', b'01000000', b'10000000'
	; dt 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
	;DT		0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

delay
	movlw .255
	movwf val1
loop2
	movlw .255
	movwf val2
loop3
	decfsz val1,1
	goto loop3
	decfsz val2,1
	goto loop2
	return

end