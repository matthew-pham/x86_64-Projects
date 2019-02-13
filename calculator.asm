section .data
	welcome db "Enter a postfix expression: "
	invalidString db "Invalid expression :(", 0x0A
	hex db "The answer in hexadecimal: "
	decimal db "The answer in decimal: "
	ascii_nums db "0123456789"
	newLine db 0x0A
	equals db 0x3D
	add_ascii db 0x2B
	sub_ascii db 0x2D
	mul_ascii db 0x2A
	div_ascii db 0x2F
	exp_ascii db 0x5E
	zero_ascii db 0x30
	nine_ascii db 0x39
	null_ascii db 0x00
	n_ascii	db 0x6E
	a_ascii db 0x41
	x_ascii db 0x78
	space_ascii db 0x20

section .bss
	input resb 64
	usr_stack_top resb 80
	usr_stack_bot resb 8
	usr_stack_len resb 1
	usr_stack_ptr resb 8
	numberGlobal resb 8
	finalAnswer resb 8
	flag resb 8
	flag_num_entered resb 8

section	.text

	global _start
_start:
	push r10
	and r10, 0
	mov r10, usr_stack_bot
	mov [usr_stack_ptr], r10
	pop r10


	call _printWelcome
	call _printNewLine
	call _getInput
	and r11, 0
	;call _printAnswer
	call _preProcessInput ;TODO
	call _printNewLine


_haltProgram:
    mov rax, 60 ; sys_exit system call
    mov rdi, 0 ; exit status is 0
    syscall ; perform system call

_printWelcome:
	mov rax, 1
	mov rdi, 1
	mov rsi, welcome
	mov rdx, 28
	syscall
	ret

_printInvalid: 
	mov rax, 1
	mov rdi, 1
	mov rsi, invalidString
	mov rdx, 22
	syscall
	ret

_printNewLine:
	mov rax, 1
	mov rdi, 1
	mov rsi, newLine
	mov rdx, 1
	syscall
	ret

_printDecAns:
	mov rax, 1
	mov rdi, 1
	mov rsi, decimal
	mov rdx, 23
	syscall
	ret

_printHexAns:
	mov rax, 1
	mov rdi, 1
	mov rsi, hex
	mov rdx, 27
	syscall
	ret

_getInput:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 64
	syscall
	ret

;In - R11 (Value to print)
_printAnswer:
	push r10
	push r9
	push r12
	push r13
	push r14
	push r15

	and r8, 0
	mov r8, [zero_ascii]
	call _printR8
	and r8, 0
	and r8, 0
	mov r8, [x_ascii]
	call _printR8
	and r8, 0


	and r14, 0

	and r10, 0
	add r10, 16
cont:
	and r9, 0
	and r12, 0
	add r12, 4
next:
	and r15, 0
	add r9, r9

	mov r15, r11
	and r14, 0
	add r14, 0x01
	shl r14, 63
	and r15, r14
	and r14, 0
	cmp r15, r14
	je isZero
	add r9, 1
isZero:
	add r11, r11
	sub r12, 1
	cmp r12, r14
	jg next
	and r13, 0
	add r13, r9
	sub r13, 10
	cmp r13, r14
	jge isLetter
	and r8, 0
	mov r8, [zero_ascii]
	add r8, r9
	call _printR8
	jmp printed
	and r8, 0
isLetter:
	mov r8, [a_ascii]
	add r8, r9
	sub r8, 10
	call _printR8
printed:
	sub r10, 1
	cmp r10, r14
	jg cont

	pop r15
	pop r14
	pop r13
	pop r12
	pop r9
	pop r10
	ret

_printDec:
	push rcx
	push rdx
	and rcx, 0
	and rdx, 0
	and rbx, 0
printDecLoop:
	call _div10
	and r11, 0
	mov r11, r12
	and r15, 0
	mov r15, r14
	call _usr_push
	add rbx, 1
	cmp r11, rcx
	jne printDecLoop
printLoop:
	call _usr_pop
	and rdx, 0
	mov rdx, [zero_ascii]
	and rdx, 0xFF
	add rdx, r15
	and r8, 0
	mov r8, rdx

	call _printR8
	sub rbx, 1
	cmp rbx, rcx
	jg printLoop

	pop rdx
	pop rcx
	ret

	;R12 quotient, R14 remainder
_div10:
	push r9
	push r13
	push r15
	and r15, 0
	add r15, 10

	and r14, 0
	and r13, 0
	and r9, 0

	sub r9, 10
	and r12, 0
	sub r12, 1
div10Loop:
	add r12, 1
	add r11, r9
	cmp r11, r13
	jge div10Loop
	add r11, r15
	mov r14, r11
	pop r15
	pop r13
	pop r9
	ret





_printR8:
	push r11
	mov rax, 1
	mov rdi, 1
	and rsi, 0
	push r8
	mov rsi, RSP
	mov rdx, 1
	syscall
	pop r8
	pop r11
	ret

_preProcessInput:
	and r13, 0
	add r13, 8
	and r14, 0
	and rcx, 0
processLoop:
	cmp r13, r14
	je next8
	and r9, 0
	mov r9, input
	add r9, r8
	mov r9, [r9]
	shr r9, cl
	and r9, 0xFF
	push r8
	push r9
	push rcx
	push r14
	push r13
	call _processInput
	pop r13
	pop r14
	pop rcx
	pop r9
	pop r8
	add rcx, 8
	add r14, 1
	jmp processLoop
	ret
next8:
	add r8, 8
	and r14, 0
	and rcx, 0
	jmp processLoop
	ret





