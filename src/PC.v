module PC(
	input logic clk, reset,
	input logic [31:0] PCcurr,
	output logic [31:0] PCnext
);

always_ff @(posedge clk) begin
	if (reset) begin
		PCnext <= 0;
	end
	else begin
		PCnext <= PCcurr + 4;
	end
end

endmodule
