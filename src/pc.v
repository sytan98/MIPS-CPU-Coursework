module pc(
	input logic clk, reset, clk_enable,
	input logic [31:0] pcin,
	output logic [31:0] pcout
);
	// initial begin
	// 	assign pcout = 32'h00000000;
	// end

	always @(posedge clk) begin
		if (reset == 1) begin
			$display("PC : INFO  : Resetting pc.");
			pcout <= 32'h00000008;
		end
		else if (clk_enable == 1) begin
			pcout <= pcin;
		end
	end

endmodule
