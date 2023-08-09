%include "src/core.asm"

section .data
    cmd_shutdown: db "shutdown", 0
    output2: db "Shutting Down...", 0

section .text
    func_shutdown:
        write output2
        call shutdown