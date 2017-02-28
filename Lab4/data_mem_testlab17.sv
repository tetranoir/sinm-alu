module data_mem(
  input       [7:0] DataAddress,
  input             ReadMem,
                    WriteMem,
  input       [7:0] DataIn,
  output logic[7:0] DataOut,
  input  	        CLK
);

logic[7:0] my_memory[256];

always_comb
  if(ReadMem)
    DataOut = my_memory[DataAddress];
  else
    DataOut = 8'bz;

always_ff @ (posedge CLK)
  if(WriteMem) 
    my_memory[DataAddress] = DataIn;

endmodule