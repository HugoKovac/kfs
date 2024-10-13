#include "gdt.h"

extern void gdt_flush(uint32_t);

s_gdt_entry gdt_entries[5];
s_gdp_ptr gdt_ptr;

void initGDT(){
    gdt_ptr.limit = sizeof(s_gdt_entry) * 5 - 1; 
    gdt_ptr.base = (uint32_t)&gdt_entries;

    // https://wiki.osdev.org/Global_Descriptor_Table
    //* Segments definition
    setGDTGate(0,0,0,0,0); // null
    setGDTGate(1,0,0xFFFFFFFF, 0x9A, 0xCF); // Kernel code
    setGDTGate(2,0,0xFFFFFFFF, 0x92, 0xCF); // Kernel data
    setGDTGate(3,0,0xFFFFFFFF, 0xFA, 0xCF); // User code
    setGDTGate(1,0,0xFFFFFFFF, 0xF2, 0xCF); // User data

    gdt_flush((uint32_t)&gdt_ptr);


}

void setGDTGate(uint32_t num, uint32_t base, uint32_t limit, uint32_t access, uint8_t gran){
    gdt_entries[num].base_low = (base & 0xFFFF);
    gdt_entries[num].base_middle = (base >> 16) & 0xFF;
    gdt_entries[num].base_high = (base >> 24) & 0xFF;

    gdt_entries[num].limit = (limit & 0xFFFF);
    gdt_entries[num].flags = (limit >> 16) & 0x0F;
    gdt_entries[num].flags |= (gran & 0xF0);

    gdt_entries[num].access = access;
}
