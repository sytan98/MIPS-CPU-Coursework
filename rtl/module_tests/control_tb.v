module control_tb();
// inputs
logic reset, waitrequest;
logic[5:0] opcode;
logic[5:0] function_code;
logic[4:0] b_code;
logic[2:0] state;
logic[1:0] byte_addressing;

// memory related
logic read, write;
logic[2:0] write_data_sel;
logic[3:0] byteenable;

// register_file related
logic[1:0] rd_select;
logic reg_write_enable;
logic[2:0] datamem_to_reg;
logic link_to_reg, mfhi, mflo, lwl, lwr;
// hi and lo registers related
logic hi_wren, lo_wren, multdiv;

// alu related
logic imdt_sel, alu_src;
logic[1:0] alu_op;

// PC address related
logic branch, jump, jumpreg;


    initial begin
        reset = 1;
        #1;
        assert (read == 1);
        assert (byteenable == 4'b1111);
        #1;

        // FETCH
        reset = 0;
        state = 0;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (reg_write_enable == 0);
        #1;

        // MEM
        state = 2;
        opcode = 40;
        byte_addressing = 2'b00;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b0001);
        assert (write_data_sel == 1);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        byte_addressing = 2'b01;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b0010);
        assert (write_data_sel == 2);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        byte_addressing = 2'b10;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b0100);
        assert (write_data_sel == 3);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        byte_addressing = 2'b11;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b1000);
        assert (write_data_sel == 4);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 41;
        byte_addressing = 2'b00;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b0011);
        assert (write_data_sel == 5);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        byte_addressing = 2'b10;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b1100);
        assert (write_data_sel == 6);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 43;
        #1;
        assert (read == 0);
        assert (write == 1);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 32;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 33;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 34;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 35;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 36;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 37;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 38;
        #1;
        assert (read == 1);
        assert (write == 0);
        assert (byteenable == 4'b1111);
        assert (alu_op == 2'b00);
        assert (alu_src == 1);
        #1;
        opcode = 0;
        #1;
        assert (read == 0);
        assert (write == 0);
        #1;



        state = 3;
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
        assert(jump == 1) else $fatal(1, "Jump, mux does not choose jump address, chooses branch output instead");
        assert(jumpreg == 0) else $fatal(1, "Jump, mux does not choose jump address, chooses read_data_b from reg file instead");

        #1

        //JALR
        #1;
        opcode = 0;
        function_code = 9;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(jumpreg == 1) else $fatal(1, "JALR, mux does not choose read_data_b from reg file, chooses jump address instead");
        assert(rd_select == 1) else $fatal(1, "JALR does not select correct register to write");
        assert(reg_write_enable == 1)  else $fatal(1, "JALR cannot save data in reg file");
        assert(link_to_reg == 1) else $fatal(1, "JALR does not store current pc+4 at the register");
        #1
        //JR

        //Branch Type
        //BEQ
        #1;
        opcode = 4;
        #1;
        // $display("a=%d, b=%d, r=%d, time=%t", A, B, alu_out, $time);
        assert(branch == 1) else $fatal(1, "BEQ does not give high signal to branch");
        assert((jump == 0) & (jumpreg == 0)) else $fatal(1, "BEQ does not send correct mux signal to give branch address to pc");
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
        assert((jump == 0) & (jumpreg == 0)) else $fatal(1, "BLTZAL does not send correct mux signal to give branch address to pc");
        assert(reg_write_enable == 1)  else $fatal(1, "BLTZAL cannot save data in reg file");
        assert(alu_src == 1) else $fatal(1, "BLTZAL does not do subtraction correctly");
        assert(link_to_reg == 1) else $fatal(1, "BLTZAL does not store pc + 4 correctly");
        #1

        //lui
        #1;
        opcode = 15;
        #1;
        // $display("datamem_to_reg=%b", datamem_to_reg);
        // $display("link_to_reg=%b", link_to_reg);
        assert(alu_src == 1) else $fatal(1, "LUI does not choose correct input to ALU");
        assert(datamem_to_reg == 0) else $fatal(1, "LUI does not choose correct data1 to write into destination register");
        assert(link_to_reg == 0) else $fatal(1, "LUI does not choose correct data2 to write into destination register");

        $display("Finished. Total time = %t", $time);
        $finish;
    end

    control dut(
      // inputs
      .reset(reset), .opcode(opcode), .function_code(function_code), .b_code(b_code),
      .state(state), .waitrequest(waitrequest), .byte_addressing(byte_addressing),
      // memory related
      .read(read), .write(write),             // read and write enable signals to bus_memory.v\
      .write_data_sel(write_data_sel),        // control signal to writedata_selector.v, for store instructions
      .byteenable(byteenable),                // control signal to bus_memory.v for sb and sh instructions
      // register_file related
      .rd_select(rd_select),                  // select signal to destination_reg_selector.v to select destination register
      .reg_write_enable(reg_write_enable),    // write enable signal for register in register_file.v
      .datamem_to_reg(datamem_to_reg),        // control signal to reg_writedata_selector.v, for load instructions
      .link_to_reg(link_to_reg),              // control signal to reg_writedata_selector.v, for link instructions
      .mfhi(mfhi), .mflo(mflo),               // control signal to reg_writedata_selector.v, for mfhi and mflo instructions
      .lwl(lwl), .lwr(lwr),                   // control signals to register_file.v for lwl and lwr instructions
      // hi and lo registers related
      .hi_wren(hi_wren),                      // write enable signal for reg_hi.v, for mthi, multiplication and division instructions
      .lo_wren(lo_wren),                      // write enable signal for reg_lo.v, for mtlo, multiplication and division instructions
      .multdiv(multdiv),                      // control signal to reg_hi.v and reg_lo.v, for multiplication and divison instructions
      // alu related
      .imdt_sel(imdt_sel),                    // control signal to imdtmux, selects between sign extended or zero extended immediate for andi, ori, xori
      .alu_src(alu_src),                      // control signal to alumux, selects between read_data_b for R-type instructions or immdt_32 for I-type instructions
      .alu_op(alu_op),                        // control signal to alu_ctrl.v, 0 for load/store instructions, 1 for BEQ/BNE, 2 for R-type instructions, 3 for I-type instructions
      // PC address related
      .branch(branch),                        // control signal to branch_cond.v, for branch instructions
      .jump(jump),                            // control signal to PC_address_selector.v for J and JAL
      .jumpreg(jumpreg)                       // control signal to PC_address_selector.v for JR and JALR
    );

endmodule
