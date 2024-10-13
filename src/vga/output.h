#ifndef OUTPUT_H
#define OUTPUT_H

#define VGA_BUFF_ADDR 0xB8000
#define VGA_WIDTH = 80;
#define VGA_HEIGHT = 25;

#include "../utils.h"
#include "./cursor.h"


typedef enum vga_color {
	VGA_COLOR_BLACK,
	VGA_COLOR_BLUE,
	VGA_COLOR_GREEN,
	VGA_COLOR_CYAN,
	VGA_COLOR_RED,
	VGA_COLOR_MAGENTA,
	VGA_COLOR_BROWN,
	VGA_COLOR_LIGHT_GREY,
	VGA_COLOR_DARK_GREY,
	VGA_COLOR_LIGHT_BLUE,
	VGA_COLOR_LIGHT_GREEN,
	VGA_COLOR_LIGHT_CYAN,
	VGA_COLOR_LIGHT_RED,
	VGA_COLOR_LIGHT_MAGENTA,
	VGA_COLOR_LIGHT_BROWN,
	VGA_COLOR_WHITE,
}__attribute__((packed)) e_vga_color;


typedef struct vga_terminal
{
    unsigned int row;
    unsigned int column;
    uint8_t color;
    uint16_t *buffer;
}__attribute__((packed)) s_vga_terminal;

void terminal_init();
void terminal_putstr(char *str);
void terminal_putchar(char c);


#endif