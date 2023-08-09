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

  ; non fatal
  err_unknown: db `Unknown command.\r\n\0`
  err_missingargument: db `Not enough arguments.\r\n\0`
  err_argumentoverflow: db `Too many arguments.\r\n\0`
  err_notimplemented: db `This command has not yet been implemented!\r\n\0`

  ; fatal
  fatal_generic: db `A fatal error has occured.\r\nPlease alert the developers as soon as possible.\r\n\0`

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

    shutdown:
        mov ax, 0x1000
        mov ax, ss
        mov sp, 0xf000
        mov ax, 0x5307
        mov bx, 0x0001
        mov cx, 0x0003
        int 0x15
    
    reboot:
        db 0x0ea 
        dw 0x0000 
        dw 0xffff

%endif
