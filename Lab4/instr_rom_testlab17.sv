// sample instruction ROM
// 9-bit microcode
// 8192 elements
//   resize as needed for your project
// this is about as simple as it gets
module instr_rom(
  input [12:0] PC,
  output[ 8:0] instr);

logic[8:0] core[2**12];

// load from external file -- recommended for large
//   arrays
initial 
  $readmemb("machine_code.txt",core);

// operation -- simply point-and-read
assign instr = core[PC];

endmodule