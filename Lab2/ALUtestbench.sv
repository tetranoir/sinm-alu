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

wire [3:0]REG_NUM_OUT;


initial begin

	//set destination register
	#10
	OP = opSetdr;
	#10
	REG_NUM = 4'hD;

	//test adding
	
	OP = opAdd;
	#10
	INPUT_A = 8'd200;
	INPUT_B = 8'd75;
	INPUT_C = 8'd4; //shouldn't matter
	REG_NUM= 4'd5;
	C_IN = 1; //shouldn't matter
	
	#10
	INPUT_A = 15;
	INPUT_B = 56;
	
	
	#10 
	INPUT_B = -3;


	
	
	//add with carry

	OP = opAddc;
	#10
	INPUT_A = 3;
	INPUT_B = 10;
	INPUT_C = 1;
	
	#10
	C_IN = 0;
	#10
	//subtract
	
	OP = opSub;
	#10
	
	INPUT_A = 3;
	INPUT_B = 10;
	INPUT_C = 1;
	
	
	
	#10
	INPUT_A = 36;
	
	#10
	INPUT_B = -5;

	
	//test incr
	
	OP = opIncr;
	#10
	INPUT_B = 2;

	#10
	//decr
	
	OP = opDecr;
	#10
	INPUT_B = 10;
	
	#10
	INPUT_B = 0;
	
	//load immediate
	#10
	OP = opLoadImm;
	#10

	INPUT_B = 8'b00111010;
	INPUT_C = 8'b11111011;
	
	#10

	//load register
	
	OP = opLoadReg;
	#10
	INPUT_B = 234;
	
	#10
	//store immediate
	
	OP = opStoreImm;
	#10
	INPUT_B = 8'b00111110;
	INPUT_C = 8'b10110010;

	//store register
	#10
	OP = opStoreReg;
	#10
	INPUT_B = 10;

	//move immediate
	#10
	OP = opMovImm;
	#10
	INPUT_A = 8'b11111011;

	
	#10
	//move register
	OP = opMovReg;
	#10
	INPUT_A = 36;
	
	
	
	//clear
	#10
	OP = opClr;
	#10
	C_IN = 1;

	//shift left
	#10
	OP = opShl;
	#10
	INPUT_A = 8'b00111001;
	INPUT_B = 2;

	#10
	INPUT_B = 15;
	
	
	//shift right
	#10
	OP = opShr;
	#10
	INPUT_B = 4;

	
	//shift right arithmetic
	#10
	OP = opSar;
	#10
	INPUT_A = 200;
	INPUT_B = 2;
	
	#10
	INPUT_A = -5;
	INPUT_B = 3;


	//rotate circular right
	#10
	OP = opRcr;
	#10
	INPUT_A = 8'b01010101;
	C_IN = 1;
	
	#10
	C_IN = 0;
	
	//rotate circular left
	#10
	OP = opRcl;
	#10
	C_IN = 1;
	
	#10
	C_IN = 0;
	
	
	//AND
	#10
	OP = opAnd;
	#10
	INPUT_A = 8'b00110001;
	INPUT_B = 8'b11001111;


	//XOR
	#10
	OP = opXor;
	#10

	
	
	//compare immediate
	#10
	OP = opCmpImm;
	#10
	INPUT_A = 3;
	INPUT_B = 3;
	
	
	#10
	INPUT_B = 15;
	
	//compare register
	#10
	OP = opCmpReg;
	#10
	INPUT_A = 8'b00011100;
	INPUT_B = 8'b00011100;
	
	#10
	INPUT_B = 8'b01011110;


	//jump
	#10
	OP = opJmp;
	#10
	INPUT_C = 8'b00000010;

	
	
	//jump zero
	#10
	OP = opJz;
	#10

	#10
	INPUT_A = 0;
	
	//jump flag not zero
	#10
	OP = opJfnz;
	#10
	C_IN = 0;
	
	#10
	C_IN = 1;
	
	//jump not zero
	#10
	OP = opJnz;
	#10
	INPUT_A = 0;
	
	#10
	INPUT_A = 9;
	
	//clear flag bit
	#10
	OP = opJmp;
	#10
	INPUT_A = 8'b00000000;
	INPUT_B = 8'b11110000;

	
	#10
	INPUT_B = 8'b11110001;
	
	
	//MAX
	#10
	OP = opMax;
	#10
	INPUT_A = 3;
	INPUT_B = 10;
	
	#10
	INPUT_B = -1;

	
	//check four registers 
	#10
	OP = opCkfr;
	#10
	INPUT_A = 78;
	
	#10
	INPUT_A = 0;
	INPUT_B = 10;
	INPUT_C = 1;
	
	


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
