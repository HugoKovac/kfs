# Directories
OBJ_DIR = ./obj
SRC_C_DIR = ./src
SRC_ASM_DIR = ./src
OBJ_DIRS = $(OBJ_DIR)/vga $(OBJ_DIR)/gdt $(OBJ_DIR)/interrupts


SRC_C = kmain.c vga/output.c vga/cursor.c interrupts/idt.c
SRC_ASM = loader.asm utils.asm interrupts/idt_asm.asm

FULL_SRC_C = $(addprefix $(SRC_C_DIR)/, $(SRC_C))
FULL_OBJ_C = $(addprefix $(OBJ_DIR)/, $(SRC_C:.c=.o))
FULL_SRC_ASM = $(addprefix $(SRC_ASM_DIR)/, $(SRC_ASM))
FULL_OBJ_ASM = $(addprefix $(OBJ_DIR)/, $(SRC_ASM:.asm=.o))

CC = gcc
CFLAGS = -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
			-nostartfiles -nodefaultlibs -Wall -Wextra -Werror -I./src  -c
LDFLAGS = -g -T ./src/link.ld -melf_i386  -I./src
AS = nasm
ASFLAGS = -f elf32 -I./src

all: iso

iso: $(OBJ_DIR)/kernel.elf
	cp $(OBJ_DIR)/kernel.elf iso/boot/kernel.elf
	genisoimage -R                              \
				-b boot/grub/stage2_eltorito    \
				-no-emul-boot                   \
				-boot-load-size 4               \
				-A os                           \
				-input-charset utf8             \
				-quiet                          \
				-boot-info-table                \
				-o $(OBJ_DIR)/os.iso			\
				iso

$(OBJ_DIRS):
	mkdir -p $(OBJ_DIR)/vga
	mkdir -p $(OBJ_DIR)/gdt
	mkdir -p $(OBJ_DIR)/interrupts

$(OBJ_DIR)/kernel.elf: $(OBJ_DIRS) $(FULL_OBJ_ASM) $(FULL_OBJ_C)
	ld $(LDFLAGS) $(FULL_OBJ_ASM) $(FULL_OBJ_C) -o $@

$(OBJ_DIR)/%.o: $(SRC_C_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_DIR)/%.o: $(SRC_ASM_DIR)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(OBJ_DIR)/*

emulate:
	qemu-system-i386 -cdrom obj/os.iso

docker:
	docker compose up --force-recreate

re: clean all emulate
