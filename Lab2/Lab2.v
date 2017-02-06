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
// CREATED		"Sun Feb 05 17:44:02 2017"

module Lab2(
	clk,
	write_en,
	data_in,
	instr,
	oprnd,
	waddr,
	data_outA,
	data_outAddrBase,
	data_outB,
	dr_code
);


input wire	clk;
input wire	write_en;
input wire	[7:0] data_in;
input wire	[4:0] instr;
input wire	[3:0] oprnd;
input wire	[3:0] waddr;
output wire	[7:0] data_outA;
output wire	[7:0] data_outAddrBase;
output wire	[7:0] data_outB;
output wire	[3:0] dr_code;






reg_file	b2v_inst(
	.clk(clk),
	.write_en(write_en),
	.data_in(data_in),
	.instr(instr),
	.oprnd(oprnd),
	.waddr(waddr),
	.data_outA(data_outA),
	.data_outAddrBase(data_outAddrBase),
	.data_outB(data_outB),
	.dr_code(dr_code));


endmodule
