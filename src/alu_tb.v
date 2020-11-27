module alu_iterative_tb(
);
    logic clk;
    logic[5:0] alu_ctrl_in;
    logic[31:0] A,B;
    logic[5:0] shamt;
    logic[31:0] alu_out;
    logic zero;
    logic[31:0] lo, hi;

    initial begin
        $dumpfile("alu_iterative_tb.vcd");
        $dumpvars(0, alu_iterative_tb);
        clk = 0;

        #5;

        repeat (100000) begin
            #5 clk = !clk;
        end

        $fatal(2, "Fail : test-bench timed out without positive exit.");
    end

    initial begin
        //Max Int 
        A = 5;
        B = 8;
        shamt = 7;

        $display("a=%d, b=%d, r=%d,  time=%t", A, B, alu_out, $time);

        //Computational Instructions
        //Addu
        @(posedge clk);
        #1;
        alu_ctrl_in = 2;
        
        @(negedge clk);
        $display("a=%d, b=%d, r=%d,  time=%t", A, B, alu_out, $time);
        assert(A + B == alu_out) else $fatal(1, "Addu is wrong.");

        #1

        A = A+32'h23456789;
        B = B+32'h34567891;

        //Sub
        @(posedge clk);
        #1;
        alu_ctrl_in = 3;
        
        @(negedge clk);
        $display("a=%d, b=%d, r=%d,  time=%t", A, B, alu_out, $time);
        assert(A - B == alu_out) else $fatal(1, "Sub is wrong.");

        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //XOR
        @(posedge clk);
        #1;
        alu_ctrl_in = 6;
        
        @(negedge clk);
        $display("a=%d, b=%d, r=%d,  time=%t", A, B, alu_out, $time);
        assert(A ^ B == alu_out) else $fatal(1, "XOR is wrong.");

        #1
        A = A+32'h23456789;
        B = B+32'h34567891;
        $display("B=%d", B);
        //SRA
        @(posedge clk);
        #1;
        alu_ctrl_in = 11;
        
        @(negedge clk);
        $display("a=%d, b=%d, shift=%d, r=%d,  time=%t", A, B, shamt, alu_out, $time);
        assert(($signed(B) >>> shamt) == $signed(alu_out)) else $fatal(1, "SRA is wrong.");

        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Mult
        A = 1987654;
        B = 9123456;
        @(posedge clk);
        #1;
        alu_ctrl_in = 15;
        
        @(negedge clk);
        $display("hi=%h, lo=%h, combined=%h", hi, lo, {32'h00000000, lo}+{hi, 32'h00000000});
        $display("a=%d, b=%d, ans=%h, r=%d,  time=%t", A, B, A * B, {32'h00000000, lo}+{hi, 32'h00000000}, $time);

        assert(A * B == {32'h00000000, lo}+{hi, 32'h00000000}) else $fatal(1, "Product is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;
        //Div
        @(posedge clk);
        #1;
        alu_ctrl_in = 17;
        
        @(negedge clk);
        $display("a=%d, b=%d, quotient=%h, remainder=%h, answer_q=%d, answer_r=%d, time=%t", A, B, lo, hi, A/B, A%B, $time);
        assert(A/B == lo) else $fatal(1, "Quotient is wrong.");
        assert(A%B == hi) else $fatal(1, "Remainder is wrong.");
        #1
        
        $display("Finished. Total time = %t", $time);
        $finish;
    end

    alu a(
        .alu_ctrl_in(alu_ctrl_in),
        .A(A), .B(B),
        .shamt(shamt),
        .alu_out(alu_out),
        .zero(zero),
        .lo(lo), .hi(hi)
    );

endmodule
