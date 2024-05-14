#!/usr/bin/python
import subprocess

test_files = [
    ("BubbleSort.x", "test BubbleSort done"),
    ("CheckVowel.x", "test CheckVowel done"),
    ("Fibonacci.x", "test Fibonacci done"),
    ("SimpleAdd.x", "test SimpleAdd done"),
    ("SimpleIf.x", "test SimpleIf done"),
    ("SumArray.x", "test SumArray done"),
    ("Swap.x", "test Swap done"),
    ("SwapShift.x", "test SwapShift done"),
    ("fact-short.x", "test fact-short done"),
    ("gcd.x", "test gcd done"),
    ("rv32ui-p-add.x", "test add done"),
    ("rv32ui-p-sub.x", "test sub done"),
    ("rv32ui-p-xor.x", "test xor done"),
    ("rv32ui-p-or.x", "test or done"),
    ("rv32ui-p-and.x", "test and done"),
    ("rv32ui-p-sll.x", "test sll done"),
    ("rv32ui-p-srl.x", "test srl done"),
    ("rv32ui-p-sra.x", "test sra done"),
    ("rv32ui-p-slt.x", "test slt done"),
    ("rv32ui-p-sltu.x", "test sltu done"),
    ("rv32ui-p-addi.x", "test addi done"),
    ("rv32ui-p-xori.x", "test xori done"),
    ("rv32ui-p-ori.x", "test ori done"),
    ("rv32ui-p-andi.x", "test andi done"),
    ("rv32ui-p-slli.x", "test slli done"),
    ("rv32ui-p-srli.x", "test srli done"),
    ("rv32ui-p-srai.x", "test srai done"),
    ("rv32ui-p-slti.x", "test slti done"),
    ("rv32ui-p-sltiu.x", "test sltiu done"),
    ("rv32ui-p-lb.x", "test lb done"),
    ("rv32ui-p-lh.x", "test lh done"),
    ("rv32ui-p-lw.x", "test lw done"),
    ("rv32ui-p-lbu.x", "test lbu done"),
    ("rv32ui-p-lhu.x", "test lhu done"),
    ("rv32ui-p-sb.x", "test sb done"),
    ("rv32ui-p-sh.x", "test sh done"),
    ("rv32ui-p-sw.x", "test sw done"),
    ("rv32ui-p-beq.x", "test beq done"),
    ("rv32ui-p-bne.x", "test bne done"),
    ("rv32ui-p-blt.x", "test blt done"),
    ("rv32ui-p-bge.x", "test bge done"),
    ("rv32ui-p-bltu.x", "test bltu done"),
    ("rv32ui-p-bgeu.x", "test bgeu done"),
    ("rv32ui-p-jal.x", "test jal done"),
    ("rv32ui-p-jalr.x", "test jalr done"),
    ("rv32ui-p-lui.x", "test lui done"),
    ("rv32ui-p-auipc.x", "test auipc done")

]

# Path to the project root directory
PROJECT_ROOT = "/home/s4sivali/ece621_w24/akmani-pd5"

# Run each test file
for test_file, message in test_files:
    command = "make -s run TEST=test_pd MEM_PATH=\"{}/verif/data/{}\"".format(PROJECT_ROOT, test_file)
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, error = process.communicate()
    #print(output)  # Print command output
    print(error)   # Print any errors
    print(message)