// Engineer:        Huajie Wu
//
// Create Date:     02/05/2017
// Design Name:     reg_file
// Module Name:     reg_file_tb.v
// Project Name:    Lab2
// Target Device:   Cyclone IV E: EP4CE40F29C6 
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: reg_file
//
// Dependencies:    definitions.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
import definitions::*;			  // includes package "definitions"

module reg_file_tb;
	bit         clk;
    bit         write_en;
    bit [8:0]   full_instr;
    bit [3:0]   waddr;
    bit [7:0]   data_in;
    
	typedef enum {hold, write} mne; 
	mne op_mne;
// DUT Outputs
    wire [7:0]  data_outA,
                data_outB,
                data_outAddrBase;
    wire [3:0]  dr_code;

    integer i, alert_code;
    bit alert;
// Instantiate the Unit Under Test (UUT)
    reg_file	uut(
        .clk(clk),
        .write_en(write_en),
        .data_in(data_in),
        .instr(full_instr[8:4]),
        .oprnd(full_instr[3:0]),
        .waddr(waddr),
        .data_outA(data_outA),
        .data_outAddrBase(data_outAddrBase),
        .data_outB(data_outB),
        .dr_code(dr_code));

    assign op_mne = mne'(write_en);
    initial begin
        // Wait 100 ns for global reset to finish
        alert = 0;
        #100ns;
        
        // check if writing works
        for (i = 0; i < 16; i = i + 1) begin
            write_en = 1;
            waddr = i;
            data_in = 64 + 15 - i;
            if (i == rn_dr)
                data_in = 0;
            #20ns;
        end
        
        write_en = 0;
        full_instr = 9'h003;    // setdr 3
        #10ns;
        if (dr_code != rn_dr || data_outB != 8'h03)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h01e;    // add r14
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h41)
            alert = 1;
        #10ns;
        alert = 0;

        full_instr = 9'h02c;    // addc r12
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h00)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h037;    // sub r7
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h48)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h049;    // incr r9
        #10ns;
        if (dr_code != 4'h9 || data_outB != 8'h46)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h05f;    // decr r15
        #10ns;
        if (dr_code != 4'hf || data_outB != 8'h40)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h06f;    // load 15
        #10ns;
        if (data_outAddrBase != 8'h42 || data_outB != 8'h0f)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h071;    // load r1
        #10ns;
        if (data_outB != 8'h4e)
            alert = 1;
        #10ns;
        alert = 0;
 
        full_instr = 9'h084;    // store 4
        #10ns;
        if (data_outAddrBase != 8'h42 || data_outB != 8'h04)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h094;    // store r4
        #10ns;
        if (data_outB != 8'h4b)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h0ae;    // mov 14
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h0e)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h0ba;    // mov r10
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h45)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h0c5;    // clr r5
        #10ns;
        if (dr_code != 4'h5)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h0d7;    // shl 7
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h07 || dr_code != 4'h0)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h0e3;    // shr 3
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h03 || dr_code != 4'h0)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h0f1;    // sar 1
        #10ns;
        if (data_outA != 8'h4f || data_outB != 8'h01 || dr_code != 4'h0)
            alert = 1;
        #10ns;
        alert = 0;
        
        uut.registers[rn_dr] = 8'h03;   // set dr to be r3
        
        full_instr = 9'h10f;    // rcr r15
        #10ns;
        if (dr_code != 4'hf || data_outB != 8'h40)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h113;    // rcl r3
        #10ns;
        if (dr_code != 4'h3 || data_outB != 8'h4c)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h126;    // and r6
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h49)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h13a;    // xor r10
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h45)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h14e;    // cmp 14
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h0e)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h152;    // cmp r2
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h4d)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h164;    // jmp 4
        #10ns;
        if (data_outAddrBase != 8'h41 || data_outB != 8'h04)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h177;    // jz 7
        #10ns;
        if (data_outAddrBase != 8'h41 || data_outB != 8'h07 || data_outA != 8'h4c)
            alert = 1;
        #10ns;
        alert = 0;
        
         full_instr = 9'h18c;    // jfnz 12
        #10ns;
        if (data_outAddrBase != 8'h41 || data_outB != 8'h0c)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h19f;    // jnz 15
        #10ns;
        if (data_outAddrBase != 8'h41 || data_outB != 8'h0f || data_outA != 8'h4c)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        full_instr = 9'h1a1;    // clfb r1
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h4e)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h1b0;    // max r0
        #10ns;
        if (data_outA != 8'h4c || data_outB != 8'h4f)
            alert = 1;
        #10ns;
        alert = 0;
        
        uut.registers[4] = 8'b11001110;   // Change r4 value
        uut.registers[5] = 8'b01011010;   // Change r5 value
        uut.registers[6] = 8'b00000100;   // Change r6 value
        uut.registers[7] = 8'b11001010;   // Change r7 value
        
        full_instr = 9'h1e0;    // ckfr
        #10ns;
        if (data_outA != 8'b11011110 || data_outB != 8'b11001110)
            alert = 1;
        #10ns;
        alert = 0;
        
        full_instr = 9'h1f0;    // halt r0
        #10ns;
        if (data_outA != 8'h00 || data_outB != 8'h00 ||
            data_outAddrBase != 8'h00 || dr_code != 4'h0)
            alert = 1;
        #10ns;
        alert = 0;
        
        
        // Write before read test
        uut.registers[0] = 8'h08;
        uut.registers[rn_dr] = 8'h00;
        #20ns;
        
        write_en = 1;
        waddr = 4'h0;
        data_in = 8'h22;
        full_instr = 9'h0d0;    // shl r0
        #10ns;
        if (data_outA != 8'h22)
            alert = 1;
        #10ns;
        alert = 0;
    end
    
    // Simulate clock
    always begin
        clk = 1;
        #10ns;
        clk = 0;
        #10ns;
    end      
endmodule

