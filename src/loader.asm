global loader

KERNEL_STACK_SIZE equ 4096
MAGIC_NUMBER    equ 0x1BADB002
FLAGS           equ 0x0
CHECKSUM        equ -MAGIC_NUMBER

section .text
align 4
    dd MAGIC_NUMBER
    dd FLAGS
    dd CHECKSUM

section .bss
align 4
kernel_stack:
    resb KERNEL_STACK_SIZE

section .data
    ; Initialized data goes here

section .rodata
    ; Read-only data such as string literals go here

section .text
loader:
    ; Set up stack
    mov esp, kernel_stack + KERNEL_STACK_SIZE

    ; Call the kernel main function
    extern kmain
    call kmain

.loop:
    hlt
    jmp .loop
