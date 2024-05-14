
module decoder #()(
    input [31:0] inst,
    input [2:0] imm_sel,
    output reg [6:0] opcode,
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [2:0] funct3,
    output reg [6:0] funct7,
    output reg [4:0] shamt,
    output [31:0] imm
);
    
    //instruction decoder
    always @ (*) begin
        opcode = inst[6:0];
        rd = inst[11:7];
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        funct3 = inst[14:12];
        funct7 = inst[31:25];
        shamt = inst[24:20];
    end

    immediate_generator imm_gen (
        .inst(inst),
        .imm_sel(imm_sel),
        .imm(imm)
    );

endmodule
