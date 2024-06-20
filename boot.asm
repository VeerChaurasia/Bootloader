
org 0x7C00
bits 16

start:
    ; Set up stack
    cli
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Clear the screen
    mov ah, 0x00    ; AH = 0x00 -> Video Services - Set Video Mode
    mov al, 0x03    ; AL = 0x03 -> Video Mode 80x25, 16 colors
    int 0x10        ; Video Services - Call BIOS

    ; Display welcome message
    mov si, welcome_msg
    call print_string

    ; Display menu
    mov si, menu_msg
    call print_string

    ; Read user input
    call get_key
    cmp al, '1'
    je load_kernel_message
    cmp al, '2'
    je show_disk_error
    cmp al, '3'
    je display_memory_map

    ; Default to normal boot (show welcome message again)
    jmp start

load_kernel_message:
    ; Clear screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Display message from kernel
    mov si, kernel_hello_msg
    call print_string

    ; Infinite loop to halt
    jmp $

show_disk_error:
    ; Display disk error message
    mov si, disk_error_msg
    call print_string

    ; Wait for key press to reboot
    mov si, press_any_key_msg
    call print_string
    call get_key   ; Wait for any key press

    ; Reboot (using BIOS function)
    mov ax, 0
    int 0x16       ; BIOS function - wait for key press
    int 0x19       ; BIOS function - warm boot

display_memory_map:
    ; Clear screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Display memory map title
    mov si, memory_map_title_msg
    call print_string

    ; Simulated memory map display
    mov si, memory_map_msg
    call print_string

    ; Prompt to reboot
    mov si, press_any_key_msg
    call print_string
    call get_key   ; Wait for any key press

    ; Reboot (using BIOS function)
    mov ax, 0
    int 0x16       ; BIOS function - wait for key press
    int 0x19       ; BIOS function - warm boot

print_string:
    ; Print string at DS:SI
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

get_key:
    ; Get key press
    xor ah, ah
    int 0x16
    ret

; Data Section
welcome_msg db 'Welcome to the Bootloader', 0x0D, 0x0A, 0
menu_msg db '1. Load Kernel', 0x0D, 0x0A, '2. Recovery Mode', 0x0D, 0x0A, '3. Display Memory Map', 0x0D, 0x0A, 0
kernel_hello_msg db 'Hello from kernel!', 0x0D, 0x0A, 0
disk_error_msg db 'Disk error: Kernel not found', 0x0D, 0x0A, 0
press_any_key_msg db 'Press any key to reboot...', 0x0D, 0x0A, 0
memory_map_title_msg db 'Memory Map:', 0x0D, 0x0A, 0
memory_map_msg db 'Base Address: 0x00000000, Length: 0x1000000 bytes (16 MB)', 0x0D, 0x0A
                db 'Base Address: 0x10000000, Length: 0x200000 bytes (2 MB)', 0x0D, 0x0A
                db 'Base Address: 0x20000000, Length: 0x400000 bytes (4 MB)', 0x0D, 0x0A
                ; db 'Base Address: 0x60000000, Length: 0x10000000 bytes (256 MB)', 0x0D, 0x0A
                ; db 'Base Address: 0xA0000000, Length: 0x20000000 bytes (512 MB)', 0x0D, 0x0A, 0

; Padding to ensure bootloader fits within 512 bytes
times 510-($-$$) db 0
dw 0xAA55       ; Boot signature


