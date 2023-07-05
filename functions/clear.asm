%ifndef CLEAR_ASM
%define CLEAR_ASM

%include "core.asm"

section .data
    cmd_clear: db `clear\0`

section .text
    func_clear:
        mov ax, 3
        int 10h
        ret

%endif