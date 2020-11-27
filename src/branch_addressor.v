//used to calculate branch target address.
module branch_addressor(
  input logic[31:0] immdt_32,
  input logic[31:0] pcnext,
  output logic[31:0] branch_addr
);

  logic[33:0] shifted;

  always@(*) begin
    shifted[33:0] = (immdt_32<<2);
    branch_addr = $signed(shifted[31:0]) + $signed(pcnext);
  end

endmodule
