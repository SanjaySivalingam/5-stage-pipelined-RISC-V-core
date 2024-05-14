
module branch_comparator #()(
    input brc_en,
    input [2:0] br_type,
    input [31:0] brc_src_a,
    input [31:0] brc_src_b,
    output reg br_taken
);
    
    always @ (*) begin
        if (brc_en) begin
            case (br_type)
                `BR_BEQ: br_taken = ($signed(brc_src_a) == $signed(brc_src_b));
                `BR_BNE: br_taken = ($signed(brc_src_a) != $signed(brc_src_b));
                `BR_BLT: br_taken = ($signed(brc_src_a) < $signed(brc_src_b));
                `BR_BGE: br_taken = ($signed(brc_src_a) >= $signed(brc_src_b));
                `BR_BLTU: br_taken = (brc_src_a < brc_src_b);
                `BR_BGEU: br_taken = (brc_src_a >= brc_src_b);
                default: br_taken = 1'b0;
            endcase
        end else begin
            br_taken = 1'b0;
        end
    end

endmodule