// CSE141L Winter 2017  Lab 18
// dummy dut -- simply for testing the testbench
// problem: count occurrences of a given 4-bit pattern
//   in an ensemble of 8-bit random values
module dummy_dut18(
  input start,			  // 1: reset; 0: run
        CLK,
  output logic halt);	  // 1: we're done

logic       we;			  // mem write enable
logic [7:0] addr, dat_in; // mem addr & write data
wire  [7:0] dat_out;	  // mem read data
logic [7:0] match_ct[6], match;

data_mem data_mem1(		 // memory core
  .CLK,
  .we ,
  .addr,
  .dat_in,
  .dat_out
  );

initial begin
  halt = 0;
  for(int k=1; k<6; k++)
    match_ct[k] = 8'b0;
  #10ns wait (!start);
// access patterns pre-stored in memory
  for(int l=32; l<96; l++) begin
    match=0;
    for(int m=0; m<5; m++) begin
      if(data_mem1.my_memory[l][3:0]==
         data_mem1.my_memory[9][3:0]) begin
		   match++; 
      end
	  data_mem1.my_memory[l]=(data_mem1.my_memory[l])>>1;
    end
// increment histogram 
// if one match on this line, match_ct[1]++
// if two matches on this line, match_ct[2]++
	case(match)
	  1: match_ct[1]=match_ct[1]+1;
	  2: match_ct[2]=match_ct[2]+1;
	  3: match_ct[3]=match_ct[3]+1;
	  4: match_ct[4]=match_ct[4]+1;
	  5: match_ct[5]=match_ct[5]+1;
	endcase	 
  end
// write results back into memory core
  for(int m=1; m<6; m++)
    data_mem1.my_memory[m+9] = match_ct[m];
  #20000ns halt = 1;
end



endmodule