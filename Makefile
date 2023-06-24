all: build
	/usr/bin/qemu/./qemu-system-i386 -cdrom kernel.iso

build: clean
	nasm -f bin -o kernel.bin kernel.asm
	mkisofs -b kernel.bin -no-emul-boot -o kernel.iso .

clean:
	rm -rvf kernel.bin
	rm -rvf cdiso
	rm -rvf kernel.iso

configure:
	sudo apt install nasm
	sudo apt install mkisofs
