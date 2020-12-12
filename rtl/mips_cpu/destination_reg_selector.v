// module to select the destination register to write into based on the type of instructions.

module destination_reg_selector(
  input logic[4:0]    read_reg_b,          // register rt, instruction[20:16]
  input logic[4:0]    rtype_rd,            // register rd, instruction[15:11]
  input logic[1:0]         rd_select,           // from control.v, select signal to select destination register
  output logic[4:0]   write_reg_rd
);

  always @(*) begin
    case (rd_select)
      0: write_reg_rd = read_reg_b;        // register rt for I-type instructions
      1: write_reg_rd = rtype_rd;          // register rd for R-type instructions
      2: write_reg_rd = 31;                // register 31 for JAL, BLTZAL, BGEZAL
      default: write_reg_rd = read_reg_b;
    endcase
  end
endmodule
