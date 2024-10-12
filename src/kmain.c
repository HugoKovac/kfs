#include "kmain.h"

void kmain(){
    s_vga_terminal vga = {0, 0, 0, (uint16_t*)VGA_BUFF_ADDR};
    terminal_init(&vga);
    terminal_putstr("42-kfs-1\nBy hkovac", &vga);
}
