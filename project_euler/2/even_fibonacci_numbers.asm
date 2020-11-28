%include "../macros.inc"

section .bss
    count   resq 1
    cPos    resb 1

section .text
    global  _start

; Initialize rbx and rcx
_start:
    mov     rbx, 1
    mov     rcx, 1
    mov     r8, 2

; Check if rdx % 2 == 0
_fibonacci:
    mov     rax, rcx
    div     r8
    cmp     rdx, 0
    je      _isEven

; Compute the next fibonacci number
_fibonacciLoop:
    mov     rax, rbx
    mov     rbx, rcx
    lea     rcx, [rax+rbx]

    cmp     rcx, 0x3D0900   ; 4,000,000
    jl      _fibonacci
    jmp     _exit

; Add rcx to count
_isEven:
    mov     rax, [count]
    add     rax, rcx
    mov     [count], rax

    jmp     _fibonacciLoop

; EXIT SUCCESS
_exit:
    mov     rax, [count]
    prax    count, cPos

    mov     rax, 60
    xor     edi, edi
    syscall
