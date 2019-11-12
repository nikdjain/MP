section .data

menu: db "MENU",0x0A
      db "1.Hex to BCD",0x0A
      db "2.BCD to Hex:",0x0A
      db "3.EXIT",0x0A
len: equ $- menu
msg1: db "Enter the 4 digit hex number:",0x0A
len1: equ $- msg1
msg2: db "Enter the 5 digit bcd number:",0x0A
len2: equ $- msg2
error: db "Invalid choice !",0x0A
errorlen: equ $- error
count: db 0
count1: db 0
count2: db 0 

enter: db 0x0A

section .bss

choice: resb 2
hex: resb 5
bcd: resb 6
new: resb 16
new1: resb 16
new2: resb 16
addr: resb 5
result: resb 5
result1: resb 8
result2: resb 8
multi: resb 2
 
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

scall 1,1,menu,len
scall 0,1,choice,2

cmp byte[choice],31h
je option1
cmp byte[choice],32h
je option2
cmp byte[choice],33h
je exit

scall 1,1,error,errorlen

option1:

scall 1,1,msg1,len1
scall 0,1,hex,5

call a2h
mov bx,10

up:
mov dx,00
div bx
push dx
inc byte[count]
cmp eax,00
jnz up

up1:
mov dx,00
pop dx
cmp dl,09h
jbe calp
add dl,07h
calp:
add dl,30h
mov byte[result],dl
scall 1,1,result,1
dec byte[count]
jnz up1
scall 1,1,enter,1
jmp _start

option2:

scall 1,1,msg2,len2
scall 0,1,bcd,6
MOV BYTE[count1],5
mov rsi,bcd
XOR RAX,RAX
XOR RBX,RBX
XOR RCX,RCX
mov word[multi],2710h
mov bx,0Ah
upp:
xor rax,rax
mov al,byte[rsi]
sub al,30h     ;ALL DECIMAL NO ARE LESS THAN NINE
mul word[multi]
OP1:
add dword[result1],eax
xor rax,rax
mov ax,word[multi]
div bx
mov word[multi],ax
inc rsi
dec byte[count1]
jnz upp


call h2a

jmp _start


exit:
 mov rax,60
 mov rdi,0
 syscall


a2h:
mov eax,00
mov byte[count1],4
lab1:
rol eax,4
mov dl,byte[rsi]
cmp dl,39h
jbe lab
sub dl,07h
lab:
sub dl,30h
add al,dl
inc rsi
dec byte[count1]
jnz lab1
ret

h2a:
XOR RAX,RAX
XOR RBX,RBX
XOR RCX,RCX
XOR RDX,RDX
mov rdi,new2
mov edx,dword[result1]
mov byte[count],8

lab3:
rol edx,4
mov cl,dl
and cl,0Fh
cmp cl,09
jbe lab2
add cl,07
lab2:
add cl,30h
mov byte[rdi],cl
inc rdi
dec byte[count]
jnz lab3
scall 1,1,new2,8
scall 1,1,enter,1
ret



