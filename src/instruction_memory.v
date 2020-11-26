module instruction_memory(
	input logic clk;
	input logic[31:0] instr_address;
	output logic[31:0] instr_read;
);
	parameter ROM_INIT_FILE = "";

	reg[31:0] MEMORY[32h'FFFFFFFF:0];

	initial begin
		integer i;
		for (i=0; i<32h'FFFFFFFF; i++) begin
			MEMORY[i]=0;
		end
		if (ROM_INIT_FILE != "") begin
			$readmemh(ROM_INIT_FILE, MEMORY, 32h'BFC00000, 32h'FFFFFFFF);
		end

	always_ff @(posedge clk) begin
		instr_read <= MEMORY[instr_address];
	end
endmodule
