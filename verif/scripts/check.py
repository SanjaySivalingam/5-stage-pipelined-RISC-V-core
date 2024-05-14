#!/usr/bin/python
import sys

def get_line_count_and_last_line(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
            line_count = len(lines)
            last_line = lines[-1].strip() if line_count > 0 else None
            return line_count, last_line
    except IOError:
        return None, None

if __name__ == "__main__":
    golden_names = [    
        "rv32ui-p-add", "rv32ui-p-sub", "rv32ui-p-xor", "rv32ui-p-or", "rv32ui-p-and",
        "rv32ui-p-sll", "rv32ui-p-srl", "rv32ui-p-sra", "rv32ui-p-slt", "rv32ui-p-sltu",
        "rv32ui-p-addi", "rv32ui-p-xori", "rv32ui-p-ori", "rv32ui-p-andi", "rv32ui-p-slli",
        "rv32ui-p-srli", "rv32ui-p-srai", "rv32ui-p-slti", "rv32ui-p-sltiu", "rv32ui-p-lb",
        "rv32ui-p-lh", "rv32ui-p-lw", "rv32ui-p-lbu", "rv32ui-p-lhu", "rv32ui-p-sb",
        "rv32ui-p-sh", "rv32ui-p-sw", "rv32ui-p-beq", "rv32ui-p-bne", "rv32ui-p-blt",
        "rv32ui-p-bge", "rv32ui-p-bltu", "rv32ui-p-bgeu", "rv32ui-p-jal", "rv32ui-p-jalr",
        "rv32ui-p-lui", "rv32ui-p-auipc"
    ]

    file_names = [
        "rv32ui-p-add",
        "rv32ui-p-sub", "rv32ui-p-xor", "rv32ui-p-or", "rv32ui-p-and",
        "rv32ui-p-sll", "rv32ui-p-srl", "rv32ui-p-sra", "rv32ui-p-slt",
        "rv32ui-p-sltu", "rv32ui-p-addi", "rv32ui-p-xori", "rv32ui-p-ori",
        "rv32ui-p-andi", "rv32ui-p-slli", "rv32ui-p-srli", "rv32ui-p-srai",
        "rv32ui-p-slti", "rv32ui-p-sltiu", "rv32ui-p-lb", "rv32ui-p-lh",
        "rv32ui-p-lw", "rv32ui-p-lbu", "rv32ui-p-lhu", "rv32ui-p-sb",
        "rv32ui-p-sh", "rv32ui-p-sw", "rv32ui-p-beq", "rv32ui-p-bne",
        "rv32ui-p-blt", "rv32ui-p-bge", "rv32ui-p-bltu", "rv32ui-p-bgeu",
        "rv32ui-p-jal", "rv32ui-p-jalr", "rv32ui-p-lui", "rv32ui-p-auipc"
    ]
    
    prog_names = [
        "BubbleSort", "CheckVowel", "Fibonacci", "SimpleAdd", "SimpleIf",
        "SumArray", "Swap", "SwapShift", "fact-short", "gcd"
        ]

    for golden_name, file_name in zip(golden_names, file_names):
        golden_path = "/home/s4sivali/ece621_w24/akmani-pd5/verif/golden/{}.trace".format(golden_name)
        golden_count, last_gold = get_line_count_and_last_line(golden_path)
        if golden_count is not None:
            print("Golden: {}".format(golden_name))
            print("Line count: {}".format(golden_count))
            if last_gold is not None:
                print("Check: {}".format(last_gold))
            else:
                print("File is empty")
        else:
            print("Error: Unable to read golden file {}".format(golden_name))

        file_path = "/home/s4sivali/ece621_w24/akmani-pd5/verif/sim/verilator/test_pd/{}.trace".format(file_name)
        line_count, last_line = get_line_count_and_last_line(file_path)
        if line_count is not None:
            print("Trace: {}".format(file_name))
            print("Line count: {}".format(line_count))
            if last_line is not None:
                print("Check: {}".format(last_line))
            else:
                print("File is empty")
            print("-----------------------------")
        else:
            print("Error: Unable to read file {}".format(file_name))
    
    for prog_name in prog_names:
        prog_path = "/home/s4sivali/ece621_w24/akmani-pd5/verif/sim/verilator/test_pd/{}.trace".format(prog_name)
        line_count, last_line = get_line_count_and_last_line(prog_path)
        if line_count is not None:
            print("Trace: {}".format(prog_name))
            print("Line count: {}".format(line_count))
            if last_line is not None:
                print("Check: {}".format(last_line))
            else:
                print("File is empty")
            print("-----------------------------")
        else:
            print("Error: Unable to read file {}".format(prog_name))