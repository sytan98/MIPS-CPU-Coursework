// module to select between branch target address (for branch instructions),
// jump target address (for J and JAL), read_data_a (for JR and JALR), or
// PC+8 (for branch not taken) based on select signals condition_met, jump and jumpreg.
// output tgt_addr_0 will be connected to a register called target_addr_holder.v

module pc_address_selector(
  // possible values of PC address
  input logic[31:0] branch_addr,      // branch target address from branch_addressor.v
  input logic[31:0] jump_addr,        // jump target address from jump_addressor.v
  input logic[31:0] read_data_a,      // value stored in register rs from register_file.v
  input logic[31:0] pc_plus4,         // PC+4 from pc_adder.v. will add 4 to this to be PC+8

  // select signals
  input logic condition_met,          // from branch_cond.v, checks if conditions for branch has been met
  input logic jump,                   // from control.v, for J or JAL instructions
  input logic jumpreg,                // from control.v, for JR or JALR instructions

  output logic[31:0] tgt_addr_0       // output. connected to tgt_addr_holder.v
);

  always_comb begin
    if (condition_met & !jump & !jumpreg) begin
      tgt_addr_0 = branch_addr;       // if conditions for branch has been met, select branch target address
    end
    else if (!condition_met & jump & !jumpreg) begin
      tgt_addr_0 = jump_addr;         // if instruction is J or JAL, select jump target address
    end
    else if (!condition_met & !jump & jumpreg) begin
      tgt_addr_0 = read_data_a;       // if instruction is JR and JALR, select read_data_a
    end
    else begin
      tgt_addr_0 = pc_plus4 + 4;      // if branch is not taken, select PC+8
    end
  end
endmodule
