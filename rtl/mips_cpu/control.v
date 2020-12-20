// control logic block: sends control signals to different modules in the cpu based on the state and the instruction so cpu does what it is supposed to do.

module control(
  // inputs
  input logic reset,
  input logic[5:0] opcode,            // instruction[31:26]
  input logic[5:0] function_code,     // instruction[5:0]
  input logic[4:0] b_code,            // instruction[20:16]
  input logic[2:0] state,             // cpu state from mips_cpu_bus.v
  input logic waitrequest,            // from bus_memory.v
  input logic[1:0] byte_addressing,   // last 2 LSB of data address

  // memory related
  output logic read,                  // read enable signal to bus_memory.v
  output logic write,                 // write enable signal to bus_memory.v
  output logic[2:0] write_data_sel,   // control signal to writedata_selector.v, for store instructions
  output logic[3:0] byteenable,       // control signal to bus_memory.v for sb and sh instructions

  // register_file related
  output logic[1:0] rd_select,        // select signal to destination_reg_selector.v to select destination register
  output logic reg_write_enable,      // write enable signal for register in register_file.v
  output logic[2:0] datamem_to_reg,   // control signal to reg_writedata_selector.v, for load instructions
  output logic link_to_reg,           // control signal to reg_writedata_selector.v, for link instructions
  output logic mfhi, mflo,            // control signal to reg_writedata_selector.v, for mfhi and mflo instructions
  output logic lwl, lwr,              // control signals to register_file.v for lwl and lwr instructions
  // hi and lo registers related
  output logic hi_wren,               // write enable signal for reg_hi.v, for mthi, multiplication and division instructions
  output logic lo_wren,               // write enable signal for reg_lo.v, for mtlo, multiplication and division instructions
  output logic multdiv,               // control signal to reg_hi.v and reg_lo.v, for multiplication and divison instructions

  // alu related
  output logic imdt_sel,              // control signal to imdtmux, selects between sign extended or zero extended immediate for andi, ori, xori
  output logic alu_src,               // control signal to alumux, selects between read_data_b for R-type instructions or immdt_32 for I-type instructions
  output logic[1:0] alu_op,           // control signal to alu_ctrl.v, 0 for load/store instructions, 1 for BEQ/BNE, 2 for R-type instructions, 3 for I-type instructions

  // PC address related
  output logic branch,                // control signal to branch_cond.v, for branch instructions
  output logic jump,                  // control signal to PC_address_selector.v for J and JAL
  output logic jumpreg                // control signal to PC_address_selector.v for JR and JALR
);

logic [1:0] byte_addressing_2;
logic byte_addressing_1;
assign byte_addressing_2 = byte_addressing[1:0];
assign byte_addressing_1 = byte_addressing[1];

