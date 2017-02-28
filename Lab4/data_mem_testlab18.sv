// data memory
module data_mem(
  input       CLK,
              we,
  input [7:0] addr,
              dat_in,
  output logic[7:0] dat_out);

logic[7:0] my_memory[256];	  // core itself

// writes are sequential and conditional
always_ff @(posedge CLK)
  if(we)
    my_memory[addr] <= dat_in;

// reads are combinational and unconditional    
always_comb
  dat_out = my_memory[addr];      

endmodule