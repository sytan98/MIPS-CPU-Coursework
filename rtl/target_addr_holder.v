module target_addr_holder(
  input logic clk,
  input logic[31:0] tgt_addr_0,
  input logic clk_enable,

  output logic[31:0] tgt_addr_1
);

  always @(posedge clk) begin
    if (clk_enable == 1) begin
      tgt_addr_1 <= tgt_addr_0;
    end
  end
endmodule