// branch target address is calculated by:
// 1. taking 16-bit immediate and sign extending it to 32 bits
// 2. shifting the 32-bit number to the left by 2 bits for word alignment
// 3. adding the shifted number to PC+4 to get branch target address
// so let's say our 16-bit immediate is FFFF, so sign extending would give FFFFFFFF,
// shifting left would give us FFFFFFC.
// adding this value to PC+4 would make us go beyond the +/- 128Kb range?

module branch_addressor_tb();
  logic[31:0] imdt;
  logic[31:0] shifted;
  logic[31:0] pc;
  logic[31:0] b_addr;

  initial begin
    imdt = 32'h0000000F;
    pc = 32'h00000004;
    #1;
    $display("output=%d", b_addr);
    assert(b_addr == 32'd64);

  end

  branch_addressor inst0(.immdt_32(imdt), .pcnext(pc), .branch_addr(b_addr));

endmodule
