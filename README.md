# iDOS

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

build:
	nasm -f bin -o kernel.bin src/kernel.asm
	mv kernel.bin bin/kernel.bin
	mkisofs -b kernel.bin -no-emul-boot -o kernel.iso bin/
	
clean:
	rm -rvf kernel.bin
	rm -rvf kernel.iso
```

Then to build and run, simply run `make all` in the terminal.
