module reg_hi_tb();
  logic clk, reset, hi_wren,clk_enable;
  logic[31:0] read_data_a, hi, hi_readdata;

  /* The number of cycles we want to actually test. Increasing the number will make the test-bench
      take longer, but may also uncover edge-cases. */
  localparam TEST_CYCLES = 100;
  /* Constant used to track how many cycles we want to run for before declarating a timeout. */
  localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

  /* Clock generation process. Starts at the beginning of simulation. */
  initial begin
      $dumpfile("reg_hi_tb.vcd");
      $dumpvars(0, reg_hi_tb);

      /* Send clock low right at the start of the simulation. */
      clk = 0;

      /* Delay by 5 timeunits (5ns) -> hold clock low for 5 timeunits */
      #5;

      /* Generate clock for at most TIMEOUT_CYCLES cycles. */
      repeat (2*TIMEOUT_CYCLES) begin
          /* Delay by 5 timeunits (5ns) then toggle clock -> 10ns = 100MHz clock. */
          #5 clk = !clk;
      end

      $fatal(1, "Testbench timed out rather than exiting gracefully.");
  end

  /* Shadow copy of what we _expect_ the register to contain. We will update this
      as necessary in order to keep track of how the entries are expected to change. */
  logic[31:0] shadow;

  /* Input stimulus and checking process. This starts at the beginning of time, and
      is synchronised to the same clock as DUT. */
  initial begin

      reset = 0;

      @(posedge clk)
      #1;
      /* Pulse the reset for one cycle, in order to get register into known state. */
      reset=1;

      @(posedge clk)
      #1;

      /* reset==1 -> Initialise shadow copy to all zeros. */
      shadow = 0;


      /* Run as many test cycles as were requested. */
      repeat (TEST_CYCLES) begin
          /* Generate random samplings of input to apply in next cycle. */
          hi = $urandom();
          read_data_a = $urandom();
          hi_wren = $urandom_range(0,1);     /* Write enable is toggled randomly. */
          clk_enable = $urandom_range(0,1);     /* clk enable is toggled randomly. */
          reset = $urandom_range(0,100)==0;       /* 1% chance of reset in each cycle. */

          @(posedge clk)
          #1;

          /* Update the shadow regsiters according to the commands given to the register. */
          if (reset==1) begin
              shadow = 0;
          end
          else if (hi_wren==1 & clk_enable==1) begin
              shadow = read_data_a;
          end
          else begin
              shadow = hi;
          end

          /* Verify the returned results against the expected output from the shadow registers. */
          if (reset==1) begin
              assert (hi_readdata == 0) else $error("hi_readdata not zero during reset.");
          end
          else begin
              assert( hi_readdata == shadow )
              else $error("At time %t, hi=%d, read_data_a=%d, got=%d, ref=%d", $time, hi, read_data_a, hi_readdata, shadow);
          end
      end

      /* Exit successfully. */
      $finish;
  end

  reg_hi reghi_inst(
    .clk(clk), .reset(reset), .hi_wren(hi_wren), .clk_enable(clk_enable),
    .read_data_a(read_data_a), .hi(hi),
    .hi_readdata(hi_readdata)
  );

endmodule
