%include "src/core.asm"

section .data
    msg_about_1: db `-- upOS --\r\n\0`
    msg_about_2: db ` Beta 1.2-dev\r\n Copyright (c) 2023 Mobren. All rights reserved.\r\n\n\0`

    cmd_about: db `about\0`

section .text
    func_about:
        write nl
        cwrite msg_about_1, $02
        write msg_about_2
        ret
