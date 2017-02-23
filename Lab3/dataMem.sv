module dataMem(
	input CLK,
	input ReadMem,
	input WriteMem,
	input [7:0] DataAddr,
	input [7:0] DataIn,
	output logic [7:0] DataOut
);

logic[7:0] MEM[256];

//TODO initialize memory
always_comb
	if(ReadMem) begin
		DataOut = MEM[DataAddr];
	end else
		DataOut = 16'bZ;
		
		
always_ff @ (posedge CLK)
	if(WriteMem) begin
		MEM[DataAddr] = DataIn;
		
	end

endmodule