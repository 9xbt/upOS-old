[bits 16]

trim_string_start:
  .loop:
    mov al, [si]

    cmp al, 0x20
    jne .notequal

    inc si
    jmp .loop

  .notequal:
    ret

trim_string_end:
  .loop:
    mov al, [si]

    cmp al, 0x20
    jne .notequal

    dec si
    jmp .loop

  .notequal:
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