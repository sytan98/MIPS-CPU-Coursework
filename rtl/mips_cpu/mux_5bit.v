// 2-input mux of width 5 bits.
// used to select the destination register: either register rt instruction[20:16] for I-type instructions or register rd instruction[15:11] for R-type instructions
// select signal is rd_select from control.v
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
