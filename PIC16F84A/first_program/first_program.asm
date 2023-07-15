list P=PIC16F84A
#include<P16F84A.inc>
; linea 1 -> indica que se esta� utilizando un microcontrolador de la familia PIC16F84A
; linea 2 -> importa el archivo de inclusion necesario para definir los registros y las constantes específicas del microcontrolador PIC16F84A
	org 0; Establece la ubicación de inicio del programa en la dirección de memoria 0
	bsf STATUS, RP0; Establece el bit RP0(Registro de Selección de Banco) en el registro STATUS. RP0 se utiliza para seleccionar entre los bancos de memoria de registros. Al establecerlo en 1, nos aseguramos de que estemos trabajando en el banco 1. 
	bsf TRISA, 1; Este comando establece el bit 1 del registro TRISA(Registro de Configuración de Dirección) en 1, TRISA se utiliza para configurar las direcciones de los pines del puerto A como entradas o salidas. Al establecer el bit 1 en 1, estamos configurando el pin RA1 como una salida. 
	clrf PORTB; Este comando limpia el contenido del registro PORTB. PORTB es el puerto de E/S B, que en este caso se utiliza para controlar la salida de datos a los pines del puerto B. 
	bcf TRISB, 1; Este comando limpia el bit 1 de trabajo del registro TRISB. Al hacerlo, configuramos el pin RB1 como una salida.
	bcf STATUS, RP0; Este comando limpiar el bit RP0 en el registro STATUS, lo que nos asegura que estemos trabajando en el banco 0

; esta subrutina TURN_ON es una estructura en bucle
TURN_ON
	btfss PORTA, 1; Verifica si el bit 1 del registro PORTA (pin RA1) está en 0 mediante el comando btfss (skip si el bit está configurado)
	goto TURN_ON; Si el bit esta� en 0 salta al bucle TURN_ON nuevamente y continúa verificando
	bsf PORTB,1; Si el bit esta� en 1, establece el bit 1 del registro PORTB (pin RB1) en 1 mediante el comando bsf (set bit)
	goto TURN_OFF; y luego salta a la etiqueta TURN_OFF

; Similar a la subrutina anterior
TURN_OFF
	btfsc PORTA, 1; Verifica si el bit 1 del registro PORTA (pin RA1) está en 1 mediante el comando btfsc (skip si el bit está despejado)
	goto TURN_OFF; Si el bit está en 1 salta al bucle TURN_OFF nuevamente y continúa verificando
	bcf PORTB, 1; Si el bit está eb cero limpira el bit 1
	goto TURN_ON; y regresa a TURN_ON
end