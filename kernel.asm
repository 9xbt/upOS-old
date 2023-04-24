org 0x7c00
bits 16

jmp _start ; start the os

; variables
startup_logo db " __  _______    ______    ______  ", 0x0d, 0x0a, "|  \|       \  /      \  /      \ ", 0x0d, 0x0a, ' \$$| $$$$$$$\|  $$$$$$\|  $$$$$$\', 0x0d, 0x0a, '|  \| $$  | $$| $$  | $$| $$___\$$', 0x0d, 0x0a, '| $$| $$  | $$| $$  | $$ \$$    \ ', 0x0d, 0x0a, '| $$| $$  | $$| $$  | $$ _\$$$$$$\', 0x0d, 0x0a, '| $$| $$__/ $$| $$__/ $$|  \__| $$', 0x0d, 0x0a, '| $$| $$    $$ \$$    $$ \$$    $$', 0x0d, 0x0a, ' \$$ \$$$$$$$   \$$$$$$   \$$$$$$ ', 0
msg_boot_successful db 'Boot successful!', 0
msg_version db 0x0d, 0x0a, 'Beta 1.0', 0x0d, 0x0a, 'Copyright (c) 2023 ImperiumX. All rights reserved', 0x0d, 0x0a, 0
msg_ram db '', 0

buffer times 255 db 0
prompt db 'usr > ', 0
nl db 0x0d, 0x0a, 0

cmd_help db 'help', 0
cmd_about db 'about', 0
cmd_clear db 'clear', 0
cmd_echo db 'echo', 0

msg_unknown db 'Unknown command.', 0x0d, 0x0a, 0
msg_about_1 db 'iDOS', 0x0d, 0x0a, 0
msg_about_2 db 'Beta 1.0', 0x0d, 0x0a, 'Copyright (c) 2023 Mobren', 0
msg_help_1 db 'Functions:', 0x0d, 0x0a, 0
msg_help_2 db ' help - Shows all functions', 0x0d, 0x0a, ' about - Shows about section for of iDOS', 0x0d, 0x0a, ' clear - Clears the screen', 0x0d, 0x0a, ' echo - Echoes what you say', 0x0d, 0x0a, 0

%macro write 1
; write %1
mov si, %1
call print_string
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
write %1 ; write %1
write nl ; write nl
%endmacro

%macro clog 3
; set color
mov bl, %2
mov cx, %3
mov ah, 09h
int 10h

write %1
write nl
%endmacro

_start:
  ; stuff
  mov ax, 0
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7c00
  mov ax, 3
  int 10h

  ; show startup screen
  log msg_boot_successful
  clog startup_logo, 0x02, 680
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
  call strcmp
  jc .echo

  jc .unknown
 
  ; Commands section

  .unknown:
    cwrite msg_unknown, 0x0C, 16
    jmp _loop

  .help:
    cwrite msg_help_1, 0x02, 10
    write msg_help_2
    jmp _loop

  .about:
    cwrite msg_about_1, 0x02, 4
    log msg_about_2
    jmp _loop

  .clear:
    mov ax, 3
    int 10h
    jmp _loop

  .echo
    mov di, buffer
    call get_string
    log buffer
    jmp _loop

print_string:
  lodsb
  or al, al
  jz .done
 
  mov ah, 0x0e
  int 0x10

  jmp print_string

  .done:
    ret

get_string:
  xor cl, cl
    .loop:
      mov ah, 0
      int 0x16

      cmp al, 0x08
      je .backspace
   
      cmp al, 0x0D
      je .done
   
      cmp cl, 0xFF ; amount of characters to take
      je .loop
   
      mov ah, 0x0e
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
    
      mov ah, 0x0e
      mov al, 0x08
      int 0x10

      mov al, ' '
      int 0x10

      mov al, 0x08
      int 0x10

      jmp .loop

    .done:
      mov al,0
      stosb
      
      mov ah, 0x0e
      mov al, 0x0d
      int 0x10
      mov al, 0x0a
      int 0x10

      ret

strcmp:
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
