[BITS 16]
org 0x7C00

jmp _start 

%macro write 1
mov si, %1
mov bl, $07
call print_string
%endmacro

%macro cwrite 2
mov bl, %2
mov si, %1
call print_string
%endmacro

%macro log 1
mov bl, 0x07
mov si, %1
call print_string
%endmacro

%macro clog 2
mov bl, %2
mov si, %1
call print_string
mov bl, $07
mov si, nl
call print_string
%endmacro

section .data:
  startup_logo: db ` __  _______    ______    ______  \r\n|  \\|       \\  /      \\  /      \\ \r\n \\$$| $$$$$$$\\|  $$$$$$\\|  $$$$$$\\\r\n|  \\| $$  | $$| $$  | $$| $$___\\$$\r\n| $$| $$  | $$| $$  | $$ \\$$    \\ \r\n| $$| $$  | $$| $$  | $$ _\\$$$$$$\\\r\n| $$| $$__/ $$| $$__/ $$|  \\__| $$\r\n| $$| $$    $$ \\$$    $$ \\$$    $$\r\n \\$$ \\$$$$$$$   \\$$$$$$   \\$$$$$$ \r\n\n\0`
  msg_boot_successful: db `Welcome to imperiumDOS!\r\n\0`
  msg_version: db `Beta 1.2-pre [build 020723a]\r\nCopyright (c) 2023 Imperium. All rights reserved\r\n\n\0`

  prompt: db `$ \0`
  nl: db `\r\n\0`

  cmd_credits: db `credits\0`
  cmd_help: db `help\0`
  cmd_about: db `about\0`
  cmd_clear: db `clear\0`
  cmd_echo: db "echo"
  cmd_user: db "user"

  err_unknown: db `Unknown command.\r\n\0`
  err_argument: db `Not enough arguments.\r\n\0`

  msg_about_1: db `-- iDOS --\r\n\0`
  msg_about_2: db ` Beta 1.2-pre\r\n Copyright (c) 2023 Imperium\r\n\n\0`
  msg_help_1: db `-- Functions --\r\n\0`
  msg_help_2: db ` help - Shows all functions.\r\n about - Shows information about the project.\r\n clear - Clears the screen.\r\n echo - Echoes what you say.\r\n credits - Shows the credits.\r\n user - Sets your username for this session.\r\n\n\0`
  msg_credits_1: db `-- Credits --\r\n\0`
  msg_credits_2: db ` xrc2 - Created the project, developer.\r\n ekeleze - Developer.\r\n\n\0`

  input_buffer: times 0x4D db 0
  user_buffer: times 0x4D db 0

section .text:
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
    log msg_boot_successful
    mov si, startup_logo
    mov bl, 0x02
    call print_string
    log msg_version

    jmp _loop ; go to main loop

  _loop:
    write user_buffer
    write prompt

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
      log input_buffer + 5
      write nl
      jmp _loop

    .user:
      ;log input_buffer + 5
      ;write nl
      mov si, user_buffer
      mov ah, 0x4D
      call str_clear

      ;mov si, input_buffer
      ;mov di, user_buffer
      ;call str_copy
      jmp _loop

  set_color:
    ; usage:
    ; mov bl, your_color
    ; mov cx, your_string_length
    mov ah, 09h
    int 10h
    ret
  
  clear_screen:
    mov ax, 3
    int 10h
    ret

  print_string:
    ; si = string pointer
    ; bl = color

    lodsb
    or al, al
    jz .ret

    cmp al, `\r`
    je .writechar
    cmp al, `\n`
    je .writechar

    ;pusha
    mov cx, 1
    call set_color
    ;popa

    jmp .writechar

    jmp print_string

    .writechar:
      mov ah, $0e
      int $10
      jmp print_string

    .ret:
      ret

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
    ; si = string
    ; di = destination

    ; usage:
    ; mov si, your_string
    ; si is the string length now

    .loop:
      mov al, [si] ; get the contents of si into al

      cmp al, 0 ; null character
      je .ret ; jump if true

      mov [di], al

      inc si ; increment the pointers
      inc di

      jmp .loop

      .ret:
        ret

  str_clear:
    ; si = string
    ; ah = length

    ; usage:
    ; mov si, your_string
    ; si is the string length now

    mov al, 0

    .loop:
      cmp al, ah ; string length
      je .ret ; jump if true

      mov si, 65

      inc si ; increment the pointers
      inc al

      jmp .loop

      .ret:
        ret