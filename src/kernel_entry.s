[BITS 16]
org 0x7C00

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
cmd_echo db `echo`, 0x20

msg_unknown db `Unknown command.\r\n\0`
msg_about_1 db `-- iDOS --\r\n\0`
msg_about_2 db ` Beta 1.0\r\nCopyright (c) 2023 Imperium\r\n\n\0`
msg_help_1 db `-- Functions --\r\n\0`
msg_help_2 db ` help - Shows all functions.\r\n about - Shows information about the project.\r\n clear - Clears the screen.\r\n echo - Echoes what you say.\r\n credits - Shows the credits.\r\n\n\0`
msg_credits_1 db `-- Credits --\r\n\0`
msg_credits_2 db ` xrc2 - Created the project.\r\n ekeleze - Contributor.\r\n\n\0`

aString db '  Hello  ', 0
; end variables

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

%include "src/kernel_loop.s"
%include "src/vga_text.s"
%include "src/string_utils.s"