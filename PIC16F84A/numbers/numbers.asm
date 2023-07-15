LIST P=16F84A
INCLUDE <P16F84A.inc>
	CBLOCK 0X0C; almacena counter
	counter; bloque de memoria para almacenar el valor actual del contador
	ENDC
		ORG 0; inicio del programa en direccion de memoria 0
		bsf STATUS,RP0; cambia al banco 1
		movlw 0x00; carga el valor de 0x00 en el registro de trabajo (W)s
		movwf TRISB; mueve contenido de W a TRISB, configurando PORTB como salidas
		bsf	  TRISA,RA0; set RA0 en STATUS en 0, configurando RA0 como entrada
		bcf   STATUS,RP0; establece RP0 de STATUS en 0, volviendo al banco de registros 0
		clrf  loop; limpia etiqueta loop para su posterior uso
		clrf  PORTB; limpia puerto B, establece todos los pines en 0 o nivel bajo
; etiqueta del bucle principal
loop
; espera que se presione RA0 (espera que RA0 del PORTA sea 0)
pul1
	btfsc	PORTA,RA0; salta linea si RA0 es 0. Si RA0 es presionado, el programa continua a la siguiente etiqueta
	goto 	pul1; vuelve a la etiqueta pul1 para esperar que RA0 sea presionado y liberado
; espera que se suelte RA0 (espera que RA0 de PORTA sea 1)
pul2
	btfss	PORTA,RA0; salta linea si RA0 de PORTA es 1 . Si RA0 esta suelto (0), el programa continua
	goto 	pul2; vuelve a la etiqueta pul2 para esperar que RA0 sea liberado (0)
	movf	counter,W; mueve contenido de counter a W
	call	TABLE; llama a la subrutina TABLE para convertir el valor de counter en segmentos para mostrarlo en el PORTB
	movwf	PORTB; mueve el contenido de W a PORTB
	incf	counter,F; incrementa el valor de counter en 1
	movlw	.10; carga el valor de 10 en el registro W
	subwf	counter,W; resta el valor de counter a 10 y guarda el resultado en W
	btfsc	STATUS,Z; salta si el resultado de la operacion anterior es cero (si counter alcanzo el valor de 10)
	clrf	counter; limpia counter, lo establece en 0 si el valor alcanzo 0
	goto 	loop; salta a loop para reiniciar el bucle y esperar que el RA0 se presione
TABLE
	addwf	PCL,F; suma el contenido de W al registro PCL (program counter low), realizando un salto a la direccion de memoria correspondiente para mostrarlo en los segmentos.
	DT		0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67; datos de la tabla de segmento. Cada numero del 1 al 9 tiene un valor hexadecimal correspondiente para mostrarlo en los segmentos
END