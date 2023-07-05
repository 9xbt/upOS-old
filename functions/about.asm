%include "core.asm"

section .data
    msg_about_1: db `-- iDOS --\r\n\0`
    msg_about_2: db ` Beta 1.2-pre\r\n Copyright (c) 2023 ImperiumSoft. All rights reserved.\r\n\n\0`

    cmd_about: db `about\0`

section .text
    func_about:
        write nl
        cwrite msg_about_1, $02
        write msg_about_2
        ret