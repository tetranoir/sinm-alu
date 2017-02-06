// Copyright (C) 2016  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
// CREATED		"Sun Feb 05 15:57:13 2017"

module Lab2(
	SC_IN,
	clk,
	write_en,
	data_in,
	INPUTA,
	INPUTB,
	OP,
	raddrA,
	raddrB,
	waddr,
	SC_OUT,
	data_outA,
	data_outB,
	OUT
);


input wire	SC_IN;
input wire	clk;
input wire	write_en;
input wire	[7:0] data_in;
input wire	[7:0] INPUTA;
input wire	[7:0] INPUTB;
input wire	[3:0] OP;
input wire	[3:0] raddrA;
input wire	[3:0] raddrB;
input wire	[3:0] waddr;
output wire	SC_OUT;
output wire	[7:0] data_outA;
output wire	[7:0] data_outB;
output wire	[7:0] OUT;






ALU	b2v_inst(
	.SC_IN(SC_IN),
	.INPUTA(INPUTA),
	.INPUTB(INPUTB),
	.OP(OP),
	.SC_OUT(SC_OUT),
	.OUT(OUT));


reg_file	b2v_inst6(
	.clk(clk),
	.write_en(write_en),
	.data_in(data_in),
	.raddrA(raddrA),
	.raddrB(raddrB),
	.waddr(waddr),
	.data_outA(data_outA),
	.data_outB(data_outB));


endmodule
