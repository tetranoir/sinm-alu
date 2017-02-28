// Engineer:        Huajie Wu
// 
// Create Date:     02/05/2017 
// Design Name: 
// Module Name:     reg_file 
// Project Name:    Lab2
// Target Devices:  Cyclone IV E: EP4CE40F29C6	
// Tool versions: 
// Description: 
//
// Dependencies:    definitions.sv
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:

import definitions::*;			  // includes package "definitions"
module reg_file(
  input        clk,
               write_en,
  input  [3:0] oprnd,
               waddr,
  input  [4:0] instr,
  input  [7:0] data_in,
  output logic [7:0] data_outA,
  output logic [7:0] data_outB,
  output logic [7:0] data_outAddrBase,
  output logic [3:0] dr_code,
  output logic halt
    );

logic [7:0] registers[2**4];

// Reg file writing.
always_ff @ (posedge clk)
  if (write_en)
    registers[waddr] <= data_in;

always_comb begin
    // There are four output lines for the reg file,
    // data_outA    : the data from the register indicated by r12.
    // data_outB    : either the data from register indicated by lower 4 bits
    //                of the instruction (R instructions), or the raw value
    //                of the lower 4 bits of the instruction (I instructions)
    // data_outAddrBase : Should a jump or a memory R/W instruction is decoded,
    //                    the value of r14 or r13, correspondingly, will go to
    //                    this line.
    // dr_code      : the code indicating which register to write back. Default
    //                to the register indicated by r12.
    data_outA   = registers[registers[rn_dr]];
    data_outB   = oprnd;
    data_outAddrBase = 0;
    dr_code     = registers[rn_dr][3:0];
    halt = 0;
    case(instr)
        // I instruction, ask to write back to r12
        opSetdr : begin
            dr_code = rn_dr;
        end
        
        // R instructions
        opAdd, opAddc, opSub    : data_outB = registers[oprnd];
        
        // R instructions, write back to source.
        opIncr, opDecr  : begin
            data_outB = registers[oprnd];
            dr_code = oprnd;
        end
        
        // I instructions, memory ops.
        opLoadImm, opStoreImm   : begin
            data_outB = oprnd;
            data_outAddrBase = registers[rn_addrbase];
        end
        opLoadReg, opStoreReg   : begin
            data_outB = registers[oprnd];
        end

        // Move instructions, two versions.
        opMovImm    : begin
            data_outB = oprnd;
        end
        opMovReg    : begin
            data_outB = registers[oprnd];
        end
        
        // Clear done by ALU, write back to source
        opClr   : begin
            dr_code = oprnd;
        end
        
        // opShl, opShr, opSar goes to default
        
        // R instructions, write back to source
        opRcr, opRcl    : begin
            data_outB = registers[oprnd];
            dr_code = oprnd;
        end
        
        opAnd, opXor    : data_outB = registers[oprnd];
        
        opCmpImm    : data_outB = oprnd;
        opCmpReg    : data_outB = registers[oprnd];
        
        // I instructions, jump ops.
        opJmp, opJz, opJfnz, opJnz  : begin
            data_outB = oprnd;
            data_outAddrBase = registers[rn_jumpbase];
        end
        
        opClfb, opMax   : begin
            data_outB = registers[oprnd];
        end
        
        opCkfr  : begin
            data_outA = registers[4] | registers[5];
            data_outB = registers[6] | registers[7];
        end
        // HALT. Simply send halt signal.
        // RELY ON ALU DEFAULT TO BE NOT WRITE TO REG
        opHalt  : begin
            halt = 1;
        end
        
        default : begin
        end
        
        
    endcase
end

endmodule
