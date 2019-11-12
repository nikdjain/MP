section .bss
	%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro

	%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
	%endmacro
	ans:resb 1
	result:resb 4
section .data
	error:db "Wrong input.Enter a single number..exiting",10
	lenerror:equ $-error
	count:db 00
section .text
	global main
	main:

	pop rbx
	cmp rbx,2
	jz nextstep
	print error,lenerror
	exit
nextstep:
	pop rbx
	pop rbx
	xor rax,rax
	mov al,byte[rbx]
	sub al,30H
	cmp al,0
	jnz down
	mov byte[ans],al
	print ans,1
	exit
down:
	push ax
	inc byte[count]
	dec al
	jnz down
	xor rbx,rbx
	mov ax,01
up:
	pop bx
	mul bx
	dec byte[count]
	jnz up

check:
	mov byte[count],4
	mov rdi,result
up2:
	rol ax,04
	mov bl,al
	and bl,0FH
	cmp bl,9
	jbe next2
	add bl,7H
next2:
	add bl,30H
	mov byte[rdi],bl
	inc rdi
	dec byte[count]
	jnz up2

	print result,4
	mov byte[count],10
	print count,1




	exit


;i am confused what is actually popped ? the address of the location where the number is stored or the number itself
;i am thinking that the first thing is no.of argunments which the the actual number and not the location 
;after that we get the addresses
;i made a mistake on about how the data is pushed into stack
;first is is the no.of argument..then from left to right of the command entered
;cannot push or pop 8-bit items