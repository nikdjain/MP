;assignment 1 using macro
section .data
arr: dq 1234567891234567h,2235472784871234h,9123456789346789h
pos: db 0
neg: db 0
count: db 3
msg dq 'the no. of positive numbers = '
len equ $ -msg
msg1 dq 'the no. of negative numbers = '
len1 equ $ -msg1
msg2 dq 0xa
len2 equ $ -msg2

section .bss
%macro nj 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro convert 2
cmp %1,9
jbe %2
add %1,07
%2:
add %1,30h
syscall
%endmacro

section .text
global _start
_start:
mov rsi,arr
up:
mov rax,qword[rsi]
bt rax,63
jc next
inc byte[pos]
add rsi,8
dec byte[count]
jnz up
jmp new
next:
inc byte[neg]
add rsi,8
dec byte[count]
jnz up

new:
convert byte[pos],next2
convert byte[neg],next3

nj msg,len

nj pos,1

nj msg2,len2

nj msg1,len1

nj neg,1

mov rax,60
mov rdi,1
syscall
