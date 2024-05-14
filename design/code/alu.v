
module alu #()(
    input [31:0] alu_src_a,
    input [31:0] alu_src_b,
    input [3:0] alu_sel,
    output reg [31:0] alu_out
);

    always @ (*) begin
        case(alu_sel)
            `ALU_ADD: alu_out = $signed(alu_src_a) + $signed(alu_src_b); 
            `ALU_SUB: alu_out = $signed(alu_src_a) - $signed(alu_src_b); 
            `ALU_SLL: alu_out = alu_src_a << alu_src_b[4:0]; 
            `ALU_SLT: alu_out = ($signed(alu_src_a) < $signed(alu_src_b))? {{31{1'b0}}, 1'b1} : {32{1'b0}}; 
            `ALU_SLTU: alu_out = (alu_src_a < alu_src_b)? {{31{1'b0}}, 1'b1} : {32{1'b0}}; 
            `ALU_XOR: alu_out = alu_src_a ^ alu_src_b; 
            `ALU_SRL: alu_out = alu_src_a >> alu_src_b[4:0]; 
            `ALU_SRA: alu_out = $signed(alu_src_a) >>> alu_src_b[4:0];
            `ALU_OR: alu_out = alu_src_a | alu_src_b; 
            `ALU_AND: alu_out = alu_src_a & alu_src_b; 
            `ALU_LUI: alu_out = alu_src_b; 
            `ALU_JALR: alu_out = ($signed(alu_src_a) + $signed(alu_src_b)) & 32'hfffffffe; //to align with multiples of 2 (LSB = 0)
            default: alu_out = 32'b0;
        endcase
    end 

endmodule
