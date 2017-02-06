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
  output logic [3:0] dr_code
    );

logic [7:0] registers[2**4];

// sequential (clocked) writes
always_ff @ (posedge clk)
  if (write_en)
    registers[waddr] <= data_in;

always_comb begin
    data_outA   = registers[registers[rn_dr]];
    data_outB   = oprnd;
    data_outAddrBase = 0;
    dr_code     = registers[rn_dr];
    case(instr)
        opSetdr : begin
            dr_code = rn_dr;
        end
        
        opAdd, opAddc, opSub    : data_outB = registers[oprnd];
        
        opIncr, opDecr  : begin
            data_outB = registers[oprnd];
            dr_code = oprnd;
        end
        
        opLoadImm, opStoreImm   : begin
            data_outB = oprnd;
            data_outAddrBase = registers[rn_addrbase];
        end
        opLoadReg, opStoreReg   : begin
            data_outB = registers[oprnd];
        end
 
        opMovImm    : begin
            data_outB = oprnd;
        end
        opMovReg    : begin
            data_outB = registers[oprnd];
        end
        
        opClr   : begin
            dr_code = oprnd;
        end
        
        // opShl, opShr, opSar goes to default
        
        opRcr, opRcl    : begin
            data_outB = registers[oprnd];
            dr_code = oprnd;
        end
        
        opAnd, opXor    : data_outB = registers[oprnd];
        
        opCmpImm    : data_outB = oprnd;
        opCmpReg    : data_outB = registers[oprnd];
        
        opJmp, opJz, opJfnz, opJnz  : begin
            data_outB = oprnd;
            data_outAddrBase = registers[rn_jumpbase];
        end
        
        opClfb, opMax   : begin
            data_outB = registers[oprnd];
        end
        
        'b11111 : begin
            case({instr, oprnd})
                opCkfr  : begin
                    data_outA = registers[4] | registers[5];
                    data_outB = registers[6] | registers[7];
                end
                default : begin
                    data_outA = 0;
                    data_outB = 0;
                    data_outAddrBase = 0;
                    dr_code = 0;
                end
            endcase
        end
        
        default : begin
        end
        
        
    endcase
end

endmodule
