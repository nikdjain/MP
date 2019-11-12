
;====================================================================================================================

section .data

global fname,length,counts,countl,countc
fname:  db 'test.txt',0
menu: 	db "Enter the choice:",0x0A
	db "1.No. of blank spaces.",0x0A
	db "2.No. of lines.",0x0A
	db "3.Occurance of any character.",0x0A
	db "4.EXIT.",0x0A
	
menulen: equ $- menu

msg1: db "Enter the character.",0x0A
len1: equ $- msg1

error: db "INVALID CHOICE",0x0A
errlen: equ $- error

op_err: db "ERROR OPENING FILE",0x0A
oplen: equ $- op_err

enter: db 0x0A

length: dq 0
counts: db 0
countl: db 0
countc:  db 0
count: db 0

;===================================================================================================================

section .bss

global FD,buffer,char

choice: resb 2
FD: resq 1
buffer: resb 1000
char: resb 2
temp: resb 2



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


;======================================================================================================================

section .text


global _start

_start:

extern spaces,lines,occur

open:

scall 2,fname,2,0777	;OPEN THE FILE
mov qword[FD],rax

BT rax,63
JC open_error   ; IF FILE COULDN'T OPEN

mov qword[FD],rax   ;FILE DESCRIPTOR
xor rax,rax

scall 0,[FD],buffer,1000  ; READING THE FILE
mov qword[length],rax


scall 1,1,menu,menulen  ; MENU
scall 0,0,choice,2

cmp byte[choice],31h
je option1

cmp byte[choice],32h
je option2

cmp byte[choice],33h
je option3

cmp byte[choice],34h
je exit

scall 1,1,error,errlen
jmp _start



option1:      ;NO. OF SPACES

call spaces
call htoa1
scall2 3,[FD]
jmp open


option2:	;NO. OF LINES

call lines
call htoa2
scall2 3,[FD]
jmp open


option3:	;OCCURANCES OF A CHARACTER

scall 1,1,msg1,len1
scall 0,0,char,2
call occur
call htoa3
scall2 3,[FD]
jmp open



exit:		;EXIT INSTRUCTION

scall2 60,0

open_error:		;ERROR OPENING FILE MESSAGE

scall 1,1,op_err,oplen
jmp exit

htoa1: 

mov word[temp],00
xor rdi,rdi
mov rdi,temp
mov dx,word[counts]
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
push dx
mov byte[temp],cl
scall 1,1,temp,1
pop dx
;mov byte[rdi],cl
;inc rdi
dec byte[count]
jnz upp1

;scall 1,1,temp,2
scall 1,1,enter,1

ret

htoa2: 

mov word[temp],00
xor rdi,rdi
mov rdi,temp
mov dx,word[countl]
mov byte[count],4
xor rcx,rcx

p2:

rol dx,4
mov cl,dl
and cl,0Fh
cmp cl,09h
jbe upp2
add cl,07h
upp2:
add cl,30h
push dx
mov byte[temp],cl
scall 1,1,temp,1
pop dx
;mov byte[rdi],cl
;inc rdi
dec byte[count]
jnz p2

;scall 1,1,temp,2
scall 1,1,enter,1

ret

htoa3: 

mov word[temp],00
xor rdi,rdi
mov rdi,temp
mov dx,word[countc]
mov byte[count],4
xor rcx,rcx

p3:

rol dx,4
mov cl,dl
and cl,0Fh
cmp cl,09h
jbe upp3
add cl,07h
upp3:
add cl,30h
push dx
mov byte[temp],cl
scall 1,1,temp,1
pop dx
;mov byte[rdi],cl
;inc rdi
dec byte[count]
jnz p3

;scall 1,1,temp,2
scall 1,1,enter,1

ret







