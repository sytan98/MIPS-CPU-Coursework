module instruction_memory(
	input logic clk,
	input logic[31:0] instr_address,
	output logic[31:0] instr_readdata
	// output logic clk_enable
);
	parameter ROM_INIT_FILE = "";
	parameter bit_size = 32;
	parameter mem_size = 16; //1073741824 
	parameter reset_vector = 8;

	logic[bit_size - 1:0] MEMORY[0: 2**mem_size - 1];
	// logic[31: 0] MEMORY[0: 1073741824];
	assign instr_readdata = MEMORY[instr_address[mem_size+1:2]];
	
	initial begin
		if (ROM_INIT_FILE != "") begin
			$readmemh(ROM_INIT_FILE, MEMORY, reset_vector/4);
		end
	end

	
	// always_ff @(posedge clk) begin
	// 	instr_readdata <= MEMORY[instr_address[mem_size+1:2]];
	// end
endmodule
