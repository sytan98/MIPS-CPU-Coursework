module instruction_memory(
	input logic clk;
	input logic[31:0] instr_address;
	output logic[31:0] instr_read;
);
	parameter ROM_INIT_FILE = "";

	logic[31:0] MEMORY[32h'FFFFFFFF:0];

	initial begin
		if (ROM_INIT_FILE != "") begin
			$readmemh(ROM_INIT_FILE, MEMORY, 32h'BFC00000, 32h'FFFFFFFF);
		end
	end

	always_ff @(posedge clk) begin
		instr_read <= MEMORY[instr_address];
	end
endmodule
