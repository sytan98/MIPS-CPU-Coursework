module test_mips_cpu_tb;
    timeunit 1ns / 10ps;

    parameter ROM_INIT_FILE = "addiu1.hex.txt";
    parameter TIMEOUT_CYCLES = 10;

    logic clk;
    logic reset;
    logic clk_enable;
    logic active;

    logic data_write;
    logic data_read;
    logic[31:0] instr_address;
    logic[31:0] instr_readdata;
    logic[31:0]  data_address;

    logic[31:0]  data_writedata;
    logic[31:0]  data_readdata;

    logic [31:0] register_v0;
    logic [1:0] check_state;
    logic[31:0] check_pcout;

    instruction_memory #(ROM_INIT_FILE) romInst(clk, instr_address, instr_readdata);
    data_memory ramInst(clk, data_address, data_read, data_write, data_writedata, data_readdata);
    mips_cpu_harvard cpuInst(clk, reset, active, register_v0, clk_enable, instr_address, instr_readdata,
                    data_address, data_write, data_read, data_writedata, data_readdata);

    // Generate clock
    initial begin
        $dumpfile("test_mips_cpu_tb.vcd");
        $dumpvars(0, test_mips_cpu_tb);
        clk=0;
        //clk_enable=1;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        reset <= 0;
        @(posedge clk);
        reset <= 1;
        $display("reset=1");
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        assert(active==1)
        else $display("TB : CPU did not set running=1 after reset.");

        while (active) begin
            @(posedge clk);
            $display("Register v0=%h", register_v0);
            $display("current instruction address=%d", instr_address);
        end

        $display("TB : finished; running=0");

        $finish;
    end
endmodule
