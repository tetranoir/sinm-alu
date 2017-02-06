// program counter example
module pc (
    input clk,
//    input abs_jump_en,
//    input jump_back_14,
//    input jump_ahead_7,
//    input [1:0] rel_jump_en,
//    input[9:0] abs_jump,
//    input signed[7:0] rel_jump,
//    output logic[9:0] p_ct
    input start,
    input branch,
    input taken,
    input [7:0] rel_jmp,
    input logic[7:0] pc_in,
    output logic[7:0] pc_out
);

always @(posedge clk) 
    if (start) begin
        pc_out <= 0;
    end
    else if (branch && taken) begin
        pc_out <= pc_in + rel_jmp;
    end
    else begin
        pc_out <= pc_out + 1;
    end
endmodule

//        case({abs_jump_en, rel_jump_en})
//            'b000: p_ct <= p_ct + 1;
//            'b001: p_ct <= p_ct + rel_jump;
//            'b010: p_ct <= p_ct + 7;
//            'b011: p_ct <= p_ct - 14;
//            'b10x: p_ct <= abs_jump; 
//        endcase
