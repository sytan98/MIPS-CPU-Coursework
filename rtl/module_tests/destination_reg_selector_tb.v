module destination_reg_selector_tb();
  logic[4:0]    read_reg_b;
  logic[4:0]    rtype_rd;
  logic[1:0]    rd_select;
  logic[4:0]    write_reg_rd;

  initial begin
    read_reg_b = 5;
    rtype_rd = 6;

    rd_select = 0;
    #1;
    assert (write_reg_rd == read_reg_b);
    #1;

    rd_select = 1;
    #1;
    assert (write_reg_rd == rtype_rd);
    #1;

    rd_select = 2;
    #1;
    assert (write_reg_rd == 5'd31);

    $display("Finished. Total time = %t", $time);
    $finish;
  end

  destination_reg_selector dut (
    .read_reg_b(read_reg_b), .rtype_rd(rtype_rd), .rd_select(rd_select),
    .write_reg_rd(write_reg_rd)
  );
endmodule
