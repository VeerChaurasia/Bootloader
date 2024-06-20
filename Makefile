# Makefile for bootloader

# Assemble the bootloader
boot.bin: boot.asm
	nasm -f bin -o boot.bin boot.asm

# Create a floppy disk image
floppy.img: boot.bin
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	dd if=boot.bin of=floppy.img conv=notrunc

# Run the bootloader with QEMU
run: floppy.img
	qemu-system-i386 -fda floppy.img

# Clean up generated files
clean:
	rm -f boot.bin floppy.img
