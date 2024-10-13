#ifndef UTILS_H
#define UTILS_H

#define DEBUG_PRINT(param_format, ...) \
    debug_print(__FUNCTION__, __FILE__, __LINE__, param_format, ##__VA_ARGS__)

typedef char uint8_t;
typedef short uint16_t;
typedef long uint32_t;

void outb(unsigned short port, unsigned char data);

#endif