
;=====================
section .data
;=====================

invalid: db "Invalid input!",0x0A
inlen: equ $- invalid

typ: db "File succesfully written.",0x0A
typlen: equ $- typ

cpy: db "File successfully copied.",0x0A
cpylen: equ $- cpy

dele: db "File successfully deleted.",0x0A
delelen: equ $- dele

err: db "Error opening file!",0x0A
errlen: equ $- err


;=====================
section .bss
;=====================

fname1: resq 1
fname2: resq 1
fname3: resq 1
FD1: resq 1
FD2: resq 1
FD3: resq 1
buffer: resb 1000
length: resq 1


%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

%macro scall2 2
mov rax,%1
mov rdi,%2
syscall
%endmacro


;=====================
section .text
;=====================

global _start
_start:

pop rbx			;ARG COUNT
pop rbx			;./A.OUT
pop rbx			;COMMAND

cmp byte[rbx],'T'	;TYPE
je type
cmp byte[rbx],'C'	;COPY
je copy
cmp byte[rbx],'D'	;DELETE
je del

scall 1,1,invalid,inlen	;WRONG COMMAND
jmp exit

type:

pop rbx			;FILE NAME
mov rsi,fname1

up:

mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jne up

scall 2,fname1,2,0777		;OPENINING FILE

BT rax,63			
jc file_open_error

mov [FD1],rax

scall 0,0,buffer,1000		;TYPING

scall 1,[FD1],buffer,1000	;WRITING

scall2 3,[FD1]			;CLOSING FILE

scall 1,1,typ,typlen

jmp exit


copy:

pop rbx
mov rsi,fname1			;FOR FIRST FILE

up1:

mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jne up1

scall 2,fname1,2,0777

BT rax,63
jc file_open_error

mov [FD1],rax


mov rsi,fname2			;FOR SECOND FILE ( TO BE WRITTEN )
inc rbx
up2:

mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jne up2

scall 2,fname2,2,0777

BT rax,63
jc file_open_error

mov [FD2],rax

scall 0,[FD1],buffer,1000
mov [length],rax

scall 1,[FD2],buffer,[length]

scall2 3,[FD1]
scall2 3,[FD2]

scall 1,1,cpy,cpylen

jmp exit

del:

pop rbx
mov rsi,fname3				;FILE TO BE DELETED

up3:

mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jne up3

scall 2,fname3,2,0777

BT rax,63
jc file_open_error

mov [FD3],rax

scall2 87,fname3			;UNLINKING

scall 1,1,dele,delelen

jmp exit


file_open_error:

scall 1,1,err,errlen

exit:

scall2 60,0
