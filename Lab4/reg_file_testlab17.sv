// Company: 
// Engineer: 
// 
// Create Date:    13:24:09 10/27/2011 
// Design Name: 
// Module Name:    reg_file 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 					  $clog2

module reg_file #(parameter W=8, D=4)(
    input         CLK,
	              RegWrite,
    input  [ D-1:0] srcA,
                    srcB,
                    writeReg,
    input  [ W-1:0] writeValue,
    output [ W-1:0] ReadA,
    output logic [W-1:0] ReadB
    );

// W bits wide [W-1:0] and 2**4 registers deep or just [16]	 
logic [W-1:0] registers[2**D];

// combinational reads
assign      ReadA = (srcA == 'b0)? 'b0 : registers[srcA];
always_comb ReadB = (srcB == 'b0)? 'b0 : registers[srcB];

// sequential (clocked) writes
always_ff @ (posedge CLK)
  if (RegWrite && (writeReg != 'b0))
    registers[writeReg] <= writeValue;

endmodule
