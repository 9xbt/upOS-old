[bits 16]

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