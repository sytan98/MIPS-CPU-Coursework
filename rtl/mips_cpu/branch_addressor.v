// used to calculate branch target address.
// calculated by sign extending the 16-bit immediate, shifiting it to the left by 2 bits,
// and then adding it to PC+4 to get the branch target address.
// addition is signed to ensure that we can branch backwards and forward.

module branch_addressor(
  input logic[31:0] immdt_32,     // signed_extended immediate
  input logic[31:0] pc_plus4,     // PC+4 from pc_adder.v
  output logic[31:0] branch_addr  // bracnh target address. connected to PC_address_selector.v
);

  always_comb begin
    branch_addr = $signed(immdt_32 << 2) + $signed(pc_plus4);
  end

endmodule