always_comb begin
  //reset
  if (reset) begin
    read = 0;
    write = 0;                        // write is disabled.
    byteenable = 4'b1111;
    write_data_sel= 0;
  end
  // cpu state = FETCH
  else if (state == 0) begin
    read = 1;                         // only reading of memory is enabled.
    write = 0;                        // write is disabled.
    byteenable = 4'b1111;
    write_data_sel= 0;
  end
  // cpu state = LOAD, LOAD_DATA
  else if (state == 1 | state == 3) begin
    read = 0;                         // only reading of memory is enabled.
    write = 0;                        // write is disabled.
    byteenable = 4'b1111;
    write_data_sel= 0;
  end
  // cpu state = MEM
  else if (state == 2) begin
    // store instructions: writing into memory. SB SH SW
    if( opcode==40 | opcode==41 | opcode==43 ) begin
      write =1 ;
      read = 0;
      // SB
      if(opcode==40) begin
        if(byte_addressing_2 == 2'b00) begin byteenable=4'b0001; write_data_sel= 1; end
        else if(byte_addressing_2 == 2'b01) begin byteenable=4'b0010; write_data_sel= 2; end
        else if(byte_addressing_2 == 2'b10) begin byteenable=4'b0100; write_data_sel= 3; end
        else if(byte_addressing_2 == 2'b11) begin byteenable=4'b1000; write_data_sel= 4; end
        else begin byteenable=4'b1111; write_data_sel= 0; end
      end
      // SH
      else if(opcode == 41) begin
        if(byte_addressing_1 == 0) begin byteenable=4'b0011; write_data_sel= 5; end
        else if(byte_addressing_1 == 1) begin byteenable=4'b1100; write_data_sel= 6; end
        else begin byteenable=4'b1111; write_data_sel= 0; end
      end
      // SW
      else begin
        byteenable = 4'b1111;
        write_data_sel= 0;
      end
    end

    // load instructions: reading from memory. LB, LH, LWL, LW, LBU, LHU, LWR
    else if ( opcode==32 | opcode==33 | opcode==34 | opcode==35 | opcode==36 | opcode== 37 | opcode==38 ) begin
      read=1;
      write=0;
      byteenable = 4'b1111;
      write_data_sel= 0;
    end

    // non load/store instructions: do nothing in MEM state
    else begin
      read=0;
      write=0;
      byteenable = 4'b1111;
      write_data_sel= 0;

    end
  end
  else begin
    byteenable = 4'b1111;
    read = 0;
    write = 0;
    write_data_sel= 0;
  end
end

always_comb begin
  if (reset| state == 0 | state  == 1 | state == 2 | state == 3) begin
    reg_write_enable = 0;             // to ensure that registers are not written to during fetch state.
    alu_op = 2'b00;                  // to ensure that memory address is calculated in MEM state.
    alu_src = 1;
    rd_select = 0;
    reg_write_enable = 1'd0;
    datamem_to_reg = 0;
    link_to_reg = 1'd0;
    mfhi = 0;
    mflo = 0;
    lwl = 0;
    lwr = 0;
    hi_wren = 0;
    lo_wren = 0;
    multdiv = 0;
    imdt_sel = 0;
    alu_src = 1;
    branch = 0;
    jump = 0;
    jumpreg = 0;
  end

  // cpu state = EXEC
  else if (state == 4) begin
    // rd_select: select signal to destination_reg_selector.v to select destination register
    case (opcode)
      0: rd_select = 1;                                 // R-type instructions
      1: rd_select = (b_code==16|b_code==17) ? 2'd2 : 2'd0;   // BLTZAL, BGEZAL
      3: rd_select = 2;                                 // JAL
      default: rd_select = 0;                           // I-type instructions
    endcase

    // reg_write_enable: write enable signal to register_file.v. for instructions that write into a register - arithmetic, logical operations, shifts, setting, loads etc
    case (opcode)
      0: reg_write_enable = ( (function_code == 8) | (function_code == 17) |(function_code == 19) | (function_code == 24) | (function_code== 25) | (function_code==26) | (function_code== 27)) ? 1'd0 : 1'd1; //0 for R-type instructions that do not write into a register: JR, MTHI, MTLO, multiply and divide
      1: reg_write_enable = ( (b_code == 17) | (b_code == 16) ) ? 1'd1 : 1'd0;    // for BGEZAL and BLTZAL
      3,9,10,11,12,13,14,15,32,33,34,35,36,37,38: reg_write_enable = 1'd1;     // for JAL, ADDIU, SLTI, SLTIU, ANDI, ORI, XORI, LUI, LB, LH, LWL, LW, LBU, LHU, LWR
      default: reg_write_enable = 1'd0;
    endcase

    // datamem_to_reg: control signal to reg_writedata_selector.v, for load instructions.
    case (opcode)
      34,35,38: datamem_to_reg = 1;  // LW, LWL, LWR
      32: datamem_to_reg = 2;        // LB
      36: datamem_to_reg = 3;        // LBU
      33: datamem_to_reg = 4;        // LH
      37: datamem_to_reg = 5;        // LHU
      default: datamem_to_reg = 0;
    endcase

    // link_to_reg: control signal to reg_writedata_selector.v, for link instructions.
    link_to_reg = ( opcode==3 | (opcode==0 & function_code==9) | (opcode==1 & (b_code==16|b_code==17)) ) ? 1'd1 : 1'd0;   // JAL, JALR, BGEZAL, BLTZAL

    // mfhi, mflo: control signal to reg_writedata_selector.v, for mfhi and mflo instructions.
    case (function_code)
      16: mfhi = (opcode==0) ? 1'd1 : 1'd0;
      default: mfhi = 0;
    endcase
    case (function_code)
      18: mflo = (opcode==0) ? 1'd1 : 1'd0;
      default: mflo = 0;
    endcase

    // lwl: control signal to register_file.v
    case(opcode)
      34: lwl = 1;
      default: lwl = 0;
    endcase
    // lwr: control signal to register_file.v
    case(opcode)
      38: lwr = 1;
      default: lwr = 0;
    endcase

    // hi_wren: write enable signal for reg_hi.v, for mthi, multiplication and division instructions
    case(function_code)
      17,24,25,26,27: hi_wren = (opcode==0) ? 1'd1 : 1'd0;   // for MTHI, MULT, MULTU, DIV, DIVU
      default: hi_wren = 0;
    endcase

    // lo_wren: write enable signal for reg_lo.v, for mtlo, multiplication and division instructions
    case(function_code)
      19,24,25,26,27: lo_wren = (opcode==0) ? 1'd1 : 1'd0;   // for MTLO, MULT, MULTU, DIV, DIVU
      default: lo_wren = 0;
    endcase

    // multdiv: control signal to reg_hi.v and reg_lo.v, for multiplication and divison instructions
    case(function_code)
      24,25,26,27: multdiv = (opcode==0) ? 1'd1 : 1'd0;      // for MULT, MULTU, DIV, DIVU
      default: multdiv = 0;
    endcase

    // imdt_sel: control signal to imdtmux, selects between sign extended or zero extended immediate for andi, ori, xori
    case (opcode)
      12,13,14: imdt_sel = 1;    // for ANDI, ORI, XORI
      default: imdt_sel = 0;
    endcase

    // alu_src: control signal to alumux, selects between read_data_b for R-type instructions/BEQ/BNE or immdt_32 for I-type instructions
    case (opcode)
      0,4,5: alu_src = 0;       // for R-type instructions, BEQ, BNE
      default: alu_src = 1;     // for I-type instructions
    endcase

    // alu_op: control signal to alu_ctrl.v, 0 for load/store instructions, 1 for BEQ/BNE, 2 for R-type instructions, 3 for I-type instructions
    alu_op[1:0] = (opcode==0) ? 2'd2 :                                                                      // 2 for R-type instructions
                  (opcode==4|opcode==5) ? 2'd1 :                                                            // 1 for BEQ, BNE
                  (opcode==9|opcode==10|opcode==11|opcode==12|opcode==13|opcode==14|opcode==15) ? 2'd3 : 2'd0; // 3 for I-type instructions, 0 for anything else including load/store instructions

    //branch: control signal to branch_cond.v, for branch instructions.
    case (opcode)
      1,4,5,6,7: branch = 1; // for BGEZ, BGEZAL, BLTZ, BLTZAL, BEQ, BNE, BLEZ, BGTZ
      default: branch = 0;
    endcase

    //jump: goes to high for J and JAL instructions. control signal to PC_address_selector.v to select jump_addr calculated by jump_addressor
    case (opcode)
      2,3: jump = 1;        // for J, JAL
      default: jump = 0;
    endcase

    //jumpreg: goes to high for JR and JALR instructions. control signal to PC_address_selector.v to select read_data_a
    case (function_code)
      8,9: jumpreg = (opcode == 0) ? 1'd1 : 1'd0;   // for JR, JALR
      default: jumpreg = 0;
    endcase
  end
  else begin
    reg_write_enable = 0;
    alu_op = 2'b00;                  // to ensure that memory address is calculated in MEM state.
    alu_src = 1;
    rd_select = 0;
    reg_write_enable = 1'd0;
    datamem_to_reg = 0;
    link_to_reg = 1'd0;
    mfhi = 0;
    mflo = 0;
    lwl = 0;
    lwr = 0;
    hi_wren = 0;
    lo_wren = 0;
    multdiv = 0;
    imdt_sel = 0;
    alu_src = 1;
    branch = 0;
    jump = 0;
    jumpreg = 0;
  end
end

endmodule
