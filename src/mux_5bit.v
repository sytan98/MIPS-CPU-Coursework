module mux_5bit(
  input logic[4:0] in_0, in_1,
  input logic[1:0] select,
  output logic[4:0] out
);

  always @(*)begin
    case (select)
    0: out = in_0;
    1: out = in_1;
    2: out = 31;
    default: out = in_0;
    endcase
  end
endmodule
