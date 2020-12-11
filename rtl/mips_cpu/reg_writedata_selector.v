//selects data to write into the destination register.
//usually selects alu_out. if it is a load instruction, selects data read from datamem to write into reg.
//if it is a link instruction (JAL, JALR, BGEZAL, BLTZAL), selects pc+4 to be written into the reg
//for mfhi and mflo, selects data read from hi or lo registers to be written into reg.
module reg_writedata_selector(
  input logic[31:0] alu_out, data_readdata, pc_plus4, hi_readdata, lo_readdata,
  input logic[2:0] datamem_to_reg,
  input logic[1:0] byte_addressing,
  input logic link_to_reg, mfhi, mflo,

  output logic[31:0] reg_write_data
);

  always @(*) begin
    // lw
    if (datamem_to_reg == 1) begin
      reg_write_data = data_readdata;
    end

    // lb
    else if (datamem_to_reg == 2) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = (data_readdata[7])? { 24'hFFFFFF, data_readdata[7:0]} : { 24'h000000, data_readdata[7:0]};
      end
      else if (byte_addressing == 2'b01) begin
        reg_write_data = (data_readdata[15])? { 24'hFFFFFF, data_readdata[15:8]} : { 24'h000000, data_readdata[15:8]};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = (data_readdata[23])? { 24'hFFFFFF, data_readdata[23:16]} : { 24'h000000, data_readdata[23:16]};
      end
      else if (byte_addressing == 2'b11) begin
        reg_write_data = (data_readdata[31])? { 24'hFFFFFF, data_readdata[31:24]} : { 24'h000000, data_readdata[31:24]};
      end
    end
    // lbu
    else if (datamem_to_reg == 3) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = { 24'h000000, data_readdata[7:0]};
      end
      else if (byte_addressing == 2'b01) begin
        reg_write_data = { 24'h000000, data_readdata[15:8]};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = { 24'h000000, data_readdata[23:16]};
      end
      else if (byte_addressing == 2'b11) begin
        reg_write_data = { 24'h000000, data_readdata[31:24]};
      end
    end

    // lh
    else if (datamem_to_reg == 4) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = (data_readdata[15])? { 16'hFFFF, data_readdata[15:0]} : { 16'h0000, data_readdata[15:0]};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = (data_readdata[31])? { 16'hFFFF, data_readdata[31:16]} : { 16'h0000, data_readdata[31:16]};
      end
    end
    // lhu
    else if (datamem_to_reg == 5) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = { 16'h0000, data_readdata[15:0]};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = { 16'h0000, data_readdata[31:16]};
      end
    end

    //jal, jalr, bgezal, bltzal
    else if (link_to_reg) begin
      reg_write_data = pc_plus4 + 4;
    end

    //mfhi and mflo
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
