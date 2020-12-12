// lo register. stores the low-order 32 bits of 64-bit result of multiply instructions or 32-bit quotient of division instructions.

module reg_lo(
  input logic clk, reset, clk_enable,
  input logic lo_wren,                // from control.v, write enable signal for lo register
  input logic multdiv,                // from control.v, for multiply and divison instructions
  input logic[31:0] read_data_a,      // from register_file.v, data read from register rs. for mthi instruction
  input logic[31:0] lo,               // from alu.v. either the low-order 32-bit result of multiply instructions or 32-bit quotient of division instructions.
  output logic[31:0] lo_readdata      // output of the lo register. connected to register_file.v for mflo instruction.
);
  logic[31:0] lo_reg;
  assign lo_readdata = lo_reg;

  always_ff @(posedge clk) begin
    if(reset) begin
      lo_reg <= 0;                    // reset sets value of register to 0
    end
    else if ( (lo_wren == 1) & (clk_enable == 1) ) begin
      if (multdiv==1) begin
        lo_reg <= lo;                //mult, multu, div, divu
      end
      else begin
        lo_reg <= read_data_a;       //mtlo
      end
    end
  end

endmodule
