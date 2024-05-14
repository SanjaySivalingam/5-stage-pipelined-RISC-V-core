
module write_back #()(
    input [1:0] wb_sel,
    input [31:0] pc,
    input [31:0] dmem_data_out,
    input [31:0] alu_out,
    output reg [31:0] wb_out
);

    always @ (*) begin
        case(wb_sel)
            `WB_PC: wb_out = pc + 4;
            `WB_MEM: wb_out = dmem_data_out;
            `WB_ALU: wb_out = alu_out;
            default: wb_out = 32'b0;
        endcase
    end

endmodule
