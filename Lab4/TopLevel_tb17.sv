// Create Date:   2017.01.25
// Latest rev:    2017.02.23
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//
// Verilog Test Fixture created for module: TopLevel
// This fixture:
//   preloads student's data_memory with randomized test operands
//   pre-clears student's reg_file
//   brings init high, waits, then brings it low
//   waits for student's done (halt) flag
//   compares expected result of program against what's in student's
//     specified data_memory locations

module TopLevel_tb17;     // Lab 17

// To DUT Inputs
  bit start;		      // 1: initialize; 0: run
  bit CLK;				  // single systemwide clock

// From DUT Outputs
  wire halt;		      // done/finished flag

// Instantiate the Device Under Test (DUT)
  dummy_dut17 DUT (
	.start       (start), 
	.CLK         (CLK)  , 
	.halt             	  // equiv. to .halt (halt)
	);
  logic signed[15:0] OpA, OpB;
  int Prod;               // 32-bit expected product of OpA*OpB
  int cycle_ct;           // clock cycle counter
initial begin
  start = 1'b1;		      // initialize PC; freeze everything temporarily

// Initialize DUT's data memory
// edit index limit for size other than 256 elements
  #10ns for(int i=0; i<256; i++) begin
    DUT.data_mem1.my_memory[i] = 8'h0;	     // clear data_mem
  end
// $random returns a 32-bit integer; we'll take the top half
    OpA = ($random)>>16;
	OpB = ($random)>>16;
	$display(OpA,,,OpB);
    DUT.data_mem1.my_memory[1] = OpA[15: 8];  // MSW of operand A
    DUT.data_mem1.my_memory[2] = OpA[ 7: 0];
    DUT.data_mem1.my_memory[3] = OpB[15: 8];  // MSW of operand B
    DUT.data_mem1.my_memory[4] = OpB[ 7: 0];
// students may also pre_load desired constants into any 
//  part of data_mem 

// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.reg_file1.registers[j] = 8'b0;    // default -- clear it
// students may pre-load desired constants into the reg_file
//   as shown above for my_memory[1:4]
    
// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  #10ns wait (halt);
  #10ns $displayh("dut_result = ",DUT.data_mem1.my_memory[5],
                  DUT.data_mem1.my_memory[6],"_",
                  DUT.data_mem1.my_memory[7],
                  DUT.data_mem1.my_memory[8]);
		Prod = OpA * OpB;        // expected result
		$displayh("bench_rslt = ",Prod[31:16],,Prod[15:0]);
        $display("cycle count = %d",cycle_ct);
        $display("instruction = %d %t",DUT.PC,$time);
  #10ns $stop;			   
end

// digital system clock generator
always begin   // clock period = 10 Verilog time units
  #5ns  CLK = 1;
  #5ns  CLK = 0;
end

// clock cycle counter
always @(posedge CLK)
  if(!start && !halt)
    cycle_ct <= cycle_ct + 32'b1;
      
endmodule

