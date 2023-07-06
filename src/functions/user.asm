%include "src/core.asm"

section .data
    cmd_user: db "user"

section .test
    func_user:
        mov si, input_buffer + 5
        mov di, user_buffer
        call str_copy
        ret