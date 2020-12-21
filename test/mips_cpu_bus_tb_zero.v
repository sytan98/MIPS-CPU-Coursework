module mips_cpu_bus_tb_zero;
    timeunit 1ns / 10ps;

    parameter ROM_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 100000;
    parameter NUM_STALLS = 0;

    logic clk;
    logic reset;

    logic active;
    logic waitrequest;
    logic write;
    logic read;
//============================================ INITIALISATIONS OF MEMORY LOGIC =============================================//
    logic[31:0] address;
    logic[31:0] readdata;
    logic[3:0] byteenable;
    logic[31:0] writedata;
//============================================= INITIALISATIONS OF CPU LOGIC ===============================================//
    logic[31:0] register_v0;
//======================================= INITIALISATIONS OF MEMORIES AND CPU BUS ==========================================//
    bus_memory #(ROM_INIT_FILE) ramInst(.clk(clk), .address(address), .write(write), .read(read),
                                        .waitrequest(waitrequest), .writedata(writedata),
                                        .byteenable(byteenable), .readdata(readdata));
    mips_cpu_bus cpuInst(.clk(clk), .reset(reset), .active(active), .register_v0(register_v0),
                         .address(address), .write(write), .read(read), .waitrequest(waitrequest),
                         .writedata(writedata), .byteenable(byteenable), .readdata(readdata));
//==========================================================================================================================//

    // Generate clock
    initial begin
        $dumpfile("mips_cpu_bus_tb_zero.vcd");
        $dumpvars(0, mips_cpu_bus_tb_zero);
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        // num_stalls = 15;

        reset = 0;
        #1;

        @(posedge clk);
        #1;
        reset = 1;
        // @(posedge clk);
        @(negedge clk);
        // assert(read == 0 & write == 0) else $fatal(2, "TB : CPU initiated memory transactions during reset.");
        // $display("check state before reset=%d", check_state);
        @(posedge clk);
        assert(read == 0 & write == 0) else $fatal(2, "TB : CPU initiated memory transactions during reset.");
        @(posedge clk);
        assert(read == 0 & write == 0) else $fatal(2, "TB : CPU initiated memory transactions during reset.");
        @(posedge clk);
        assert(read == 0 & write == 0) else $fatal(2, "TB : CPU initiated memory transactions during reset.");
        @(posedge clk);
        assert(read == 0 & write == 0) else $fatal(2, "TB : CPU initiated memory transactions during reset.");
        #2;
        reset = 0;
        @(posedge clk);

        assert(active==1)
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            // num_stalls = 15;

            @(posedge clk);
            // $display("current instruction address=%h", instr_address);
            $display("Register v0:%h", register_v0);
            assert(address > 0 & address <= 8 & register_v0 == 32'h00001234);
        end
        $display("Output at v0:%h", register_v0);
        $display("TB : finished; running=0");

        $finish;
    end
endmodule
