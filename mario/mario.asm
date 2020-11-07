%include "macros.inc"

section .rodata
    prompt db "Height: ", 0
    prompt_len equ $- prompt
    blocks db "########"
    spaces db "       "
    newline db 0xA

section .bss
    height resb 1

section .text
    global _start

; Program entry point
_start:
    ; Print the prompt
    print prompt, prompt_len

    ; Get the height from the user
    getchar height

    ; If user enters nothing, reprompt
    cmp byte [height], 0xA
    je _start

    ; Convert height to an int
    mov rax, [height]
    sub rax, '0'

    ; Check if the input is valid
    call _checkInput

    ; Loop each row of the pyramid
    xor ecx, ecx
    call _printRow

    ; Exit the program
    mov rax, 60
    xor edi, edi
    syscall

; Loop over every row in the pyramid
_printRow:
    ; Push the height to the stack
    push rax

    ; Move the number of spaces to print to rbx
    mov rbx, rax
    sub rbx, rcx
    dec rbx

    ; Align the left pyramid
    push rcx
    print spaces, rbx
    pop rcx

    ; Print the left pyramid
    mov rbx, rcx
    inc rbx
    push rcx
    print blocks, rbx

    ; Print the gap
    print spaces, 2

    ; Print the right pyramid
    pop rcx
    mov rbx, rcx
    inc rbx
    push rcx
    print blocks, rbx

    ; Print a newline
    print newline, 1

    ; Pop the index and max from the stack
    ; and increment the index
    pop rcx
    pop rax
    inc rcx

    ; Loop if index < max
    cmp rcx, rax
    jl _printRow
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
    getchar height

    ; If input != '\n', jump to _invalidInput
    cmp byte [height], 0xA
    jne _invalidInput
    ret

; Flush the input buffer and jump to _start
_invalidInput:
    ; Flush stdin and reprompt
    call _readBuf
    jmp _start
