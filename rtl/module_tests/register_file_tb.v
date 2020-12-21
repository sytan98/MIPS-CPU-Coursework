module register_file_tb(
);
    logic clk;
    logic clk_enable;
    logic reset;
    logic lwl, lwr;
    logic[4:0] write_reg_rd, read_reg_a, read_reg_b;
    logic[1:0] byte_addressing;
    logic[31:0] reg_write_data, read_data_a, read_data_b;
    logic reg_write_enable;

    /* The number of cycles we want to actually test. Increasing the number will make the test-bench
        take longer, but may also uncover edge-cases. */
    localparam TEST_CYCLES = 100;

    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    /* Clock generation process. Starts at the beginning of simulation. */
    initial begin
        // $dumpfile("./register_file_tb.vcd");
        // $dumpvars(0, register_file_tb);

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

    /* Shadow copy of what we _expect_ the register file to contain. We will update this
        as necessary in order to keep track of how the entries are expected to change. */
    logic[31:0] shadow[31:0];

    /* Input stimulus and checking process. This starts at the beginning of time, and
        is synchronised to the same clock as DUT. */
    integer i;
    initial begin

        reset = 0;

        @(posedge clk)
        #1;
        /* Pulse the reset for one cycle, in order to get register file into known state. */
        reset=1;

        @(posedge clk)
        #1;

        /* reset==1 -> Initialise shadow copy to all zeros. */
        for(i=0; i<32; i++) begin
            shadow[i]=0;
        end


        /* Run as many test cycles as were requested. */
        repeat (TEST_CYCLES) begin
            /* Generate random samplings of input to apply in next cycle. */
            write_reg_rd = $urandom_range(0,31);
            reg_write_data = $urandom();
            reg_write_enable = $urandom_range(0,1);     /* Write enable is toggled randomly. */
            read_reg_a = $urandom_range(0,31);
            read_reg_b = $urandom_range(0,31);
            reset = $urandom_range(0,100)==0;       /* 1% chance of reset in each cycle. */
            clk_enable = $urandom_range(0,1);
            @(posedge clk)
            #1;

            /* Update the shadow regsiters according to the commands given to the register file. */
            if (reset==1) begin
                for(i=0; i<32; i++) begin
                    shadow[i]=0;
                end
            end
            else begin
                if( clk_enable && reg_write_enable) begin
                    shadow[write_reg_rd] = reg_write_data;
                end
            end

            /* Verify the returned results against the expected output from the shadow registers. */
            if (reset==1) begin
                assert (read_data_a==0 && read_data_b == 0) else $error("read_data_a not zero during reset.");
            end
            else if (clk_enable) begin
                assert( read_data_a == shadow[read_reg_a] )
                else $error("At time %t, read_index_rs=%d, got=%h, ref=%h", $time, read_reg_a, read_data_a, shadow[read_reg_a]);
                assert( read_data_b == shadow[read_reg_b] )
                else $error("At time %t, read_index_rt=%d, got=%h, ref=%h", $time, read_reg_b, read_data_a, shadow[read_reg_b]);
            end
        end

        /* Exit successfully. */
        $display("Finished. Total time = %t", $time);
        $finish;
    end

    register_file dut(
        .clk(clk),
        .clk_enable(clk_enable),
        .reset(reset),
        .read_reg_a(read_reg_a), .read_reg_b(read_reg_b),
        .lwl(lwl), .lwr(lwr),
        .byte_addressing(byte_addressing),
        .read_data_a(read_data_a), .read_data_b(read_data_b),
        .write_reg_rd(write_reg_rd), .reg_write_data(reg_write_data),
        .reg_write_enable(reg_write_enable)
    );
endmodule
