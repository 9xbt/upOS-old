%include "src/core.asm"

section .data
    cmd_echo: db "echo"

section .text
    func_echo:
        mov si, input_buffer
        call len_string
        cmp si, 4
        je .no_args_given

        log input_buffer + 5
        ;write nl ; not needed since input buffer already has nl
        ret

        .no_args_given:
            write nl
            ret


