section .bss
    digitSpace resb 100
    digitSpacePos resb 8

section .text
    global _start

; Program entry point
_start:
    ; Add the multiples of 3 to rax
    mov rcx, 3
    call _addFactors

    ; Add the multiples of 5 to rax
    mov rcx, 5
    call _addFactors

    ; Subtract the multiples of 15 from rax
    mov rcx, 15
    call _mulOf15

    ; Print result
    mov rax, rbx
    call _printRAX

    ; Exit
    mov rax, 60
    xor edx, edx
    syscall

_addFactors:
    mov rdx, rcx

_addFactorsLoop:
    add rbx, rcx
    add rcx, rdx
    cmp rcx, 1000
    jl _addFactorsLoop
    ret

_mulOf15:
    sub rbx, rcx
    add rcx, 15
    cmp rcx, 1000
    jl _mulOf15
    ret

_printRAX:
	mov rcx, digitSpace
	mov rbx, 0xA
	mov [rcx], rbx
	inc rcx
	mov [digitSpacePos], rcx

_printRAXLoop:
    xor edx, edx
	mov rbx, 10
	div rbx
	push rax
	add rdx, 48

	mov rcx, [digitSpacePos]
	mov [rcx], dl
	inc rcx
	mov [digitSpacePos], rcx

	pop rax
	cmp rax, 0
	jne _printRAXLoop

_printRAXLoop2:
	mov rcx, [digitSpacePos]

	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	mov rdx, 1
	syscall

	mov rcx, [digitSpacePos]
	dec rcx
	mov [digitSpacePos], rcx

	cmp rcx, digitSpace
	jge _printRAXLoop2

	ret
