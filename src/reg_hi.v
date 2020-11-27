module reg_hi(
  input clk;
  input logic hi_wren,
  input logic[31:0] read_data_a
  input logic[63:0] mult_div_out,
  output logic[31:0] hi_read
);

assign hi_read = reset==1 ? 0 : mult_div_out[63:32];

always_ff @(posedge clk) begin
  if(hi_wren==1) begin
    hi_read <= read_data_a;
  end
end

endmodule
