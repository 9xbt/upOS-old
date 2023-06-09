[BITS 16]
org 0x7C00

jmp main

; variables
startup_logo db ` __  _______    ______    ______  \r\n|  \\|       \\  /      \\  /      \\ \r\n \\$$| $$$$$$$\\|  $$$$$$\\|  $$$$$$\\\r\n|  \\| $$  | $$| $$  | $$| $$___\\$$\r\n| $$| $$  | $$| $$  | $$ \\$$    \\ \r\n| $$| $$  | $$| $$  | $$ _\\$$$$$$\\\r\n| $$| $$__/ $$| $$__/ $$|  \\__| $$\r\n| $$| $$    $$ \\$$    $$ \\$$    $$\r\n \\$$ \\$$$$$$$   \\$$$$$$   \\$$$$$$ \r\n\n\0`
msg_boot_successful db `Welcome to imperiumDOS!\r\n\0`
msg_version db `Beta 1.2-pre\r\nCopyright (c) 2023 Imperium. All rights reserved\r\n\n\0`

buffer times 0x4D db 0
prompt db `$ \0`
nl db `\r\n\0`

cmd_credits db `credits\0`
cmd_help db `help\0`
cmd_about db `about\0`
cmd_clear db `clear\0`
cmd_echo db `echo`
cmd_edit db `edit`

err_unknown db `Unknown command.\r\n\0`
err_argument db `Not enough arguments.\r\n\0`

msg_about_1 db `-- iDOS --\r\n\0`
msg_about_2 db ` Beta 1.2-pre\r\n Copyright (c) 2023 Imperium\r\n\n\0`
msg_help_1 db `-- Functions --\r\n\0`
msg_help_2 db ` help - Shows all functions.\r\n about - Shows information about the project.\r\n clear - Clears the screen.\r\n echo - Echoes what you say.\r\n credits - Shows the credits.\r\n edit - Text editor.\r\n\n\0`
msg_credits_1 db `-- Credits --\r\n\0`
msg_credits_2 db ` xrc2 - Created the project.\r\n ekeleze - Contributor.\r\n\n\0`

cmd_edit_buffer times 0x7D0 db 0

%macro write 1
mov si, %1
mov bl, 0x07
call print_string
%endmacro

%macro cwrite 2
mov si, %1
call len_string

mov bl, %2
mov cx, si
call set_color

write %1
%endmacro

%macro log 1
write %1
write `\r\n`
%endmacro

%macro clog 2
cwrite %1, %2
write nl
%endmacro

main:
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
  mov bl, 0x02
  mov cx, 674
  call set_color
  log startup_logo
  log msg_version

  jmp _loop ; go to main loop

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
  mov cl, 'o'
  call cmp_string
  jc .echo

  mov si, buffer
  mov di, cmd_credits
  mov cl, 0x00
  call cmp_string
  jc .credits

  mov si, buffer
  mov di, cmd_edit
  mov cl, 't'
  call cmp_string
  jc .edit

  jc .err_unknown
 
  ; Commands section

  .err_unknown:
    cwrite err_unknown, $0C
    jmp _loop

  .err_argument:
    cwrite err_argument, $0C
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

  .edit:
    call clear_screen

    mov di, cmd_edit_buffer
    call cmd_edit_get_string

    ;log cmd_edit_buffer
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

  ;mov cx, 1
  ;call set_color
 
  mov ah, $0e
  int $10

  jmp print_string

  .ret:
    ret

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
  ; mov si, your_string_2
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
    inc al

    jmp .loop

    .done:
      mov si, di ; move the length to si
      ret ; then retire

cmd_edit_get_string:
  xor cl, cl
    .loop:
      mov ah, 0
      int $16

      cmp al, 0x08
      je .backspace

      cmp al, 0x0D
      je .newline
   
      cmp al, 0x1B
      je .done
   
      mov ah, $0e
      int 0x10

      stosb
      inc cl
      jmp .loop

    .backspace:
      push cx
      mov bh, 0
      mov ah, 03h
      int 10h
      pop cx

      cmp cl, 0
      je .loop

      dec di
      mov byte [di], 0
      dec cl

      cmp dl, 0
      je .decline
    
      ; move the cursor back 1 position
      mov ah, 0eh
      mov al, 08h
      int 10h

      ; remove the character at the current position
      mov al, ' '
      int $10

      ; move the cursor back 1 position
      mov al, 08h
      int 10h

      jmp .loop

    .decline:
      mov bh, 0
      mov dl, bl
      dec dh
      mov ah, 02h
      int 10h

      mov ah, 0eh
      mov al, ' '
      int 10h

      mov ah, 02h
      int 10h

      jmp .loop

    .done:
      write nl
      write cmd_edit_buffer

      mov al, 0
      stosb
      write nl
      ret

    .newline:
      ; dl = col
      ; dh = row
      push cx
      mov bh, 0
      mov ah, 03h
      int 10h
      pop cx

      mov bl, dl ; bl is not used, so store it there instead

      inc di
      mov byte [di], 0x0D ; \r
      inc di
      mov byte [di], 0x0A ; \n
      inc cl
      write nl
      jmp .loop