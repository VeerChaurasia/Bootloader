; KERNEL.BIN - Example kernel code

org 0x7E00    ; Kernel entry point

start:
    ; Set up stack
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF

    ; Display message
    mov si, hello_msg
    call print_string

    ; Infinite loop (halt)
.loop:
    jmp .loop

; Function to print a string
print_string:
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

; Data Section
hello_msg db 'Hello from KERNEL.BIN!', 0

times 512-($-$$) db 0  
