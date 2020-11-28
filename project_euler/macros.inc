; Prints the value in RAX
; arg 1: bss var to print
; arg 2: 1 byte to use as a pointer
%macro prax 2
    %%printRAX:
        mov rcx, %1
        mov rbx, 0xA
        mov [rcx], rbx
        inc rcx
        mov [%2], rcx

    %%printRAXLoop:
        xor edx, edx
        mov rbx, 10
        div rbx
        push rax
        add rdx, 48

        mov rcx, [%2]
        mov [rcx], dl
        inc rcx
        mov [%2], rcx

        pop rax
        cmp rax, 0
        jne %%printRAXLoop

    %%printRAXLoop2:
        mov rcx, [%2]

        mov rax, 1
        mov rdi, 1
        mov rsi, rcx
        mov rdx, 1
        syscall

        mov rcx, [%2]
        dec rcx
        mov [%2], rcx

        cmp rcx, %1
        jge %%printRAXLoop2
%endmacro
