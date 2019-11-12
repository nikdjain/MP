section .data
arr: dq 1234567891234567h,2235472784871234h
pos: db 0
neg: db 0
count: db 2
msg dq 'the no. of positive numbers = '
len equ $ -msg
msg1 dq 'the no. of negative numbers = '
len1 equ $ -msg1
msg2 dq 0xa
len2 equ $ -msg2


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
cmp byte[pos],9
jbe next2
add byte[pos],07
next2:
add byte[pos],30h

cmp byte[neg],9
jbe next3
add byte[neg],07
next3:
add byte[neg],30h

mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,len
syscall

mov rax,1
mov rdi,1
mov rsi,pos
mov rdx,1
syscall

mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall

mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall


mov rax,1
mov rdi,1
mov rsi,neg
mov rdx,1
syscall

mov rax,60
mov rdi,1
syscall
