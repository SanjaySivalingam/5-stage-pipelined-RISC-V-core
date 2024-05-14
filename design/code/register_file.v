
module register_file #()(
    input clock,
    input write_enable,
    input [4:0] addr_rs1,
    input [4:0] addr_rs2,
    input [4:0] addr_rd,
    input [31:0] data_rd,
    output reg [31:0] data_rs1,
    output reg [31:0] data_rs2
);

    reg [31:0] reg_file [0:31]; //x0 to x31
    integer i;

    assign data_rs1 = reg_file[addr_rs1]; //combinational reads
    assign data_rs2 = reg_file[addr_rs2];

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 2) reg_file[i] = 32'h01000000 + `MEM_DEPTH; //initializing the stack pointer, x2 = 0x10000000 + MEM_DEPTH
            else reg_file[i] = {32{1'b0}}; //initializing all other registers to 0
        end
    end
 
    always @ (posedge clock) begin //sequential writes
        if (write_enable) begin
            if(addr_rd == 5'b0) 
                reg_file[addr_rd] <= 32'b0; //x0 = 0
            else 
                reg_file[addr_rd] <= data_rd; //writing if write_enable is 1
        end
    end

endmodule

