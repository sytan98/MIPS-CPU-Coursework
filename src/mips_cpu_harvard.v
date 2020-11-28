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

  // not sure on how to implement reset, active and register_v0 yet
  // initial begin
  //   active = 0;
  // end
  //
  // if (reset) begin
  //   active = 1;
  // end
  //
  // register_v0 = read_data_a;


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
  .instr_readdata(instr_readdata)
);

//control
logic rd_select, imdt_sel, branch, jump1, jump2, alu_src, write_enable, hi_wren, lo_wren, data_into_reg1, data_into_reg2;
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
  .write_enable(write_enable),
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

//immdt_extender
logic[31:0] signed_32, zero_32;
immdt_extender imdtextd_inst(
  .immdt_16(instr_readdata[15:0]),
  .sign_immdt_32(signed_32), .zero_immdt_32(zero_32)
);

//immdt mux
logic[31:0] immdt_32;
mux_32bit imdtmux(
  .select(imdt_sel),
  .in_0(signed_32), .in_1(zero_32),
  .out(immdt_32)
);

//mux_32bit alumux
logic[31:0] alu_in;
mux_32bit alumux(
  .select(alu_src),
  .in_0(read_data_b), .in_1(immdt_32),
  .out(alu_in)
);

//alu_ctrl
logic[4:0] alu_ctrl_in;
alu_ctrl aluctrl_inst(
  .alu_op(alu_op),
  .opcode(instr_readdata[31:26]),
  .function_code(instr_readdata[5:0]),
  .alu_ctrl_in(alu_ctrl_in)
);

//alu
logic[31:0] alu_out, lo, hi;
logic zero;
alu alu_inst(
  .alu_ctrl_in(alu_ctrl_in),
  .A(read_data_a),
  .B(alu_in),
  .shamt(instr_readdata[10:6]),
  .alu_out(alu_out),
  .zero(zero),
  .lo(lo),
  .hi(hi)
);

//reg_hi
logic[31:0] hi_read;
reg_hi reghi_inst(
  .clk(clk),
  .hi_wren(hi_wren),
  .read_data_a(read_data_a),
  .hi(hi),
  .hi_read(hi_read)
);

//reg_lo
logic[31:0] lo_read;
reg_lo reglo_inst(
  .clk(clk),
  .lo_wren(lo_wren),
  .read_data_a(read_data_a),
  .lo(lo),
  .lo_read(lo_read)
);

//branch_cond
logic condition_met;
branch_cond branchcond_inst(
  .branch(branch),
  .opcode(instr_readdata[31:26]), .b_code(instr_readdata[15:11]),
  .equal(zero),
  .read_data_a(read_data_a),
  .condition_met(condition_met)
);

//jump_addressor
logic[31:0] jump_addr;
jump_addressor j_calc(
  .j_immdt(instr_readdata[25:0]),
  .pc_4msb(PCnext[31:28]),
  .jump_addr(jump_addr)
);

//branch_addressor
logic[31:0] branch_addr;
branch_addressor b_calc(
  .immdt_32(immdt_32),
  .PCnext(PCnext),
  .branch_addr(branch_addr)
);

//mux_32bit branchmux
logic[31:0] bmuxout;
mux_32bit branchmux(
  .select(condition_met),
  .in_0(PCnext), .in_1(branch_addr),
  .out(bmuxout)
);
//mux_32bit jump1mux
logic[31:0] jmuxout;
mux_32bit jump1mux(
  .select(jump1),
  .in_0(bmuxout), .in_1(jump_addr),
  .out(jmuxout)
);
//mux_32bit jump2mux
mux_32bit jump2mux(
  .select(jump2),
  .in_0(jmuxout), .in_1(read_data_a),
  .out(instr_address)
);

//data_memory
data_memory datamem_inst(
  .clk(clk),
  .data_address(data_address),
  .data_read(data_read),
  .data_write(data_write),
  .data_writedata(data_writedata),
  .data_readdata(data_readdata)
);

//data_into_reg_mux1
logic[31:0] data1muxout;
mux_32bit data1mux(
  .select(data_into_reg1),
  .in_0(alu_out), .in_1(data_readdata),
  .out(data1muxout)
);

//data_into_reg_mux2
mux_32bit data2mux(
  .select(data_into_reg2),
  .in_0(data1muxout), .in_1(PCnext),
  .out(write_data)
);
