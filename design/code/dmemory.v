
module dmemory #()(
    input clock,
    input read_write,
    input [2:0] access_size,
    input [31:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [7:0] mem [0:`MEM_DEPTH-1];
    reg [31:0] temp_mem [0:`LINE_COUNT-1];
    integer i;
    reg [31:0] t_a;

    //initializing 8bit mem with 32b data
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

    //combinational loading when read_write = 0 based on access_size 
    always @ (*) begin
        if (!read_write) begin
            case (access_size)
                `LB: data_out = {{24{mem[address][7]}}, mem[address]};
                `LH: data_out = {{16{mem[address+1][7]}}, mem[address+1], mem[address]};
                `LW: data_out = {mem[address+3], mem[address+2], mem[address+1], mem[address]};
                `LBU: data_out = {{24{1'b0}}, mem[address]};
                `LHU: data_out = {{16{1'b0}}, mem[address+1], mem[address]};
                default: data_out = 32'b0;
            endcase
        end
        else begin
            data_out = 32'b0;
        end
    end


    //sequential storing when read_write = 1 based on access_size
    always @ (posedge clock) begin
        if (read_write) begin
            case (access_size)
                `SB: begin
                    mem[address] <= data_in[7:0];
                end
                `SH: begin
                    mem[address] <= data_in[7:0];
                    mem[address+1] <= data_in[15:8];
                end
                `SW: begin
                    mem[address] <= data_in[7:0];
                    mem[address+1] <= data_in[15:8];
                    mem[address+2] <= data_in[23:16];
                    mem[address+3] <= data_in[31:24];
                end
                default: begin
                    mem[address] <= 8'b0;
                    mem[address+1] <= 8'b0;
                    mem[address+2] <= 8'b0;
                    mem[address+3] <= 8'b0;
                end
            endcase
        end
    end

endmodule
