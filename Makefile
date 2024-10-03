OBJ_DIR = ./obj
SRC_C_DIR = ./src
SRC_C = kmain.c
FULL_SRC_C = $(addprefix $(SRC_C_DIR)/, $(SRC_C))
FULL_OBJ_C = $(addprefix $(OBJ_DIR)/, $(SRC_C:.c=.o))
SRC_ASM_DIR = ./src
SRC_ASM = loader.s
FULL_SRC_ASM = $(addprefix $(SRC_ASM_DIR)/, $(SRC_ASM))
FULL_OBJ_ASM = $(addprefix $(OBJ_DIR)/, $(SRC_ASM:.s=.o))
OBJ = $(SRC_ASM:.s=.o) $(SRC_C:.c=.o)
FULL_OBJ = $(addprefix $(OBJ_DIR)/, $(OBJ))
CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
			-nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
LDFLAGS = -T ./src/link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf32

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

$(OBJ_DIR)/kernel.elf: $(FULL_OBJ_ASM) $(FULL_OBJ_C) 
	ld $(LDFLAGS) $(FULL_OBJ) -o $(OBJ_DIR)/kernel.elf


$(FULL_OBJ_C): $(FULL_SRC_C)
	$(CC) $(CFLAGS)  $< -o $@

$(FULL_OBJ_ASM): $(FULL_SRC_ASM)
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(OBJ_DIR)/*

emulate:
	qemu-system-i386 -cdrom obj/os.iso -monitor stdio

docker:
	docker compose up --no-deps --force-recreate --build

re: clean docker