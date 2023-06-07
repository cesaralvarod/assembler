section .data

msg db "Hello world!",0xa,0xd

section .text
    global _start
_start:
    mov ax, 4

int 0x80
