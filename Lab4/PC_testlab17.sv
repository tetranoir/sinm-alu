// instruction counter for demo
// no jumps or branches -- insert as desired
module PCt (
  input              init,
  output logic       halt,
  input              CLK,
  output logic[15:0] PC
  );

always @(posedge CLK)
  if(init) begin
    PC   <= 16'b0;
	halt <= 1'b0;
  end
  else if(PC<100)
	PC   <= PC + 16'b1;
  else
    halt <= 1'b1;

endmodule