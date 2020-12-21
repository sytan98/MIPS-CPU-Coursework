module reg_writedata_selector_tb();
  logic[31:0] alu_out, data_readdata, pc_plus4, hi_readdata, lo_readdata;
  logic[2:0] datamem_to_reg;
  logic[1:0] byte_addressing;
  logic link_to_reg, mfhi, mflo;
  logic[31:0] reg_write_data;

  initial begin
    alu_out = 32'hABCD1234;
    data_readdata = 32'h876543F1;
    pc_plus4 = 32'hBFC0000C;
    hi_readdata = 32'h10001000;
    lo_readdata = 32'h00010001;

    // LW
    datamem_to_reg = 1;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h876543F1);
    #1;

    // LB
    datamem_to_reg = 2;
    byte_addressing = 2'b00;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'hFFFFFFF1);
    #1;
    byte_addressing = 2'b01;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00000043);
    #1;
    byte_addressing = 2'b10;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00000065);
    #1;
    byte_addressing = 2'b11;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'hFFFFFF87);
    #1;
    // LBU
    datamem_to_reg = 3;
    byte_addressing = 2'b00;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h000000F1);
    #1;
    byte_addressing = 2'b01;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00000043);
    #1;
    byte_addressing = 2'b10;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00000065);
    #1;
    byte_addressing = 2'b11;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00000087);
    #1;

    // LH
    datamem_to_reg = 4;
    byte_addressing = 2'b00;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h000043F1);
    #1;
    byte_addressing = 2'b10;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'hFFFF8765);
    #1;
    // LHU
    datamem_to_reg = 5;
    byte_addressing = 2'b00;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h000043F1);
    #1;
    byte_addressing = 2'b10;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00008765);
    #1;

    datamem_to_reg = 0;
    link_to_reg = 1;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'hBFC00010);
    #1;
    link_to_reg = 0;

    mfhi = 1;
    mflo = 0;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h10001000);
    #1;
    mfhi = 0;
    mflo = 1;
    #1;
    // $display("reg_write_data=%h", reg_write_data);
    assert(reg_write_data == 32'h00010001);


    $display("Finished. Total time = %t", $time);
    $finish;
  end

  reg_writedata_selector dut(
    .alu_out(alu_out),
    .data_readdata(data_readdata),
    .pc_plus4(pc_plus4),
    .hi_readdata(hi_readdata), .lo_readdata(lo_readdata),
    .datamem_to_reg(datamem_to_reg), .byte_addressing(byte_addressing),
    .link_to_reg(link_to_reg), .mfhi(mfhi), .mflo(mflo),
    .reg_write_data(reg_write_data)
  );
endmodule
