module reg_hi(
  input logic clk, reset, clk_enable,
  input logic hi_wren,
  input logic[31:0] read_data_a,
  input logic[31:0] hi,
  output logic[31:0] hi_readdata
);

  always_ff @(posedge clk) begin
    if(reset) begin
      hi_readdata <= 0;
    end
    else if(hi_wren == 1 & clk_enable == 1) begin
      hi_readdata <= read_data_a;
    end
    else begin
      hi_readdata <= hi;
    end
  end

endmodule
