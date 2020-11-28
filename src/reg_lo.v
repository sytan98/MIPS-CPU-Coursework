module reg_lo(
  input clk,
  input reset,
  input logic lo_wren,
  input logic[31:0] read_data_a,
  input logic[31:0] lo,
  output logic[31:0] lo_read
);

  always_ff @(posedge clk) begin
    if(reset) begin
      lo_read <= 0;
    end
    else if(lo_wren) begin
      lo_read <= read_data_a;
    end
    else begin
      lo_read <= lo;
    end
  end

endmodule
