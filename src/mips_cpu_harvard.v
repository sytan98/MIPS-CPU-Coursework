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
    input logic[31:0]  data_readdata,
    output logic[1:0] check_state, //for debugging
    output logic[31:0] check_pcout //for debugging
);

//cpu state
typedef enum logic[1:0] {
        FETCH = 2'b00,
        EXEC = 2'b01,
        HALTED = 2'b11
} state_t;
logic[1:0] state;

//Wire Definition
logic[31:0] pcin;
logic[31:0] pcout;
logic[31:0] pc_plus4;
logic [1:0]rd_select;
logic imdt_sel, branch, jump1, jump2, alu_src, reg_write_enable, hi_wren, lo_wren, data_into_reg1, data_into_reg2;
logic[1:0] alu_op;
logic[4:0] write_reg_rd;
logic[31:0] read_data_a, read_data_b, reg_write_data;
logic[31:0] signed_32, zero_32;
logic[31:0] immdt_32;
logic[31:0] alu_in;
logic[4:0] alu_ctrl_in;
logic[31:0] alu_out, lo, hi;
logic zero;

logic[31:0] hi_readdata;
logic[31:0] lo_readdata;
logic condition_met;
logic[31:0] jump_addr;
logic[31:0] branch_addr;
logic[31:0] tgt_addr_0;
logic[31:0] tgt_addr_1;

logic[31:0] data1muxout;
logic delay;

assign check_state = state; //for debugging
assign check_pcout = pcout; //for debugging
assign instr_address = pcout;
assign data_writedata = read_data_b;
assign data_address = alu_out;

initial begin
    state = HALTED;
    active = 0;
    delay = 0;
end

always @(posedge clk) begin
    if (reset) begin
        $display("CPU : INFO  : Resetting.");
        state <= EXEC;
        active <= 1;
    end
    else if (state == EXEC) begin
        $display("CPU : INFO  : Executing.");

        //Current address
        $display("current PC address=%h", pcout);
        $display("current inst address=%h", instr_address);
        $display("current inst =%h", instr_readdata);

        //Branch Related
        $display("opcode =%d", instr_readdata[31:26]);
        $display("branch =%h", branch);
        $display("jump1 =%h", jump1);
        $display("jump2 =%h", jump2);
        $display("condition_met =%h", condition_met);
        $display("tgt_addr_0 =%h", tgt_addr_0);
        $display("tgt_addr_1 =%h", tgt_addr_1);
        $display("delay =%h", delay);
        $display("branch address =%h", branch_addr);
        // $display("next PC =%d", pcin);

        //Register Values
        $display("Reading Register A=%d", instr_readdata[25:21]);
        $display("Reading Register B=%d", instr_readdata[20:16]);
        $display("Data from Reg A=%h", read_data_a);
        $display("Data from Reg B=%h", read_data_b);
        $display("Register being written to=%d", write_reg_rd);
        $display("Reg Write Data=%h", reg_write_data);
        $display("Write Data to data mem=%h", data_write);
        // $display("Data1 MUX=%h", data_into_reg1);
        // $display("Data2 MUX=%h", data_into_reg2);
        // $display("Data read data=%h", data_readdata);
        // $display("sign extended immediate=%h", immdt_32);

        //ALU 
        $display("alu_src=%b", alu_src);
        $display("alu out=%h", alu_out);
        $display("value going into hi=%h", hi);
        $display("value going into lo=%h", lo);
        // $display("data_readdata=%h", data_readdata);
        $display("data_into_reg1=%b", data_into_reg1);
        $display("data_into_reg2=%b", data_into_reg2);
        // $display("data read signal=%h", data_read);
        $display("Data address=%h", data_address);
        if (instr_address == 0) begin
            state <= HALTED;
            active <= 0;
        end
        if (branch|jump1|jump2) begin
            delay <= 1;
        end
        else begin
            delay <= 0;
        end
    end
    else if (state == HALTED) begin
        //do nothing
        //potential bug, still increments pc?
    end
end


//PC
pc pc_inst(
  .clk(clk), .reset(reset), .clk_enable(clk_enable),
  .pcin(pcin),
  .pcout(pcout)
);

//PCadder
pc_adder pcadder_inst(
  .pcout(pcout),
  .pc_plus4(pc_plus4)
);

