// program counter example
module pc_exam (
    input clk,
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
        pc_out <= pc_in + 1;
    end
endmodule
