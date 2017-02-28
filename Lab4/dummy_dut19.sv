// CSE141L Winter 2017  Lab 19
// dummy dut -- simply for testing the testbench
// problem: count occurrences of a given 4-bit pattern
//   in an ensemble of 8-bit random values
module dummy_dut19(
  input start,			  // 1: reset; 0: run
        CLK,
  output logic halt);	  // 1: we're done

logic       we;			  // mem write enable
logic [7:0] addr, dat_in; // mem addr & write data
wire  [7:0] dat_out;	  // mem read data
logic [3:0] ham, ham_max;

// hamming distance calculator (anti-correlator)
function[3:0] corr(
  input[7:0] a, b);
  begin
    corr = 0;
    for(int i=0; i<8; i++)
      corr = corr + (a[i]^b[i]);  
  end
endfunction

data_mem data_mem1(		 // memory core
  .CLK,
  .we ,
  .addr,
  .dat_in,
  .dat_out
  );

initial begin
  halt = 0;
  #10ns wait (!start);
// access patterns pre-stored in memory
// write results back into memory core
  ham = 0;
  ham_max = 0;            // greatest hamming distance
// brute-force search through all 400 permutations
//   of two addresses out of 20
//  works because we are looking for max, instead of min.
  for(int i=128; i<148; i++) begin
    for(int j=i+1; j<148; j++) begin
	  ham = corr(data_mem1.my_memory[i],data_mem1.my_memory[j]);
	  if(ham>ham_max)
	    ham_max = ham;
	end
  end
  data_mem1.my_memory[127] = ham_max;
  #20000ns halt = 1;
end



endmodule