[BITS 16]
[ORG 0x7C00]
start:
    cli ; Disable interrupts
    xor ax, ax ; Zero out AX register
    mov ds, ax ; Set DS register to 0
    mov es, ax ; Set ES register to 0
; Clear the screen
call clear_screen
; Display boot menu
call display_menu
    ; Initialize the keyboard
    mov al, 0xF4
    out 0x60, al    ; Send the reset command to the keyboard controller
    mov al, 0xF4
    out 0x60, al    ; Send the reset command again
                    ; Wait for user input
wait_for_input:
    mov ah, 0 ; BIOS keyboard interrupt function
    int 0x16 ; Wait for key press
    ; Check for valid scan code range (0x02 for '1', 0x03 for '2')
    cmp al, 0x02
    je normal_boot ; If '1' is pressed, jump to normal boot
    cmp al, 0x03
    je recovery_boot ; If '2' is pressed, jump to recovery boot
    jmp wait_for_input ; If invalid key, wait for input again
normal_boot:
    call load_kernel
    jmp 0x1000:0000 ; Jump to the kernel's entry point
recovery_boot:
    call load_recovery_kernel
    jmp 0x2000:0000 ; Jump to the recovery kernel's entry point
; Function to load the kernel
load_kernel:
    mov bx, 0x1000 ; Load address for the kernel (0x1000:0000)
    call read_sector
    ret
; Function to load the recovery kernel
load_recovery_kernel:
    mov bx, 0x2000 ; Load address for the recovery kernel (0x2000:0000)
    call read_sector
    ret
; Function to read a sector from the disk
read_sector:
    mov ah, 0x02 ; BIOS read sectors function
    mov al, 1 ; Number of sectors to read
    mov ch, 0 ; Cylinder number
    mov dh, 0 ; Head number
    mov cl, 2 ; Sector number (LBA 2)
    mov dl, 0x80 ; Drive number (first hard drive)
    int 0x13 ; BIOS interrupt
    jc read_error ; Jump if carry flag is set (read error)
    ret
read_error:
    mov si, error_msg
    call print_string
    jmp $
; Function to clear the screen
clear_screen:
    mov ax, 0xB800 ; Video memory segment
    mov es, ax
    xor di, di ; Set DI to 0
    mov ah, 0x07 ; Light gray on black
    mov al, ' ' ; Space character
    mov cx, 2000 ; 80x25 screen = 2000 characters
    rep stosw ; Fill video memory with spaces
    ret
; Function to display the boot menu
display_menu:
    mov si, menu_msg ; Load address of menu message
    call print_string ; Print the menu message
    ret
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
menu_msg db '1. Normal Boot', 0x0D, 0x0A, '2. Recovery Mode', 0x0D, 0x0A, 0
error_msg db 'Error loading kernel', 0
times 510 - ($ - $$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xAA55 ; Boot signature