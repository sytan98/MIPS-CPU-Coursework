module data_register_tb();
  logic clk, reset;
  logic[2:0] state;
  logic [31:0] dr_writedata, dr_readdata;
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
      dr_writedata = $urandom();
      @(posedge clk)
      #1;

      if (reset == 1) begin
        assert (dr_readdata == 0);
      end
      else if(state == 3) begin
        assert (dr_readdata == dr_writedata)
        else $error("At time %t, dr_writedata=%h, but dr_readdata=%h", $time, dr_writedata, dr_readdata);
      end
    end

    $display("Finished. Total time = %t", $time);
    $finish;
  end

  data_register dut(
    .clk(clk), .state(state), .reset(reset),
    .dr_writedata(dr_writedata), .dr_readdata(dr_readdata)
  );

endmodule
