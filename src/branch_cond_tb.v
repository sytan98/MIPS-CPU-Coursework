module branch_cond_tb();
  logic branch;
  logic[5:0] opcode;
  logic[5:0] b_code;
  logic equal;
  logic[31:0] reg_value;
  logic out;

  initial begin
    //BEQ
    branch = 1; opcode = 4;
    equal = 1;
    #1;
    assert(out == 1);

    branch = 1; opcode = 4;
    equal = 0;
    #1;
    assert(out == 0);

    //BNE
    branch = 1; opcode = 5;
    equal = 0;
    #1;
    assert(out == 1);

    branch = 1; opcode = 5;
    equal = 1;
    #1;
    assert(out == 0);

    //BGTZ
    branch = 1; opcode = 7;
    reg_value[31:0] = 32'd5;
    #1;
    assert(out == 1);

    branch = 1; opcode = 7;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 0);

    branch = 1; opcode = 7;
    reg_value[31:0] = -32'd357;
    #1;
    assert(out == 0);

    //BLEZ
    branch = 1; opcode = 6;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 1);

    branch = 1; opcode = 6;
    reg_value[31:0] = -32'd163114;
    #1;
    assert(out == 1);

    branch = 1; opcode = 6;
    reg_value[31:0] = 32'd163114;
    #1;
    assert(out == 0);

    //BGEZ
    branch = 1; opcode = 1; b_code = 1;
    reg_value[31:0] = 32'd5134;
    #1;
    assert(out == 1);

    branch = 1; opcode = 1; b_code = 1;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 1);

    branch = 1; opcode = 1; b_code = 1;
    reg_value[31:0] = -32'd3140314;
    #1;
    assert(out == 0);
    //BGEZAL
    branch = 1; opcode = 1; b_code = 17;
    reg_value[31:0] = 32'd5134;
    #1;
    assert(out == 1);

    branch = 1; opcode = 1; b_code = 17;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 1);

    branch = 1; opcode = 1; b_code = 17;
    reg_value[31:0] = -32'd3140314;
    #1;
    assert(out == 0);

    //BLTZ
    branch = 1; opcode = 1; b_code = 0;
    reg_value[31:0] = 32'd5134;
    #1;
    assert(out == 0);

    branch = 1; opcode = 1; b_code = 0;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 0);

    branch = 1; opcode = 1; b_code = 0;
    reg_value[31:0] = -32'd3140314;
    #1;
    assert(out == 1);
    //BLTZAL
    branch = 1; opcode = 1; b_code = 16;
    reg_value[31:0] = 32'd5134;
    #1;
    assert(out == 0);

    branch = 1; opcode = 1; b_code = 16;
    reg_value[31:0] = 32'd0;
    #1;
    assert(out == 0);

    branch = 1; opcode = 1; b_code = 16;
    reg_value[31:0] = -32'd3140314;
    #1;
    assert(out == 1);

  end

  branch_cond inst0(
    .branch(branch), .opcode(opcode), .b_code(b_code),
    .equal(equal), .read_data_a(reg_value), .condition_met(out)
  );

endmodule
