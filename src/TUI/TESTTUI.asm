%include "src/core.asm"
%include "src/functions/clear.asm"

section .data
    cmd_tui_test: db `tui\0`
    text_one: db `one\0`
    text_two: db `two\0`

section .text
    tui_run:
        call func_clear
        mov ch, 0
        jmp .run

        .run:
            mov ah, 0h
            int 16h

            cmp al, 113
            je .down

            cmp al, 119
            je .up

            cmp al, 27
            je .ret

            cmp ch, 1
            je .display_one

            cmp ch, 2
            je .display_two

            jmp .run

        .ret:
            call func_clear
            ret

        .display_one:
            ;mov ah, 02h
            ;mov bh, 0
            ;mov dh, 10
            ;mov dl, 10
            ;int 10h

            write text_one
            jmp .run

        .display_two:
            ;mov ah, 02h
            ;mov bh, 0
            ;mov dh, 11
            ;mov dl, 10
            ;int 10h

            write text_two
            jmp .run

        .up:
            inc ch
            cmp ch, 0
            je .last

            jmp .run

        .down:
            cmp ch, 2
            je .first

            mov ch, 2
            jmp .run

        .last:
            mov ch, 2
            jmp .run

        .first:
            mov ch, 1
            jmp .run