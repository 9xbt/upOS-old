# iDOS-C boot file, boots the OS. What did you even expect it to do?

# set magic number to 0x1BADB002 to identified by bootloader 
.set MAGIC,    0x1BADB002

# set flags to 0
.set FLAGS,    0

# set the checksum
.set CHECKSUM, -(MAGIC + FLAGS)

# set multiboot enabled
.section .multiboot

# define type to long for each data defined as above
.long MAGIC
.long FLAGS
.long CHECKSUM


# set the stack bottom 
stackBottom:

# define the maximum size of stack to 512 bytes
.skip 1024


# set the stack top which grows from higher to lower
stackTop:

.section .text
.global _start
.type _start, @function

# iDOS entry point
_start:
	mov $stackTop, %esp
	call kernel_entry
	cli

hltLoop:
	hlt
	jmp hltLoop

.size _start, . - _start
