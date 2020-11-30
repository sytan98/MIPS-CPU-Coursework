/*  Implements a 16-bit x 4K RAM, with zero delay read.
    This is synthesisable, but will have relatively high
    resource usage and combinatorial delay.
*/
module RAM_32x8_delay0(
    input logic clk,
    input logic[3:0] data_address,
    input logic data_write,
    input logic data_read,
    input logic[31:0] data_writedata,
    output logic[31:0] data_readdata
);
    parameter RAM_INIT_FILE = "";

    reg [31:0] memory [7:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<8; i++) begin
            memory[i]=0;
        end
        
    end

    /* Combinatorial read path. */
    assign data_readdata = data_read ? memory[data_address] : 32'hxxxxxxxx;

    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (data_write) begin
            memory[data_address] <= data_writedata;
        end
    end
endmodule