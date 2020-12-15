module writedata_selector_tb();
  logic[31:0] read_data_b;
  logic [2:0] write_data_sel;
  logic [31:0] writedata;

  initial begin
    read_data_b = 32'h87654321;

    write_data_sel = 0;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h87654321);
    #1;

    write_data_sel = 1;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h00000021);
    #1;

    write_data_sel = 2;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h00002100);
    #1;

    write_data_sel = 3;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h00210000);
    #1;

    write_data_sel = 4;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h21000000);
    #1;

    write_data_sel = 5;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h00004321);
    #1;

    write_data_sel = 6;
    #1;
    // $display("writedata =%h", writedata);
    assert (writedata == 32'h43210000);
    #1;

    $display("Finished. Total time = %t", $time);
    $finish;
  end

  writedata_selector dut(
    .read_data_b(read_data_b), .write_data_sel(write_data_sel),
    .writedata(writedata)
  );
endmodule
