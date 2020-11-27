module branch_cond(
  input logic branch,
  input logic[5:0] opcode,
  input logic[5:0] b_code,
  input logic equal, //zero flag from alu.v
  input logic[31:0] rs_readdata, //data read from register rs.
  output logic condition_met //will be used as a control signal to branchmux that selects btwn 0:PC+4 or 1:branch target address
);

  logic zero;
  logic neg;

  assign zero = (rs_readdata[31:0]==32'h00000000) ? 1 : 0; //if value of rs = 0
  assign neg = (rs_readdata[31]==1) ? 1 : 0; //if value of rs < 0


  always@(*) begin
    case(opcode)
      4: condition_met = (branch &  equal) ? 1 : 0; //BEQ
      5: condition_met = (branch & !equal) ? 1 : 0; //BNE
      7: condition_met = (branch & !zero & !neg) ? 1 : 0;//BGTZ
      6: condition_met = (branch & (zero | neg)) ? 1 : 0; //BLEZ
      1: case(b_code)
          1, 17: condition_met = (branch & !neg) ? 1 : 0; //BGEZ, BGEZAL
          0, 16: condition_met = (branch &  neg) ? 1 : 0; //BLTZ, BLTZAL
         endcase
    endcase
  end

endmodule
