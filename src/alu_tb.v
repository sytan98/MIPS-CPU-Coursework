module alu_iterative_tb(
);
    logic clk;
    logic[5:0] alu_ctrl_in;
    logic[31:0] A,B;
    logic[4:0] shamt;
    logic[31:0] alu_out;
    logic zero;
    logic[31:0] lo, hi;

    initial begin

        A = 32'd5;
        B = 32'd8;
        shamt = 7;

        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);

        //Computational Instructions
        //Addu
        #1;
        alu_ctrl_in = 2;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(A + B == alu_out) else $fatal(1, "Addu is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Sub
        #1;
        alu_ctrl_in = 3;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(A - B == alu_out) else $fatal(1, "Sub is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //AND
        #1;
        alu_ctrl_in = 4;
        #1;
        $display("a=%b, b=%b, answer=%b, r=%b, time=%t", A, B,A&B, alu_out, $time);
        assert( (A&B)== alu_out) else $fatal(1, "AND is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //OR
        #1;
        alu_ctrl_in = 5;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert((A|B)== alu_out) else $fatal(1, "OR is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //XOR
        #1;
        alu_ctrl_in = 6;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(A ^ B == alu_out) else $fatal(1, "XOR is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //SLLV
        #1;
        alu_ctrl_in = 8;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert( B << A == alu_out) else $fatal(1, "SLLV is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //SRL
        #1;
        alu_ctrl_in = 11;
        #1;
        $display("a=%d, shift=%d, r=%d, time=%t", A, B, shamt, alu_out, $time);
        assert(B >> shamt == alu_out) else $fatal(1, "SRL is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //SRA
        #1;
        alu_ctrl_in = 11;
        #1;
        $display("a=%d, shift=%d, r=%d, time=%t", A, B, shamt, alu_out, $time);
        assert(($signed(B) >>> shamt) == $signed(alu_out)) else $fatal(1, "SRA is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Mult
        #1;
        alu_ctrl_in = 15;
        #1;
        $display("hi=%h, lo=%h, combined=%h", hi, lo, {32'h00000000, lo}+{hi, 32'h00000000});
        $display("a=%d, b=%d, ans=%h, r=%h, time=%t", $signed(A), $signed(B), $signed(A) * $signed(B), $signed({32'h00000000, lo}+{hi, 32'h00000000}), $time);
        assert($signed(A) * $signed(B) == $signed({32'h00000000, lo}+{hi, 32'h00000000})) else $fatal(1, "MULT is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Multu
        #1;
        alu_ctrl_in = 16;
        #1;
        $display("hi=%h, lo=%h, combined=%h", hi, lo, {32'h00000000, lo}+{hi, 32'h00000000});
        $display("a=%d, b=%d, ans=%h, r=%h, time=%t", A, B, A * B, {32'h00000000, lo}+{hi, 32'h00000000}, $time);
        assert(A * B == {32'h00000000, lo}+{hi, 32'h00000000}) else $fatal(2, "MULTU is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Div
        #1;
        alu_ctrl_in = 17;
        #1;
        $display("a=%d, b=%d, quotient=%d, remainder=%d, time=%t", $signed(A), $signed(B), $signed(lo), $signed(hi), $time);
        assert($signed(A)/$signed(B) == $signed(lo)) else $fatal(1, "Quotient is wrong.");
        assert($signed(A)%$signed(B) == $signed(hi)) else $fatal(1, "Remainder is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //Divu
        #1;
        alu_ctrl_in = 18;
        #1;
        $display("a=%d, b=%d, quotient=%d, remainder=%d, time=%t", A, B, lo, hi, $time);
        assert(A/B == lo) else $fatal(1, "Quotient is wrong.");
        assert(A%B == hi) else $fatal(1, "Remainder is wrong.");
        #1
        
        //BEQ
        #1;
        A = 5;
        B = 5;
        alu_ctrl_in = 1;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(zero == 1) else $fatal(1, "BEQ is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;

        //LUI
        #1;
        alu_ctrl_in = 25;
        #1;
        $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(B << 16 == alu_out) else $fatal(1, "Sub is wrong.");
        #1
        A = A+32'h23456789;
        B = B+32'h34567891;
        
        $display("Finished. Total time = %t", $time);
        $finish;
    end

    alu dut(
        .alu_ctrl_in(alu_ctrl_in),
        .A(A), .B(B),
        .shamt(shamt),
        .alu_out(alu_out),
        .zero(zero),
        .lo(lo), .hi(hi)
    );

endmodule
