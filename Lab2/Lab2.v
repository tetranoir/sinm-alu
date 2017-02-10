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
<<<<<<< HEAD
// CREATED		"Sun Feb 05 18:36:35 2017"
=======
// CREATED		"Sun Feb 05 22:16:31 2017"
>>>>>>> b73edaa268bc8044f0c2bdd1b087595feb4b46f8

module Lab2(
	clk,
	write_en,
	C_IN,
	data_in,
	INPUT_A,
	INPUT_B,
	INPUT_C,
<<<<<<< HEAD
	OP,
	raddrA,
	raddrB,
=======
	instr,
	OP,
	oprnd,
>>>>>>> b73edaa268bc8044f0c2bdd1b087595feb4b46f8
	REG_NUM,
	waddr,
	FLAG_OUT,
	REG_NUM_OUT,
	data_outA,
	data_outAddrBase,
	data_outB,
	dr_code,
	OUT
);


input wire	clk;
input wire	write_en;
input wire	C_IN;
input wire	[7:0] data_in;
input wire	[7:0] INPUT_A;
input wire	[7:0] INPUT_B;
input wire	[7:0] INPUT_C;
<<<<<<< HEAD
input wire	[4:0] OP;
input wire	[3:0] raddrA;
input wire	[3:0] raddrB;
=======
input wire	[4:0] instr;
input wire	[4:0] OP;
input wire	[3:0] oprnd;
>>>>>>> b73edaa268bc8044f0c2bdd1b087595feb4b46f8
input wire	[3:0] REG_NUM;
input wire	[3:0] waddr;
output wire	FLAG_OUT;
output wire	REG_NUM_OUT;
output wire	[7:0] data_outA;
output wire	[7:0] data_outAddrBase;
output wire	[7:0] data_outB;
output wire	[3:0] dr_code;
output wire	[7:0] OUT;






<<<<<<< HEAD
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


reg_file	b2v_inst6(
	
	
	
	
	
	
=======
reg_file	b2v_inst(
	.clk(clk),
	.write_en(write_en),
	.data_in(data_in),
	.instr(instr),
	.oprnd(oprnd),
	.waddr(waddr),
>>>>>>> b73edaa268bc8044f0c2bdd1b087595feb4b46f8
	.data_outA(data_outA),
	.data_outAddrBase(data_outAddrBase),
	.data_outB(data_outB),
	.dr_code(dr_code));


ALU	b2v_inst3(
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
