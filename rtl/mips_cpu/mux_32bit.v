// 2-input mux of width 32 bits.
// imdtmux to choose between sign-extended or zero-extended immediate, select signal imdt_sel from control.v
// alumux to choose between read_data_b for R-type instructions or immediate for I-type instructions, select signal alu_src from control.v
// pcmux to choose between PC+4 or tgt_addr_1 for delay slot, select signal is delay in mips_cpu_bus.v
// addressmux to choose between pcout or data_address, select signal is address_sel in mips_cpu_bus.v for MEM state.

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
