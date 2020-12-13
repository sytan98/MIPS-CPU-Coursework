module jump_addressor_tb();
  logic[25:0] imdt;
  logic[3:0] msb;
  logic[31:0] j_addr;

  initial begin
    imdt = 26'b11001100000100011100000001;
    msb = 4'b0001;
    #1;
    $display("output=%b", j_addr);
    assert(j_addr == 32'b00011100110000010001110000000100);

    imdt = 26'b00001100000000000000000000;
    msb = 4'b1000;
    #1;
    $display("output=%b", j_addr);
    assert(j_addr == 32'b10000000110000000000000000000000);

    imdt = 26'b00001100000000110000110000;
    msb = 4'b0000;
    #1;
    $display("output=%b", j_addr);
    assert(j_addr == 32'b00000000110000000011000011000000);

  end

  jump_addressor inst0(.j_immdt(imdt), .pc_4msb(msb), .jump_addr(j_addr));

endmodule
