%include "core.asm"

section .data
    msg_credits_1: db `-- Credits --\r\n\0`
    msg_credits_2: db ` xrc2 - Owner.\r\n ekeleze - Developer.\r\n\n\0`

    cmd_credits: db `credits\0`

section .text
    func_credits:
        write nl
        cwrite msg_credits_1, $02
        write msg_credits_2
        ret