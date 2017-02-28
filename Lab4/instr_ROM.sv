// Create Date:    2017.01.25 
// Design Name: 
// Module Name:    InstROM 
// Description: Verilog module -- instruction ROM 	
//
module instr_ROM #(parameter A=8, W=9) (
    input       [A-1:0] instAddress,
    output logic[W-1:0] instrOut
);
	 
// need $readmemh or $readmemb to initialize all of the elements
// ^ Should be done in TopLevel_tbXX.sv
// declare ROM array
    logic[W-1:0] inst_rom[2**(A)];

// read from it
    always_comb instrOut = inst_rom[instAddress];

endmodule
