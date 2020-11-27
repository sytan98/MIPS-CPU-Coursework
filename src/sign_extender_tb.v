module sign_extender_tb();
  logic[15:0] imdt;
  logic[31:0] extd;

  initial begin
    imdt = 16'h0001;
    #1;
    $display("input=%b, output=%b", imdt, extd);
    assert(extd == 32'h00000001);

    imdt = 16'h8001;
    #1;
    $display("input=%b, output=%b", imdt, extd);
    assert(extd == 32'hffff8001);
  end

  sign_extender inst0(.immdt_16(imdt), .immdt_32(extd));

endmodule
