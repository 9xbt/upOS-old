[bits 16]

_loop:
  mov si, prompt
  call print_string

  mov di, buffer
  call get_string

  mov si, buffer
  cmp byte [si], 0
  je _loop

  mov si, buffer
  mov di, cmd_help
  mov cl, 0x00
  call cmp_string
  jc .help
 
  mov si, buffer
  mov di, cmd_about
  mov cl, 0x00
  call cmp_string
  jc .about

  mov si, buffer
  mov di, cmd_clear
  mov cl, 0x00
  call cmp_string
  jc .clear

  mov si, buffer
  mov di, cmd_echo
  mov cl, 0x20
  call cmp_string
  jc .echo

  mov si, buffer
  mov di, cmd_credits
  mov cl, 0x00
  call cmp_string
  jc .credits

  jc .unknown
 
  ; Commands section

  .unknown:
    cwrite msg_unknown, $0C
    jmp _loop

  .help:
    write nl
    cwrite msg_help_1, $02
    write msg_help_2
    jmp _loop

  .about:
    write nl
    cwrite msg_about_1, $02
    log msg_about_2
    jmp _loop

  .credits:
    write nl
    cwrite msg_credits_1, $02
    log msg_credits_2
    jmp _loop

  .clear:
    mov ax, 3
    int 10h
    jmp _loop

  .echo:
    log buffer + 5
    write nl
    jmp _loop