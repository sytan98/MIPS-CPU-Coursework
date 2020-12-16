module mips_cpu_bus_tb;
    timeunit 1ns / 10ps;

    parameter ROM_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 10000;

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
    logic[3:0] num_stalls;
//============================================= INITIALISATIONS OF CPU LOGIC ===============================================//
    logic[31:0] register_v0;
//======================================= INITIALISATIONS OF MEMORIES AND CPU BUS ==========================================//
    bus_memory #(ROM_INIT_FILE) ramInst(.clk(clk), .address(address), .write(write), .read(read),
                                        .num_stalls(num_stalls), .waitrequest(waitrequest), .writedata(writedata),
                                        .byteenable(byteenable), .readdata(readdata));
    mips_cpu_bus cpuInst(.clk(clk), .reset(reset), .active(active), .register_v0(register_v0),
                         .address(address), .write(write), .read(read), .waitrequest(waitrequest),
                         .writedata(writedata), .byteenable(byteenable), .readdata(readdata));
//==========================================================================================================================//

    // Generate clock
    initial begin
        $dumpfile("mips_cpu_bus_tb.vcd");
        $dumpvars(0, mips_cpu_bus_tb);
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
        num_stalls = $urandom_range(0,8);

        reset <= 0;
        @(posedge clk);
        reset <= 1;
        // $display("check state before reset=%d", check_state);
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        assert(active==1)
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            num_stalls = $urandom_range(0,8);
            $display("num stalls:%d", num_stalls);

            @(posedge clk);
            // $display("current instruction address=%h", instr_address);
            $display("Register v0:%h", register_v0);
        end
        $display("Output at v0:%h", register_v0);
        $display("TB : finished; running=0");

        $finish;
    end
endmodule
