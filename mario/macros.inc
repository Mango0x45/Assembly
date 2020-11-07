%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro getchar 1
    xor eax, eax
    xor edi, edi
    mov rsi, %1
    mov rdx, 1
    syscall
%endmacro
