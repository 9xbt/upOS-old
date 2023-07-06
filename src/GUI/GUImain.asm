%include "src/GUIcore.asm"
%include "src/functions/clear.asm"

section .data
    cmd_gui: db `gui\0`

section .text
    gui_enable:
        mov ax, 4f02h
        mov bx, 106
        int 10h
        call gui_mode
        call func_clear
        ret

    gui_mode:
        mov bl, 0

        .guiloop:
            cmp bl, 1
            je .ret

            push bx
            push ax



            pixel 10, 10, $0F

            pop bx
            pop ax
            jmp .guiloop

        .ret:
            ret

        ret
