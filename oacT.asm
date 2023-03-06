%define maxChars 100
%define openrw  102o ; flag open()
%define userWR 644o  ; Read+Write+Execute
%define append 2101o ; flag open() criar/escrever no final

section .data
    strArq: db "Nome do arquivo a se copiado: "
    strArqL: equ $ - strArq     

    fileName: db 0
	
	fileDescriptor: dq 0
	fileDescriptorX: dq 0
	
	varStc: db 0
	varStcL: db 0
	varFim: equ $ - varStc
	
	newFile: db "New"
	
section .bss
    varArq  : resb maxChars
    varArqL : resb 1

section .text
	global _start

_start:
    mov rax, 1
    mov rdi, 1  ; std_file
    lea rsi, [strArq]
    mov edx, strArqL
    syscall

leitura:
    mov rax, 0  ; READ
    mov rdi, 1
    lea rsi, [varArq]
    mov edx, maxChars
    syscall

    mov [varArqL], eax

init:
	mov r14, [varArq]
	mov [fileName], r14
	mov [newFile+4], r14
	
	mov rax, 2
	lea rdi, [newFile]
	mov rsi, openrw
	mov rdx, userWR
	syscall
	
    mov [fileDescriptorX], rax
openFile:
    mov rax, 2          
    lea rdi, [fileName] 
    mov rsi, openrw     
    mov rdx, userWR     
    syscall
    
    mov [fileDescriptor], rax

readFile:
	mov rax, 0
	mov rdi, [fileDescriptor]
    lea rsi, [varStc]
    mov rdx, 100
	syscall

	;add [varStcL], rdx
	;cmp rax, rdx
	;jb writeInFile
	
	;add rcx, 100
	;cmp rcx, [varFim]
	;jae writeInFile
	;jmp readFile

closeFile:
    mov rax, 3  
    mov rdi, [fileDescriptor]
    syscall

writeInFile:

    
	mov rax, 1
	mov rdi, [fileDescriptorX]
	lea rsi, [varStc]
	mov rdx, 13
	syscall

    mov rax, 3  
    mov rdi, [fileDescriptorX]
    syscall


fim:
    mov rax, 60
    mov rdi, 0
    syscall
