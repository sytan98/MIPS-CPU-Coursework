module pc_adder_tb();
  logic[31:0] pcout, pc_plus4;

  initial begin
    pcout = 0;
    #1;
    // $display("input=%d, output=%d", pcout, pc_plus4);
    assert(pc_plus4 == 4);

    pcout = 4;
    #1;
    // $display("input=%d, output=%d", pcout, pc_plus4);
    assert(pc_plus4 == 8);

    pcout = 8;
    #1;
    // $display("input=%d, output=%d", pcout, pc_plus4);
    assert(pc_plus4 == 12);
    
    $display("Finished. Total time = %t", $time);
    $finish;
  end

  pc_adder pcadder_inst(
    .pcout(pcout), .pc_plus4(pc_plus4)
  );
endmodule
