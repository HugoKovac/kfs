#include "output.h"

uint8_t vga_color(e_vga_color fg, e_vga_color bg){
    return fg | bg << 4;
}

uint16_t vga_formated_char(char c, uint8_t color) 
{
	return (uint16_t) c | (uint16_t) color << 8;
}

void terminal_init(s_vga_terminal *vga) {
    vga->color = vga_color(VGA_COLOR_WHITE, VGA_COLOR_DARK_GREY);
    unsigned int idx = 0;
    for (unsigned int y = 0; y < 25; y++){
        for (unsigned int x = 0; x < 80; x++){
            idx = y * 80 + x;
            vga->buffer[idx] = vga_formated_char(' ', vga->color);
        }
    }
}

unsigned int strlen(char* str) 
{
	unsigned int len = 0;
	while (str[len])
		len++;
	return len;
}

void terminal_putchar(char c, s_vga_terminal *vga){
    unsigned idx = vga->row * 80 + vga->column;
    vga->buffer[idx] = vga_formated_char(c, vga->color);
    if (++vga->column == 80){
        vga->column = 0;
        if (++vga->row == 25)
            vga->row = 0;
    }
}

void terminal_write(char *str, unsigned int len, s_vga_terminal *vga){
    for (unsigned int i = 0; i < len; i++)
        terminal_putchar(str[i], vga);
}

void terminal_putstr(char *str, s_vga_terminal *vga){
    terminal_write(str, strlen(str), vga);
}
