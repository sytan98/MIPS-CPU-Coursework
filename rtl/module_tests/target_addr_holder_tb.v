module target_addr_holder_tb();
  logic clk, clk_enable;
  logic [31:0] tgt_addr_0, tgt_addr_1;
  initial begin
    clk = 0;
    #5;
    repeat (220) begin
      #5 clk = !clk;
    end
    $fatal(1, "Testbench timed out rather than exiting gracefully.");
  end

  initial begin
    repeat (100) begin
      clk_enable = $urandom_range(0,1);
      tgt_addr_0 = $urandom();
      @(posedge clk)
      #1;
      if(clk_enable) begin
        assert (tgt_addr_1 == tgt_addr_0)
        else $error("At time %t, tgt_addr_0=%h, but tgt_addr_1=%h", $time, tgt_addr_0, tgt_addr_1);
      end
    end

    $display("Finished. Total time = %t", $time);
    $finish;
  end

  target_addr_holder dut(
    .clk(clk), .clk_enable(clk_enable),
    .tgt_addr_0(tgt_addr_0), .tgt_addr_1(tgt_addr_1)
  );

endmodule
