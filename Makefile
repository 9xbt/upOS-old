all: clean bin iso

configure:
	sudo apt install nasm
	sudo apt install mkisofs

bin:
	touch kernel.bin
	nasm -f bin -o kernel.bin kernel.asm

iso:
	dd if=kernel.bin of=kernel.img
	mkdir -v cdiso
	mv -v kernel.img cdiso
	mkisofs -b kernel.img -no-emul-boot -o kernel.iso cdiso/

run: 
	make all
	qemu-system-i386 -cdrom kernel.iso

clean:
	rm -rvf kernel.bin
	rm -rvf cdiso
	rm -rvf kernel.iso
