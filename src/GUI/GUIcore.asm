%macro pixel 3
mov ah, 0Ch
mov al, %3 ; color
mov bh, 0
mov cx, %1 ; X
mov dx, %2 ; Y
int 10h
%endmacro

%macro dmouse 3
; side 1
pixel %1, %2, %3
pixel %1 + 1, %2 + 1, %3
pixel %1 + 2, %2 + 2, %3
pixel %1 + 3, %2 + 3, %3
pixel %1 + 4, %2 + 4, %3
pixel %1 + 5, %2 + 5, %3
pixel %1 + 6, %2 + 6, %3
pixel %1 + 7, %2 + 7, %3
pixel %1 + 8, %2 + 8, %3
; side 2
pixel %1 + 7, %2 + 9, %3
pixel %1 + 6, %2 + 9, %3
pixel %1 + 5, %2 + 10, %3
pixel %1 + 4, %2 + 10, %3
pixel %1 + 3, %2 + 11, %3
pixel %1 + 2, %2 + 11, %3
pixel %1 + 1, %2 + 12, %3
pixel %1, %2 + 12, %3
; side 3
pixel %1, %2 + 11, %3
pixel %1, %2 + 10, %3
pixel %1, %2 + 9, %3
pixel %1, %2 + 8, %3
pixel %1, %2 + 7, %3
pixel %1, %2 + 6, %3
pixel %1, %2 + 5, %3
pixel %1, %2 + 4, %3
pixel %1, %2 + 3, %3
pixel %1, %2 + 2, %3
pixel %1, %2 + 1, %3
%endmacro

%macro kbr 1
mov ah, 1h
int 16h
%endmacro

