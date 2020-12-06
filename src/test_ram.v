/*  Implements a 16-bit x 4K RAM, with zero delay read.
    This is synthesisable, but will have relatively high
    resource usage and combinatorial delay.
*/
module RAM_32x4GB(
    input logic clk,
    input logic[3:0] instr_address,
    output logic[31:0] instr_readdata
);

    reg [31:0] memory [7:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<8; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        //memory[0]=32'b10010110000000100000000000000111;
        memory[0]=32'b00000000000000010001000000100001;
        memory[1]=32'b10101100000000100000000000000001;
        memory[2]=32'b00000000000000100001000000100001;
        memory[3]=32'b10001100001000100000000000000000;
        memory[4]=32'b11111100000000000000000000000000;
    end

    /* Combinatorial read path. */
    assign instr_readdata = memory[instr_address];

    // SYNCHRONOUS
    //always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
      //  instr_readdata <= memory[instr_address]; // Read-after-write mode
    //end

endmodule


/*DIVISION: DIV REG[0]/REG[1] // MVFH TO REG[2] // MFLO TO REG[2]
memory[0]=32'b00000000000000010000000000011010;
        memory[1]=32'b00000000000000000001000000010000;
        memory[2]=32'b00000000000000000001000000010010;

*/