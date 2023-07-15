; incluyendo libreria del PIC
list P=16F84A
include <P16F84A.inc>; el procesador

org 0

bsf STATUS,RP0; me voy al banco 1
bcf TRISB,6; configurando como salida el pin 6 RB6
bcf STATUS,RP0; devuelta al banco 0

; subrutina main para crear un bucle
main:
	bsf PORTB,6; pongo a 1 logico el pin 6 del puerto B
	goto main
end