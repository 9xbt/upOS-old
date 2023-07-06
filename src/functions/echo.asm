%include "src/core.asm"

section .data
    cmd_echo: db "echo"

section .text
    func_echo:
        log input_buffer + 5
        write nl
        ret


