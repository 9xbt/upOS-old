#include "inttypes.h"

void kernel_entry() {
  print_string("Hello, world!", 0x0F);
}

void print_string(char* text, int color){ 
  int counter = 0;

  while (1) {
    if (*(text + counter) == '\0') {
      break;
    }
    
    *((char*)0xB8000 + (counter * 2 + 1)) = color;
    *((char*)0xB8000 + (counter * 2)) = *(text + counter);

    counter++;
  }
}
