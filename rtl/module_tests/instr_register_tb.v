module instr_register_tb();
  logic clk, reset;
  logic[2:0] state;
  logic [31:0] ir_writedata, ir_readdata;
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
      reset = $urandom_range(0,100)==0;
      state = $urandom_range(0,5);
      ir_writedata = $urandom();
      @(posedge clk)
      #1;

      if (reset == 1) begin
        assert (ir_readdata == 0);
      end
      if(state == 1) begin
        assert (ir_readdata == ir_writedata)
        else $error("At time %t, ir_writedata=%h, but ir_readdata=%h", $time, ir_writedata, ir_readdata);
      end
    end

    $display("Finished. Total time = %t", $time);
    $finish;
  end

  instr_register dut(
    .clk(clk), .state(state), .reset(reset),
    .ir_writedata(ir_writedata), .ir_readdata(ir_readdata)
  );

endmodule
