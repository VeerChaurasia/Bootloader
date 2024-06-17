; Kernel code
[BITS 16]
[ORG 0x1000] ; Normal boot kernel load address

start:
    mov ax, 0x07C0 ; Set up segment registers
    mov ds, ax
    mov es, ax
    mov si, kernel_msg ; Load kernel message address
    call print_string ; Print kernel message

    ; Halt the system
    cli ; Disable interrupts
    hlt ; Halt the CPU

; Function to print a null-terminated string
print_string:
    mov ah, 0x0E ; BIOS teletype function
.next_char:
    lodsb ; Load next byte from string
    or al, al ; Check if end of string (null terminator)
    jz .done ; If null terminator, end
    int 0x10 ; Print character
    jmp .next_char ; Repeat for next character
.done:
    ret

kernel_msg db 'Kernel loaded successfully!', 0x0D, 0x0A, 0

times 512 - ($ - $$) db 0 ; Pad the kernel to 512 bytes