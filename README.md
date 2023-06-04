# Lenguaje ensamblador

- El único lenguaje que entienden los microcontroladores es el código máquina formado por ceros y unos del sistema binario.
- El lenguaje ensamblador expresa las instrucciones de una forma más natural al hombre a la vez que muy cercana al microcontrolador, ya que cada una de esas instrucciones se corresponse con otra en código máquina.
- El lenguaje ensamblador trabaja con nemónicos, que son grupos de caracteres que simbolizan las órdenes o tareas a realizar.
- La traducción de los nemónicos a código máquina entendible por el microcontrolador la lleva a cabo un programa ensamblador.
- El programa escrito en lenguaje ensamblador se denomina código fuente (\*.asm). El programa ensamblador proporciona a partir de este fichero el correspondiente código máquina, que suele tener la extensión \*.hex.

## El código fuente

- Está compuesto por una sucesión de líneas de texto.
- Cada línea puede estructurarse en hasta cuatro campos o columnas separados por uno o más espacios o tabulaciones entre sí.
  - Campo de etiquetas: Expresiones alfanuméricas escogidas por el usuario para identificar unqa determinada línea. Todas las etiquetas tienen asignado el valor de la posición de memoria en las que se encuentra el código al que acompañan.
  - Campo de código: Corresponde al nemónico de una instrucción, de una directiva o de una llamada a macro.
  - Campo de operandos y datos. Contiene los operandos que precisa el nemónico utilizado. Según el código, puede haber dos, uno o ningún operando.
  - Campo de comentarios. Dentro de una línea, todo lo que se encuentre a continuación de un punto y coma (;) será ignorado por el programa ensamblador y considerado como comentario.

### Campo de código

Puede corresponder ese código a:

- Instrucciones: son aquellos nemónicos que son convertidos por el ensamblador en código máquina que puede ejecutar el núcleo del microcontrolador. En la gama media (PIC16xxx) cada nemónico se convierte en una palabra en la memoria de programa
- Directivas. Pseudoinstrucciones que controlan el proceso de ensamblado del programa, pero no son parte del código. Son indicaciones al programa ensamblador de cómo tiene que generar el código máquina
- Macros: Secuencia de nemónicos que pueden insertarse en el código fuente del ensamblador de una manera abreviada mediante una simple llamada.

### Ejemplo de código fuente

```asm
;Fichero CUENTA.ASM
;
;Programa de Prueba para la placa PICDEM-2 plus
;Por el Puerto B se saca en binario, el numero de veces
;que se pulsó la tecla que está conectada a la entrada RA4
;si pulsada a cero y si libre a 1
;
    LIST P=16F877           ;Directiva para definir listado y microcontrolador
    INCLUDE P16F877.INC     ;Inclusión de fichero de etiquetas
    ORG 0
    BSF STATUS,RP0          ;Paso al banco 1 de la memoria de datos
    CLRF TRISB              ;para definir el PORTB como salida
    BCF STATUS,RP0          ;Volvemos al banco 0
    CLRF PORTB              ;Ponemos a cero el PORTB para que aparezca ese
                            ;valor cuando se defina como salida
ESPERA  BTFSS PORTA,4       ;Esperamos a que se pulse la tecla
        CALL INCREMENTO     ;en cuyo caso RA4 pasa a 0 y vamos a
        GOTO ESPERA ;subprograma de INCREMENTO
;Subprograma de INCREMENTO
INCREMENTO
    INCF PORTB,F            ;Si se pulsó incrementamos PORTB
SOLTAR
    BTFSS PORTA,4           ;no salimos hasta que se haya soltado
    GOTO SOLTAR             ;la tecla, en ese caso RA4 pasaría a 1
    RETURN                  ;y volvemos al programa principal
    END
```

### Campo de operandos y datos

- El ensamblados MPASM(distribuido por Microchip) soporta los sistemas de numeración decimal, hexadecimal, octal, binario y ASCII.
- Los nemónicos que tengan una constante como operando deberán incluirla respetando la sintaxis que se indica a continuación.

| TIPO        | SINTAXIS                                          |
| ----------- | ------------------------------------------------- |
| Decimal     | D'<valor>' d'<valor>' .<valor>                    |
| Hexadecimal | H'<valor>' h'<valor>' Ox<valor> <valor>H <valor>h |
| Octal       | O'<valor>' o'<valor>'                             |
| Binario     | B'<valor>' b'<valor>'                             |
| ASCII       | A'<carácter>' a'<carácter>' '<carácter>'          |
| Cadena      | "<cadena>"                                        |

> Las constantes hexadecimales que empiecen por una letra deben ir precedidas de un cero para no confundirlas con una etiqueta. Ejemplo: **movlw** **0F7h**
