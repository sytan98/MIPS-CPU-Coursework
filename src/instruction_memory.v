module instruction_memory(
	input logic clk,
	input logic[31:0] instr_address,
	output logic[31:0] instr_readdata
);
	parameter ROM_INIT_FILE = "";

	logic[31:0] MEMORY[32'hFFFFFFFF:0];

	initial begin
		if (ROM_INIT_FILE != "") begin
			$readmemh(ROM_INIT_FILE, MEMORY, 32'hBFC00000, 32'hFFFFFFFF);
		end
	end

	always_ff @(posedge clk) begin
		instr_readdata <= MEMORY[instr_address];
	end
endmodule