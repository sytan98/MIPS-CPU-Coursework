module control(
  input logic[5:0] opcode,
  input logic[5:0] funct_code,  //for JR and JALR. funct codes for other R-type instructions will be handled in alu_ctrl
  input logic[5:0] b_code
  output logic rd_select,
  output logic branch,
  output logic jump1,
  output logic jump2,
  output logic[1:0] alu_op,
  output logic alu_src,
  output logic data_read,
  output logic data_write,
  output logic reg_wren,
  output logic lo_wren,
  output logic hi_wren,
  output logic data_into_reg1,
  output logic data_into_reg2
);

always @(*) begin
  rd_select = (opcode==0) ? 1 : 0;
  branch = (opcode==1|opcode==4|opcode==6|opcode==7) ? 1 : 0;
  jump1 = (opcode==2|opcode==3) ? 1 : 0;
  jump2 = (funct_code==8|funct_code==9) ? 1 : 0;
  alu_op[1:0] = (opcode==0) ? 2'd2 :
                (opcode==4|opcode==5) ? 2'd1 :
                (opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15) ? 2'd3 : 0;
  alu_src = (opcode==0) ? 0 : 1;
  data_read = (opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  data_write = (opcode==40|opcode==41|opcode==43) ? 1 : 0;
  reg_wren = (opcode==0|opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15|opcode==32|opcode==33|opcode==34|opcode==35|opcode==36|opcode==37|opcode==38) ? 1 : 0;
  lo_wren = (opcode==19) ? 1 : 0;
  hi_wren = (opcode==17) ? 1 : 0;
  data_into_reg1 = (opcode==40|opcode==41|opcode==43) ? 1 : 0;
  data_into_reg2 = (opcode==3|funct_code==9|b_code==17|b_code==16) ? 1 : 0;
end


endmodule
