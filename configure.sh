#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 0
fi

declare -i nasmExists=0
declare -i mkisoExists=0
declare -i qemuExists=0

echo "Preparing system for build..."
echo

echo -n "Checking if system is debian-based or ubuntu-based... "

if uname -a | grep -q 'Ubuntu\|ubuntu' ; then
    echo "ok"
elif gcc --version | grep -q 'Debian\|debian'; then
    echo "ok"
else
    echo "fail"
    exit 1
fi

echo -n "Checking if nasm exists... "

if command -v nasm &> /dev/null
then
    echo "ok"
    ((nasmExists++))
else
    echo "fail"
    exit 1
fi

echo -n "Checking if mkisofs exists... "

if command -v mkisofs &> /dev/null
then
    echo "ok"
    ((mkisoExists++))
else
    echo "fail"
    exit 1
fi

echo -n "Checking if qemu-system-i386 exists... "

if command -v qemu-system-i386 &> /dev/null
then
    echo "ok"
    ((qemuExists++))
else
    echo "fail"
    exit 1
fi

if [ $nasmExists == 1 ] && [ $mkisoExists == 1 ] && [ $qemuExists == 1 ]; then
    echo "No configure jobs to do. nasm, mkisofs & qemu already exist."
    exit 0
fi

if [ $nasmExists == 0 ]; then
    echo "nasm doesn't exist. Installing..."
    apt install nasm
fi

if [ $mkisoExists == 0 ]; then
    echo "mkisofs doesn't exist. Installing..."
    apt install mkisofs
fi

if [ $qemuExists == 0 ]; then
    echo "qemu-system-i386 doesn't exist. Installing..."
    apt install qemu
    apt install qemu-system-i386
fi

echo "All configure jobs finished."
exit 0