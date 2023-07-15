; incluyendo libreria del PIC
list P=16F84A
include <P16F84A.inc>; cargar procesador

org 0; ubicacion de inicio del programa en la direccion de memoria 0

bsf STATUS,RP0;		me dirijo al banco 1 donde esta el registro TRIS

bsf TRISA, 0; 		configurar el pin 0 del puerto A como ENTRADA

clrf PORTB; 		limpiamos todos los bits del puerto B

;bcf TRISB, 0;		configurar el pin 0 del puerto B como SALIDA

movlw b'0000000'; 	lo mismo de arriba pero con registros
movwf TRISB;		todos los pines del PORTB seran configurados como salida

bcf STATUS, RP0;	volvemos al banco 0

main:
	movlw b'00001111'; 	cargar el valor de 0000111 en la carga w
	movwf PORTB;		coloca el valor de carga del registro w en el PORTB, esto se interpreta:
	;	pin 7 del puerto B = 0 logico
	; 	pin 6 del puerto B = 0 logico
	;	pin 5 del puerto B = 0 logico
	;	pin 4 del puerto B = 0 logico
	; 	pin 3 del puerto B = 1 logico
	; 	pin 2 del puerto B = 1 logico
	; 	pin 1 del puerto B = 1 logico
	; 	pin 0 del puerto B = 1 logico
	goto main; 		para que se haga bucle
end