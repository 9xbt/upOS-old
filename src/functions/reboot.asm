%include "src/core.asm"

section .data
    cmd_reboot: db "reboot", 0
    output1: db "Rebooting...", 0

section .text
    func_reboot:
        write output1
        call reboot