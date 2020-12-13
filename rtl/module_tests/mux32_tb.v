module mux32_tb();
  logic[31:0] a,b, out;
  logic sel;

  initial begin
    a = 32'd4;
    b = 32'd100;
    sel = 0;
    #1;
    $display("output=%d", out);
    assert(out == 32'd4);

    a = 32'd10;
    b = 32'd110;
    sel = 0;
    #1;
    $display("output=%d", out);
    assert(out == 32'd10);

    a = 32'd23210;
    b = 32'd17878710;
    sel = 1;
    #1;
    $display("output=%d", out);
    assert(out == 32'd17878710);
  end

  mux_32bit inst0(.in_0(a), .in_1(b), .out(out), .select(sel));

endmodule
