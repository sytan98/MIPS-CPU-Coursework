module immdt_extender(
  input logic[15:0] immdt_16,
  output logic [31:0] sign_immdt_32,
  output logic [31:0] zero_immdt_32
);

  always@(*) begin
    if (immdt_16[15]==1) begin
      sign_immdt_32[31:16] = 16'hFFFF;
    end
    else if(immdt_16[15]==0) begin
      sign_immdt_32[31:16] = 16'h0000;
    end
    sign_immdt_32[15:0] = immdt_16[15:0];

    zero_immdt_32[31:16] = 16'h0000;
    zero_immdt_32[15:0] = immdt_16[15:0];
  end

endmodule
