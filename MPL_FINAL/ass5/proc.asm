
;========================================================================================================================

section .data

extern fname,length,counts,countl,countc



;========================================================================================================================

section .bss

extern FD,buffer,char


%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro


%macro clear 1
xor %1,%1
%endmacro

;========================================================================================================================

section .text

global _start2
_start2:

global spaces,lines,occur


spaces:

mov byte[counts],00
clear rsi
mov rsi,buffer
clear rcx
mov rcx,qword[length]

up:

cmp byte[rsi],20H
JNE next
inc byte[counts]

next:

inc rsi
dec rcx
jnz up

ret

lines:

mov byte[countl],00
clear rsi
mov rsi,buffer
clear rcx
mov rcx,qword[length]

up1:

cmp byte[rsi],0x0A
JNE next1
inc byte[countl]

next1:

inc rsi
dec rcx
jnz up1

ret

occur:

mov byte[countc],00
clear rsi
mov rsi,buffer
clear rdx
mov dl,byte[char]
clear rcx
mov rcx,qword[length]

up2:

cmp byte[rsi],dl
JNE next2
inc byte[countc]

next2:

inc rsi
dec rcx
jnz up2

ret







