module target_addr_holder(
  input logic clk,
  input logic[31:0] tgt_addr_0,

  output logic[31:0] tgt_addr_1
);

  always @(posedge clk) begin
    tgt_addr_1 <= tgt_addr_0;
  end
endmodule
