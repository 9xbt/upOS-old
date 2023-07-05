# iDOS
![image](https://github.com/9xbt/iDOS/actions/workflows/makefile.yml/badge.svg)

A simple kernel made in assembly.

![image](https://user-images.githubusercontent.com/109512837/233864806-b14c6f2a-7d7a-4c0e-9337-b6667efbf62b.png)

## Building it
Prerequisites:
- make
- nasm
- qemu
- cdrtools

To install them simply run `sudo apt install prerequisite-here` on ubuntu-based distros, or `sudo pacman -S prerequisite-here` on arch-based distros.

To build iDOS you simply need to do `make all`, this will build the kernel and run it.
