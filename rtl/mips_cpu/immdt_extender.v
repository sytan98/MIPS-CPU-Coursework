// sign extends and zero extends the 16-bit immediate in i-type instructions to 32 bits.
// the two outputs will be connected to a mux (imdtmux) and control signal imdt_sel from control.v
// will select between either the sign extended immediate or the zero extended immediate (for XORI, ANDI, ORI).
module immdt_extender(
  input logic[15:0] immdt_16,
  output logic [31:0] sign_immdt_32,
  output logic [31:0] zero_immdt_32
);
  logic msb;
  assign msb = immdt_16[15];
  always_comb begin
    sign_immdt_32 = (msb==1) ? {16'hFFFF, immdt_16[15:0]} : {16'h0000, immdt_16[15:0]};
    zero_immdt_32 = {16'h0000, immdt_16[15:0]};
  end

endmodule
