section .data
    prompt db "Height: "
    prompt_len equ $- prompt
    invalid_input db "mario: Pyramid height must be an integer from 1 to 9", 0xA
    invalid_input_len equ $- invalid_input
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
    xor rax, rax
    xor rdi, rdi
    mov rsi, height
    mov rdx, 1
    syscall

    ; If user enters nothing
    cmp byte [height], 0xA
    je _invalidInput2

    ; Convert height to an int
    mov rax, [height]
    sub rax, '0'

    ; Check if the input is valid
    call _checkInput

    ; Loop each row of the pyramid
    xor rcx, rcx
    call _rowLoop

    ; Exit the program
    mov rax, 60
    xor rdi, rdi
    syscall

; Loop over every row in the pyramid
_rowLoop:
    ; Push the max to the stack
    push rax

    ; Set the max and index for _alignLeft
    sub rax, rcx
    dec rax
    push rcx
    xor rcx, rcx

    ; Allign the left pyramid
    call _alignLeft

    ; Set the max and index for _printRow
    pop rcx
    mov rax, rcx
    push rcx
    xor rcx, rcx

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
    xor rcx, rcx

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

; Flush the input buffer, and then continue to _invalidInput
_readBuf:
    ; Read from stdin
    xor rax, rax
    xor rdi, rdi
    mov rsi, height
    mov rdx, 1
    syscall

    ; If input == '\n', it's valid
    cmp byte [height], 0xA
    jne _invalidInput
    ret

; Warn the user and exit when input isn't valid
_invalidInput:
    ; Flush stdin
    call _readBuf

; Continuation of _invalidInput, but without clearing
; the input buffer, which is needed when theres no input
_invalidInput2:
    ; Print the warning
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_input
    mov rdx, invalid_input_len
    syscall

    ; Exit with exit code 1
    mov rax, 60
    mov rdi, 1
    syscall
