module sign_extender(
  input logic[15:0] immdt_16,
  output logic [31:0] immdt_32
);

  always @(*) begin
    integer i;
    for(i=16; i<=31; i++) begin
      immdt_32[i] = immdt_16[15];
    end
    immdt_32[15:0] = immdt_16[15:0];
  end

endmodule
