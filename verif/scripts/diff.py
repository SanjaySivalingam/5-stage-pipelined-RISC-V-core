## [F] pc_address content in adecimal format
##[D] pc_address opcode rd rs1 rs2 funct3 funct7 imm shamt in adecimal format.
##Register file [R]: formatted as [R] addr_rs1 addr_rs2 data_rs1 data_rs2 in adecimal format.
##Execute stage [E]: formatted as [E] pc_address alu_result branch_taken in adecimal format.
##Memory stage [M]: formatted as [M] pc_address memory_address read_write access_size memory_data in adecimal format.
##Writeback stage [W]: formatted as [W] pc_address write_enable write_rd data_rd in adecimal format.

import sys

def parse_line(line):
    parts = line.strip().split(' ')
    if parts[0] == '[F]':
        return ['F', parts[1], parts[2]]
    elif parts[0] == '[D]':
        #print(parts)
        #print(['D', parts[1], [p for p in parts[2:]]])
        return ['D', parts[1], [p for p in parts[2:]]]
    elif parts[0] == '[R]':
        return ['R', [p for p in parts[1:]]]
    elif parts[0] == '[E]':
        return ['E', parts[1], parts[2], parts[3]]
    elif parts[0] == '[M]':
        return ['M', parts[1], parts[2], parts[3], parts[4]]
    elif parts[0] == '[W]':
        return ['W', parts[1], parts[2], parts[3], parts[4]]

def compare(trace_line, golden_line):
    if trace_line[0] != golden_line[0]:
        return False
    if trace_line[0] == 'F':
        return trace_line[1:] == golden_line[1:]
    elif trace_line[0] == 'D':
        return trace_line[1:] == golden_line[1:]
    elif trace_line[0] == 'R':
        return trace_line[1:] == golden_line[1:]
    elif trace_line[0] == 'E':
        return trace_line[1:] == golden_line[1:]
    elif trace_line[0] == 'M':
        return trace_line[1:] == golden_line[1:]
    elif trace_line[0] == 'W':
        return trace_line[1:] == golden_line[1:]

def mainexecutor(trace_file, golden_file):
    with open(trace_file, 'r') as trace_f, open(golden_file, 'r') as golden_f:
        trace_lines = trace_f.readlines()
        golden_lines = golden_f.readlines()

    if len(trace_lines) != len(golden_lines):
        print(f"Trace File Lines = {len(trace_lines)}")
        print(f"Golden File Lines = {len(golden_lines)}")
        print("Files have different number of lines, can't compare. Proceeding for now...")

    for i in range(len(trace_lines)):
        trace_line = parse_line(trace_lines[i])
        golden_line = parse_line(golden_lines[i])
        if not compare(trace_line, golden_line):
            if trace_line[0] == 'F':
                print(f"Test failed at Fetch line {i + 1}: \n Expected:  pc={golden_line[1]}, inst={(golden_line[2])} \n Actual: pc={(trace_line[1])}, inst={(trace_line[2])}")
            elif trace_line[0] == 'D':
                print(trace_line[2]) 
                print(golden_line[2])
                print(f"Test failed at Decode line {i + 1}: \n Expected: pc={golden_line[1]}, opcode={golden_line[2][0]}, rd={golden_line[2][1]}, rs1={golden_line[2][2]}, rs2={golden_line[2][3]}, funct3={golden_line[2][4]}, funct7={golden_line[2][5]}, imm={golden_line[2][6]}, shamt={golden_line[2][7]} \n Actual: pc={trace_line[1]}, opcode={trace_line[2][0]}, rd={trace_line[2][1]}, rs1={trace_line[2][2]}, rs2={trace_line[2][3]}, funct3={trace_line[2][4]}, funct7={trace_line[2][5]}, imm={trace_line[2][6]}, shamt={trace_line[2][7]}")
            elif trace_line[0] == 'R':
                print(f"Test failed at RegFile line {i + 1}: \n Expected: addr_rs1={(golden_line[1][0])}, addr_rs2={(golden_line[1][1])}, data_rs1={(golden_line[1][2])}, data_rs2={(golden_line[1][3])} \n Actual: addr_rs1={(trace_line[1][0])}, addr_rs2={(trace_line[1][1])}, data_rs1={(trace_line[1][2])}, data_rs2={(trace_line[1][3])}")
            elif trace_line[0] == 'E':
                print(f"Test failed at Execute line {i + 1}: \n Expected: pc={(golden_line[1])}, alu_result={(golden_line[2])}, branch_taken={golden_line[3]} \n Actual pc={(trace_line[1])}, alu_result={(trace_line[2])}, branch_taken={trace_line[3]}")
            elif trace_line[0] == 'M':
                print(f"Test failed at Memory line {i + 1}: \n Expected: pc={(golden_line[1])}, memory_address={(golden_line[2][0])}, read_write={golden_line[2][1]}, access_size={golden_line[2][2]} memory_data={(golden_line[2][3])} \n Actual pc={(trace_line[1])}, memory_address={(trace_line[2][0])}, read_write={trace_line[2][1]}, access_size={trace_line[2][2]} memory_data={(trace_line[2][3])}")
            elif trace_line[0] == 'W':
                print(f"Test failed at Writeback line {i + 1}: \n Expected: pc={(golden_line[1])}, write_enable={golden_line[2]}, write_rd={golden_line[3]}, data_rd={(trace_line[4])} \n Actual: pc={(trace_line[1])}, write_enable={trace_line[2]}, write_rd={trace_line[3]}, data_rd={(trace_line[4])}")
            return
    
    print("Test passed.")

# Example usage:
mainexecutor("/yourprojectroot/verif/sim/verilator/test_pd/rv32ui-p-add.trace", "/yourprojectroot/verif/golden/rv32ui-p-add.trace")
 