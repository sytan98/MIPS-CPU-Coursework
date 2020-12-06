module control(
  input logic[5:0] opcode,
  input logic[5:0] function_code,
  input logic[4:0] b_code,
  output logic [1:0] rd_select,
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
  output logic[2:0] datamem_to_reg,
  output logic link_to_reg,
  output logic mfhi,
  output logic mflo,
  output logic multdiv
);

always @(*) begin

  //rd_select: selects either 0:rt for i-type instructions or 1:rd for r-type instructions to be the destination register that we write to.
  case (opcode)
    0: rd_select = 1;
    1: rd_select = (b_code==16|b_code==17) ? 2:0;
    3: rd_select = 2;
    default: rd_select = 0;
  endcase

  //imdt_sel: selects either the 1:zero-extended immediate for ANDI, ORI, XORI or the 0:sign-extended immediate for other i-type instructions.
  case (opcode)
    12,13,14: imdt_sel = 1;
    default: imdt_sel = 0;
  endcase

  //branch: goes to high for branch instructions. checking if the conditions for branch to be taken has been met is done in branch_cond.v
  case (opcode)
    1,4,5,6,7: branch = 1;
    default: branch = 0;
  endcase

  //jump1: goes to high for J and JAL instructions. control signal to PC_address_selector.v to select jump_addr calculated by jump_addressor
  case (opcode)
    2,3: jump1 = 1;
    default: jump1 = 0;
  endcase

  //jump2: goes to high for JR and JALR instructions. control signal to PC_address_selector.v to select read_data_a
  case (function_code)
    8,9: jump2 = (opcode == 0) ? 1 : 0;
    default: jump2 = 0;
  endcase

  //alu_src: selects between 0:read_data_b for r-type instructions and 1:immediate for i-type instructions to be the 2nd input to the ALU
  case (opcode)
    0,4,5: alu_src = 0;
    default: alu_src = 1;
  endcase

  //alu_op: control signal to alu_ctrl.v
  alu_op[1:0] = (opcode==0) ? 2'd2 :
                (opcode==4|opcode==5) ? 2'd1 :
                (opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15) ? 2'd3 : 0;

  //data_write: write enable signal to datamem for store instructions (storing from register into memory)
  case (opcode)
    40,41,43: data_write = 1;
    default: data_write = 0;
  endcase

  //data_read: read enable signal to datamem. for load instructions (loading from memory into register)
  case (opcode)
    32,33,34,35,36,37,38: data_read = 1;
    default: data_read = 0;
  endcase

  //reg_write_enable: write enable signal to register_file. for instructions that write into a register so arithmetic, logical operations, shifts, setting etc
  case (opcode)
    0: reg_write_enable = ( (function_code == 8) | (function_code == 17) |(function_code == 19) | (function_code == 24) | (function_code== 25) | (function_code==26) | (function_code== 27)) ? 0 : 1;
    1: reg_write_enable = ( (b_code == 17) | (b_code == 16) ) ? 1 : 0;
    3,9,10,11,12,13,14,15,32,33,34,35,36,37,38: reg_write_enable = 1;
    default: reg_write_enable = 0;
  endcase

  //hi_wren, lo_wren: write enable signal to hi and lo registers. for mthi and mtlo
  case(function_code)
    17,24,25,26,27: hi_wren = (opcode==0) ? 1 : 0;
    default: hi_wren = 0;
  endcase
  case(function_code)
    19,24,25,26,27: lo_wren = (opcode==0) ? 1 : 0;
    default: lo_wren = 0;
  endcase

  //datamem_to_reg: control signal to reg_writedata_selector.v selects data from datamemory to be written into destination register for load instructions
  case (opcode)
    34,35,38: datamem_to_reg = 1;
    32: datamem_to_reg = 2;//lb
    36: datamem_to_reg = 3;//lbu
    33: datamem_to_reg = 4;//lh
    37: datamem_to_reg = 5;//lhu
    default: datamem_to_reg = 0;
  endcase

  //link_to_reg: control signal to reg_writedata_selector.v selects pc_plus4 to be written into dst reg for link instructions (JAL, JALR, BGEZAL, BLTZAL)
  link_to_reg = ( opcode==3 | (opcode==0 & function_code==9) | (opcode==1 & (b_code==16|b_code==17)) ) ? 1 : 0;

  //mfhi, mflo: control signal to reg_writedata_selector.v selects value stored in hi or lo registers to be written into dst reg for mfhi and mflo.
  case (function_code)
    16: mfhi = (opcode==0) ? 1 : 0;
    default: mfhi = 0;
  endcase
  case (function_code)
    18: mflo = (opcode==0) ? 1 : 0;
    default: mflo = 0;
  endcase

  //multdiv: write enable signal for hi and lo registers to update with value of hi and lo from alu during mult and div instructions.
  case(function_code)
    24,25,26,27: multdiv = (opcode==0) ? 1 : 0;
    default: multdiv = 0;
  endcase
end

endmodule
