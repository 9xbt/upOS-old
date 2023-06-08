all: clean compile isomake vm

clean:
	rm -rf out
	rm -rf cdiso
	rm -rf upOS.iso

compile:
	mkdir out
	nasm -f bin src/kernel_entry.s -o out/kernel.bin

isomake:
	mkdir cdiso
	dd if=out/kernel.bin of=cdiso/kernel.img
	mkisofs -b kernel.img -no-emul-boot -o iDOS.iso cdiso/

vm:
	qemu-system-i386 -cdrom iDOS.iso