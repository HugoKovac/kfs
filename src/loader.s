global loader

KERNEL_STACK_SIZE equ 4096
MAGIC_NUMBER    equ 0x1BADB002
FLAGS           equ 0x0
CHECKSUM        equ -MAGIC_NUMBER

section .text:
align 4
    dd MAGIC_NUMBER
    dd FLAGS
    dd CHECKSUM

section .bss:
align 4
kernel_stack:
    resb KERNEL_STACK_SIZE

loader:
    ;mov eax, 0xCAFEBABE
    mov esp, kernel_stack + KERNEL_STACK_SIZE


.loop:
    extern sum_of_three
    push dword 3
    push dword 2
    push dword 1
    call sum_of_three
    jmp .loop