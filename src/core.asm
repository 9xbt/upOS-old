%ifndef CORE_ASM
%define CORE_ASM

%macro write 1
mov bl, 0x07
mov si, %1
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
mov bl, $07
mov si, nl
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

section .data
  nl: db `\r\n\0`

  err_unknown: db `Unknown command.\r\n\0`
  err_missingargument: db `Not enough arguments.\r\n\0`
  err_argumentoverflow: db `Too many arguments.\r\n\0`

  msg_notimplemented: db `This command is not implemented, sorry!\r\n\0`

section .text
  set_color:
    ; usage:
    ; mov bl, your_color
    ; mov cx, your_string_length
    mov ah, 09h
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
      mov ah, 0xE
      int 10h
      jmp print_string

    .ret:
      ret

    print_char:
      ; al = char
      mov ah, 0xE
      int 10h
      ret

%endif
