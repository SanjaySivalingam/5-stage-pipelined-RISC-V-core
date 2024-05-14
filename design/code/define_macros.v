//NOP instruction
`define NOP 32'h00000011 //addi x0, x0, 0

//opcodes
`define R 7'b0110011
`define I 7'b0010011
`define S 7'b0100011
`define B 7'b1100011
`define J 7'b1101111
`define LUI 7'b0110111
`define AUIPC 7'b0010111
`define JALR 7'b1100111
`define LOAD 7'b0000011
`define ECALL 7'b1110011
`define FENCE 7'b0001111

//immediate types
`define IMM_I 0
`define IMM_S 1
`define IMM_B 2
`define IMM_J 3
`define IMM_U 4

//branch types
`define BR_BEQ 3'b000
`define BR_BNE 3'b001
`define BR_BLT 3'b100
`define BR_BGE 3'b101
`define BR_BLTU 3'b110
`define BR_BGEU 3'b111

//ALU operations
`define ALU_ADD 0
`define ALU_SUB 1
`define ALU_SLL 2
`define ALU_SLT 3
`define ALU_SLTU 4
`define ALU_XOR 5
`define ALU_SRL 6
`define ALU_SRA 7
`define ALU_OR 8
`define ALU_AND 9
`define ALU_LUI 10
`define ALU_JALR 11

//writeback data options
`define WB_MEM 2
`define WB_ALU 1
`define WB_PC 0

//dmem access sizes
`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101

`define SB 3'b000
`define SH 3'b001
`define SW 3'b010