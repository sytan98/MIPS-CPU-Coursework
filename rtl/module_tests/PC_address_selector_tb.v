module pc_address_selector_tb();
  logic[31:0] pc_plus4, branch_addr, jump_addr, read_data_a;
  logic condition_met, jump, jumpreg;
  logic[31:0] tgt_addr_0;

  initial begin
    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump = 0;
    jumpreg = 0;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == pc_plus4  + 4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump = 0;
    jumpreg = 0;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == branch_addr);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump = 1;
    jumpreg = 0;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == jump_addr);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump = 0;
    jumpreg = 1;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == read_data_a);

    //test that it defaults to pc_plus4 if control signals are wonky
    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump = 1;
    jumpreg = 0;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == pc_plus4 + 4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump = 1;
    jumpreg = 1;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == pc_plus4 + 4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump = 0;
    jumpreg = 1;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == pc_plus4 + 4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump = 1;
    jumpreg = 1;
    #1;
    // $display("branch?=%b, jump?=%b, jumpreg?=%b, PC=%d", condition_met, jump, jumpreg, tgt_addr_0);
    assert(tgt_addr_0 == pc_plus4 + 4);

    $display("Finished. Total time = %t", $time);
    $finish;

  end


  pc_address_selector dut(
    .pc_plus4(pc_plus4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .read_data_a(read_data_a),
    .condition_met(condition_met), //from branch_cond block
    .jump(jump), //from control, for J and JAL
    .jumpreg(jumpreg), //from control, for JR and JALR
    .tgt_addr_0(tgt_addr_0)
  );
endmodule
