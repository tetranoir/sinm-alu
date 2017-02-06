//This file defines the parameters used in the alu
package definitions;

// Instruction map
	const logic [4:0] opSetdr	=	'b00000;
    
	const logic [4:0] opAdd		=	'b00001;
	const logic [4:0] opAddc	=	'b00010;
	const logic [4:0] opSub		=	'b00011;

	const logic [4:0] opIncr	=	'b00100;
	const logic [4:0] opDecr	=	'b00101;
	
	const logic [4:0] opLoadImm	=	'b00110;
	const logic [4:0] opLoadReg	=	'b00111;
	const logic [4:0] opStoreImm	=	'b01000;
	const logic [4:0] opStoreReg	=	'b01001;
	
	const logic [4:0] opMovImm	=	'b01010;
	const logic [4:0] opMovReg	=	'b01011;
	
	const logic [4:0] opClr		=	'b01100;
	
	const logic [4:0] opShl		=	'b01101;
	const logic [4:0] opShr		=	'b01110;
	const logic [4:0] opSar		=	'b01111;
	
	const logic [4:0] opRcr		=	'b10000;
	const logic [4:0] opRcl		=	'b10001;
	
	const logic [4:0] opAnd		=	'b10010;
	const logic [4:0] opXor		=	'b10011;
	
	const logic [4:0] opCmpImm	=	'b10100;
	const logic [4:0] opCmpReg =	'b10101;
	
	const logic [4:0] opJmp		=	'b10110;
	const logic [4:0] opJz		=	'b10111;
	const logic [4:0] opJfnz	=	'b11000;
	const logic [4:0] opJnz		=	'b11001;
	
	const logic [4:0] opClfb	=	'b11010;
	const logic [4:0] opMax		=	'b11011;
	const logic [4:0] opTBA		=	'b11100;
	
	const logic [8:0] opCkfr	=	'b111111110;
	const logic [8:0] opHalt	=	'b111111111;
    
    const logic [3:0] rn_dr         =   4'hc;
    const logic [3:0] rn_addrbase   =   4'hd;
    const logic [3:0] rn_jumpbase   =   4'he;

	// Not sure what these do. Figure out later.
	typedef enum logic[1:0] {
	    ADDU    = 2'h0, 
	    SUBU    = 2'h1, 
	    AND     = 2'h2,
	    XOR     = 2'h3
	} op_mne;
 
endpackage // defintions
