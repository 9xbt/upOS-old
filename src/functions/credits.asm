%include "src/core.asm"
%include "src/functions/clear.asm"

section .data
    msg_credits: db `                                -- CREDITS --                                 \r\n\0`

    ; ekeleze section
    msg_ekeleze: db `      _        _              \r\n     | |      | |             \r\n  ___| | _____| | ___ _______  Role: iDOS Contributor\r\n / _ \\ |/ / _ \\ |/ _ \\_  / _ \\ Other projects: ChaOS, GoOS, SpiderWeb, WebAce\r\n|  __/   <  __/ |  __// /  __/ About: A self taught developer.\r\n \\___|_|\\_\\___|_|\\___/___\\___| Links: www.ekeleze.net\r\n\0`

    ; xrc2 section
    msg_xrc2: db `                ___  \r\n               |__ \\ \r\n__  ___ __ ___   ) | Role: Owner\r\n\\ \\/ / '__/ __| / /  Other projects: ChaOS, GoOS, WebWatcher, 9xCode\r\n >  <| | | (__ / /_  About: Just an average coder that codes stuff.\r\n/_/\\_\\_|  \\___|____| Links: www.mobren.net\r\n\0`

    cmd_credits: db `credits\0`

section .text
    func_credits:
        write nl
        call func_clear
        cwrite msg_credits, $02
        cwrite msg_xrc2, $0E
        write nl
        cwrite msg_ekeleze, $0C

        mov cl, 0

        .loop:
            cmp cl, 10
            je .ret

            write nl

            inc cl
            jmp .loop

        .ret:
            ret

        ret