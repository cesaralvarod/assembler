; Configuración del PIC 16F877A
list p=16F877A
include <p16F877A.inc>


; Definición de registros
cblock 0x0C
    contador
    segundos
    minutos
    horas
    unidades
    decenas
endc

; Inicialización del PIC
org 0x00
    goto Inicio

; Función para transformar un dígito decimal a su representación en el display de 7 segmentos
; Parámetro: Registro WREG, Devuelve: Registro WREG
Bin2_7seg:
    ; Tabla de conversión de dígitos a códigos de 7 segmentos
    ; Los valores de la tabla deben estar en el orden de 0, 1, 2, ..., 9
    ; Asegúrate de que los valores sean correctos para tu tipo de display de 7 segmentos
    movlw 0x3F   ; 0 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x06   ; 1 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x5B   ; 2 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x4F   ; 3 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x66   ; 4 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x6D   ; 5 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x7D   ; 6 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x07   ; 7 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x7F   ; 8 en código de 7 segmentos
    cpfseq WREG
    return

    movlw 0x67   ; 9 en código de 7 segmentos
    cpfseq WREG
    return

    ; Si WREG no coincide con ningún dígito (0 a 9), retorna 0xFF para mostrar un segmento apagado
    movlw 0xFF
    return
EndBin2_7seg:

; Rutina para esperar un pequeño retardo
EsperarRetardo:
    movlw D'100'
    call EsperarRetardoLoop
    return

EsperarRetardoLoop:
    decfsz WREG, F
    goto EsperarRetardoLoop
    return

; Rutina de interrupción del Timer0 para el reloj
ISR:
    movlw 61   ; Valor inicial del TMR0 para interrupción cada 50 ms
    movwf TMR0
    incf contador, F

    movlw 20   ; Aproximadamente 1 segundo (20 x 50 ms)
    subwf contador, W
    btfss STATUS, Z
    return

    clrf contador   ; Reiniciar contador cada segundo

    incf segundos, F
    movlw 60
    subwf segundos, W
    btfss STATUS, Z
    return

    clrf segundos

    incf minutos, F
    movlw 60
    subwf minutos, W
    btfss STATUS, Z
    return

    clrf minutos

    incf horas, F
    movlw 24
    subwf horas, W
    btfss STATUS, Z
    return

    clrf horas
    return

; Inicio del programa principal
Inicio:
    ; Configuración de puertos y registros
    bsf STATUS, RP0   ; Seleccionar el banco 1 de registros
    clrf TRISA        ; Puerto A como salida
    movlw 0x80
    movwf TRISB       ; RB7 como entrada, RB<6:0> como salidas
    movlw 0x80
    movwf TRISC       ; RC7 como entrada, RC<6:0> como salidas
    clrf TRISD        ; Puerto D como salida
    bcf STATUS, RP0   ; Volver al banco 0 de registros

    clrf contador
    clrf segundos
    clrf minutos
    clrf horas
    clrf unidades
    clrf decenas

    movlw 0x00
    movwf PORTA
    movwf PORTB
    movwf PORTC
    movwf PORTD

    ; Configuración del Timer0
    movlw 0x67   ; 4 MHz de frecuencia de oscilador, prescaler 1:256
    movwf OPTION_REG

    ; Habilitar interrupciones globales y la interrupción del Timer0
    bsf INTCON, GIE
    bsf INTCON, T0IE

BuclePrincipal:
    ; Leer el estado de RB7 para activar/desactivar el reloj
    btfsc PORTB, 7
    goto RelojDesactivado

    ; Reloj activado, mostrar la hora en los displays
    movf horas, WREG
    call Bin2_7seg
    movwf PORTA

    movf minutos, WREG
    call Bin2_7seg
    movwf PORTC

    movf segundos, WREG
    call Bin2_7seg
    movwf PORTD

    ; Esperar 1 segundo
    call EsperarRetardo

    goto BuclePrincipal

RelojDesactivado:
    ; Reloj desactivado, apagar los displays
    clrf PORTA
    clrf PORTC
    clrf PORTD

    goto BuclePrincipal

; Fin del programa
end

