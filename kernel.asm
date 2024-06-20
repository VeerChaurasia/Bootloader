bits 16
org 0x7E00  ; Example entry point for normal kernel

_start:
    ; Display a message on the screen
    mov si, hello_msg
    call print_string

    ; Infinite loop or other kernel functionality
    jmp $

hello_msg db 'Hello from kernel!', 0x0D, 0x0A, 0

print_string:
    ; Print string routine
    mov ah, 0x0E  ; BIOS teletype function
.next_char:
    lodsb          ; Load next byte from DS:SI
    cmp al, 0      ; Check for null terminator
    je .done       ; End of string
    int 0x10       ; BIOS video services
    jmp .next_char ; Print next character
.done:
    ret
