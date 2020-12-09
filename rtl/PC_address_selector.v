module PC_address_selector(
  input logic[31:0] branch_addr, jump_addr, read_data_a, pc_plus4,
  input logic condition_met, jump1, jump2,

  output logic[31:0] tgt_addr_0
);

  always @(*) begin
    //from branch_cond block
    if (condition_met & !jump1 & !jump2) begin
      tgt_addr_0 = branch_addr;
    end
    //from control, for J and JAL
    else if (!condition_met & jump1 & !jump2) begin
      tgt_addr_0 = jump_addr;
    end
    //from control, for JR and JALR
    else if (!condition_met & !jump1 & jump2) begin
      tgt_addr_0 = read_data_a;
    end
    // Need this to go to PC + 8 if branch not taken
    else begin
      tgt_addr_0 = pc_plus4 + 4;
    end
  end
endmodule
