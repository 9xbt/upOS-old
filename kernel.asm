org 0x7C00
bits 16

jmp main

; variables
startup_logo db ` __  _______    ______    ______  \r\n|  \\|       \\  /      \\  /      \\ \r\n \\$$| $$$$$$$\\|  $$$$$$\\|  $$$$$$\\\r\n|  \\| $$  | $$| $$  | $$| $$___\\$$\r\n| $$| $$  | $$| $$  | $$ \\$$    \\ \r\n| $$| $$  | $$| $$  | $$ _\\$$$$$$\\\r\n| $$| $$__/ $$| $$__/ $$|  \\__| $$\r\n| $$| $$    $$ \\$$    $$ \\$$    $$\r\n \\$$ \\$$$$$$$   \\$$$$$$   \\$$$$$$ \r\n\n\0`
msg_boot_successful db `Welcome to imperiumDOS!\r\n\0`
msg_version db `Beta 1.1\r\nCopyright (c) 2023 Imperium. All rights reserved\r\n\n\0`

buffer times 0x4D db `\0`
prompt db `$ \0`
nl db `\r\n\0`

cmd_credits db `credits`, 0x00
cmd_help db `help`, 0x00
cmd_about db `about`, 0x00
cmd_clear db `clear`, 0x00
cmd_echo db `echo`, 0x20 ; this one uses strstart so it ends in 0x20

msg_unknown db `Unknown command.\r\n\0`
msg_about_1 db `-- iDOS --\r\n\0`
msg_about_2 db ` Beta 1.0\r\nCopyright (c) 2023 Imperium\r\n\n\0`
msg_help_1 db `-- Functions --\r\n\0`
msg_help_2 db ` help - Shows all functions.\r\n about - Shows information about the project.\r\n clear - Clears the screen.\r\n echo - Echoes what you say.\r\n credits - Shows the credits.\r\n\n\0`
msg_credits_1 db `-- Credits --\r\n\0`
msg_credits_2 db ` xrc2 - Created the project.\r\n ekeleze - Contributor.\r\n\n\0`

%macro write 1
mov si, %1
call printf
%endmacro

%macro cwrite 3
; set color
mov bl, %2
mov cx, %3
mov ah, 09h
int 10h

write %1
%endmacro

%macro log 1
write %1
write `\r\n`
%endmacro

%macro clog 3
; set color
mov bl, %2
mov cx, %3
mov ah, 09h
int 10h

log %1
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
  clog startup_logo, 0x02, 680
  log msg_version

  jmp _loop ; go to main loop

_loop:
  mov si, prompt
  call printf

  mov di, buffer
  call getline

  mov si, buffer
  cmp byte [si], 0
  je _loop

  mov si, buffer
  mov di, cmd_help
  call strcmp
  jc .help
 
  mov si, buffer
  mov di, cmd_about
  call strcmp
  jc .about

  mov si, buffer
  mov di, cmd_clear
  call strcmp
  jc .clear

  mov si, buffer
  mov di, cmd_echo
  call strstart
  jc .echo

  mov si, buffer
  mov di, cmd_credits
  call strcmp
  jc .credits

  jc .unknown
 
  ; Commands section

  .unknown:
    cwrite msg_unknown, $0C, 16
    jmp _loop

  .help:
    write nl
    cwrite msg_help_1, $02, 15
    write msg_help_2
    jmp _loop

  .about:
    write nl
    cwrite msg_about_1, $02, 10
    log msg_about_2
    jmp _loop

  .credits:
    write nl
    cwrite msg_credits_1, $02, 13
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

printf:
  lodsb
  or al, al
  jz .ret
 
  mov ah, $0e
  int $10

  jmp printf

  .ret:
    ret

getline:
  xor cl, cl
    .loop:
      mov ah, 0
      int $16

      cmp al, $08
      je .backspace
   
      cmp al, 0x0D
      je .done
   
      cmp cl, 0x4D ; amount of characters to take
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
    
      mov ah, $0e
      mov al, $08
      int $10

      mov al, ' '
      int $10

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

strcmp:
  ; si: buffer
  ; di: command
 .loop:
  mov al, [si]
  mov bl, [di]
  cmp al, bl
  jne .notequal

  cmp al, 0
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

strstart:
  ; si: buffer
  ; di: command
 .loop:
  mov al, [si]
  mov bl, [di]
  cmp al, bl
  jne .notequal

  cmp al, 0x20 ; space char
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