module PC_address_selector_tb();
  logic[31:0] pc_plus4, branch_addr, jump_addr, read_data_a;
  logic condition_met, jump1, jump2;
  logic[31:0] pcin_0;

  initial begin
    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump1 = 0;
    jump2 = 0;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == pc_plus4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump1 = 0;
    jump2 = 0;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == branch_addr);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump1 = 1;
    jump2 = 0;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == jump_addr);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump1 = 0;
    jump2 = 1;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == read_data_a);

    //test that it defaults to pc_plus4 if control signals are wonky
    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump1 = 1;
    jump2 = 0;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == pc_plus4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 0;
    jump1 = 1;
    jump2 = 1;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == pc_plus4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump1 = 0;
    jump2 = 1;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == pc_plus4);

    pc_plus4 = 4;
    branch_addr = 8;
    jump_addr = 12;
    read_data_a = 40000;
    condition_met = 1;
    jump1 = 1;
    jump2 = 1;
    #1;
    $display("branch?=%b, jump1?=%b, jump2?=%b, PC=%d", condition_met, jump1, jump2, pcin_0);
    assert(pcin_0 == pc_plus4);



  end


  PC_address_selector inst0(
    .pc_plus4(pc_plus4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .read_data_a(read_data_a),
    .condition_met(condition_met), //from branch_cond block
    .jump1(jump1), //from control, for J and JAL
    .jump2(jump2), //from control, for JR and JALR
    .pcin_0(pcin_0)
  );
endmodule
