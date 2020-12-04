//selects data to write into the destination register.
//usually selects alu_out. if it is a load instruction, selects data read from datamem to write into reg.
//if it is a link instruction (JAL, JALR, BGEZAL, BLTZAL), selects pc+4 to be written into the reg
//for mfhi and mflo, selects data read from hi or lo registers to be written into reg.
module reg_writedata_selector(
  input logic[31:0] alu_out, data_readdata, pc_plus4, hi_readdata, lo_readdata,
  input logic datamem_to_reg, link_to_reg, mfhi, mflo,

  output logic[31:0] reg_write_data
);

  always @(*) begin
    if (datamem_to_reg) begin
      reg_write_data = data_readdata;
    end
    else if (link_to_reg) begin
      reg_write_data = pc_plus4;
    end
    else if (mfhi) begin
      reg_write_data = hi_readdata;
    end
    else if (mflo) begin
      reg_write_data = lo_readdata;
    end
    else begin
      reg_write_data = alu_out;
    end
  end
endmodule
