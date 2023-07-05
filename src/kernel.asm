[BITS 16]
org 0x7C00

jmp _start

%include "src/core.asm"
%include "src/functions/help.asm"
%include "src/functions/credits.asm"
%include "src/functions/about.asm"
%include "src/functions/clear.asm"

section .data
  startup_logo: db ` __  _______    ______    ______  \r\n|  \\|       \\  /      \\  /      \\ \r\n \\$$| $$$$$$$\\|  $$$$$$\\|  $$$$$$\\\r\n|  \\| $$  | $$| $$  | $$| $$___\\$$\r\n| $$| $$  | $$| $$  | $$ \\$$    \\ \r\n| $$| $$  | $$| $$  | $$ _\\$$$$$$\\\r\n| $$| $$__/ $$| $$__/ $$|  \\__| $$\r\n| $$| $$    $$ \\$$    $$ \\$$    $$\r\n \\$$ \\$$$$$$$   \\$$$$$$   \\$$$$$$ \r\n\n\0`
  msg_boot_successful: db `Welcome to imperiumDOS!\r\n\0`
  msg_version: db `Beta 1.2-dev\r\nCopyright (c) 2023 ImperiumSoft. All rights reserved.\r\n\0`
  msg_helptostart: db `Type help and press enter to get started.\r\n\n\0`

  prompt: db `$ \0`
  user_prompt: db ` $ \0`

  cmd_echo: db "echo"
  cmd_user: db "user"

  err_unknown: db `Unknown command.\r\n\0`
  err_missingargument: db `Not enough arguments.\r\n\0`
  err_argumentoverflow: db `Too many arguments.\r\n\0`

  msg_notimplemented: db `This command is not implemented, sorry!\r\n\0`

  input_buffer: times 0x4D db 0
  user_buffer: times 0x4D db 0

section .text
  _start:
    ; clear the registers
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    ; set the stack at 0x7C00
    mov sp, 0x7C00
  
    ; clear the screen
    mov ax, 3
    int 10h

    ; show startup screen
    ; log msg_boot_successful
    mov si, startup_logo
    mov bl, 0x02
    call print_string
    write msg_version
    write msg_helptostart

    jmp _loop ; go to main loop

  print_prompt:
    cmp byte [user_buffer], 0
    je .prompt

    jmp .userprompt

    .prompt:
      cwrite prompt, 0x0E
      ret

    .userprompt:
      cwrite user_prompt, 0x0E
      ret

  _loop:
    write user_buffer
    call print_prompt

    mov di, input_buffer
    call get_string
  
    mov si, input_buffer
    cmp byte [si], 0
    je _loop

    mov si, input_buffer
    mov di, cmd_help
    mov cl, 0x00
    call cmp_string
    jc .help

    mov si, input_buffer
    mov di, cmd_help_alias
    mov cl, 0x00
    call cmp_string
    jc .help
 
    mov si, input_buffer
    mov di, cmd_about
    mov cl, 0x00
    call cmp_string
    jc .about

    mov si, input_buffer
    mov di, cmd_clear
    mov cl, 0x00
    call cmp_string
    jc .clear

    mov si, input_buffer
    mov di, cmd_credits
    mov cl, 0x00
    call cmp_string
    jc .credits

    mov si, input_buffer
    mov di, cmd_echo
    mov cl, 'o'
    call cmp_string
    jc .echo

    mov si, input_buffer
    mov di, cmd_user
    mov cl, 'r'
    call cmp_string
    jc .user

    jmp .unknown
 
    ; Commands section

    .unknown:
      cwrite err_unknown, $0C
      jmp _loop

    .help:
      call func_help
      jmp _loop

    .about:
      call func_about
      jmp _loop

    .credits:
      call func_credits
      jmp _loop

    .clear:
      call func_clear
      jmp _loop

    .echo:
      log input_buffer + 5
      write nl
      jmp _loop

    .user:
      mov si, input_buffer + 5
      mov di, user_buffer
      call str_copy
      jmp _loop

    ;https://www.reddit.com/r/asm/comments/jd2osj/how_could_i_implement_a_delay_in_asm/

  get_string:
    xor cl, cl
      .loop:
        mov ah, 0
        int $16
  
        cmp al, $08
        je .backspace
   
        cmp al, 0x0D
        je .done
   
        cmp cl, 0x4D ; 77
        je .loop

        mov ah, $0e
        int 0x10

        stosb
        inc cl
        jmp .loop

      .backspace:
        cmp cl, 0
        je .loop

        dec di
        mov byte [di], 0
        dec cl
    
        ; move the cursor back 1 position
        mov ah, $0e
        mov al, $08
        int $10

        ; remove the character at the current position
        mov al, ' '
        int $10

        ; move the cursor back 1 position
        mov al, $08
        int $10

        jmp .loop

      .done:
        mov al,0
        stosb
      
        mov ah, $0e
        mov al, 0x0D
        int $10
        mov al, 0x0A
        int $10

        ret

  cmp_string:
    ; usage:
    ; mov si, your_string_1
    ; mov di, your_string_2
    ; the carry flag is set to high if they match

    .loop:
      mov al, [si]
      mov bl, [di]
      cmp al, bl
      jne .notequal

      cmp al, cl ; the string ending
      je .done

      inc di
      inc si

      jmp .loop

      .notequal:
        clc
        ret

      .done:
        stc
        ret

  len_string:
    ; usage:
    ; mov si, your_string
    ; si is the string length now

    mov di, 0

    .loop:
      mov al, [si] ; get the contents of si into al

      cmp al, 0x00 ; null character
      je .done ; jump if true

      inc si ; increment the pointers
      inc di

      jmp .loop

      .done:
        mov si, di ; move the length to si
        ret ; then retire

  str_copy:
    .loop:
      mov al, [si] ; get the contents of si into al
      mov [di], al

      cmp al, 0x00 ; null character
      je .done ; jump if true

      inc si ; increment the pointers
      inc di

      jmp .loop

      .done:
        ret ; then retire