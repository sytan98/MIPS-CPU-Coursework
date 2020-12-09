module memory_write_tb(
);
	logic clk;
	logic[31:0] address;
	logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;
    logic[1:0] check_state;

    /* The number of cycles we want to actually test. Increasing the number will make the test-bench
        take longer, but may also uncover edge-cases. */
    localparam TEST_CYCLES = 100;
    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    bus_memory ramInst(clk, address, write, read, waitrequest, writedata, byteenable, readdata, check_state);

    /* Clock generation process. Starts at the beginning of simulation. */
    initial begin
        $dumpfile("memory_write_tb.vcd");
        $dumpvars(0, memory_write_tb);

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
        // write data in
        @(posedge clk);
        @(negedge clk);
        byteenable=4'b1111;
        address = 1;
        #2
        write = 1;
        writedata=32'hF0F0F0F0;
        @(posedge clk);
        @(negedge clk);
        $display("State=%h", check_state);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        #5
        write = 0;

        // test byte enable with writing
        @(posedge clk);
        @(negedge clk);
        byteenable=4'b0101;
        address = 1;
        #2
        write = 1;
        writedata=32'hAAAAAAAA;
        @(posedge clk);
        @(negedge clk);
        $display("State=%h", check_state);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        #5
        write = 0;

        //read data from the address with previous byteenable
        @(posedge clk);
        @(negedge clk);
        read = 1;

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        #5
        read = 0;

        // read from same address with different byteenable
        byteenable=4'b1101;
        @(posedge clk);
        @(negedge clk);
        read = 1;

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        
        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);
        #5
        read = 0;


        $display("TB : finished; running=0");

        $finish;
    end
endmodule