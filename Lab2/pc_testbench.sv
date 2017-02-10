module pc_testbench();

reg clk;
reg start;
reg branch;
reg taken;
reg [7:0] rel_jmp; // we only use relative jumps
reg [7:0] pc_in;

wire [7:0] pc_out;

initial begin
	clk = 1;
	start = 0;
	branch = 0;
	taken = 0;
	rel_jmp = 0;
	pc_in = 0;
	
	#10 start = 1; // sets pc to 0
	#10 start = 0;
	#10	// pc = 1
	#10	// pc = 2
	#10 	// pc = 3
	#10   // pc = 4
	#10 branch = 1; taken = 1; rel_jmp = 2; // pc = 2
	#10	// pc = 3 
	#10 start = 1;
	#10 start = 0; 
	
end

	
always begin
	#5 clk = ~clk;
end

pc_exam b2v_inst(
	.clk(clk),
	.start(start),
	.branch(branch),
	.taken(taken),
	.rel_jmp(rel_jmp),
	.pc_in(pc_in),
	.pc_out(pc_out)
);

endmodule
