all: build
	qemu-system-i386 -cdrom kernel.iso

build: clean
	touch kernel.bin
	nasm -f bin -o kernel.bin kernel.asm
	dd if=kernel.bin of=kernel.img
	mkdir -v cdiso
	mv -v kernel.img cdiso
	mkisofs -b kernel.img -no-emul-boot -o kernel.iso cdiso/

clean:
	rm -rvf kernel.bin
	rm -rvf cdiso
	rm -rvf kernel.iso
