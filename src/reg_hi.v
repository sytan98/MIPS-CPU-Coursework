module reg_hi(
  input logic clk, reset, clk_enable,
  input logic hi_wren, multdiv,
  input logic[31:0] read_data_a,
  input logic[31:0] hi,
  output logic[31:0] hi_readdata
);
  logic[31:0] hi_reg;
  assign hi_readdata = hi_reg;

  always_ff @(posedge clk) begin
    if(reset) begin
      hi_reg <= 0;
    end
    else if ( (hi_wren == 1) & (clk_enable == 1) ) begin
      if (multdiv==1) begin
        hi_reg <= hi; //mult, multu, div, divu
      end
      else begin
        hi_reg <= read_data_a; //mtlo
      end
    end
  end

endmodule
