module memory_tb(
);
    logic clk;
    logic[31:0] instr_address;
    logic[31:0] instr_readdata;

    /* The number of cycles we want to actually test. Increasing the number will make the test-bench
        take longer, but may also uncover edge-cases. */
    localparam TEST_CYCLES = 100;
    parameter ROM_INIT_FILE = "../test/cases/addiu_1.byte.txt";
    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    instruction_memory #(ROM_INIT_FILE) romInst(clk, instr_address, instr_readdata);

    /* Clock generation process. Starts at the beginning of simulation. */
    initial begin
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);

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
    // logic[31:0] shadow[31:0];

    /* Input stimulus and checking process. This starts at the beginning of time, and   
        is synchronised to the same clock as DUT. */
    initial begin
        instr_address = 0;
        @(posedge clk);
        
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address =20;

        @(posedge clk);
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address = 24;

        @(posedge clk);
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address = 28;

        @(posedge clk);
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address = 32;

        @(posedge clk);
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address = 36;

        @(posedge clk);
        $display("Instruction=%h", instr_readdata);
        @(negedge clk);
        instr_address = 12;

        // while (active) begin
        //     @(posedge clk);
        //     $display("Register v0=%h", register_v0);
        //     $display("current instruction address=%d", instr_address);
        // end

        $display("TB : finished; running=0");

        $finish;
    end
endmodule