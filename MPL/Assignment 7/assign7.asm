;doing bubble sort by getting numbers from a file
;open file
;read data
;sort it
;write back
section .bss
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

	buffer:resb 1000
	fd_in:resb 8
	len:resb 8
	count:resb 1
	swap_count:resb 1

section .data
	fname:db 'input.txt',0
	error:db "File not opened..exiting",10
	lenerror:equ $-error


section .text
	global main
	main:

	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,0777
	syscall
	bt rax,63
	jnc nextstep
	print error,lenerror
	exit
nextstep:
	mov qword[fd_in],rax
	;read from file
	mov rax,0
	mov rdi,qword[fd_in]
	mov rsi,buffer
	mov rdx,1000
	syscall
	mov qword[len],rax

upper:
	mov byte[swap_count],0
	mov byte[count],3
	mov rsi,buffer
	mov rdi,buffer+2
up:
	mov bl,byte[rsi]
	cmp byte[rdi],bl
	jbe swap
	add rsi,2
	add rdi,2
	dec byte[count]
	jnz up
	cmp byte[swap_count],0
	jnz upper
	jmp last
swap:
	mov al,byte[rdi]
	mov byte[rsi],al
	mov byte[rdi],bl
	inc byte[swap_count]
	dec byte[count]
	jnz up
	cmp byte[swap_count],0
	jnz upper
last:
	;contents have been sorted successfully
	print buffer,qword[len]

	mov rax,1
	mov rdi,[fd_in]
	mov rsi,buffer
	mov rdx,qword[len]
	syscall

	;file successfully written

	mov rax,3
	mov rdi,qword[fd_in]
	syscall

	exit

;normal print commmand is appending,that is system call number 1..but we need to change the content completely
;check that out later