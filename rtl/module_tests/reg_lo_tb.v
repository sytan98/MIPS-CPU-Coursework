module reg_lo_tb();
    logic clk, reset, lo_wren, clk_enable, multdiv;
    logic[31:0] read_data_a, lo, lo_readdata;
    /* The number of cycles we want to actually test. Increasing the number will make the test-bench
        take longer, but may also uncover edge-cases. */
    localparam TEST_CYCLES = 100;
    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    /* Clock generation process. Starts at the beginning of simulation. */
    initial begin
    //   $dumpfile("../module_tests_outputs/reg_lo_tb.vcd");
    //   $dumpvars(0, reg_lo_tb);

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
            lo = $urandom();
            read_data_a = $urandom();
            lo_wren = $urandom_range(0,1);     /* Write enable is toggled randomly. */
            clk_enable = $urandom_range(0,1);     /* Write enable is toggled randomly. */
            reset = $urandom_range(0,100)==0;       /* 1% chance of reset in each cycle. */
            multdiv = $urandom_range(0,1);

            @(posedge clk)
            #1;

            /* Update the shadow regsiters according to the commands given to the register. */
            if (reset==1) begin
                shadow = 0;
            end
            else if (lo_wren==1 & clk_enable==1) begin
                if (multdiv == 1) begin
                    shadow = lo;
                end
                else begin
                    shadow = read_data_a;
                end
            end

            /* Verify the returned results against the expected output from the shadow register. */
            if (reset==1) begin
                assert (lo_readdata == 0) else $error("lo_readdata not zero during reset.");
            end
            else begin
                assert( lo_readdata == shadow )
                else $error("At time %t, lo=%d, read_data_a=%d, got=%d, ref=%d", $time, lo, read_data_a, lo_readdata, shadow);
            end
        end

        /* Exit successfully. */
        $display("Finished. Total time = %t", $time);
        $finish;
    end

    reg_lo reglo_inst(
    .clk(clk), .reset(reset), .lo_wren(lo_wren), .clk_enable(clk_enable),
    .read_data_a(read_data_a), .lo(lo),
    .lo_readdata(lo_readdata), .multdiv(multdiv)
    );

endmodule