_processInput:
	and rbx, 0
	mov rbx, [n_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isN
	and rbx, 0
	mov rbx, [space_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isSpace
	and rbx, 0
	mov rbx, [newLine]
	and rbx, 0xFF
	cmp rbx, r9
	je isEqual
	and rbx, 0
	mov rbx, [add_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isPlus
	and rbx, 0
	mov rbx, [sub_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isMinus
	and rbx, 0
	mov rbx, [mul_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isMult
	and rbx, 0
	mov rbx, [div_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isDiv
	and rbx, 0
	mov rbx, [exp_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	je isExp
	and rbx, 0
	mov rbx, [zero_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	jg invalid
	and rbx, 0
	mov rbx, [nine_ascii]
	and rbx, 0xFF
	cmp rbx, r9
	jl invalid
	sub r9, 0x30
	push rbp
	and rbp, 0
	mov rbp, [numberGlobal]
	imul rbp, 10
	add rbp, r9
	mov [numberGlobal], rbp
	and rbp, 0
	add rbp, 1
	mov [flag_num_entered], rbp
	pop rbp
	ret

isPlus:
	push r10
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and r10, 0
	mov r10, r15
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	add r15, r10
	call _usr_push
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r10
	ret

isN:
	push r10
	and r10, 0
	mov r10, [flag]
	add r10, 1
	mov [flag], r10
	pop r10
	ret

isMinus:
	push r10
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and r10, 0
	mov r10, r15
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	sub r15, r10
	call _usr_push
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r10
	ret

end_space:
	pop r11
	pop r10
	ret

isSpace:
	push r10
	push r11
	and r10, 0

	mov r10, [flag_num_entered]
	and r11, 0
	cmp r11, r10
	je end_space

	and r10, 0
	and r11, 0
	add r11, 1
	mov r10, [flag]
	cmp r10, r11
	je isNegative
	and r10, 0
	and r11, 0
	mov r10, [numberGlobal]
	and r15, 0
	mov r15, r10
	call _usr_push
	and r10, 0
	mov [numberGlobal], r10
	and r11, 0
	mov [flag_num_entered], r11
	pop r11
	pop r10
	ret

isNegative:
	and r10, 0
	and r11, 0
	mov r10, [numberGlobal]
	and r15, 0
	mov r15, r10
	imul r15, -1
	call _usr_push
	and r10, 0
	mov [numberGlobal], r10
	mov [flag], r10
	pop r11
	pop r10
	ret

isMult:
	push r10
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and r10, 0
	mov r10, r15
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	imul r15, r10
	call _usr_push
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r10
	ret

isDiv:
	push r10
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and r10, 0
	mov r10, r15
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and rdx, 0
	and rax, 0
	mov rax, r15
	add rcx, r10
	idiv r10
	and r15, 0
	mov r15, rax
	call _usr_push
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r10
	ret

isExp:
	push r10
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	and r10, 0
	mov r10, r15
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	call _exponent
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r10
	ret

;r15 ^ r10, Out: r15
_exponent:
	push r8
	push r13
	push r9
	and r8, 0
	and r13, 0
	mov r13, r15
	dec r10
expLoop:
	cmp r8, r10
	je expDone
	imul r15, r13
	add r8, 1
	jmp expLoop
expDone:
	call _usr_push
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8
	pop r9
	pop r13
	pop r8
	ret
	
invalid:
	call _printInvalid
	call _haltProgram
	ret

isEqual:
	and r15, 0
	call _usr_pop
	push r8
	and r8, 0
	add r8, 1
	cmp r8, rbp
	je invalid
	pop r8

	push r15
	push r8
	and r8, 0
	add r8, 1
	call _usr_stack_isEmpty
	cmp r8, r15
	je invalid
	pop r8
	pop r15

	and r11, 0
	mov r11, r15
	mov [finalAnswer], r11
	call _printHexAns
	and r11, 0
	mov r11, [finalAnswer]
	call _printAnswer
	call _printNewLine
	call _printDecAns
	mov r11, [finalAnswer]
	call _printDec
	call _printNewLine
	call _haltProgram
	ret

 ;In: r15, Out: rbp (0-success/1-fail)
_usr_push:
	push r9
	push r10
	and rbp, 0
	mov r9, usr_stack_top
	mov r10, [usr_stack_ptr]
	sub r9, 8
	cmp r9, r10
	je overflow
	mov [r10], r15
	sub r10, 8
	mov [usr_stack_ptr], r10
	jmp done_push
overflow:
	add rbp, 1
done_push:
	pop r10
	pop r9
	ret

;Out: r15, Out rbp (0-success/1-fail)
_usr_pop:
	and r15, 0
	push r9
	push r10
	and rbp, 0
	mov r9, usr_stack_bot
	mov r10, [usr_stack_ptr]
	cmp r9, r10
	je underflow
	add r10, 8
	mov r15, [r10]
	mov [usr_stack_ptr], r10
	jmp done_pop
underflow:
	add rbp, 1
done_pop:
	pop r10
	pop r9
	ret

_getTop:
	push r11
	and r11, 0
	mov r11, [usr_stack_ptr]
	mov r11, [r11]
	call _printAnswer
	pop r11
	ret

;checks if stack is empty: 0-empty, 1-notempty
_usr_stack_isEmpty:
	and r15, 0
	mov r15, [usr_stack_ptr]
	cmp r15, usr_stack_bot
	je isEmpty
	and r15, 0
	add r15, 1
	ret
isEmpty:
	and r15, 0
	ret






