module pc_adder(
  input logic[31:0] pcout,
  output logic[31:0] pc_plus4
);
  always_comb begin
    pc_plus4 = pcout + 4;
  end
endmodule
