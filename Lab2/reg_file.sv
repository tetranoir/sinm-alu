// Engineer: 
// 
// Create Date:    13:24:09 10/17/2016 
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

module reg_file(
  input           clk,
                  write_en,
  input  [3:0] raddrA,
                  raddrB,
                  waddr,
  input  [7:0] data_in,
  output [7:0] data_outA,
  output logic [7:0] data_outB
    );

// W bits wide [W-1:0] and 2**4 registers deep or just [64]	 
logic [7:0] registers[2**4];

// combinational reads w/ blanking of address 0
assign      data_outA = raddrA? registers[raddrA] : '0;
always_comb data_outB = raddrB? registers[raddrB] : 'b0;

// sequential (clocked) writes
always_ff @ (posedge clk)
  if (write_en && waddr)
    registers[waddr] <= data_in;

endmodule
