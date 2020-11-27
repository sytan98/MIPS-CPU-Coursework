// branch target address is calculated by:
// 1. taking 16-bit immediate and sign extending it to 32 bits
// 2. shifting the 32-bit number to the left by 2 bits for word alignment
// 3. adding the shifted number to PC+4 to get branch target address
// so let's say our 16-bit immediate is FFFF, so sign extending would give FFFFFFFF,
// shifting left would give us FFFFFFC.
// adding this value to PC+4 would make us go beyond the +/- 128Kb range that's mentioned in the MIPS ISA Specification Revision 3.2?

module branch_addressor_tb();
  logic[31:0] imdt;
  logic[31:0] shifted;
  logic[31:0] pc;
  logic[31:0] b_addr;

  initial begin
    //test for branching forwards
    imdt = 32'd8;
    pc = 32'd16;
    #1;
    $display("branch target address:%d", b_addr);
    assert($signed(b_addr) == 32'd48);

    //test for branching backwards
    imdt = 32'hFFFFFFF8;
    pc = 32'd40;
    #1;
    $display("branch target address:%d", b_addr);
    assert($signed(b_addr) == 32'd8);

    //edgecase for forward branches, immediate in decimal is 32767
    imdt = 32'h00007FFF;
    pc = 32'd8;
    #1;
    $display("branch target address:%d", b_addr);
    assert($signed(b_addr) == 32'd131076);

    //edgecase for backward branches, immediate in decimal is -32768
    imdt = 32'hFFFF8000;
    pc = 32'd160000;
    #1;
    $display("branch target address:%d", b_addr);
    assert($signed(b_addr) == 32'd28928);
  end

  branch_addressor inst0(.immdt_32(imdt), .pcnext(pc), .branch_addr(b_addr));

endmodule
