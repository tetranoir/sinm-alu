module TopLevel(
	input start,
	input CLK,
	output halt
);


//9 bit instruction
wire[8:0] Instruction;
wire[7:0] InstrAddr; //instructionaddress
wire[7:0] PC; //program count
wire branch_en,
		taken,
		reg_write,
		flag,
		mem_read,
		mem_write;
wire[3:0] destReg; //destination register
wire[7:0] Data; //data to write to the reg file
wire[7:0] dataA, dataB, dataC;



//pc
pc_exam ProgramCounter(
	.clk(CLK),
	.start(start),
	.branch(branch_en),
	.taken(taken),
	.rel_jump(Data), //TODO change?
	.pc_in(PC),
	.pc_out(InstrAddr)
);

//instructionrom
instr_ROM #(.A(8), .W(9)) INSTR(
    .instAddress(InstrAddr),
    .instrOut(Instruction)
);
//reg file
reg_file REG_FILE(
  .clk (CLK),
  .write_en(reg_write),
  .oprnd(Instruction[3:0]),
  .waddr(destReg),
  .instr(Instruction[8:4]),
  .data_in(Data),
  .data_outA(dataA),
  .data_outB(dataB),
  .data_outAddrBase(dataC),
  .dr_code(destReg)
    );
	 
//alu
ALU ALU1(
	.REG_NUM(destReg), //number of the destination reg
	.OP(Instruction[8:4]), //5 bit ALU OP code
	.INPUT_A(dataA), // 8 bit destination reg
	.INPUT_B(dataB), // 8 bit immediate or whatever
	.INPUT_C(dataC), // address base
	.C_IN(flag), // carry in or flag bit
	
	.OUT(Data), //8 bit output 
	.FLAG_OUT(flag), //if we need to set the flag
	
	.REG_NUM_OUT(destReg)
	
	
);

//memory
dataMem Memory(
	.CLK(CLK),
	.ReadMem(mem_read),
	.WriteMem(mem_write),
	.DataAddr(Data),
	.DataIn(Data),
	.DataOut(Data) //TODO does this need to be different?
);


endmodule