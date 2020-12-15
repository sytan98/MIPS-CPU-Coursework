// register to hold the PC target address for branch and jump instructions for the delay slot to work.
// tgt_addr_1 will take on the value of tgt_addr_0 from PC_address_selector in the next clock cycle.
// tgt_addr_1 and PC+4 will be inputs to a mux and the select signal to this mux is the delay signal.
// the delay signal will go to high during the instruction in the delay slot, and select the next
// value of PC to be tgt_addr_1 (branch target address, jump target address, read_data_a or PC+8 from previous clk cycle).

module target_addr_holder(
  input logic clk, reset, clk_enable,
  input logic[31:0] tgt_addr_0,     // from PC_address_selector.v branch target address, jump target address, read_data_a or PC+8.

  output logic[31:0] tgt_addr_1     // output. connected to a mux which will select the next value of PC to be either tgt_addr_1 or PC+4.
);

  always @(posedge clk) begin
    if (reset) begin
      tgt_addr_1 <= 0;
    end
    else if (clk_enable == 1) begin
      tgt_addr_1 <= tgt_addr_0;
    end
  end
endmodule
