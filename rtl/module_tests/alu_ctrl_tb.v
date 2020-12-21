module alu_ctrl_tb(
);
logic[1:0] alu_op;
logic[5:0] function_code;
logic[5:0] opcode;
logic[4:0] alu_ctrl_in;

    initial begin

        // alu_op == 0
        #1;
        alu_op = 0;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 0) else $fatal(1, "alu_ctrl_in not 0 for alu_op = 0!");

        // alu_op == 1
        #1;
        alu_op = 1;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 1) else $fatal(1, "alu_ctrl_in not 1 for alu_op = 1!");

        // alu_op == 2
        #1;
        alu_op = 2;

        opcode = 0;
        function_code = 33;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 2);
        #1;
        function_code = 35;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 3);
        #1;
        function_code = 36;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 4);
        #1;
        function_code = 37;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 5);
        #1;
        function_code = 38;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 6);
        #1;
        function_code = 0;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 7);
        #1;
        function_code = 4;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 8);
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        function_code = 2;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 9);
        #1;
        function_code = 6;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 10);
        #1;
        function_code = 3;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 11);
        #1;
        function_code = 7;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 12);
        #1;
        function_code = 42;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 13);
        #1;
        function_code = 43;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 14);
        #1;
        function_code = 24;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 15);
        #1;
        function_code = 25;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 16);
        #1;
        function_code = 26;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 17);
        #1;
        function_code = 27;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 18);
        #1;

        // alu_op == 3
        alu_op = 3;
        opcode = 9;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 19);
        #1;
        opcode = 10;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 20);
        #1;
        opcode = 11;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 21);
        #1;
        opcode = 12;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 22);
        #1;
        opcode = 13;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 23);
        #1;
        opcode = 14;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 24);
        #1;
        opcode = 15;
        #1;
        // $display("alu_op=%d, opcode=%d, function_code=%d, alu_ctrl_in=%d", alu_op, opcode, function_code, alu_ctrl_in);
        assert(alu_ctrl_in == 25);


        $display("Finished. Total time = %t", $time);
        $finish;
    end

    alu_ctrl dut(
        .alu_op(alu_op), .function_code(function_code),
        .opcode(opcode), .alu_ctrl_in(alu_ctrl_in)
    );

endmodule
