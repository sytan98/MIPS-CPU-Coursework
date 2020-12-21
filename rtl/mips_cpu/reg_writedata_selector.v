// selects data to write into the destination register based on the different control signals.

module reg_writedata_selector(
  // data to write into destination register
  input logic[31:0] alu_out,                  // output of alu from alu.v
  input logic[31:0] data_readdata,            // data read from memory for load instructions.
  input logic[31:0] pc_plus4,                 // PC+4 from pc_adder.v. will add 4 to this to be PC+8 for link instructions.
  input logic[31:0] hi_readdata, lo_readdata, // data read from hi and lo registers for mfhi and mflo instructions

  // control signals
  input logic[2:0] datamem_to_reg,            // from control.v, for load instructions (lw, lb, lbu, lh, lhu)
  input logic[1:0] byte_addressing,           // last 2 LSB of data address to tell us which byte/halfword in the full word from the data memory to write into the destination register.
  input logic link_to_reg,                    // from control.v, for link instructions (JAL, JALR, BGEZAL, BLTZAL)
  input logic mfhi, mflo,                     // from control.v, for mfhi and mflo instructions respectively

  output logic[31:0] reg_write_data           // data to write into destination register. connceted to register_file.v
);
  logic data_readdata_7;
  logic data_readdata_15;
  logic data_readdata_23;
  logic data_readdata_31;
  logic [7:0] data_readdata_7_0;
  logic [7:0] data_readdata_15_8;
  logic [7:0] data_readdata_23_16;
  logic [7:0] data_readdata_31_24;
  logic [15:0] data_readdata_15_0;
  logic [15:0] data_readdata_31_16;
  assign data_readdata_7= data_readdata[7];
  assign data_readdata_15= data_readdata[15];
  assign data_readdata_23= data_readdata[23];
  assign data_readdata_31= data_readdata[31];
  assign data_readdata_7_0 = data_readdata[7:0];
  assign data_readdata_15_8 = data_readdata[15:8];
  assign data_readdata_23_16 = data_readdata[23:16];
  assign data_readdata_31_24 = data_readdata[31:24];
  assign data_readdata_15_0 = data_readdata[15:0];
  assign data_readdata_31_16 = data_readdata[31:16];

  always_comb begin
    // lw: load a word from memory into destination register.
    if (datamem_to_reg == 1) begin
      reg_write_data = data_readdata;
    end

    // lb: byte is sign-extended. byte_addressing tells us which byte in the full word of data_readdata to load into destination register.
    else if (datamem_to_reg == 2) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = (data_readdata_7)? { 24'hFFFFFF, data_readdata_7_0} : { 24'h000000, data_readdata_7_0};
      end
      else if (byte_addressing == 2'b01) begin
        reg_write_data = (data_readdata_15)? { 24'hFFFFFF, data_readdata_15_8} : { 24'h000000, data_readdata_15_8};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = (data_readdata_23)? { 24'hFFFFFF, data_readdata_23_16} : { 24'h000000, data_readdata_23_16};
      end
      else if (byte_addressing == 2'b11) begin
        reg_write_data = (data_readdata_31)? { 24'hFFFFFF, data_readdata_31_24} : { 24'h000000, data_readdata_31_24};
      end
      else begin
        reg_write_data = data_readdata;
      end
    end
    // lbu: byte is zero-extended. byte_addressing tells us which byte in the full word of data_readdata to load into destination register.
    else if (datamem_to_reg == 3) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = { 24'h000000, data_readdata_7_0};
      end
      else if (byte_addressing == 2'b01) begin
        reg_write_data = { 24'h000000, data_readdata_15_8};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = { 24'h000000, data_readdata_23_16};
      end
      else if (byte_addressing == 2'b11) begin
        reg_write_data = { 24'h000000, data_readdata_31_24};
      end
      else begin
        reg_write_data = data_readdata;
      end
    end

    // lh: halfword is sign-extended. byte_addressing tells us which halfword in the full word of data_readdata to load into destination register.
    else if (datamem_to_reg == 4) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = (data_readdata_15)? { 16'hFFFF, data_readdata_15_0} : { 16'h0000, data_readdata_15_0};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = (data_readdata_31)? { 16'hFFFF, data_readdata_31_16} : { 16'h0000, data_readdata_31_16};
      end
      else begin
        reg_write_data = data_readdata;
      end
    end
    // lhu: halfword is zero-extended. byte_addressing tells us which halfword in the full word of data_readdata to load into destination register.
    else if (datamem_to_reg == 5) begin
      if (byte_addressing == 2'b00) begin
        reg_write_data = { 16'h0000, data_readdata_15_0};
      end
      else if (byte_addressing == 2'b10) begin
        reg_write_data = { 16'h0000, data_readdata_31_16};
      end
      else begin
        reg_write_data = data_readdata;
      end
    end

    // link instructions: jal, jalr, bgezal, bltzal. write PC+8 into destination register.
    else if (link_to_reg) begin
      reg_write_data = pc_plus4 + 4;
    end

    // mfhi and mflo: move values stored in hi or lo registers into one of the 32 registers in register_file
    else if (mfhi == 1) begin
      reg_write_data = hi_readdata;
    end
    else if (mflo == 1) begin
      reg_write_data = lo_readdata;
    end

    // update destination register with value of alu_out
    else begin
      reg_write_data = alu_out;
    end
  end
endmodule
