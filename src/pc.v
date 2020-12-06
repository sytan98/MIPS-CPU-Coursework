module pc(
  input logic clk, reset,
	input logic [31:0] pcin,
	output logic [31:0] pcout
);
  initial begin
    pcout <= 32'h00000000;
  end

  always_ff @(posedge clk) begin
	 if (reset) begin
		 pcout <= 32'hBFC00000;
	 end
	 else begin
		 pcout <= pcin;
	 end
  end

endmodule
