
module imemory #()(
    input clock,
    input read_write,
    input [31:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [7:0] mem [0:`MEM_DEPTH-1];
    reg [31:0] temp_mem [0:`LINE_COUNT];
    integer i;
    reg [31:0] t_a;

    //initializing 8bit mem with 32b instructions
    initial begin
        $readmemh(`MEM_PATH, temp_mem);
        t_a = address;
        for (i = 0; i < `LINE_COUNT; i = i + 1) begin
            mem[t_a] = temp_mem[i][7:0];
            mem[t_a+1] = temp_mem[i][15:8];
            mem[t_a+2] = temp_mem[i][23:16];
            mem[t_a+3] = temp_mem[i][31:24];
            t_a = t_a + 4;
        end
    end

    //reading when read_write = 0
    assign data_out = read_write? 32'b0 : {mem[address+3], mem[address+2], mem[address+1], mem[address]};

    //writing only when read_write = 1
    always @ (posedge clock) begin
        if (read_write) begin
            mem[address] <= data_in[7:0];
            mem[address+1] <= data_in[15:8];
            mem[address+2] <= data_in[23:16];
            mem[address+3] <= data_in[31:24];
        end
    end

endmodule
