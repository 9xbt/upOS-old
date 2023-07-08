#ifndef TERMINAL_C
#define TERMINAL_C

#include "inttypes.h"
#include "ports/io_ports.c"

#define VGA_WIDTH 80

int CURSOR_X, CURSOR_Y;

void print_string(char* text, int color) {
  int counter = 0;

  while (1) {
    int start = (CURSOR_Y * VGA_WIDTH + CURSOR_X);

    if (*(text + counter) == '\0') {
      break;
    }

     if (*(text + counter) == '\n') {
      CURSOR_X = 0;
      CURSOR_Y ++;
    }
    
    else {
      print_char(*(text + start), color);

      CURSOR_X++;
      if (CURSOR_X == VGA_WIDTH) {
        CURSOR_X = 0;
        CURSOR_Y++;
      }
    }

    counter++;
  }

  set_cursor_pos(CURSOR_X, CURSOR_Y);
}

void print_char(char c, int color) {
  *((char*)0xB8000 + ((CURSOR_Y * VGA_WIDTH + CURSOR_X) * 2 + 1)) = color;
  *((char*)0xB8000 + ((CURSOR_Y * VGA_WIDTH + CURSOR_X) * 2))     = c;
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