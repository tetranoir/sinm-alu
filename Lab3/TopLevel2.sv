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
		mem_read,
		mem_write,
		flag_write;
wire[3:0] destRegALUin; //destination register
wire[3:0] destRegALUout; //destination register
wire[7:0] Data, ALUData, MemData; //data to write to the reg file
wire[7:0] memAddr;
wire[7:0] dataA, dataB, dataC;

wire flagIn, flagOut;

//pc
pc_exam ProgramCounter1(
	.clk(CLK),
	.start(start),
	.branch(branch_en),
	.taken(taken),
	.rel_jmp(ALUData),
	.pc_in(PC),
	.pc_out(InstrAddr)
);

//instructionrom
instr_ROM #(.A(8), .W(9)) INSTR(
    .instAddress(InstrAddr),
    .instrOut(Instruction)
);

//reg file
reg_file REG_FILE1(
  .clk (CLK),
  .write_en(reg_write),
  .oprnd(Instruction[3:0]),
  .waddr(destRegALUout),
  .instr(Instruction[8:4]),
  .data_in(Data),
  .data_outA(dataA),
  .data_outB(dataB),
  .data_outAddrBase(dataC),
  .dr_code(destRegALUin),
  .halt(halt)
);

//alu
// TODO: Add the port for flag enable and register write enable
ALU ALU1(
	.REG_NUM(destRegALUin), //number of the destination reg
	.OP(Instruction[8:4]), //5 bit ALU OP code
	.INPUT_A(dataA), // 8 bit destination reg
	.INPUT_B(dataB), // 8 bit immediate or whatever
	.INPUT_C(dataC), // address base
	.C_IN(flagOut), // carry in or flag bit
	
	.OUT(ALUData), //8 bit output 
    .OUT_ADDR(memAddr),
	.FLAG_OUT(flagIn), //if we need to set the flag
    .TO_WRITE_MEM(mem_write),
    .TO_READ_MEM(mem_read),
	.write_reg(reg_write),
	.branch(branch_en),
	.write_flag(flag_write),
	.REG_NUM_OUT(destRegALUout)
	
	
);

//memory
dataMem memory1(
	.CLK(CLK),
	.ReadMem(mem_read),
	.WriteMem(mem_write),
	.DataAddr(memAddr),
	.DataIn(ALUData),
	.DataOut(MemData)
);

busmux #(.WIDTH(8), .LPM_WIDTHS(1)) reginMux(
    .dataa(ALUData),
    .datab(MemData),
    .sel(mem_read),
    .result(Data)
);

lpm_ff #(.LPM_AVALUE(0), .LPM_WIDTH(1)) flagReg(
    .sload(1),
    .enable(1), // TODO: Connect it to the ALU flag enable wire.
    .clock(CLK),
    .data(flagIn),
    .q(flagOut)
);


endmodule