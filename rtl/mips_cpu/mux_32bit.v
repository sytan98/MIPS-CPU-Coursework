module mux_32bit(
  input logic[31:0] in_0, in_1,
  input logic select,
  output logic[31:0] out
);

  always @(*)begin
    if(select) begin
      out = in_1;
    end
    else if(!select)begin
      out = in_0;
    end
  end
endmodule
