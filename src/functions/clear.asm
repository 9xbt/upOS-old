%ifndef CLEAR_ASM
%define CLEAR_ASM

%include "src/core.asm"

section .data
    cmd_clear: db `clear\0`

section .text
    func_clear:
        mov ah, 00
        mov ax, 3
        mov bh, 0
        int 10h
        ret

%endif