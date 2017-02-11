import definitions::*;



module ALU (
	input [3:0] REG_NUM, //number of the destination reg
	input [4:0] OP, //5 bit ALU OP code
	input [7:0] INPUT_A, // 8 bit destination reg
					INPUT_B, // 8 bit immediate or whatever
					INPUT_C, // address base
	input C_IN, // carry in or flag bit
	
	output logic[7:0] OUT, //8 bit output 
	output logic FLAG_OUT, //if we need to set the flag
	
	output logic [3:0]REG_NUM_OUT
	
	
);



always_comb begin
	REG_NUM_OUT = REG_NUM;
	OUT = 0;
	FLAG_OUT = C_IN;
	

	case(OP)
		opSetdr: REG_NUM_OUT = INPUT_B[3:0];
		opAdd: {FLAG_OUT, OUT} = INPUT_A + INPUT_B; //any overflow get stored in flagout
		opAddc:  {FLAG_OUT, OUT} = INPUT_A + INPUT_B + C_IN;
		opSub: OUT = INPUT_A - INPUT_B;
		
		opIncr: {FLAG_OUT, OUT} = INPUT_B + 8'h01;
		opDecr: OUT = INPUT_B - 8'h01;
		
		opLoadImm: OUT = (INPUT_C << 4) + INPUT_B[3:0];
		opLoadReg: OUT = INPUT_B;
		
		opStoreImm: OUT = (INPUT_C << 4) + INPUT_B[3:0];
		opStoreReg: OUT = INPUT_B;
		
		opMovImm: OUT = INPUT_A[3:0];
		opMovReg: OUT = INPUT_A;
		
		opClr: {FLAG_OUT, OUT} = 0;
		
		opShl: {FLAG_OUT, OUT} = INPUT_A << INPUT_B[3:0];
		opShr: OUT = INPUT_A >> INPUT_B[3:0];
		opSar: OUT = $signed(INPUT_A) >>> INPUT_B[3:0];
			   
		
		//REDO ASDFKJASDF
		opRcr: begin 
					FLAG_OUT = INPUT_A[0];
					OUT = ({C_IN, INPUT_A[7:1]});
				 end
				 
				 
		opRcl: begin 
					FLAG_OUT = INPUT_A[7];
					OUT = ({INPUT_A[6:0], C_IN});
				 end
		
		opAnd: OUT = INPUT_A & INPUT_B;
		opXor: OUT = INPUT_A ^ INPUT_B;
		
		opCmpImm:
			if(INPUT_A == INPUT_B) begin
				FLAG_OUT = 1;
			end else begin
				FLAG_OUT = 0;
			end
		opCmpReg:
			if(INPUT_A == INPUT_B) begin
				FLAG_OUT = 1;
			end else begin
				FLAG_OUT = 0;
			end
		
		opJmp: OUT = (INPUT_C << 4) + INPUT_B[3:0];
		opJz:
			if(INPUT_A == 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
			end else begin 
				OUT = 0;
			end
		opJfnz:
			if(C_IN != 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
			end else begin 
				OUT = 0;
			end
		opJnz:
			if(INPUT_A != 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
			end else begin 
				OUT = 0;
			end
		
		opClfb: if(((INPUT_A ^ INPUT_B)& 8'h0F) == 0) begin
						FLAG_OUT = 0;
					end else begin 
						FLAG_OUT = 1; 
					end
		opMax:
			if(INPUT_A >= INPUT_B) begin
				OUT = INPUT_A;
			end else begin 
				OUT = INPUT_B; 
			end
		
	
		opCkfr:
			if((INPUT_A | INPUT_B) == 0) begin
				FLAG_OUT = 0;
			end else begin
				FLAG_OUT = 1;
			end
			
		
	
	endcase
	
	







end //end always_comb



endmodule