// program counter module. if reset is high, reset PC to the reset vector of 0xBFC00000.
// otherwise, if clk_enable is high, at every positive edge of the clk, pcout will take in the value of pcin.
// pcin could either be PC+4, or tgt_addr_1
module pc(
	input logic clk, reset, clk_enable,
	input logic [31:0] pcin,
	output logic [31:0] pcout
);
	always @(posedge clk) begin
		if (reset == 1) begin
			$display("PC : INFO  : Resetting pc.");
			pcout <= 32'hBFC00000;
		end
		else if (clk_enable == 1) begin
			pcout <= pcin;
		end
	end

endmodule
