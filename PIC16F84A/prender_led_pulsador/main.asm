list P=16F84A
include <P16F84A.inc>

org 0;

bsf STATUS, RP0; 	BANK 1

bsf TRISA, 1; 		RA1 INPUT
clrf PORTB;			CLEAN PORTB
bcf TRISB, 1;		RB1 OUTPUT

bcf STATUS, RP0; BANK 0

;	RB0 TO RB7 = 0
movlw b'00000000'
movwf PORTB

; MAIN -> TURN ON RB0
main:
	; btfsc -> Bit Test F, Skype if is Clear (0)
	; btfss -> Bit Test F, Skype if is Set (1)
	btfss PORTA, 1; 	IF RA1==1 -> SKYPE LINE
	goto turnoff
	bsf PORTB, 1;		RB1 SET 1
	goto main

; TURNOFF -> TURN OFF RB0
turnoff:
	btfsc PORTA, 1;		IF RA1==0 -> SKYPE LINE
	goto main
	bcf PORTB, 1;		RB0 SET 0
	goto turnoff
end