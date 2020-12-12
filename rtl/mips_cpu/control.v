module control(
  // inputs
  input logic reset,
  input logic[5:0] opcode,            // instruction[31:26]
  input logic[5:0] function_code,     // instruction[5:0]
  input logic[4:0] b_code,            // instruction[20:16]
  input logic[2:0] state,             // cpu state from mips_cpu_bus.v
  input logic waitrequest,            // from bus_memory.v
  input logic[1:0] byte_addressing,  // last 2 LSB of data address

  // register_file related
  output logic[1:0] rd_select,        // select signal to destination_reg_selector.v to select destination register
  output logic reg_write_enable,      // write enable signal for register in register_file.v
  output logic[2:0] datamem_to_reg,   // control signal to reg_writedata_selector.v, for load instructions
  output logic link_to_reg,           // control signal to reg_writedata_selector.v, for link instructions
  output logic mfhi, mflo,            // control signal to reg_writedata_selector.v, for mfhi and mflo instructions
  output logic lwl, lwr,              // signal to register_file.v for lwl and lwr instructions
  // hi and lo registers related
  output logic hi_wren,               // write enable signal for reg_hi.v, for mthi, multiplication and division instructions
  output logic lo_wren,               // write enable signal for reg_lo.v, for mtlo, multiplication and division instructions
  output logic multdiv,               // control signal to reg_hi.v and reg_lo.v, for multiplication and divison instructions

  // memory related
  output logic read,                  // read enable signal to bus_memory.v
  output logic write,                 // write enable signal to bus_memory.v
  output logic[4:0] write_data_sel,  // control signal to writedata_selector.v, for store instructions
  output logic[3:0] byteenable,      // control signal to bus_memory.v for sb and sh instructions

  // alu related
  output logic imdt_sel,              // control signal to imdtmux, selects between sign extended or zero extended immediate for andi, ori, xori
  output logic alu_src,               // control signal to alumux, selects between read_data_b for R-type instructions or immdt_32 for I-type instructions
  output logic[1:0] alu_op,           // control signal to alu_ctrl.v, 0 for load/store instructions, 1 for BEQ/BNE, 2 for R-type/I-type instructions

  // PC address related
  output logic branch,                // control signal to branch_cond.v, for branch instructions
  output logic jump,                  // control signal to PC_address_selector.v for J and JAL
  output logic jumpreg              // control signal to PC_address_selector.v for JR and JALR
);

always @(*) begin
  //reset
  if (reset) begin
    read = 1;
    byteenable = 4'b1111;
  end
  //Fetch
  else if (state == 0) begin
    read = 1;
    write = 0;
    byteenable = 4'b1111;
    reg_write_enable = 0;
  end
  //mem
  else if (state == 1) begin
    if(opcode==40 | opcode==41 | opcode==43) begin
      write=1;
      read=0;
      //SB
      if(opcode==40) begin
        if(byte_addressing[1:0] == 2'b00) begin byteenable=4'b0001; write_data_sel= 1; end
        else if(byte_addressing[1:0] == 2'b01) begin byteenable=4'b0010; write_data_sel= 2; end
        else if(byte_addressing[1:0] == 2'b10) begin byteenable=4'b0100; write_data_sel= 3; end
        else if(byte_addressing[1:0] == 2'b11) begin byteenable=4'b1000; write_data_sel= 4; end
      end
      //SH
      else if(opcode==41) begin
        if(byte_addressing[1] == 0) begin byteenable=4'b0011; write_data_sel= 5; end
        else if(byte_addressing[1] == 1) begin byteenable=4'b1100; write_data_sel= 6; end
        end
      //SW
      else begin
        byteenable = 4'b1111;
      end

    end
    else if (opcode==35 | opcode==32 | opcode==33 | opcode==34 | opcode==36 | opcode== 37 | opcode==38 ) begin
      read=1;
      write=0;
      byteenable = 4'b1111;
    end
    else begin
      read=0;
      write=0;
      byteenable = 4'b1111;
    end


    alu_op = 2'b00;
    alu_src = 1;

  end

  //Exec
  else if (state == 2) begin
    byteenable = 4'b1111;
    read = 0;
    write = 0;
    write_data_sel= 0;
    //rd_select: selects either 0:rt for i-type instructions or 1:rd for r-type instructions to be the destination register that we write to.
    case (opcode)
      0: rd_select = 1;
      1: rd_select = (b_code==16|b_code==17) ? 2 : 0;   //BLTZAL, BGEZAL
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

    //jump: goes to high for J and JAL instructions. control signal to PC_address_selector.v to select jump_addr calculated by jump_addressor
    case (opcode)
      2,3: jump = 1;
      default: jump = 0;
    endcase

    //jumpreg: goes to high for JR and JALR instructions. control signal to PC_address_selector.v to select read_data_a
    case (function_code)
      8,9: jumpreg = (opcode == 0) ? 1 : 0;
      default: jumpreg = 0;
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

    //lwl
    case(opcode)
      34: lwl = 1;
      default: lwl = 0;
    endcase
    //lwr
    case(opcode)
      38: lwr = 1;
      default: lwr = 0;
    endcase
  end
end

endmodule
