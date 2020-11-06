section .data
    prompt db "Height: "
    prompt_len equ $- prompt
    symbol db "#"
    space db " "
    gap db "  "
    newline db 0xA

section .bss
    height resb 1

section .text
    global _start

; Program entry point
_start:
    ; Print the prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Get the height from the user
    xor eax, eax
    xor edi, edi
    mov rsi, height
    mov rdx, 1
    syscall

    ; If user enters nothing
    cmp byte [height], 0xA
    je _start

    ; Convert height to an int
    mov rax, [height]
    sub rax, '0'

    ; Check if the input is valid
    call _checkInput

    ; Loop each row of the pyramid
    xor ecx, ecx
    call _rowLoop

    ; Exit the program
    mov rax, 60
    xor edi, edi
    syscall

; Loop over every row in the pyramid
_rowLoop:
    ; Push the max to the stack
    push rax

    ; Set the max and index for _alignLeft
    sub rax, rcx
    dec rax
    push rcx
    xor ecx, ecx

    ; Allign the left pyramid
    call _alignLeft

    ; Set the max and index for _printRow
    pop rcx
    mov rax, rcx
    push rcx
    xor ecx, ecx

    ; Print the left pyramid
    call _printRow

    ; Print the gap
    mov rax, 1
    mov rdi, 1
    mov rsi, gap
    mov rdx, 2
    syscall

    ; Set the max and index for _printRow
    pop rcx
    mov rax, rcx
    push rcx
    xor ecx, ecx

    ; Print the right pyramid
    call _printRow

    ; Print a newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Pop the index and max from the stack
    ; and increment the index
    pop rcx
    pop rax
    inc rcx

    ; Loop if index < max
    cmp rcx, rax
    jl _rowLoop
    ret

; Print spaces to align the left pyramid
_alignLeft:
    ; Loop is index < max
    cmp rcx, rax
    jl _alignLeft2
    ret

_alignLeft2:
    ; Push max and index onto the stack
    push rax
    push rcx

    ; Print a space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    ; Pop the index and max from the stack
    ; and increment the index
    pop rcx
    pop rax
    inc rcx

    jmp _alignLeft

; Print a row of the pyramid
_printRow:
    ; Push max and index onto the stack
    push rax
    push rcx

    ; Print symbol
    mov rax, 1
    mov rdi, 1
    mov rsi, symbol
    mov rdx, 1
    syscall

    ; Pop the index and max from the stack
    ; and increment the index
    pop rcx
    pop rax
    inc rcx

    ; Loop if index =< max
    cmp rcx, rax
    jle _printRow
    ret

; Check the validity of user input
_checkInput:
    ; Make sure 0 < input < 9
    cmp rax, 1
    jl _invalidInput
    cmp rax, 8
    jg _invalidInput

    ; Check to see if the user entered valid input
    push rax
    call _readBuf
    pop rax

    ret

; Check if the next character in the input buffer is '\n'
_readBuf:
    ; Read from stdin
    xor eax, eax
    xor edi, edi
    mov rsi, height
    mov rdx, 1
    syscall

    ; If input != '\n', jump to _invalidInput
    cmp byte [height], 0xA
    jne _invalidInput
    ret

; Flush the input buffer and jump to _start
_invalidInput:
    ; Flush stdin
    call _readBuf
    jmp _start
