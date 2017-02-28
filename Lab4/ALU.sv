import definitions::*;



module ALU (
	input [3:0] REG_NUM, //number of the destination reg
	input [4:0] OP, //5 bit ALU OP code
	input [7:0] INPUT_A, // 8 bit destination reg
					INPUT_B, // 8 bit immediate or whatever
					INPUT_C, // address base
	input C_IN, // carry in or flag bit
	
	output logic[7:0] OUT, //8 bit output 
    output logic[7:0] OUT_ADDR, //8 bit address for mem unit
	output reg FLAG_OUT, //if we need to set the flag
    output logic TO_WRITE_MEM,
    output logic TO_READ_MEM, // bit signal for mem and data sel mux
	
	output logic [3:0]REG_NUM_OUT,
	output logic write_reg,
	output logic branch,
	output logic write_flag
	
);



always_comb begin
	REG_NUM_OUT = REG_NUM;
	OUT = 0;
    OUT_ADDR = 0;
    TO_WRITE_MEM = 0;
    TO_READ_MEM = 0;
	FLAG_OUT = C_IN;
	write_reg = 0;
	branch = 0;
	write_flag = 0;
	

	case(OP)
		opSetdr: begin OUT = INPUT_B; write_reg = 1; end
		opAdd: begin 
			{FLAG_OUT, OUT} = INPUT_A + INPUT_B; //any overflow get stored in flagout
			write_reg = 1;
			write_flag = 1;
			end
		opAddc:  begin
			{FLAG_OUT, OUT} = INPUT_A + INPUT_B + C_IN;
			write_reg = 1;
			write_flag = 1;
			end
		opSub: begin 
			OUT = INPUT_A - INPUT_B;
			write_reg = 1;
			end
		
		opIncr: begin
			{FLAG_OUT, OUT} = INPUT_B + 8'h01;
			write_reg = 1;
			write_flag = 1;
			end
		opDecr: begin 
			OUT = INPUT_B - 8'h01;
			write_reg = 1;
			end
		
		opLoadImm: begin
            OUT_ADDR = (INPUT_C << 4) + INPUT_B[3:0];
            TO_READ_MEM = 1;
				write_reg = 1;
        end
		opLoadReg: begin
            OUT_ADDR = INPUT_B;
            TO_READ_MEM = 1;
				write_reg = 1;
        end
		
		opStoreImm: begin
            OUT = INPUT_A;
            OUT_ADDR = (INPUT_C << 4) + INPUT_B[3:0];
            TO_WRITE_MEM = 1;
				
        end
		opStoreReg: begin
            OUT = INPUT_A;
            OUT_ADDR = INPUT_B;
            TO_WRITE_MEM = 1;
        end
		
		opMovImm: begin OUT = INPUT_B[3:0]; write_reg = 1; end
		opMovReg: begin OUT = INPUT_B; write_reg = 1; end
		
		opClr: begin {FLAG_OUT, OUT} = 0; write_reg = 1; write_flag =1; end
		
		opShl: begin OUT = INPUT_A << INPUT_B[3:0]; write_reg = 1; end
		opShr: begin OUT = INPUT_A >> INPUT_B[3:0]; write_reg = 1; end
		opSar: begin OUT = $signed(INPUT_A) >>> INPUT_B[3:0]; write_reg = 1; end
			   
		
		
		opRcr: begin 
					FLAG_OUT = INPUT_B[0];
					OUT = ({C_IN, INPUT_B[7:1]});
					write_reg = 1;
					write_flag = 1;
				 end
				 
				 
		opRcl: begin 
					FLAG_OUT = INPUT_B[7];
					OUT = ({INPUT_B[6:0], C_IN});
					write_reg = 1;
					write_flag = 1;
				 end
		
		opAnd: begin OUT = INPUT_A & INPUT_B; write_reg = 1; end
		opXor: begin OUT = INPUT_A ^ INPUT_B; write_reg = 1; end
		
		opCmpImm:
			if(INPUT_A == INPUT_B) begin
				FLAG_OUT = 1;
				write_flag = 1;
			end else begin
				FLAG_OUT = 0;
				write_flag = 1;
			end
		opCmpReg:
			if(INPUT_A == INPUT_B) begin
				FLAG_OUT = 1;
				write_flag = 1;
			end else begin
				FLAG_OUT = 0;
				write_flag = 1;
			end
		
		opJmp: begin OUT = (INPUT_C << 4) + INPUT_B[3:0]; branch = 1; end
		opJz:
			if(INPUT_A == 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
				branch = 1;
			end else begin 
				OUT = 0;
			end
		opJfnz:
			if(C_IN != 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
				branch = 1;
			end else begin 
				OUT = 0;
			end
		opJnz:
			if(INPUT_A != 0) begin
				OUT = (INPUT_C << 4) + INPUT_B[3:0];
				branch = 1;
			end else begin 
				OUT = 0;
			end
		
		opClfb: if(((INPUT_A ^ INPUT_B)& 8'h0F) == 0) begin
						FLAG_OUT = 0;
						write_flag = 1;
					end else begin 
						FLAG_OUT = 1; 
						write_flag = 1;
					end
		opMax:
			if(INPUT_A >= INPUT_B) begin
				OUT = INPUT_A;
				write_reg = 1;
			end else begin 
				OUT = INPUT_B; 
				write_reg = 1;
			end
		
	
		opCkfr:
			if((INPUT_A | INPUT_B) == 0) begin
				FLAG_OUT = 0;
				write_flag = 1;
			end else begin
				FLAG_OUT = 1;
				write_flag = 1;
			end
			
		
	
	endcase
	
	







end //end always_comb



endmodule