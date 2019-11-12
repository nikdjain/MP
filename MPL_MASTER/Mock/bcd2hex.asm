;=================================
section .data
;=================================

msg: db "Enter choice:",0x0A
len: equ $- msg

msg1: db "1. BCD to HEX conversion.",0x0A
len1: equ $- msg1

ex: db "2. EXIT.",0x0A
exlen: equ $- ex

msg2: db "Enter the five digit bcd no. :",0x0A
len2: equ $- msg2

enter: db 0x0A

ans: db "Hex value for given value is:  "
anslen: equ $- ans

count: db 0


;=================================
section .bss
;=================================

bcd: resb 6
multi: resw 1
choice: resb 2
result: resd 1
new: resw 1

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

;=================================
section .text
;=================================


global _start
_start:

scall 1,1,msg,len			;MENU
scall 1,1,msg1,len1
scall 1,1,ex,exlen
scall 0,0,choice,2

cmp byte[choice],31h
je b2h

jmp exit

b2h:					;BCD 2 HEX

scall 1,1,msg2,len2
scall 0,0,bcd,6

mov word[multi],2710h			;MULTI ARRAY
mov byte[count],5
mov rsi,bcd
xor rbx,rbx
mov bx,0Ah

up:					;ACTUAL CONVERSION
xor rax,rax
mov al,byte[rsi]
sub al,30h				;ASCII TO HEX CONVERSION
mul word[multi]
add dword[result],eax
xor rax,rax
mov ax,word[multi]
div bx
mov word[multi],ax
inc rsi
dec byte[count]
jnz up


xor rsi,rsi
xor rax,rax
xor rbx,rbx
xor rdx,rdx
xor rcx,rcx

mov eax,dword[result]			;HEX TO ASCII CONVERSION
mov rsi,new
mov byte[count],4

up1:
rol ax,4
mov cl,al
and cl,0Fh
cmp cl,09h
jbe down
add cl,07h
down:
add cl,30h
mov byte[rsi],cl
inc rsi
dec byte[count]
jnz up1


scall 1,1,ans,anslen			;PRINTING THE ANSWER
scall 1,1,new,4
scall 1,1,enter,1



exit:					;EXIT

mov rax,60
mov rdi,0
syscall


