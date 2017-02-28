// dummy for lab 17
module dummy_dut17(
  input    start,
  input    CLK,
  output   halt
);
wire [15:0] PC;
logic[ 7:0] ReadA;
wire [ 7:0] memWriteValue, // data in to data_mem
	   	    Mem_Out;	   // data out from data_mem
logic       MEM_READ =1'b1,    // data_mem read enable
		    MEM_WRITE;	   // data_mem write enable
logic signed[15:0] OpA, OpB;
integer Prod;

// fetch unit -- program counter
// optional jump & branch controls not shown
  PCt PC1 (
	.init       (start), 
	.halt       (halt) , 
	.CLK               , 
	.PC             
	);

// reg_file
  reg_file reg_file1(
    .CLK        (CLK),
    .RegWrite   (1'b0),
    .srcA       (4'b0),
    .srcB       (4'b0),
    .writeReg   (4'b0),
    .writeValue (8'b0),
	.ReadA      (),
	.ReadB      ()
    );

// data_memory
  data_mem data_mem1(
		.DataAddress  (ReadA), 
		.ReadMem      (MEM_READ), 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (memWriteValue), 
		.DataOut      (Mem_Out), 
		.CLK 
);

always @(posedge CLK) 
  case(PC)
     0: MEM_WRITE   <= 1'b0;
	41: OpA[15: 8] <= data_mem1.my_memory[1];
	42: OpA[ 7: 0] <= data_mem1.my_memory[2];
	43: OpB[15: 8] <= data_mem1.my_memory[3];
    45: OpB[ 7: 0] <= data_mem1.my_memory[4];
	46: Prod <= OpA * OpB;
	47:	data_mem1.my_memory[5] <= Prod[31:24];
	48: data_mem1.my_memory[6] <= Prod[23:16];
	49: data_mem1.my_memory[7] <= Prod[15: 8];
	50: data_mem1.my_memory[8] <= Prod[ 7: 0];
  endcase

endmodule

