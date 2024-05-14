module pipeline_control #()(
    input clock,
    input [31:0] inst_d, inst_x, inst_m, inst_w,
    input [31:0] pc_x,
    input [31:0] data_rs1_x, data_rs2_x, data_rs2_m,
    input br_taken_x,
    input [31:0] imm_x,
    input [31:0] alu_out_m,
    input [31:0] data_rd_w,
    output stall,
    output pc_sel,
    output reg [2:0] imm_sel,
    output reg_wr_en,
    output brc_en,
    output reg [31:0] brc_src_a, brc_src_b,
    output reg [31:0] alu_src_a, alu_src_b,
    output reg [3:0] alu_sel,
    output dmem_wr_en,
    output [31:0] dmem_data_in,
    output reg [1:0] wb_sel
);

    wire reg_wr_en_m;
    wire [6:0] opcode_d;
    wire [4:0] addr_rs1_d, addr_rs2_d;
    wire [6:0] opcode_x, opcode_m, opcode_w;
    wire [2:0] funct3_x;
    wire funct7_b5_x;
    wire [4:0] shamt_x;
    wire [4:0] addr_rs1_x, addr_rs2_x, addr_rd_x;
    wire [4:0] addr_rs2_m;
    wire [4:0] addr_rd_m, addr_rd_w;
    reg mx_a, mx_b, mx_a_brc, mx_b_brc, wx_a, wx_b, wx_a_brc, wx_b_brc; //bypass check bits

    assign opcode_d = inst_d[6:0];
    assign addr_rs1_d = (opcode_d == `LUI || opcode_d == `AUIPC || opcode_d == `J)? 5'dx : inst_d[19:15];
    assign addr_rs2_d = (opcode_d == `R || opcode_d == `S || opcode_d == `B)? inst_d[24:20] : 5'dx; 
    assign opcode_x = inst_x[6:0];
    assign opcode_m = inst_m[6:0];
    assign opcode_w = inst_w[6:0];
    assign funct3_x = inst_x[14:12];
    assign funct7_b5_x = inst_x[30];
    assign shamt_x = inst_x[24:20];
    assign addr_rs1_x = inst_x[19:15];
    assign addr_rs2_x = inst_x[24:20];
    assign addr_rd_x = (opcode_x == `S || opcode_x == `B)? 5'dx : inst_x[11:7];
    assign addr_rs2_m = inst_m[24:20];
    assign addr_rd_m = (opcode_m == `S || opcode_m == `B)? 5'dx : inst_m[11:7];
    assign addr_rd_w = (opcode_w == `S || opcode_w == `B)? 5'dx : inst_w[11:7]; // to avoid erroneous forwarding or stall

    //stall control
    wire load_stall, wd_stall, store_stall;
    
    assign load_stall = ((opcode_x == `LOAD) && ((addr_rs1_d == addr_rd_x) || ((addr_rs2_d == addr_rd_x) && (opcode_d != `S)))); //load-to-use dependency
    assign wd_stall = ((opcode_d == `B || opcode_d == `R || opcode_d == `I || opcode_d == `LOAD || opcode_d == `JALR) && (!pc_sel) && ((addr_rs1_d == addr_rd_w && addr_rd_w != 0) || (addr_rs2_d == addr_rd_w && addr_rd_w != 0)) && (addr_rd_w != addr_rd_m && addr_rd_w != addr_rd_x)); //WD dependency
    assign store_stall = ((opcode_d == `S) && ((addr_rs1_d == addr_rd_w && addr_rd_w != 0 && addr_rs1_d != addr_rd_m) || (addr_rs2_d == addr_rd_w && addr_rd_w != 0 && addr_rs2_d != addr_rd_m) || (addr_rs2_d == addr_rd_m && addr_rs2_x != addr_rd_m && addr_rd_m != addr_rd_x && !pc_sel))); //Store WD/MD dependency
    assign stall = (load_stall || wd_stall || store_stall)? 1'b1 : 1'b0; 
                   
    //pc select
    assign pc_sel = (br_taken_x || opcode_x == `J || opcode_x == `JALR)? 1'b1 : 1'b0; //for J-type, JALR-type and B-type with br_taken -> 1, for others -> 0

    //immediate select
    always @ (*) begin
        case(opcode_d)
            `I, `LOAD, `JALR: imm_sel = `IMM_I;
            `S: imm_sel = `IMM_S;
            `B: imm_sel = `IMM_B;
            `J: imm_sel = `IMM_J;
            `LUI, `AUIPC: imm_sel = `IMM_U;
            default: imm_sel = `IMM_I;
        endcase
    end

    //brc_en
    assign brc_en = (opcode_x == `B)? 1'b1 : 1'b0; //branch comparator enabled only for B-type

    //brc src_a control
    //(bypass only for B-type and should not bypass from B or S type and should not bypass from x0)
    always @ (*) begin
        if (addr_rs1_x == addr_rd_m && opcode_x == `B && (opcode_m != `S || opcode_m != `B) && addr_rd_m != 0) begin //MX bypass 
            brc_src_a = alu_out_m;
            mx_a_brc = 1'b1;
            wx_a_brc = 1'b0;
        end
        else if (addr_rs1_x == addr_rd_w && opcode_x == `B && (opcode_w != `S || opcode_w != `B) && addr_rd_w != 0) begin //WX bypass
            brc_src_a = data_rd_w;
            wx_a_brc = 1'b1;
            mx_a_brc = 1'b0;
        end
        else begin //no bypass
            brc_src_a = data_rs1_x;
            mx_a_brc = 1'b0;
            wx_a_brc = 1'b0;
        end
    end    

    //brc src_b control
    //(bypass only for B-type and should not bypass from B or S type and should not bypass from x0)
    always @ (*) begin
        if (addr_rs2_x == addr_rd_m && opcode_x == `B && (opcode_m != `S || opcode_m != `B) && addr_rd_m != 0) begin//MX bypass 
            brc_src_b = alu_out_m;
            mx_b_brc = 1'b1;
            wx_b_brc = 1'b0;
        end
        else if (addr_rs2_x == addr_rd_w && opcode_x == `B && (opcode_w != `S || opcode_w != `B) && addr_rd_w != 0) begin//WX bypass 
            brc_src_b = data_rd_w;
            wx_b_brc = 1'b1;
            mx_b_brc = 1'b0;
        end
        else begin //no bypass
            brc_src_b = data_rs2_x;
            mx_b_brc = 1'b0;
            wx_b_brc = 1'b0;
        end
    end

    //alu src_a control
    //(bypass only for those with valid rs1 for alu and rd_w should write back to rf and should not bypass from x0)
    always @ (*) begin
        if (inst_x == `NOP) begin //stall
            alu_src_a = 32'h0; 
            mx_a = 1'b0;
            wx_a = 1'b0;
        end
        else if (addr_rs1_x == addr_rd_m && (opcode_x == `R || opcode_x == `I || opcode_x == `LOAD || opcode_x == `S || opcode_x == `JALR) && reg_wr_en_m && addr_rd_m != 0) begin //MX bypass 
            alu_src_a = alu_out_m;
            mx_a = 1'b1;
            wx_a = 1'b0;
        end
        else if (addr_rs1_x == addr_rd_w && (opcode_x == `R || opcode_x == `I || opcode_x == `LOAD || opcode_x == `S || opcode_x == `JALR) && reg_wr_en && addr_rd_w != 0) begin //WX bypass 
            alu_src_a = data_rd_w;
            wx_a = 1'b1;
            mx_a = 1'b0;
        end
        else begin //no bypass
            mx_a = 1'b0;
            wx_a = 1'b0;
            if (opcode_x == `B || opcode_x == `J || opcode_x == `AUIPC) //for B-type, J-type and AUIPC-type -> pc, 
                alu_src_a = pc_x;
            else
                alu_src_a = data_rs1_x; //for others -> data_rs1_x
        end
    end

    //alu src_b control
    //(bypass only for those with valid rs2 for alu and rd_w should write back to rf and should not bypass from x0)
    always @ (*) begin
        if (inst_x == `NOP) begin //stall
            alu_src_b = 32'h0;
            mx_b = 1'b0;
            wx_b = 1'b0;
        end 
        else if (addr_rs2_x == addr_rd_m && opcode_x == `R && reg_wr_en_m && addr_rd_m != 0) begin //MX bypass
            alu_src_b = alu_out_m;
            mx_b = 1'b1;
            wx_b = 1'b0;
        end
        else if (addr_rs2_x == addr_rd_w && opcode_x == `R && reg_wr_en && addr_rd_w != 0) begin //WX bypass
            alu_src_b = data_rd_w;
            wx_b = 1'b1;
            mx_b = 1'b0;
        end
        else begin //no bypass
            mx_b = 1'b0;
            wx_b = 1'b0;
            if (opcode_x == `R) //for R-type -> data_rs2_x
                alu_src_b = data_rs2_x;
            else if (opcode_x == `I && (funct3_x == 3'b001 || funct3_x == 3'b101)) //for shift instructions (SLLI, SRLI and SRAI)
                alu_src_b = {{27{1'b0}}, shamt_x};
            else
                alu_src_b = imm_x; //for others -> imm_x
        end
    end         

    //alu select 
    always @ (*) begin
        if (opcode_x == `R || opcode_x == `I) begin
            case(funct3_x)
                3'b000: alu_sel = (opcode_x == `R && funct7_b5_x)? `ALU_SUB : `ALU_ADD;
                3'b001: alu_sel = `ALU_SLL;
                3'b010: alu_sel = `ALU_SLT;
                3'b011: alu_sel = `ALU_SLTU;
                3'b100: alu_sel = `ALU_XOR;
                3'b101: alu_sel = funct7_b5_x? `ALU_SRA : `ALU_SRL;             
                3'b110: alu_sel = `ALU_OR;              
                3'b111: alu_sel = `ALU_AND;              
                default: alu_sel = `ALU_ADD;
            endcase
        end else if (opcode_x == `LUI) begin
            alu_sel = `ALU_LUI;
        end else if (opcode_x == `JALR) begin
            alu_sel = `ALU_JALR;
        end else begin
            alu_sel = `ALU_ADD;
        end
    end

    //dmem control
    assign dmem_wr_en = (opcode_m == `S)? 1'b1 : 1'b0; //write enable only for S-type
    assign dmem_data_in = ((opcode_m == `S) && (addr_rs2_m == addr_rd_w && addr_rs2_m != 0))? data_rd_w : data_rs2_m; //WM bypass

    //wb control
    always @ (*) begin
        if (opcode_m != `S || opcode_m != `B) begin
            if (opcode_m == `J || opcode_m == `JALR) wb_sel = `WB_PC; //pc+4 
            else if (opcode_m == `LOAD) wb_sel = `WB_MEM; //dmem_out
            else wb_sel = `WB_ALU; //alu_out
        end
        else wb_sel = 2'bz;
    end

    //reg_wr_en (used as wb_en as well)
    assign reg_wr_en = ((inst_w == `NOP || opcode_w == `S || opcode_w == `B || opcode_w == `ECALL || opcode_w == 7'd0))? 1'b0 : 1'b1; //for S-type, NOP Inst, ECALl, Fence and B-type -> 0, for others -> 1
    assign reg_wr_en_m = ((inst_m == `NOP || opcode_m == `S || opcode_m == `B || opcode_m == `ECALL || opcode_m == 7'd0))? 1'b0 : 1'b1; //to use in bypass testing
    
    //simulation control
    //stop simulation when hit `ECALL at W stage
    always @ (posedge clock) begin
        if ((opcode_w == `ECALL)) 
           $finish();
    end

endmodule
