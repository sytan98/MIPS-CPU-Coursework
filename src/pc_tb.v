module pc_tb();
    logic clk, reset;
    logic[31:0] adder_input, adder_output, pcout;
    assign pcout = adder_input;

    /* The number of cycles we want to actually test. Increasing the number will make the test-bench
        take longer, but may also uncover edge-cases. */
    localparam TEST_CYCLES = 100;

    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    /* Clock generation process. Starts at the beginning of simulation. */
    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

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

    /* Shadow copy of what we _expect_ the PC to contain. We will update this
        as necessary in order to keep track of how the entries are expected to change. */
    logic[31:0] shadow;

    /* Input stimulus and checking process. This starts at the beginning of time, and
        is synchronised to the same clock as DUT. */
    initial begin

        reset = 0;

        @(posedge clk)
        #1;
        /* Pulse the reset for one cycle, in order to get PC into known state. */
        reset=1;

        @(posedge clk)
        #1;

        /* reset==1 -> Initialise PC to reset vector. */
        shadow = 32'hBFC00000;


        /* Run as many test cycles as were requested. */
        repeat (TEST_CYCLES) begin
            /* Generate input*/
            reset = $urandom_range(0,100)==0;       /* 1% chance of reset in each cycle. */

            @(posedge clk)
            #1;
            /* Update the shadow regsiters according to the commands given to the PC */
            if (reset==1) begin
              shadow = 32'hBFC00000;
            end
            else begin
              shadow = shadow + 4;
            end

            /* Verify the returned results against the expected output from the shadow registers. */
            if (reset==1) begin
                assert (pcout == 32'hBFC00000) else $error("PC not reset to reset vector.");
            end
            else begin
                assert(pcout == shadow )
                else $error("At time %t, PC=%h, shadow=%h", $time, pcout, shadow);
            end
        end

        /* Exit successfully. */
        $finish;
    end

    pc pc_inst(
      .clk(clk), .reset(reset),
      .pcin(adder_output),
      .pcout(adder_input)
    );

    pc_adder pcadder_inst(
      .pcout(adder_input),
      .pc_plus4(adder_output)
    );
endmodule
