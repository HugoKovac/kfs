#ifndef OUTPUT_H
#define OUTPUT_H

#define VGA_BUFF_ADDR 0xB8000
#define VGA_WIDTH = 80;
#define VGA_HEIGHT = 25;

#define DEBUG_PRINT(param_format, ...) \
    debug_print(__FUNCTION__, __FILE__, __LINE__, param_format, ##__VA_ARGS__)

typedef char uint8_t;
typedef short uint16_t;


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
} e_vga_color;


typedef struct vga_terminal
{
    unsigned int row;
    unsigned int column;
    uint8_t color;
    uint16_t *buffer;
} s_vga_terminal;

void terminal_init(s_vga_terminal *vga);
void terminal_putstr(char *str, s_vga_terminal *vga);


#endif