#ifndef GDT_H
#define GDT_H

#include "../utils.h"

typedef struct gdt_entry {
    uint16_t limit;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t flags;
    uint8_t base_high;

}__attribute__((packed)) s_gdt_entry;

typedef struct gdt_ptr{
    uint16_t limit;
    unsigned int base;
}__attribute((packed)) s_gdp_ptr;

void initGDT();
void setGDTGate(uint32_t num, uint32_t base, uint32_t limit, uint32_t access, uint8_t gran);

#endif