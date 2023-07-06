#ifndef TERMINAL_C
#define TERMINAL_C

#include "inttypes.h"
#include "ports/io_ports.c"

#define VGA_WIDTH 80

int CURSOR_X, CURSOR_Y;

void print_string(char* text, int color){ 
  int counter = 0;
  int start = (CURSOR_Y * VGA_WIDTH + CURSOR_X) * 2;

  while (1) {
    if (*(text + counter) == '\0') {
      break;
    }

    *((char*)0xB8000 + (counter * 2 + 1) + start) = color;
    *((char*)0xB8000 + (counter * 2) + start) = *(text + counter);

    counter++;

    CURSOR_X = counter;
    if (CURSOR_X > VGA_WIDTH) {
        CURSOR_X = 0;
        CURSOR_Y++;
    }
  }

  set_cursor_pos(CURSOR_X, CURSOR_Y);
}

void set_cursor_pos(uint8_t x, uint8_t y) {
    *((char*)0xB8000 + ((y * VGA_WIDTH + x) * 2 + 1)) = 0x0F;
    uint16_t cursorLocation = y * VGA_WIDTH + x;
    outportb(0x3D4, 14);
    outportb(0x3D5, cursorLocation >> 8);
    outportb(0x3D4, 15);
    outportb(0x3D5, cursorLocation);
}

#endif