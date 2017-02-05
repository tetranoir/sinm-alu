module program_counter 
(
  input [7:0] newpc_i, 
  input clock,
  input wenable_i, 
  input reset_i,
  output [7:0] pc_o
);

reg [7:0] pc, pcnext;

assign pc_o = pc;

always_comb
	begin
	if (reset_i) begin
		pcnext = 0;
	end else if (wenable_i)
		pcnext = newpc_i;
	else 
		pcnext = pc;
	end
	
always_ff @(posedge clock)
	pc <= pcnext;
	
endmodule
