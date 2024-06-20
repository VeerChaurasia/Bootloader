# Simple Bootloader Project

## Project Description
This project is a simple bootloader written in Assembly language for x86 architecture. The bootloader displays a welcome message and a menu with options to load a kernel, enter recovery mode, or display the system's memory map. The primary goal of this project is to understand the basics of bootloaders, BIOS interrupts, and memory mapping in x86 systems.

## How to Run the Project

### Dependencies
- **NASM**: The Netwide Assembler, used to assemble the bootloader.
- **QEMU**: An open-source emulator that is used to run the bootloader.

### Steps to Run
1. **Install NASM and QEMU**:
    - On Ubuntu/Debian:
      ```sh
      sudo apt-get update
      sudo apt-get install nasm qemu
      ```
    - On macOS using Homebrew:
      ```sh
      brew install nasm qemu
      ```
2. **Clone the Repository**:
    ```sh
    git clone <repository_url>
    cd <repository_directory>
    ```
3. **Build the Bootloader**:
    ```sh
    make
    ```
4. **Run the Bootloader in QEMU**:
    ```sh
    make run
    ```
5. **Clean Up Generated Files**:
    ```sh
    make clean
    ```

## Internal Working of the Project

### Theory
A bootloader is a small program that is loaded by the BIOS from the boot sector of a storage device. Its main purpose is to load the operating system kernel into memory and transfer control to it. In this project, the bootloader performs the following tasks:

1. **Setup**:
    - Initializes the stack.
    - Clears the screen using BIOS interrupts.

2. **Menu Display**:
    - Shows a welcome message and a menu with options to load a kernel, enter recovery mode, or display the memory map.

3. **User Input**:
    - Waits for user input and jumps to the corresponding section based on the key pressed.

4. **Kernel Loading and Recovery Mode**:
    - Displays a message("Hello from Kernel!!)

5. **Memory Map Display**:
    - Uses BIOS interrupt `0x15` with function `0xE820` to get the memory map and displays it on the screen.

### Bootloader Code Breakdown
- **Stack Initialization**: Setting up the stack to a known location.
- **Screen Clearing**: Using BIOS interrupt `0x10` to set the video mode and clear the screen.
- **Printing Strings**: A simple function to print null-terminated strings using BIOS interrupt `0x10`.
- **Getting Key Presses**: Waiting for a key press using BIOS interrupt `0x16`.
- **Memory Map Retrieval**: Calling BIOS interrupt `0x15` with `0xE820` to get memory map entries and displaying them.

### Learning Takeaways
- Understanding how x86 bootloaders interact with BIOS.
- Learning to use BIOS interrupts for various functions.
- Gaining insights into low-level programming and memory management.
- Experiencing the process of assembling and linking code for bootloaders.
- Realizing the importance of efficient and compact code in bootloader development.

### Resources/References
- [OSDev Wiki](https://wiki.osdev.org/Main_Page): Comprehensive resource for OS development.
- [NASM Documentation](https://www.nasm.us/doc/): Official documentation for NASM assembler.
- [BIOS Interrupts](https://en.wikipedia.org/wiki/BIOS_interrupt_call): Information on BIOS interrupt calls.


