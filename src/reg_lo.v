module reg_lo(
  input logic clk, reset, clk_enable,
  input logic lo_wren,
  input logic[31:0] read_data_a,
  input logic[31:0] lo,
  output logic[31:0] lo_readdata
);

  always_ff @(posedge clk) begin
    if(reset) begin
      lo_readdata <= 0;
    end
    else if(lo_wren == 1 & clk_enable == 1) begin
      lo_readdata <= read_data_a;
    end
    else begin
      lo_readdata <= lo;
    end
  end

endmodule
