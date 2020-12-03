module pc(
	input logic clk, reset,
	input logic [31:0] pcin,
	output logic [31:0] pcout
);
	// initial begin
	// 	assign pcout = 32'h00000000;
	// end
		
	always @(posedge clk) begin
		if (reset) begin
			$display("PC : INFO  : Resetting pc.");
			pcout <= 32'h00000020;
		end
		else begin
			pcout <= pcin;
		end
	end

endmodule
