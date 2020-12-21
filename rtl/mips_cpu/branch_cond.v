// used to check if the conditions for a branch to be taken has been met.
// takes in the different opcodes and b_codes (needed as some branch instructions have same opcode)
// to tell which branch instruction is happening and hence check for the different conditions.
// depending on the branch instruction, condition_met will go to high if the appropriate conditions have been met.

module branch_cond(
  input logic branch,            // from control.v for branch instructions
  input logic[5:0] opcode,       // instruction[31:26]
  input logic[4:0] b_code,       // instruction[20:16]
  input logic equal,             // zero flag from alu.v, will be high if values in two registers are equal
  input logic[31:0] read_data_a, // data read from register rs.
  output logic condition_met     // control signal to PC_address_selector.v to select the branch target address.
);

  logic zero;
  logic neg;

  assign zero = (read_data_a[31:0]==32'h00000000) ? 1'd1 : 1'd0; //if value of rs = 0
  assign neg = (read_data_a[31]==1) ? 1'd1 : 1'd0;               //if value of rs < 0


  always_comb begin
    case(opcode)
      4: condition_met = (branch &  equal) ? 1'd1 : 1'd0;        //BEQ
      5: condition_met = (branch & !equal) ? 1'd1 : 1'd0;        //BNE
      7: condition_met = (branch & !zero & !neg) ? 1'd1 : 1'd0;  //BGTZ
      6: condition_met = (branch & (zero | neg)) ? 1'd1 : 1'd0;  //BLEZ
      1: condition_met = ( ((b_code==1|b_code==17)&(branch&!neg)) | ((b_code==0|b_code==16)&(branch&neg)) ) ? 1'd1 : 1'd0;
                                                           //BGEZ, BGEZAL, BLTZ, BLTZAL
      default: condition_met = 0;                          //condition for branch to be taken has not been met, branch will not be taken
    endcase
  end

endmodule
