module control_tb(
);
    logic[5:0] opcode;
    logic[5:0] function_code;
    logic[4:0] b_code; //branch instruction code
    logic rd_select; //output - select register to write to
    logic branch; //output - if branch, go to 1 so that block can check if condition met
    logic imdt_sel; //output - selects which type of extended immediate value to send to alu
    logic jump1; //output - select between output and branch mux (JAL J)
    logic jump2; //output - select between output jump1 mux or read data a (JR JALR)
    logic[1:0] alu_op; //output //for alu control
    logic alu_src; //output //controls what is going into alu ()
    logic data_read; //output //High for load instructions
    logic data_write; //output //High for store instructions
    logic reg_write_enable; //output //High for writing reg file (Arithmetic, logical shifts, setting inst, loading)
    logic hi_wren; //output for writing to hi
    logic lo_wren; //output for writing to lo
    logic data_into_reg1; //output //
    logic data_into_reg2; //output //for anything and links

    initial begin
        //R Type
        opcode = 0;

        //addu
        #1;
        function_code = 33;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(rd_select == 1) else $fatal(1, "Addu does not select correct register to write");
        assert(alu_op == 2) else $fatal(1, "Addu does not send correct alu_op");
        assert(alu_src == 0) else $fatal(1, "Addu does not send correct alu port b input");
        assert(reg_write_enable == 1)  else $fatal(1, "Addu cannot save data in reg file");
        #1

        //xor
        #1;
        function_code = 38;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(rd_select == 1) else $fatal(1, "Xor does not select correct register to write");
        assert(alu_op == 2) else $fatal(1, "Xor does not send correct alu_op");
        assert(alu_src == 0) else $fatal(1, "Xor does not send correct alu port b input");
        assert(reg_write_enable == 1)  else $fatal(1, "Xor cannot save data in reg file");
        #1

        //sltu

        //Load/store

        //lw
        #1;
        opcode = 35;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(rd_select == 0) else $fatal(1, "Lw does not select correct register to write");
        assert(alu_op == 0) else $fatal(1, "Lw does not send correct alu_op");
        assert(imdt_sel == 0) else $fatal(1, "Lw does not send sign extended immediate port b input");
        assert(alu_src == 1) else $fatal(1, "Lw does not send correct alu port b input");
        assert(reg_write_enable == 1)  else $fatal(1, "Lw cannot save data in reg file");
        #1

        //sh
        #1;
        opcode = 41;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(rd_select == 0) else $fatal(1, "Sh does not select correct register to write");
        assert(alu_op == 0) else $fatal(1, "Sh does not send correct alu_op");
        assert(imdt_sel == 0) else $fatal(1, "Sh does not send sign extended immediate port b input");
        assert(alu_src == 1) else $fatal(1, "Sh does not send correct alu port b input");
        #1
        //lwr

        //mtlo

        //lui

        //Jump Type

        //Jump
        #1;
        opcode = 2;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(jump1 == 1) else $fatal(1, "Jump, mux does not choose jump address, chooses branch output instead");
        assert(jump2 == 0) else $fatal(1, "Jump, mux does not choose jump address, chooses read_data_b from reg file instead");

        #1

        //JALR
        #1;
        opcode = 0;
        function_code = 9;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(jump2 == 1) else $fatal(1, "JALR, mux does not choose read_data_b from reg file, chooses jump address instead");
        assert(rd_select == 1) else $fatal(1, "JALR does not select correct register to write");
        assert(reg_write_enable == 1)  else $fatal(1, "JALR cannot save data in reg file");
        assert(data_into_reg2 == 1) else $fatal(1, "JALR does not store current pc+4 at the register");
        #1
        //JR

        //Branch Type
        //BEQ
        #1;
        opcode = 4;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(branch == 1) else $fatal(1, "BEQ does not give high signal to branch");
        assert((jump1 == 0) & (jump2 == 0)) else $fatal(1, "BEQ does not send correct mux signal to give branch address to pc");
        assert(reg_write_enable == 0)  else $fatal(1, "BEQ cannot save data in reg file");
        assert(alu_src == 0) else $fatal(1, "BEQ does not do subtraction correctly");
        assert(alu_op == 1) else $fatal(1, "BEQ does not send correct alu op");
        #1

        //BLTZAL
        #1;
        opcode = 1;
        b_code = 16;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(branch == 1) else $fatal(1, "BLTZAL does not give high signal to branch");
        assert((jump1 == 0) & (jump2 == 0)) else $fatal(1, "BLTZAL does not send correct mux signal to give branch address to pc");
        assert(reg_write_enable == 0)  else $fatal(1, "BLTZAL cannot save data in reg file");
        assert(alu_src == 1) else $fatal(1, "BLTZAL does not do subtraction correctly");
        assert(data_into_reg2 == 1) else $fatal(1, "BLTZAL does not store pc + 4 correctly");
        #1

        $display("Finished. Total time = %t", $time);
        $finish;
    end

    control dut(
        .opcode(opcode),
        .function_code,
        .b_code(b_code),
        .rd_select(rd_select),
        .imdt_sel(imdt_sel),
        .branch(branch),
        .jump1(jump1),
        .jump2(jump2),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .data_read(data_read),
        .data_write(data_write),
        .reg_write_enable(reg_write_enable),
        .hi_wren(hi_wren),
        .lo_wren(lo_wren),
        .data_into_reg1(data_into_reg1),
        .data_into_reg2(data_into_reg2)
    );

endmodule
