module memory_tb(
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
    parameter ROM_INIT_FILE = "./cases/addiu_1.bytes.txt";
    /* Constant used to track how many cycles we want to run for before declarating a timeout. */
    localparam TIMEOUT_CYCLES = TEST_CYCLES + 10;

    bus_memory #(ROM_INIT_FILE) ramInst(clk, address, write, read, waitrequest, writedata, byteenable, readdata, check_state);

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
        @(posedge clk);
        @(negedge clk);
        address = 32'hBFC00000;
        #2
        read = 1;
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
        address = 32'hBFC00004;
        #5
        read = 0;

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
        address = 32'hBFC0000C;
        #5
        read = 0;
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

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        @(posedge clk);
        @(negedge clk);
        $display("Instruction=%h", readdata);
        $display("Wait Request=%h", waitrequest);

        

        // address = 32'hBFC00008;

        // @(posedge clk);
        
        // @(negedge clk);
        // $display("Wait Request=%h", waitrequest);
        // $display("Instruction=%h", readdata);
        // 

        // @(posedge clk);
        
        // @(negedge clk);
        // $display("Wait Request=%h", waitrequest);
        // $display("Instruction=%h", readdata);
        // address = 32'hBFC00010;


        $display("TB : finished; running=0");

        $finish;
    end
endmodule