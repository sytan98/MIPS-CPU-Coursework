module PC_address_selector(
  input logic[31:0] branch_addr, jump_addr, read_data_a,
  input logic condition_met, jump1, jump2,

  output logic[31:0] tgt_addr_0
);

  always @(*) begin
    if (condition_met & !jump1 & !jump2) begin
      tgt_addr_0 = branch_addr;
    end
    else if (!condition_met & jump1 & !jump2) begin
      tgt_addr_0 = jump_addr;
    end
    else if (!condition_met & !jump1 & jump2) begin
      tgt_addr_0 = read_data_a;
    end
    // else begin
    //   tgt_addr_0 = pc_plus4;
    // end
  end
endmodule
