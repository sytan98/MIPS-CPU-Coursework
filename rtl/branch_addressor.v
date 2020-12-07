//used to calculate branch target address.
module branch_addressor(
  input logic[31:0] immdt_32,
  input logic[31:0] PCnext,
  output logic[31:0] branch_addr
);

  always@(*) begin
    branch_addr = $signed(immdt_32 << 2) + $signed(PCnext);
  end

endmodule
