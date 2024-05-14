
module pc #()(
    input clock,
    input reset,
    input pc_sel,
    input stall,
    input [31:0] alu_out_x,
    output reg [31:0] pc_f
);

  always @ (posedge clock) begin
    if (reset) begin
      pc_f <= 32'h01000000;
    end
    else begin
      pc_f <= (stall)? pc_f : ((pc_sel)? alu_out_x : pc_f + 4);
    end
  end

endmodule
