

section .data

array: dq 12346245615h,615465135534341h,665464654646h,0234947458324847h,4545512125h
count: db 5
count1: db 0
count2: db 0
msg1: db "12346245615h,615465135534341h,665464654646h,0234947458324847h,4545512125h"
len1: equ $- msg1

msg2: db "Menu",0x0A
      db "1.Non-Overlapped without string.",0x0A
      db "2.Non-Overlapped with string.",0x0A
      db "3.Overlapped without string.", 0x0A
      db "4.Overlapped with string.", 0x0A
      db "5.EXIT.",0x0A
      
len2: equ $- msg2
space: db 0x20
enter: db 0x0A

section .bss

addr: resb 16
choice: resb 2
array1: resb 40

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

;printing array

mov rsi,array
mov byte[count],5

up:
mov rbx,rsi
push rsi
call h2a
scall 1,1,space,1
pop rsi

mov rbx,qword[rsi]
push rsi
call h2a
scall 1,1,enter,1
pop rsi
add rsi,8
dec byte[count]
jnz up


select:

scall 1,1,msg2,len2
scall 0,1,choice,2

cmp byte[choice],31h
je option1
cmp byte[choice],32h
je option2
cmp byte[choice],33h
je option3
cmp byte[choice],34h
je option4
cmp byte[choice],35h
je exit

;non-overlapped without string
option1:       

mov rsi,array
mov rdi,array+42
mov byte[count],5

up1:
mov rax,qword[rsi]
mov qword[rdi],rax
add rsi,8
add rdi,8
dec byte[count]
jnz up1


;printing
print:

;xor rsi,rsi
mov rsi,array
mov byte[count],5

up2:

mov rbx,rsi
push rsi
call h2a
scall 1,1,space,1
pop rsi

mov rbx,qword[rsi]
push rsi 
call h2a
scall 1,1,enter,1

pop rsi
add rsi,8
dec byte[count]
jnz up2

;xor rsi,rsi
mov rsi,array+42
mov byte[count],5

up3:

mov rbx,rsi
push rsi
call h2a
scall 1,1,space,1
pop rsi

mov rbx,qword[rsi]
push rsi 
call h2a
scall 1,1,enter,1
pop rsi
add rsi,8
dec byte[count]
jnz up3
jmp select

;non-overlapped with string
option2:

mov rsi,array
mov rdi,array+42
mov cx,5
cld

up7:

movsq
dec cx
jnz up7

jmp print

;overlapped without string
option3:       

mov rsi,array
mov rdi,array1
mov byte[count],5

up4:
mov rax,qword[rsi]
mov qword[rdi],rax
add rsi,8
add rdi,8
dec byte[count]
jnz up4


mov rsi,array1
mov rdi,array+24
mov byte[count],5

up5:
mov rax,qword[rsi]
mov qword[rdi],rax
add rsi,8
add rdi,8
dec byte[count]
jnz up5


;printing
print1:

mov rsi,array
mov byte[count],8

up6:

mov rbx,rsi
push rsi
call h2a
scall 1,1,space,1
pop rsi

mov rbx,qword[rsi]
push rsi 
call h2a
scall 1,1,enter,1
pop rsi
add rsi,8
dec byte[count]
jnz up6
jmp select


;non-overlapped with string
option4:

mov rsi,array
mov rdi,array1
mov byte[count],05h
cld

continue1:

movsq
dec byte[count]
jnz continue1

mov rsi,array1
mov rdi,array+24
mov byte[count],05h
cld

continue2:

movsq
dec byte[count]
jnz continue2
jmp print1 


;hex to ascii conversion

h2a:

 mov rdi,addr
 mov byte[count1],16
upp:
 rol rbx,4
 mov dl,bl
 and dl,0Fh
 cmp dl,09h
 jbe cal
 add dl,07h
cal:
 add dl,30h
  
 mov byte[rdi],dl
 inc rdi
 dec byte[count1]
 jnz upp
 
 scall 1,1,addr,16

ret


exit:
	mov rax,60
	mov rdi,0
syscall

