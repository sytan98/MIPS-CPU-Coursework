// used to calculate the jump target address for J and JAL instructions.
// the 26-bit immediate is shifted to the left by 2 bits to get a 28-bit number.
// the first 4 MSB of PC+4 is then concatenated to this 28-bit number to give a 32-bit value, which is the jump target address.

module jump_addressor(
  input logic[25:0] j_immdt,      // instruction[25:0]. 26-bit immediate for J and JAL instructions.
  input logic[3:0] pc_4msb,       // first 4 MSB of PC+4
  output logic[31:0] jump_addr    // jump target address. connceted to PC_address_selector.v
);

  logic[27:0] shifted;

  always_comb begin
    shifted[27:0] = {j_immdt, 2'b00};
    jump_addr[31:28] = pc_4msb;
    jump_addr[27:0] = shifted;
  end

endmodule
