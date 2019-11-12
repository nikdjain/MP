
;=================================
section .data
;=================================

fname: db 'test.txt',0


;==================================
section .bss
;==================================

FD:	resq 1
array:	resb 100
buffer:	resb 1000
length:	resq 1
cnt:	resq 1



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


;==================================
section .text
;==================================

global _start
_start:


scall 2,fname,2,0777		;CHECK IF THE FILE IS OPENING CORRECTLY

BT rax,63
JC end

mov [FD],rax
xor rax,rax

scall 0,[FD],buffer,1000	;READING THE FILE
mov [length],rax

call copydata			;COPYING THE CONTENTS OF THE FILE


xor rdx,rdx
xor rdi,rdi
xor rsi,rsi
xor rbp,rbp			;INNER LOOP COUNT
xor rcx,rcx			;OUTER LOOP COUNT


mov rcx,[cnt]

outer:				;OUTER LOOP

mov rsi,array			;SIMILAR TO A[J]
mov rdi,array+2			;SIMILAR TO A[J+1]

dec rcx				;DECREMENT TWO TIMES TO AVOID SPACES THAT WERE READ
jz exit
dec rcx
jz exit

mov rbp,rcx

inner:				;INNER LOOP

xor rax,rax
xor rbx,rbx

mov al,byte[rsi]
mov bl,byte[rdi]
cmp al,bl			;COMPARING A[J] AND A[J+1]

;cmp bl,al			;FOR DESCENDING ORDER

jbe noswap

mov byte[rsi],bl		;SWAP FUNCTION
mov byte[rdi],al

noswap:

inc rsi				;INCREMENT TWICE TO AVOID SPACES THAT WERE READ
inc rsi
inc rdi
inc rdi
dec rbp 			;DECREMENT TWICE TO AVOID SPACES THAT WERE READ
jz outer
dec rbp
jz outer

jmp inner

copydata:

xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx
xor rdi,rdi
xor rsi,rsi

mov rsi,buffer
mov rdi,array
mov rdx,[length]

up:

mov al,byte[rsi]
mov byte[rdi],al

inc rsi
inc rdi
inc rcx
dec rdx
jnz up
mov [cnt],rcx

ret

exit:

scall2 3,[FD]
scall 1,1,array,qword[cnt] 
jmp end

end:

scall2 60,0
