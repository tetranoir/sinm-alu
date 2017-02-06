import definitions::*;

module ALUtestbench();

//inputs



reg [3:0] REG_NUM; //number of the destination reg
reg [4:0] OP; //5 bit ALU OP code
reg [7:0] INPUT_A, // 8 bit destination reg
			 INPUT_B, // 8 bit immediate or whatever
			 INPUT_C; // address base
reg C_IN; // carry in or flag bit

wire[7:0] OUT; //8 bit output 
wire FLAG_OUT; //if we need to set the flag

wire REG_NUM_OUT;


initial begin
	OP = opAdd;
	INPUT_A = 1;
	INPUT_B = 2;
	INPUT_C = 0;
	REG_NUM= 5;
	C_IN = 0;
	
	#10
	
	INPUT_A = 3;
	INPUT_B = 2;


end


ALU	b2v_inst(
	.C_IN(C_IN),
	.INPUT_A(INPUT_A),
	.INPUT_B(INPUT_B),
	.INPUT_C(INPUT_C),
	.OP(OP),
	.REG_NUM(REG_NUM),
	.FLAG_OUT(FLAG_OUT),
	.REG_NUM_OUT(REG_NUM_OUT),
	.OUT(OUT));
	
endmodule
