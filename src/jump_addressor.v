module jump_addressor(
  input logic[25:0] j_immdt,
  input logic[3:0] pc_4msb,
  output logic[31:0] jump_addr
);

  logic[27:0] shifted;

  always@(*) begin
    shifted[27:0] = j_immdt<<2;
    jump_addr[31:28] = pc_4msb;
    jump_addr[27:0] = shifted;
  end

endmodule
