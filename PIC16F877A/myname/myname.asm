list P=16F877A
include <P16F877A.inc>

val1 EQU 0x30
val2 EQU 0x31

	org 0
	goto init
	org 5

init 
	clrf PORTB
	clrf PORTD
	bsf STATUS,RP0
	bcf STATUS,RP1
	clrf TRISB
	clrf TRISD; seleccion del puerto B y D como salidas
	bcf STATUS,RP0

start
	call LCD_init
	call message_1
	call LCD_line2
	call message_2
	goto start

message_1
	movlw 'M'
	movwf PORTB
	call LCD_send
	movlw 'I'
	movwf PORTB
	call LCD_send
	movlw 'C'
	movwf PORTB
	call LCD_send
	movlw 'R'
	movwf PORTB
	call LCD_send
	movlw 'O'
	movwf PORTB
	call LCD_send
	movlw 'C'
	movwf PORTB
	call LCD_send
	movlw 'O'
	movwf PORTB
	call LCD_send
	movlw 'N'
	movwf PORTB
	call LCD_send
	movlw 'T'
	movwf PORTB
	call LCD_send
	movlw 'R'
	movwf PORTB
	call LCD_send
	movlw 'O'
	movwf PORTB
	call LCD_send
	movlw 'L'
	movwf PORTB
	call LCD_send
	movlw 'A'
	movwf PORTB
	call LCD_send
	movlw 'D'
	movwf PORTB
	call LCD_send
	movlw 'O'
	movwf PORTB
	call LCD_send
	movlw 'R'

	return

message_2
	movlw 'C'
	movwf PORTB
	call LCD_send
	movlw 'E'
	movwf PORTB
	call LCD_send
	movlw 'S'
	movwf PORTB
	call LCD_send
	movlw 'A'
	movwf PORTB
	call LCD_send
	movlw 'R'
	movwf PORTB
	call LCD_send

	return

; inicializar led
LCD_init
	bcf PORTB,0
	movlw 0x01; clear screen
	movwf PORTB
	call LCD_command
	movlw 0x0C; select line 1
	movwf PORTB
	call LCD_command
	movlw 0x3C
	movwf PORTB
	call LCD_command
	bsf PORTD,0; RS=1 modo dato
	return

; send commands
LCD_command
	bsf PORTD,1; pone el enable en 1
	call delay; tiempo de espera
	call delay
	bcf PORTD,1; enable en 0
	call delay
	return

LCD_send
	bsf PORTD,0
	call LCD_command
	return

LCD_line2
	bsf PORTD,0
	movlw 0xC0
	movwf PORTB
	call LCD_command

delay
	movlw .255
	movwf val2

loop
	movlw .255
	movwf val1

loop2
	decfsz val1,1
	goto loop2
	decfsz val2,1
	goto loop
	return

END