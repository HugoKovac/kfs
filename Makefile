# Directories
OBJ_DIR = ./obj
SRC_C_DIR = ./src
SRC_ASM_DIR = ./src

# Source files
SRC_C = kmain.c
SRC_ASM = io.s loader.s

# Full paths for source and object files
FULL_SRC_C = $(addprefix $(SRC_C_DIR)/, $(SRC_C))
FULL_OBJ_C = $(addprefix $(OBJ_DIR)/, $(SRC_C:.c=.o))
FULL_SRC_ASM = $(addprefix $(SRC_ASM_DIR)/, $(SRC_ASM))
FULL_OBJ_ASM = $(addprefix $(OBJ_DIR)/, $(SRC_ASM:.s=.o))

# Tools and flags
CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
			-nostartfiles -nodefaultlibs -Wall -Wextra -Werror -I ./src  -c
LDFLAGS = -T ./src/link.ld -melf_i386 -I ./src
AS = nasm
ASFLAGS = -f elf32 -I ./src

# Targets
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

# Linking the kernel ELF
$(OBJ_DIR)/kernel.elf: $(FULL_OBJ_ASM) $(FULL_OBJ_C)
	ld $(LDFLAGS) $(FULL_OBJ_ASM) $(FULL_OBJ_C) -o $@

# Pattern rule for C files
$(OBJ_DIR)/%.o: $(SRC_C_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

# Pattern rule for ASM files
$(OBJ_DIR)/%.o: $(SRC_ASM_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

# Clean target
clean:
	rm -rf $(OBJ_DIR)/*

# Emulation using QEMU
emulate:
	qemu-system-i386 -cdrom obj/os.iso -monitor stdio

# Docker command
docker:
	docker compose up --no-deps --force-recreate --build

# Rebuild target
re: clean docker
