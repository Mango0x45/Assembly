%include "../macros.inc"

section .bss
    digitSpace      resq 1
    digitSpacePos   resb 1

section .text
    global  _start

_start:
    ; Add the multiples of 3 and 5 to rax
    mov     rcx, 3
    call    _addFactors
    mov     rcx, 5
    call    _addFactors

    ; Subtract the multiples of 15 from rax
    mov     rcx, 15
    call    _mulOf15

    ; Print result
    prax    digitSpace, digitSpacePos

    ; EXIT SUCCESS
    mov     rax, 60
    xor     edx, edx
    syscall

_addFactors:
    mov     rdx, rcx

_addFactorsLoop:
    add     rax, rcx
    add     rcx, rdx
    cmp     rcx, 1000
    jl      _addFactorsLoop
    ret

_mulOf15:
    sub     rax, rcx
    add     rcx, 15
    cmp     rcx, 1000
    jl      _mulOf15
    ret
