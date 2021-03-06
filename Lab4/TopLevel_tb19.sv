// Create Date:   2017.01.25
// Latest rev:    2017.02.23
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb18.v
//
// Verilog Test Fixture created for module: TopLevel
// This fixture:
//   preloads student's data_memory with randomized test operands
//   pre-clears student's reg_file
//   brings init high, waits, then brings it low
//   waits for student's done (halt) flag
//   compares expected result of program against what's in student's
//     specified data_memory locations

module TopLevel_tb19;     // Lab 18

// To DUT Inputs
  bit start;		      // 1: initialize; 0: run
  bit CLK;				  // single systemwide clock

// From DUT Outputs
  wire halt;		      // done/finished flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
	.start       (start), 
	.CLK         (CLK)  , 
	.halt             	  // equiv. to .halt (halt)
	);
  logic [3:0] ham, ham_max;
  logic [7:0] mymem[256]; // fake memory in testbench
  logic [7:0] jaldo;	  // series of random 8-bit values
  logic [7:0] indi, indj; // indices where max ham occurred
  int cycle_ct;           // clock cycle counter

// anti-correlator function
  function[3:0] corr(
    input[7:0] a, b);
    begin
      corr = 0;
      for(int i=0; i<8; i++)
        corr = corr + (a[i]^b[i]);  
    end
  endfunction

initial begin
$display("4");
  start = 1'b1;		      // initialize PC; freeze everything temporarily
  // Loads instructions to instruction ROM
  $readmemb("farpair2_mcode.txt",DUT.INSTR.inst_rom);
$display("5+++");
// Initialize DUT's data memory
// edit index limit for size other than 256 elements
  #10ns for(int i=0; i<256; i++) begin
    DUT.memory1.MEM[i] = 8'h0;	     // clear data_mem
    mymem[i] = 8'b0;
  end
// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.REG_FILE1.registers[j] = 8'b0;    // default -- clear it
$display("6");
// load 20 random unsigned bytes into data_memory
  for(int j=128; j<148; j++) begin
    jaldo = $random;
    mymem[j] = jaldo;
    DUT.memory1.MEM[j] = jaldo;  // 
	$display("%d  %b",j,jaldo);
	#10ns;// $displayb(mymem[j]);
  end
$display("7");
    
// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  #10ns wait (halt);
$display("8");
  ham = 0;
  ham_max = 0;
// search the upper triangle (190 of 400 permutations)
$display("9");
  #10ns for(int l=128; l<148; l++) begin
          for(int m=l+1; m<148; m++) begin
   	        ham = corr(mymem[l],mymem[m]);
			$write(" ",ham);
	        if(ham>ham_max) begin
	          ham_max = ham;
			  indi = l;
			  indj = m;
	        end
		  end
          $display();
 	    end
$display("10");
// testbench's histogram
// for diagnostics, also display where we found the max.
    	$display("testbench max: ",ham_max,,indi,,indj);
// DUT's histogram
        $display("DUT       max: ",DUT.memory1.MEM[127]);
        $display("cycle count = %d",cycle_ct);
        $display("instruction = %d %t",DUT.instr_cnt,$time);
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

