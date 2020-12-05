module bus_memory(
	input logic clk,
	input logic[31:0] address,
	input logic write,
    input logic read,
    output logic waitrequest,
    input logic[31:0] writedata,
    input logic[3:0] byteenable,
    output logic[31:0] readdata
);
	// Memory (256 x 4 x 8-bit bytes) address is 32 bits (used only 10), word is 32 bits
	// Full memory supposed to be able to store 2^30 words but we reduce it to store 2^8 (256) words. 
	// 10 bits used for address as it is byte addressing.
	// parameter ROM_INIT_FILE = "";
	// parameter address_bit_size = 10; 
	// parameter reset_vector = 8; // this is word addressing, technically should be 0xbfc00000 

	// logic[address_bit_size - 1: 0] mapped_address;		

	// assign mapped_address = (instr_address != 0) ? instr_address[address_bit_size-1:0] - 32'hBFBFFFE0 : 0;

	// logic[7:0] bytes [0: (2**address_bit_size-1)];
	// assign instr_readdata = {bytes[mapped_address+3], bytes[mapped_address+2], bytes[mapped_address+1], bytes[mapped_address]};

	// initial begin
	// 	if (ROM_INIT_FILE != "") begin
	// 		$readmemh(ROM_INIT_FILE, bytes, reset_vector*4); // multiply by 4 to get byte addressing
	// 	end
	// end

	
endmodule