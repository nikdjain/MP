section .data

msg: db "Menu:",0x0A
     db "1.Successive addition method.",0x0A
     db "2.Add and shift method.",0x0A
     db "3.Exit.",0x0A
len: equ $- msg

msg1:	db "Enter the 2 digit hex multiplier.",0x0A
len1: 	equ $- msg1

msg2:	db "Enter the 2 digit hex multiplicand.",0x0A
len2:	equ $- msg2

error: 	db "Invalid Choice",0x0A
errlen: equ $- error

zro: 	db "0000",0x0A

enter: db 0x0A

count: db 0
count1: db 0

section .bss

choice: resb 2
mul:	resb 3
mul2:	resb 3
cmul:	resb 3
cmul2:	resb 3
result: resb 8
new:	resb 16
new1: 	resb 16


%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro



section .text

global _start
_start:
			
scall 1,1,msg,len
scall 0,0,choice,2

cmp byte[choice],31h
je option1 

cmp byte[choice],32h
je option2

cmp byte[choice],33h
je exit

scall 1,1,error,errlen 
jmp _start

exit:

mov rax,60
mov rdi,0
syscall


option1:	;;SUCCESSIVE ADDITION

scall 1,1,msg1,len1
scall 0,0,mul,3

call clear

mov rsi,mul
call atoh
mov [cmul],bx


scall 1,1,msg2,len2
scall 0,0,mul2,3

call clear

mov rsi,mul2
call atoh
mov [cmul2],bx

cmp byte[cmul],0
je zero

cmp byte[cmul2],0
je zero

mov cx,word[cmul2]
mov ax,word[cmul]
up:
add dx,ax
dec cx
jnz up


mov rdi,new
call htoa	


scall 1,1,new,4
scall 1,1,enter,1
jmp _start

option2:	;;ADD AND SHIFT

scall 1,1,msg1,len1
scall 0,0,mul,3

call clear

mov rsi,mul
call atoh
mov [cmul],bx


scall 1,1,msg2,len2
scall 0,0,mul2,3

call clear

mov rsi,mul2
call atoh
mov [cmul2],bx

cmp byte[cmul],0
je zero

cmp byte[cmul2],0
je zero

call clear

mov byte[count],16
mov eax,0000h
mov bx,[cmul]
mov cx,[cmul2]

UP:

SHL ax,1
ROL bx,1
JNC below
add ax,cx
below:
dec byte[count]
jnz UP

xor rdi,rdi
mov dx,ax
mov rdi,new1	

call htoa

scall 1,1,new1,4
scall 1,1,enter,1
jmp _start

clear:

xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx

ret

atoh:		;ASCII TO HEX CONVERSION

mov byte[count],02
mov ebx,00
x1:
rol ebx,04
mov al,byte[rsi]
cmp al,39h
jbe x2
sub al,07
x2:
sub al,30h
add bl,al
inc rsi
dec byte[count]
jnz x1

ret
		;;HEX TO ASCII CONVERSION
htoa:     ;req result in dx and address to store it in rdi

mov byte[count],4
xor rcx,rcx

upp1:

rol dx,4
mov cl,dl
and cl,0Fh
cmp cl,09h
jbe upp
add cl,07h
upp:
add cl,30h
mov byte[rdi],cl
inc rdi
dec byte[count]
jnz upp1

ret

zero:		;CASE WHERE ONE OF THE OPERAND IS ZERO

scall 1,1,zro,5
jmp _start
