module immdt_extender_tb();
  logic[15:0] imdt;
  logic[31:0] sign_extd;
  logic[31:0] zero_extd;

  initial begin
    imdt = 16'h0001;
    #1;
    // $display("input=%b, sign=%b, zero=%b", imdt, sign_extd, zero_extd);
    assert(sign_extd == 32'h00000001);
    assert(zero_extd == 32'h00000001);

    imdt = 16'h8001;
    #1;
    // $display("input=%b, sign=%b, zero=%b", imdt, sign_extd, zero_extd);
    assert(sign_extd == 32'hffff8001);
    assert(zero_extd == 32'h00008001);
    $display("Finished. Total time = %t", $time);
    $finish;
  end

  immdt_extender dut(.immdt_16(imdt), .sign_immdt_32(sign_extd), .zero_immdt_32(zero_extd));

endmodule
