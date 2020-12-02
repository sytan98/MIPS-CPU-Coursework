module control(
  input logic[5:0] opcode,
  input logic[5:0] function_code,
  input logic[4:0] b_code,
  output logic rd_select,
  output logic imdt_sel,
  output logic branch,
  output logic jump1,
  output logic jump2,
  output logic[1:0] alu_op,
  output logic alu_src,
  output logic data_read,
  output logic data_write,
  output logic reg_write_enable,
  output logic hi_wren,
  output logic lo_wren,
  output logic data_into_reg1,
  output logic data_into_reg2
);

always @(*) begin
  case (opcode)
    0: rd_select = 1;
    default: rd_select = 0;
  endcase
  case (opcode)
    12,13,14: imdt_sel = 1;
    default: imdt_sel = 0;
  endcase
  case (opcode)
    1,4,6,7: branch = 1;
    default: branch = 0;
  endcase
  case (opcode)
    2,3: jump1 = 1;
    default: jump1 = 0;
  endcase
  case (function_code)
    8,9: jump2 = (opcode == 0) ? 1 : 0;
    default: jump2 = 0;
  endcase
  case (opcode)
    0,4,5: alu_src = 0;
    default: alu_src = 1;
  endcase
  alu_op[1:0] = (opcode==0) ? 2'd2 :
                (opcode==4|opcode==5) ? 2'd1 :
                (opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15) ? 2'd3 : 0;
  case (opcode)
    0,4,5: alu_src = 0;
    default: alu_src = 1;
  endcase
  case (opcode)
    40,41,43: data_write = 1;
    default: data_write = 0;
  endcase
  data_read = (opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  reg_write_enable = (opcode==0|opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15|opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  hi_wren = (opcode==17) ? 1 : 0;
  lo_wren = (opcode==19) ? 1 : 0;
  case (opcode)
    32,33,34,35, 36, 37, 38: data_into_reg1 = 1;
    default: data_into_reg1 = 0;
  endcase
  case (opcode)
    3: data_into_reg2 = 1;
    default: case (function_code)
               9: data_into_reg2 = 1;
               default: case(b_code)
                          16,17: data_into_reg2 = 1;
                          default: data_into_reg2 = 0;
                        endcase
             endcase
  endcase
end

endmodule
