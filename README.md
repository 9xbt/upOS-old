# iDOS
![image](https://github.com/9xbt/iDOS/actions/workflows/makefile.yml/badge.svg)

A simple kernel made in assembly.

![image](https://www.ekeleze.net/assets/external/iDOS.png)

## Building it
Prerequisites:
- make
- nasm
- qemu
- cdrtools

To install them simply run `sudo apt install prerequisite-here` on ubuntu-based distros<br>or `sudo pacman -S prerequisite-here` on arch-based distros.

Before you build it, you should set up a Makefile.<br>
(Note: The makefile is no longer included because the makefile sometimes varies from computer to computer)

It should look something like this if you are on linux: 
```
all: build
	qemu-system-i386 -cdrom kernel.iso

build: clean
	nasm -f bin -o kernel.bin kernel.asm
	mkisofs -b kernel.bin -no-emul-boot -o kernel.iso .

clean:
	rm -rvf kernel.bin
	rm -rvf cdiso
	rm -rvf kernel.iso
