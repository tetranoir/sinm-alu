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
// CREATED		"Thu Feb 02 08:54:36 2017"

module WalkThrough(
	clock,
	wenable_i,
	reset_i,
	newpc_i,
	pc_o
);


input wire	clock;
input wire	wenable_i;
input wire	reset_i;
input wire	[7:0] newpc_i;
output wire	[7:0] pc_o;






program_counter	b2v_inst(
	.clock(clock),
	.wenable_i(wenable_i),
	.reset_i(reset_i),
	.newpc_i(newpc_i),
	.pc_o(pc_o));


endmodule
