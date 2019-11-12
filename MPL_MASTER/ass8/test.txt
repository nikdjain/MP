SECTION .DATA
hello: db 'hello world!',10
hellolen: equ $-hello;
SECTION .TEXT
	GLOBAL _start
_start:
	mov EAX,4
	mov EBX,1
	mov ECX,first
	mov EDX,hellolen
	int 80H
	mov EAX,1H
	mov EBX, 0H
	int 80H
	
