list P=PIC16F84A
#include<P16F84A.inc>
    org 0;
    bsf STATUS,RP0;
    bsf TRISA,1;
    clrf PORTB;
    bcf TRISB,1;
    bcf STATUS,RP0;

TURN_ON
    btfss PORTA,1;
    goto TURN_ON;
    bsf PORTB,1;
    goto TURN_OFF;

TURN_OFF
    btfsc PORTA,1;
    goto TURN_OFF;
    bcf PORTB,1;
    goto TURN_ON;
END