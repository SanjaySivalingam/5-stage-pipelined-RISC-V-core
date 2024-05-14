#!/usr/bin/python

import sys
import os
import subprocess

# Function to grep a pc in a file
def capture(pc, filename):
    # Check if the file exists
    if not os.path.isfile(filename):
        print("Error: File '{}' not found.".format(filename))
        sys.exit(1)

    # Using grep command
    with open(filename, 'r') as file:
        cap_res = [line.strip() for line in file if pc in line]

    # Check if grep returned any result
    if not cap_res:
        print("No matching lines found.")
        sys.exit(2)
    else:
        for line in cap_res:
            print(line)

# Assign values from the command-line
pc = '01000000'
file = sys.argv[1]
ic = int(sys.argv[2])
PROJECT_ROOT = os.getenv("PROJECT_ROOT")
mempath = "{}/verif/data/rv32ui-p-{}.x".format(PROJECT_ROOT, file)
instpath = "{}/verif/data/rv32ui-p-{}.d".format(PROJECT_ROOT, file)
goldenpath = "{}/verif/golden/rv32ui-p-{}.trace".format(PROJECT_ROOT, file)
yourpath = "{}/verif/sim/verilator/test_pd/rv32ui-p-{}.trace".format(PROJECT_ROOT, file)

# 'make' command 
subprocess.call(["make", "-s", "run", "TEST=test_pd", "MEM_PATH={}".format(mempath)], shell=True)

# Loop to grep
count = 0
while count < ic:
    print("")
    print("Current PC: {}".format(pc))
    print("Instruction: ")
    capture(pc.lstrip('0'), instpath)
    print("")
    print("Golden Output:")
    capture(pc, goldenpath)
    print("Your Output:")
    capture(pc, yourpath)
    print("")
    print("Comparing Outputs:")
    
    # Run grep commands to capture the outputs
    golden_output = subprocess.check_output(["grep", pc, goldenpath])
    your_output = subprocess.check_output(["grep", pc, yourpath])
    
    # Split the outputs into lines
    golden_lines = golden_output.splitlines()
    your_lines = your_output.splitlines()
    
    # Compare the outputs line by line
    for golden_line, your_line in zip(golden_lines, your_lines):
        if golden_line != your_line:
            print("golden: {}".format(golden_line))
            print("yours: {}".format(your_line))
    
    print("")
    
    # Increment pc
    decimal_value = int(pc, 16)
    decimal_value += 4
    pc = format(decimal_value, '08x')

    # Increment counter
    count += 1
