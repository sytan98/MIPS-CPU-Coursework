module reg_lo(
  input logic clk, reset, clk_enable,
  input logic lo_wren, multdiv,
  input logic[31:0] read_data_a,
  input logic[31:0] lo,
  output logic[31:0] lo_readdata
);
  logic[31:0] lo_reg;
  assign lo_readdata = lo_reg;

  always_ff @(posedge clk) begin
    if(reset) begin
      lo_reg <= 0;
    end
    else if ( (lo_wren == 1) & (clk_enable == 1) ) begin
      if (multdiv==1) begin
        lo_reg <= lo; //mult, multu, div, divu
      end
      else begin
        lo_reg <= read_data_a; //mtlo
      end
    end
  end

endmodule
