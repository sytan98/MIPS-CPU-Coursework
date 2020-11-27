module reg_lo(
  input clk;
  input logic lo_wren,
  input logic[31:0] read_data_a
  input logic[63:0] mult_div_out,
  output logic[31:0] lo_read
);

assign lo_read = reset==1 ? 0 : mult_div_out[31:0];

always_ff @(posedge clk) begin
  if(lo_wren==1) begin
    lo_read <= read_data_a;
  end
end

endmodule
