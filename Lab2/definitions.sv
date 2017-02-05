//This file defines the parameters used in the alu
package definitions;
    
// Instruction map
    const logic [2:0] kADDL  = 'b000;
	const logic [2:0] kADDU  = 'b001;
    const logic [2:0] kLSAL  = 'b010;
	const logic [2:0] kLSAU  = 'b011;
    const logic [1:0]kAND  = 2'b10;
    const logic [1:0]kXOR  = 2'b11;
    
/*	const logic [4:0] opSetdr	=	'b00000;

	const logic [4:0] opAdd		=	'b00001;
	const logic [4:0] opAddc	=	'b00010;
	const logic [4:0] opSub		=	'b00011;

	const logic [4:0] opIncr	=	'b00100;
	const logic [4:0] opDecr	=	'b00101;
	
	const logic [4:0] opLoadImm	=	'b00110;
	const logic [4:0] opLoadReg	=	'b00111;
	const logic [4:0] opLoadReg	=	'b00111;
	*/

    typedef enum logic[1:0] {
        ADDU    = 2'h0, 
        SUBU    = 2'h1, 
        AND     = 2'h2,
        XOR     = 2'h3
    } op_mne;
    
endpackage // defintions
