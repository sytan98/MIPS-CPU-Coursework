module PC(
	input logic clk, reset;
	input logic [31:0] PC_curr;
	output logic [31:0] PC_next
);
always_ff @(posedge clk) begin
	if (reset) then begin
		PC_next <= 0;
	end
	else if begin
		PC_next <= PC_curr + 4;
	end
end
endmodule
