# Makefile for RISC-V ELF compilation and linking

# Compiler and flags
CC = riscv32-unknown-elf-gcc
CFLAGS = -march=rv32imc -mabi=ilp32 -mcmodel=medany \
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
ASM_FILE = $(BUILD_DIR)/output.asm

# Binary file
BIN_FILE = $(BUILD_DIR)/output.bin

.PHONY: all clean dump 

all: $(TARGET) dump

$(TARGET): $(SRCS) $(LDSCRIPT) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRCS) -o $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

dump: $(TARGET)
	riscv32-unknown-elf-objdump -d $(TARGET) > $(ASM_FILE)
	riscv32-unknown-elf-objcopy -O binary $(TARGET) $(BIN_FILE)

	

