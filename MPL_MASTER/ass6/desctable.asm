
;====================================================================================================================
 section .data
;===================================================================================================================

msg: 	db 0x0A,"--------Register Contents---------"
len:	equ $- msg

rmsg: 	db 0x0A,"-----REAL MODE-----"
rlen:	equ $- rmsg

pmsg:	db 0x0A,"-----PROTECTED MODE-----"
plen:	equ $- pmsg

mmsg:	db 0x0A,"Contents of MSW : "
mlen:	equ $- mmsg

gmsg: 	db 0x0A,"Contents of GDTR : "
glen:	equ $- gmsg

lmsg: 	db 0x0A,"Contents of LDTR : "
llen:	equ $- lmsg

imsg: 	db 0x0A,"Contents of IDTR : "
ilen:	equ $- imsg

tmsg:	db 0x0A,"Contents of TR : "
tlen:	equ $- tmsg

enter: 	db 0x0A

space: 	db 20H

count: 	db 0


;=====================================================================================================================
section .bss
;=====================================================================================================================

cr_0: 	resd 1
gdtr: 	resd 1
	resw 1
ldtr:	resw 1
idtr:	resd 1
	resw 1
tr:	resw 1
temp:	resb 4


%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro




;======================================================================================================================
section .text
;======================================================================================================================

global _start
_start:


smsw eax
mov [cr_0],eax
BT eax,1
JC protect

scall 1,1,rmsg,rlen		;REAL MODE
jmp exit

protect:

scall 1,1,pmsg,plen		;PROTECTED MODE

scall 1,1,msg,len

scall 1,1,mmsg,mlen		;MSW PRINTING

call clear

mov ax,word[cr_0+2]
call htoa


scall 1,1,gmsg,glen		;GDT PRINTING

call clear 

SGDT [gdtr]

mov ax,word[gdtr+4]
call htoa

mov ax,word[gdtr+2]
call htoa

mov ax,word[gdtr]
call htoa


scall 1,1,lmsg,llen		;LDT PRINTING

call clear 
lp:
sldt [ldtr]

mov ax,word[ldtr]
call htoa


scall 1,1,imsg,ilen		;IDT PRINTING

call clear

SIDT [idtr]

mov ax,word[idtr+4]
call htoa

mov ax,word[idtr+2]
call htoa

mov ax,word[idtr]
call htoa


scall 1,1,tmsg,tlen		;TR PRINTING

call clear

STR [tr]
mov ax,word[tr]
call htoa
scall 1,1,enter,1
jmp exit

exit:				;EXIT

mov rax,60
mov rdi,0
syscall

htoa:				;HEX TO ASCII CONVERSION


mov rsi,temp
mov byte[count],04h
up:
rol ax,4
mov cl,al
and cl,0Fh
cmp cl,09h
jbe next
add cl,07h
next:
add cl,30h
mov byte[rsi],cl
;push ax
;scall 1,1,temp,1
;pop ax
inc rsi
dec byte[count]
jnz up

scall 1,1,temp,4

ret

clear:

xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx

ret

