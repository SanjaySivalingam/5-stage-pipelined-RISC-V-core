
module pd #()(
  input clock,
  input reset
);

//******************fetch stage******************//

  //instruction memory

  reg imem_wr_en = 1'b0; //always read from instruction memory
  reg [31:0] imem_data_in;

  imemory imem (
                .clock (clock),
                .read_write(imem_wr_en), 
                .address(pc_f), 
                .data_in(imem_data_in), 
                .data_out(inst_f)
               );

  //pc

  pc pc_mod (
              .clock(clock),
              .reset(reset),
              .pc_sel(pc_sel),
              .stall(stall),
              .alu_out_x(alu_out_x),
              .pc_f(pc_f)
            );

//******************decode stage******************//

  //instruction decoder

  wire [6:0] opcode_d;
  wire [4:0] addr_rd_d;
  wire [4:0] addr_rs1_d;
  wire [4:0] addr_rs2_d;
  wire [2:0] funct3_d;
  wire [6:0] funct7_d;
  wire [4:0] shamt_d;

  decoder dec (
               .inst(inst_d),
               .opcode(opcode_d),
               .imm_sel(imm_sel),
               .rd(addr_rd_d),
               .rs1(addr_rs1_d),
               .rs2(addr_rs2_d),
               .funct3(funct3_d),
               .funct7(funct7_d),
               .shamt(shamt_d),
               .imm(imm_d)
              );

  //register file

  wire [4:0] addr_rd_w;
  assign addr_rd_w = inst_w[11:7]; //for register write enable control

  register_file rf (
                   .clock(clock),
                   .addr_rs1(addr_rs1_d),
                   .addr_rs2(addr_rs2_d),
                   .addr_rd(addr_rd_w),
                   .data_rd(data_rd_w),
                   .data_rs1(data_rs1_d),
                   .data_rs2(data_rs2_d),
                   .write_enable(reg_wr_en)
                   );

//******************execute stage******************//

  //branch comparator

  wire br_taken_x;
  wire [2:0] br_type_x;
  assign br_type_x = inst_x[14:12]; //for branch comparison

  branch_comparator brc(
                        .brc_en(brc_en),
                        .br_type(br_type_x),
                        .brc_src_a(brc_src_a),
                        .brc_src_b(brc_src_b),
                        .br_taken(br_taken_x)
                       );

  //alu

  alu alu(
          .alu_src_a(alu_src_a),
          .alu_src_b(alu_src_b),
          .alu_sel(alu_sel),
          .alu_out(alu_out_x)
         );

//******************memory stage******************//

  wire [31:0] dmem_data_out_m;
  wire [2:0] access_size_m;
  wire [31:0] dmem_addr_in_m;
  assign access_size_m = inst_m[14:12]; //for dmem access size control
  assign dmem_addr_in_m = alu_out_m;

  dmemory dmem(
               .clock(clock),
               .read_write(dmem_wr_en),
               .address(dmem_addr_in_m),
               .access_size(access_size_m),
               .data_in(dmem_data_in_m),
               .data_out(dmem_data_out_m)
              );

//******************writeback stage******************//

   write_back wb(
                .wb_sel(wb_sel),
                .pc(pc_m),
                .dmem_data_out(dmem_data_out_m),
                .alu_out(alu_out_m),
                .wb_out(data_rd_m)
              );

//******************pipeline control******************//

  wire stall;
  wire [2:0] imm_sel;
  wire pc_sel;
  wire brc_en;
  wire reg_wr_en;
  wire [31:0] brc_src_a;
  wire [31:0] brc_src_b;
  wire [31:0] alu_src_a;
  wire [31:0] alu_src_b;
  wire [3:0] alu_sel;
  wire dmem_wr_en;
  wire [31:0] dmem_data_in_m;
  wire [1:0] wb_sel;

  pipeline_control cont(
                        .clock(clock),
                        .inst_d(inst_d), .inst_x(inst_x), .inst_m(inst_m), .inst_w(inst_w),
                        .pc_x(pc_x),
                        .imm_x(imm_x),
                        .data_rs1_x(data_rs1_x), .data_rs2_x(data_rs2_x), .data_rs2_m(data_rs2_m),
                        .br_taken_x(br_taken_x),
                        .alu_out_m(alu_out_m),
                        .data_rd_w(data_rd_w),                        
                        .stall(stall),
                        .pc_sel(pc_sel),
                        .imm_sel(imm_sel),
                        .reg_wr_en(reg_wr_en),                        
                        .brc_en(brc_en), .brc_src_a(brc_src_a), .brc_src_b(brc_src_b),
                        .alu_src_a(alu_src_a), .alu_src_b(alu_src_b), .alu_sel(alu_sel),
                        .dmem_wr_en(dmem_wr_en), .dmem_data_in(dmem_data_in_m),
                        .wb_sel(wb_sel)
                      );

//******************pipeline registers******************//

  //pc pipeline

  reg [31:0] pc_f, pc_d, pc_x, pc_m, pc_w;

  always @ (posedge clock) begin
    if (reset) begin
      pc_f <= 32'h01000000;
      pc_d <= 32'h00000000;
      pc_x <= 32'h00000000;
      pc_m <= 32'h00000000;
      pc_w <= 32'h00000000;
    end else begin
      pc_d <= (stall)? pc_d : pc_f;
      pc_x <= pc_d;
      pc_m <= pc_x;
      pc_w <= pc_m; //for functionality testing
    end
  end

  //instruction pipeline

  wire [31:0] inst_f;
  reg [31:0] inst_d, inst_x, inst_m, inst_w;

  always @ (posedge clock) begin
    if (reset) begin
      inst_d <= 32'h0;
      inst_x <= 32'h0;
      inst_m <= 32'h0;
      inst_w <= 32'h0;
    end else begin
      inst_d <= (stall)? inst_d : (pc_sel)? `NOP : inst_f; //stall and control dependence handling
      inst_x <= (stall || opcode_d == `FENCE || pc_sel)? `NOP : inst_d;
      inst_m <= inst_x;
      inst_w <= inst_m;
    end
  end

  //register_file data pipeline

  wire [31:0] data_rs1_d;
  wire [31:0] data_rs2_d;
  reg [31:0] data_rs1_x;
  reg [31:0] data_rs2_x, data_rs2_m;

  always @ (posedge clock) begin
    if (reset) begin
      data_rs1_x <= 32'h0;
      data_rs2_x <= 32'h0;
      data_rs2_m <= 32'h0;
    end else begin
      data_rs1_x <= data_rs1_d;
      data_rs2_x <= data_rs2_d;
      data_rs2_m <= data_rs2_x;
    end
  end

  //immediate pipeline

  wire [31:0] imm_d;
  reg [31:0] imm_x;

  always @ (posedge clock) begin
    if (reset) begin
      imm_x <= 32'h0;
    end else begin
      imm_x <= imm_d;
    end
  end

  //alu_out pipeline

  wire [31:0] alu_out_x;
  reg [31:0] alu_out_m;

  always @ (posedge clock) begin
    if (reset) begin
      alu_out_m <= 32'h0;
    end else begin
      alu_out_m <= alu_out_x;
    end
  end

  //wb_out pipeline
  
  wire [31:0] data_rd_m;
  reg [31:0] data_rd_w;

  always @ (posedge clock) begin
    if (reset) begin
      data_rd_w <= 32'h0;
    end else begin
      data_rd_w <= data_rd_m;
    end
  end

endmodule
