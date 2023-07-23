%include "src/core.asm"

section .data
    cmd_user: db "user"
    msg_user_no_args: db `No arguments specified. Required to change username.\r\n\0`

section .test
    func_user:
        mov si, input_buffer
        call len_string
        cmp si, 4
        je .no_args_given

        mov si, input_buffer + 5
        mov di, user_buffer
        call str_copy
        ret

        .no_args_given:
            write msg_user_no_args
            ret
