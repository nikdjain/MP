;DOS commands, type copy and delete
;we need to use stack 

section .bss
	argc:resb 1
	saveaddr:resb 8

	%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
	%endmacro

	%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
	count:resb 1
	fd_in:resb 8
	len:resb 8
	buffer:resb 1000
	fname:resb 20
	fname2:resb 20
	fd_in1:resb 8
section .data
 	error:db "Wrong input..exiting",10
 	lenerror:equ $-error
 	notopen:db "File not exists",10
 	lennotopen:equ $-notopen
section .text
	global main
	main:

	pop rbx  ;no .of arguments
check:	
	 ;checking the number of arguments

	cmp rbx,3
	jz three   ;if three arguments then it is either type or delete

	cmp rbx,4
	jz four

	print error,lenerror
	exit

three:
	pop rbx
	pop rbx
	cmp byte[rbx],'T'
	jz typeone
	cmp byte[rbx],'D'
	jz deleteone
	print error,lenerror
	exit
typeone:
	pop rbx
	mov rsi,rbx
	mov rdi,fname
up:
	mov al,byte[rsi]
	cmp al,0
	jz done
	mov byte[rdi],al
	inc rsi
	inc rdi
	inc byte[count]
	jmp up
done:
	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,0777
	syscall
	bt rax,63
	jnc continuenow
	print notopen,lennotopen
	exit
continuenow:
	mov qword[fd_in],rax
	mov rax,0
	mov rdi,qword[fd_in]
	mov rsi,buffer
	mov rdx,1000
	syscall
	mov qword[len],rax
	print buffer,qword[len]
	exit
deleteone:
	pop rbx
	mov rsi,rbx
	mov rdi,fname
up2:
	mov al,byte[rsi]
	cmp al,0
	jz done2
	mov byte[rdi],al
	inc rsi
	inc rdi
	inc byte[count]
	jmp up2
done2:
	mov rax,87
	mov rdi,fname
	syscall
	exit

four:
	pop rbx
	pop rbx
	cmp byte[rbx],'C'
	jz next3
	print error,lenerror
	exit
next3:
	pop rbx
	mov rsi,rbx
	mov rdi,fname
up4:
	mov al,byte[rsi]
	cmp al,0
	jz done4
	mov byte[rdi],al
	inc rsi
	inc rdi
	jmp up4
done4:
	pop rbx
	mov rsi,rbx
	mov rdi,fname2
up5:
	mov al,byte[rsi]
	cmp al,0
	jz done5
	mov byte[rdi],al
	inc rsi
	inc rdi
	jmp up5
done5:
	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,0777
	syscall
	bt rax,63
	jnc nextpart
	exit
nextpart:
	mov qword[fd_in],rax
	mov rax,0
	mov rdi,qword[fd_in]
	mov rsi,buffer
	mov rdx,1000
	syscall
	mov qword[len],rax
	print buffer,qword[len]
	mov rax,2
	mov rdi,fname2	
	mov rsi,2
	mov rdx,0777
	syscall
	bt rax,63
	jnc continuepart

continuepart:
	mov qword[fd_in1],rax
	mov rax,1
	mov rdi,qword[fd_in1]
	mov rsi,buffer
	mov rdx,qword[len]
	syscall

	exit



