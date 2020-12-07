module mux5_tb();
  logic[4:0] a,b, out;
  logic sel;

  initial begin
    a = 5'd0;
    b = 5'd1;
    sel = 0;
    #1;
    $display("output=%d", out);
    assert(out == 5'd0);

    a = 5'd30;
    b = 5'd5;
    sel = 0;
    #1;
    $display("output=%d", out);
    assert(out == 5'd30);

    a = 5'd2;
    b = 5'd31;
    sel = 1;
    #1;
    $display("output=%d", out);
    assert(out == 5'd31);
  end

  mux_5bit inst0(.in_0(a), .in_1(b), .out(out), .select(sel));

endmodule
