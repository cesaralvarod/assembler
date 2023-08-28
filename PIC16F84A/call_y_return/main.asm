list P=16F84A
include <P16F84A.inc>

bsf STATUS, RP0

movlw b'00010001'
movwf TRISA
clrf TRISB

bcf STATUS, RP0

;--------------------------------------------------
; una funcion que la llamamos con un CALL siempre tiene que tener un RETURN
; ojo con la pila (last in first out) para el llamado de subrutinas
; para el pic 16F84A tiene 8 niveles de pila
; este pic no cuenta con sobredesbordamiento de pila
;----------------------------------------------------

clrf PORTB; 	limpiar todo el puerto B

; subrutina main
main:
	btfsc PORTA, 0; skip if clear
	call turnon1
	btfsc PORTA, 4; skip if clear
	call turnon2
	call turnoffglobal
	goto main

turnon1:
	bsf PORTB, 0
	return

turnon2:
	bsf PORTB, 1
	return

turnoffglobal:
	btfss PORTA, 0
	call turnoff1
	btfss PORTA, 4
	call turnoff2
	return

turnoff1:
	bcf PORTB, 0
	return

turnoff2:
	bcf PORTB, 1
	return

end