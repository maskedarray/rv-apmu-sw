# Makefile for RISC-V ELF compilation and linking

# Compiler and flags
CC = riscv32-unknown-elf-gcc
CFLAGS = -march=rv32im -mabi=ilp32 -mcmodel=medany \
         -Wall -fvisibility=hidden -ffreestanding \
         -nostartfiles -O0

# Source directory
SRC_DIR = src

# Source files
SRCS = $(SRC_DIR)/crt0.s $(SRC_DIR)/main.c

# Linker script
LDSCRIPT = $(SRC_DIR)/linker.ld
LDFLAGS = -T $(LDSCRIPT)

# Build directory
BUILD_DIR = build

# Output file
TARGET = $(BUILD_DIR)/output.elf

# Assembly dump file
ASM_FILE_DISASM = $(BUILD_DIR)/output.asm
ASM_FILE = $(BUILD_DIR)/main.s
OBJ_FILES = $(BUILD_DIR)/crt0.o $(BUILD_DIR)/main.o

# Binary file
BIN_FILE = $(BUILD_DIR)/output.bin

# Custom instruction modification script
MODIFY_SCRIPT = Implinstr.py

.PHONY: all clean dump 

all: $(TARGET) dump

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/crt0.o: $(SRC_DIR)/crt0.s | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/main.s: $(SRC_DIR)/main.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -S $< -o $@

$(BUILD_DIR)/main.o: $(BUILD_DIR)/main.s | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Modify the .s files
modified: $(BUILD_DIR)/main.s $(SRC_DIR)/crt0.s
	python3 $(MODIFY_SCRIPT) $(BUILD_DIR)/main.s $(SRC_DIR)/crt0.s

# Compile .s to .o after modification
compile_asm: $(BUILD_DIR)/crt0.o $(BUILD_DIR)/main.o

# Link object files to create ELF
$(TARGET): modified compile_asm | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJ_FILES) -o $@

clean:
	rm -rf $(BUILD_DIR)

dump: $(TARGET)
	riscv32-unknown-elf-objdump -d $(TARGET) > $(ASM_FILE_DISASM)
	riscv32-unknown-elf-objcopy -O binary $(TARGET) $(BIN_FILE)

generate-assembly: $(BUILD_DIR)
	$(CC) $(CFLAGS) -S src/main.c -o $(BUILD_DIR)/main.S

clang: 
	clang --target=riscv32-unknown-elf -march=rv32imc -nostartfiles -nostdlib src/main.c -o main.o
	

