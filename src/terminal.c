#ifndef TERMINAL_C
#define TERMINAL_C

#include "inttypes.h"
#include "ports/io_ports.c"
#include "stdbool.h"

#define VGA_WIDTH 80

int CursorX, CursorY;

void print_string(char* text, int color) {
  while (true) {
    int start = CursorY * VGA_WIDTH + CursorX;

    if (*(text) == '\0') {
      break;
    }

    if (*(text) == '\n') {
        CursorX = 0;
        CursorY++;
    }

    else {
      print_char(*(text), color);

      CursorX++;
      if (CursorX == VGA_WIDTH) {
        CursorX = 0;
        CursorY++;
      }
    }

    text++;
  }

  set_cursor_pos(CursorX, CursorY);
}

void print_char(char c, int color) {
  *((char*)0xB8000 + ((CursorY * VGA_WIDTH + CursorX) * 2 + 1)) = color;
  *((char*)0xB8000 + ((CursorY * VGA_WIDTH + CursorX) * 2))     = c;
}

void set_cursor_pos(uint8_t x, uint8_t y) {
    *((char*)0xB8000 + ((y * VGA_WIDTH + x) * 2 + 1)) = 0x0F;
    uint16_t cursorLocation = y * VGA_WIDTH + x;
    outportb(0x3D4, 14);
    outportb(0x3D5, cursorLocation >> 8);
    outportb(0x3D4, 15);
    outportb(0x3D5, cursorLocation);
    CursorX = x;
    CursorY = y;
}

#endif