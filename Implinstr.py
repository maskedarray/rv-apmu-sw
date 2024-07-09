import sys
import re

register_map = {
    "x0": 0, "x1": 1, "x2": 2, "x3": 3, "x4": 4, "x5": 5, "x6": 6, "x7": 7,
    "x8": 8, "x9": 9, "x10": 10, "x11": 11, "x12": 12, "x13": 13, "x14": 14, "x15": 15,
    "x16": 16, "x17": 17, "x18": 18, "x19": 19, "x20": 20, "x21": 21, "x22": 22, "x23": 23,
    "x24": 24, "x25": 25, "x26": 26, "x27": 27, "x28": 28, "x29": 29, "x30": 30, "x31": 31,
    "zero": 0, "ra": 1, "sp": 2, "gp": 3, "tp": 4, "t0": 5, "t1": 6, "t2": 7, "s0": 8, "fp": 8,
    "s1": 9, "a0": 10, "a1": 11, "a2": 12, "a3": 13, "a4": 14, "a5": 15, "a6": 16, "a7": 17,
    "s2": 18, "s3": 19, "s4": 20, "s5": 21, "s6": 22, "s7": 23, "s8": 24, "s9": 25, "s10": 26, "s11": 27,
    "t3": 28, "t4": 29, "t5": 30, "t6": 31
}

def modify_asm(file):
    with open(file, 'r') as f:
        lines = f.readlines()

    pattern = re.compile(r'cnt\.rd\s+(\w+),\s*(\w+)')
    modified_lines = []
    
    for line in lines:
        match = pattern.search(line)
        if match:
            reg0 = match.group(1)
            reg1 = match.group(2)
            if reg0 in register_map and reg1 in register_map:
                reg0_val = register_map[reg0]
                reg1_val = register_map[reg1]
                machine_code = (reg1_val << 15) | (0x000 << 12) | (reg0_val << 7) | 0x07
                modified_lines.append(f".word 0x{machine_code:08x}\n")
            else:
                print(f"Error: Unknown register(s) {reg0}, {reg1} in line: {line}")
                modified_lines.append(line)
        else:
            modified_lines.append(line)

    with open(file, 'w') as f:
        f.writelines(modified_lines)
        
if __name__ == "__main__":
    for asm_file in sys.argv[1:]:
        modify_asm(asm_file)
