module mips_cpu_harvard(
    /* Standard signals */
    input logic     clk,
    input logic     reset,
    output logic    active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic     clk_enable,

    /* Combinatorial read access to instructions */
    output logic[31:0]  instr_address,
    input logic[31:0]   instr_readdata,

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0]  data_address,
    output logic        data_write,
    output logic        data_read,
    output logic[31:0]  data_writedata,
    input logic[31:0]  data_readdata
);

//PC
logic[31:0] PCnext;
PC PC_inst(
  .clk(clk),
  .reset(reset),
  .PCcurr(instr_address),
  .PCnext(PCnext)
);

//instruction_memory
instruction_memory instmem_inst(
  .clk(clk),
  .instr_address(instr_address),
  .instr_readdata(instr_readdata),
);

//control
logic rd_select, branch, jump1, jump2, alu_src, reg_wren, hi_wren, lo_wren, data_into_reg1, data_into_reg2;
logic write_enable;
logic[1:0] alu_op;
control control_inst(
  .opcode(instr_readdata[31:26]), .function_code(instr_readdata[5:0]), .b_code(instr_readdata[15:11]),
  .rd_select(rd_select),
  .branch(branch),
  .jump1(jump1),
  .jump2(jump2),
  .alu_op(alu_op),
  .alu_src(alu_src),
  .data_read(data_read),
  .data_write(data_write),
  .reg_wren(write_enable),
  .hi_wren(hi_wren),
  .lo_wren(lo_wren),
  .data_into_reg1(data_into_reg1),
  .data_into_reg2(data_into_reg1)
);

//mux_5bit rd_mux
logic write_reg_rd;
mux_5bit rd_mux(
  .select(rd_select),
  .in_0(instr_readdata[20:16]), .in_1(instr_readdata[15:11]),
  .out(write_reg_rd)
);

//register_file
logic[31:0] read_data_a, read_data_b, write_data;
register_file regfile_inst(
  .clk(clk),
  .reset(reset),
  .read_reg_a(instr_readdata[25:21]), .read_reg_b(instr_readdata[20:16]),
  .read_data_a(read_data_a), .read_data_b(read_data_b),
  .write_reg_rd(write_reg_rd),
  .write_data(write_data),
  .write_enable(write_enable)
);

//sign_extender
sign_extender signextender_inst(
  .immdt_16(instr_readdata[15:0]),
  .immdt_32(immdt_32)
);

//mux_32bit alumux
mux_32bit alumux(
  .select(alu_src),
  .in_0(read_data_b), .in_1(immdt_32),
  .out(write_data)
);

//alu_ctrl
alu_ctrl aluctrl_inst(
  .alu_op(alu_op),
  .opcode(instr_readdata[31:26]),
  .function_code(instr_readdata[5:0]),
  .alu_ctrl_in(alu_ctrl_in)
);


//alu

//reg_hi

//reg_lo

//branch_cond

//jump_addressor

//branch_addressor

//mux_32bit branchmux

//mux_32bit jump1mux

//mux_32bit jump2mux

//data_memory

//data_into_reg_mux1
//data_into_reg_mux2
