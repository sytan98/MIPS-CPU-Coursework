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
  output logic write_enable,
  output logic hi_wren,
  output logic lo_wren,
  output logic data_into_reg1,
  output logic data_into_reg2
);

always @(*) begin
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
  rd_select = (opcode==0) ? 1 : 0;
  imdt_sel = (opcode==12|opcode==13|opcode==14) ? 1 : 0;
  // branch = (opcode==1|opcode==4|opcode==6|opcode==7) ? 1 : 0;
  // jump1 = (opcode==2|opcode==3) ? 1 : 0;
  // jump2 = (opcode==0 &(function_code==8|function_code==9)) ? 1 : 0;
  alu_op[1:0] = (opcode==0) ? 2'd2 :
                (opcode==4|opcode==5) ? 2'd1 :
                (opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15) ? 2'd3 : 0;
  alu_src = (opcode==0|opcode==4|opcode==5) ? 0 : 1;
  data_read = (opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  data_write = (opcode==40|opcode==41|opcode==43) ? 1 : 0;
  write_enable = (opcode==0|opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15|opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  hi_wren = (opcode==17) ? 1 : 0;
  lo_wren = (opcode==19) ? 1 : 0;
  data_into_reg1 = (opcode==40|opcode==41|opcode==43) ? 1 : 0;
  data_into_reg2 = (opcode==3|function_code==9|b_code==17|b_code==16) ? 1 : 0;
end

endmodule
