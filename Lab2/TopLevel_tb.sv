// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//
// Verilog Test Fixture created for module: TopLevel

module TopLevel_tb;	     // Lab 17

// To DUT Inputs
  bit start;
  bit CLK;

// From DUT Outputs
  wire halt;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
	.start           , 
	.CLK             , 
	.halt             
	);

initial begin
  start = 1;
// Initialize DUT's data memory
  #10ns for(int i=0; i<256; i++)
    DUT.data_mem1[i] = 8'h0;	 // clear data_mem
  DUT.data_mem1[1] = 8'h03;      // MSW of operand A
  DUT.data_mem1[2] = 8'hff;
  DUT.data_mem1[3] = 8'hff;      // MSW of operand B
  DUT.data_mem1[4] = 8'hfb;
// students may also pre_load desired constants into data_mem
// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.reg_file1[j] = 8'b0;    // default -- clear it
// students may pre-load desired constants into the reg_file
// Initialize instruction ROM
//	 read instruction list generated by compiler
  $readmemh("machine_code.txt",DUT.instr_ROM1);
    
// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  wait (halt);
  #10ns $displayh(DUT.data_mem1[5],DUT.data_mem1[6],"_",
     DUT.data_mem1[7],DUT.data_mem1[8]);
  #10ns $stop;			   
end

always begin   // clock period = 10 Verilog time units
  #5ns  CLK = 1;
  #5ns  CLK = 0;
end
      
endmodule

