// hi register. stores the high-order 32 bits of 64-bit result of multiply instructions or 32-bit remainder of division instructions.

module reg_hi(
  input logic clk, reset, clk_enable,
  input logic hi_wren,                // from control.v, write enable signal for hi register
  input logic multdiv,                // from control.v, for multiply and divison instructions
  input logic[31:0] read_data_a,      // from register_file.v, data read from register rs. for mthi instruction
  input logic[31:0] hi,               // from alu.v. either the high-order 32-bit result of multiply instructions or 32-bit remainder of division instructions.
  output logic[31:0] hi_readdata      // output of the hi register. connected to register_file.v for mfhi instruction.
);
  logic[31:0] hi_reg;
  assign hi_readdata = hi_reg;

  always_ff @(posedge clk) begin
    if(reset) begin                   // reset sets value of register to 0
      hi_reg <= 0;
    end
    else if ( (hi_wren == 1) & (clk_enable == 1) ) begin
      if (multdiv==1) begin
        hi_reg <= hi;                //mult, multu, div, divu
      end
      else begin
        hi_reg <= read_data_a;       //mthi
      end
    end
  end

endmodule