// control
control control_inst(
  .opcode(instr_readdata[31:26]), .function_code(instr_readdata[5:0]), .b_code(instr_readdata[20:16]),
  .rd_select(rd_select),
  .imdt_sel(imdt_sel),
  .branch(branch),
  .jump1(jump1),
  .jump2(jump2),
  .alu_op(alu_op),
  .alu_src(alu_src),
  .data_read(data_read),
  .data_write(data_write),
  .reg_write_enable(reg_write_enable),
  .hi_wren(hi_wren),
  .lo_wren(lo_wren),
  .data_into_reg1(data_into_reg1),
  .data_into_reg2(data_into_reg2)
);

//mux_5bit rd_mux
mux_5bit rd_mux(
  .select(rd_select),
  .in_0(instr_readdata[20:16]), .in_1(instr_readdata[15:11]),
  .out(write_reg_rd)
);

//register_file
register_file regfile_inst(
  .clk(clk),
  .clk_enable(clk_enable),
  .reset(reset),
  .read_reg_a(instr_readdata[25:21]), .read_reg_b(instr_readdata[20:16]),
  .read_data_a(read_data_a), .read_data_b(read_data_b),
  .write_reg_rd(write_reg_rd),
  .reg_write_data(reg_write_data),
  .reg_write_enable(reg_write_enable),
  .register_v0(register_v0)
);

//immdt_extender
immdt_extender imdtextd_inst(
  .immdt_16(instr_readdata[15:0]),
  .sign_immdt_32(signed_32), .zero_immdt_32(zero_32)
);

//immdt mux
mux_32bit imdtmux(
  .select(imdt_sel),
  .in_0(signed_32), .in_1(zero_32),
  .out(immdt_32)
);

//mux_32bit alumux
mux_32bit alumux(
  .select(alu_src),
  .in_0(read_data_b), .in_1(immdt_32),
  .out(alu_in)
);

//alu_ctrl
alu_ctrl aluctrl_inst(
  .alu_op(alu_op),
  .opcode(instr_readdata[31:26]),
  .function_code(instr_readdata[5:0]),
  .alu_ctrl_in(alu_ctrl_in)
);

//alu
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
reg_hi reghi_inst(
  .clk(clk), .reset(reset), .clk_enable(clk_enable),
  .hi_wren(hi_wren),
  .read_data_a(read_data_a),
  .hi(hi),
  .hi_readdata(hi_readdata)
);

//reg_lo
reg_lo reglo_inst(
  .clk(clk), .reset(reset), .clk_enable(clk_enable),
  .lo_wren(lo_wren),
  .read_data_a(read_data_a),
  .lo(lo),
  .lo_readdata(lo_readdata)
);

// branch_cond
branch_cond branchcond_inst(
  .branch(branch),
  .opcode(instr_readdata[31:26]), .b_code(instr_readdata[20:16]),
  .equal(zero),
  .read_data_a(read_data_a),
  .condition_met(condition_met)
);

//jump_addressor
jump_addressor j_calc(
  .j_immdt(instr_readdata[25:0]),
  .pc_4msb(pc_plus4[31:28]),
  .jump_addr(jump_addr)
);

// branch_addressor
branch_addressor b_calc(
  .immdt_32(immdt_32),
  .PCnext(pcout),
  .branch_addr(branch_addr)
);

//PC_address_selector
PC_address_selector pcsel_inst(
  .branch_addr(branch_addr),
  .jump_addr(jump_addr),
  .read_data_a(read_data_a),
  .pc_plus4(pc_plus4),
  .condition_met(condition_met), //from branch_cond block
  .jump1(jump1), //from control, for J and JAL
  .jump2(jump2), //from control, for JR and JALR
  .tgt_addr_0(tgt_addr_0)
);

target_addr_holder taddr_inst(
  .clk(clk),
  .tgt_addr_0(tgt_addr_0),
  .tgt_addr_1(tgt_addr_1)
);

mux_32bit pcmux(
  .select(delay),
  .in_0(pc_plus4), .in_1(tgt_addr_1),
  .out(pcin)
);

//data_into_reg_mux1
mux_32bit data1mux(
  .select(data_into_reg1),
  .in_0(alu_out), .in_1(data_readdata),
  .out(data1muxout)
);

//data_into_reg_mux2
mux_32bit data2mux(
  .select(data_into_reg2),
  .in_0(data1muxout), .in_1(pc_plus4),
  .out(reg_write_data)
);

endmodule
