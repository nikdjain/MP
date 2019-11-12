;=========================================
section .data
;=========================================

array:	dd 102.56,104.25,235.26,205.04,326.01;100.2,100.3,100.4,100.5,100.6
count: 	dw 5

msg1:	db 0x0A,"The mean is : "
len1:	equ $- msg1

msg2:	db 0x0A,"The variance is :"
len2:	equ $- msg2

msg3:	db 0x0A,"The standard deviation is :"
len3:   equ $- msg3

dot:	db "."
dotlen:	equ $- dot

hun: 	dd 100



;=========================================
section .bss
;=========================================

mean: resd 1
var:  resd 1
sd:   resd 1
cnt:  resb 1
temp: resb 2
cnt2: resb 1
buffer: resb 10




%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro




;=========================================
section .text
;=========================================


global _start
_start:



mov rsi,array
mov byte[cnt],5
FINIT
FLDZ

up:
FADD dword[rsi]
add rsi,4
dec byte[cnt]
jnz up

FIDIV word[count]
FST dword[mean]

scall 1,1,msg1,len1
call display


mov rsi,array
mov byte[cnt],5



variance:

FLD dword[rsi]
FSUB dword[mean]
FST ST1
FMUL ST0,ST1
FADD dword[var]
FST dword[var]
add rsi,4
dec byte[cnt]
jnz variance

FLD dword[var]
FIDIV word[count]
FST dword[var]

scall 1,1,msg2,len2
call display 


FLDZ
FADD dword[var]
FSQRT

FST dword[sd]

scall 1,1,msg3,len3
call display


exit:

mov rax,60
mov rdi,0
syscall



h2a:

mov rdi,temp
mov byte[cnt2],2

lp1:
rol bl,4
mov dl,bl
and dl,0Fh
cmp dl,09h
jbe lp2
add dl,07
lp2:
add dl,30h
mov byte[rdi],dl
inc rdi
dec byte[cnt2]
jnz lp1
scall 1,1,temp,2

ret


	
display:
	FIMUL dword[hun]
	FBSTP [buffer]
	mov byte[cnt],9
	mov rsi,buffer+9
Lp1:
	push rsi
	mov bl,byte[rsi]
	CALL h2a
	pop rsi
	dec rsi
	dec byte[cnt]
	JNZ Lp1
	
	scall 1,1,dot,dotlen
	mov rsi,buffer
	mov bl,byte[rsi]
	CALL h2a
	RET















