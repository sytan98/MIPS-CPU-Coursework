module reg_hi(
  input clk,
  input reset,
  input logic hi_wren,
  input logic[31:0] read_data_a,
  input logic[31:0] hi,
  output logic[31:0] hi_read
);

always_ff @(posedge clk) begin
  if(hi_wren==1) begin
    hi_read <= read_data_a;
  end
  else begin
    hi_read <= hi;
  end
end

endmodule
