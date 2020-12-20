module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);
// cpu state
typedef enum logic[2:0] {
        FETCH = 3'b000,       // fetch the instruction from memory
        LOAD = 3'b001,        // load instruction into intrustion register
        MEM = 3'b010,         // calculate memory address for load/store instructions, otherwise do nothing for non load/store instructions
        LOAD_DATA = 3'b011,   
        EXEC = 3'b100,        // for CPU to execute instructions
        HALTED = 3'b101       // cpu halted
} state_t;
logic[2:0] state;

// Wire Definition
logic       clk_enable;
// PC related
logic[31:0] pcin, pcout, pc_plus4, jump_addr, branch_addr, tgt_addr_0, tgt_addr_1;
logic       condition_met;
logic       delay;
// control signals
logic[1:0] rd_select;
logic      imdt_sel, branch, jump, jumpreg, alu_src, reg_write_enable, hi_wren, lo_wren, link_to_reg, mfhi, mflo, multdiv, lwl, lwr;
logic[2:0] datamem_to_reg;
logic[1:0] alu_op;
// register_file related
logic[4:0]  write_reg_rd;
logic[31:0] read_data_a, read_data_b, reg_write_data;
// reg_hi, reg_lo
logic[31:0] hi_readdata;
logic[31:0] lo_readdata;
// alu related
logic[31:0] signed_32, zero_32, immdt_32;
logic[4:0]  alu_ctrl_in;
logic[31:0] alu_in, alu_out, lo, hi;
logic       zero;

// bus related
logic[31:0] ir_readdata;
logic[31:0] dr_readdata;
logic[31:0] instruction;
assign instruction = ir_readdata;

// to ensure that the memory address is output from the CPU into bus_memory.v during MEM stage, important for load/store instructions
logic address_sel;
assign address_sel = (state==MEM | state == LOAD_DATA) ? 1'd1 : 1'd0;

logic[31:0] memory_address;
logic[31:0] memory_address_temp;
logic[1:0]  byte_addressing;
logic [2:0] write_data_sel;

assign memory_address_temp = alu_out;                         // alu_out calculates address in memory based on read_data_a and immediate
assign memory_address = {memory_address_temp[31:2], 2'b00};   // last 2 bits forced to 00 to ensure that word output from memory is always word aligned
assign byte_addressing = memory_address_temp[1:0];            // last 2 LSB of memory address

initial begin
    state = HALTED;
    active = 0;
    delay = 0;
    clk_enable = 0;
end

always @(posedge clk) begin
    $display("-------------------------------");
    if (reset) begin
        $display("CPU : INFO  : Resetting.");
        state <= FETCH;
        active <= 1;
    end
    else if (state == FETCH) begin
        $display("CPU : INFO  : Fetching.");
        $display("current PC address =%h", pcout);
        if (address == 0) begin
            state <= HALTED;
            active <= 0;
        end
        state <= LOAD;

    end
    else if (state == LOAD) begin
        $display("CPU : INFO  : LOAD.");
        //Current address
        $display("current PC address =%h", pcout);
        $display("current inst address =%h", address);
        $display("current inst =%h", instruction);
        if (waitrequest == 0) begin
          state <= MEM;
        end
    end
    else if (state == MEM) begin
      $display("CPU : INFO  : MEM.");
      //Current address
      $display("current PC address =%h", pcout);
      $display("current inst address =%h", address);
      $display("current inst =%h", instruction);
      state <= LOAD_DATA;
    end
    else if (state == LOAD_DATA) begin
      $display("CPU : INFO  : MEM.");
      //Current address
      $display("current PC address =%h", pcout);
      $display("current inst address =%h", address);
      $display("current inst =%h", instruction);
      if (waitrequest == 0) begin
        state <= EXEC;
        clk_enable <= 1;
      end
    end
    else if (state == EXEC) begin
        $display("CPU : INFO  : Executing.");
        //Current address
        $display("current PC address =%h", pcout);
        $display("current inst address =%h", address);
        $display("current inst =%h", instruction);

        //Branch/Jump Related
        $display("opcode = %d", readdata[31:26]);
        $display("branch = %h", branch);
        $display("jump = %h", jump);
        $display("jumpreg = %h", jumpreg);
        $display("condition_met = %h", condition_met);
        $display("tgt_addr_0 = %h", tgt_addr_0);
        $display("tgt_addr_1 = %h", tgt_addr_1);
        $display("delay = %h", delay);
        $display("branch address = %h", branch_addr);
        $display("jump address = %h", jump_addr);

        //Register Related
        $display("Reading Register A = %d", instruction[25:21]);
        $display("Reading Register B = %d", instruction[20:16]);
        $display("Data from Reg A = %h", read_data_a);
        $display("Data from Reg B = %h", read_data_b);
        $display("Register being written to = %d", write_reg_rd);
        $display("Reg Write Data = %h", reg_write_data);
        $display("Datamem to Reg signal for loads = %d", datamem_to_reg);
        $display("Link to reg for links = %d", link_to_reg);
        $display("Reg Write Enable = %h", reg_write_enable);

        //Data Memory Related
        $display("READ = %b", read);
        $display("WRITE = %b", write);
        $display("Data address = %h", memory_address);
        $display("Data address temp = %h", memory_address_temp);
        // $display("lwl signal = %b", lwl);
        // $display("lwr signal = %b", lwr);
        // $display("byte_addressing = %b", byte_addressing);
        // $display("Write Data to memory = %h", writedata);

        $display("immediate = %h", immdt_32);

        //ALU
        $display("alu_src = %b", alu_src);
        $display("alu out = %h", alu_out);
        // $display("value going into hi = %h", hi);
        // $display("value going into lo = %h", lo);
        clk_enable <= 0;

        state <= FETCH;

        if (branch|jump|jumpreg) begin        // delay slot for branch and jump instructions
            delay <= 1;
        end
        else begin
            delay <= 0;
        end
    end
    else if (state == HALTED) begin
        //do nothing
    end
end

// instruction register: to hold onto the instruction output from the memory
instr_register ir_inst(
  .clk(clk), .reset(reset),
  .state(state), .ir_writedata(readdata),
  .ir_readdata(ir_readdata)
);

// data register: to hold onto the data output from the memory
data_register dr_inst(
  .clk(clk), .reset(reset),
  .state(state), .dr_writedata(readdata),
  .dr_readdata(dr_readdata)
);

// memory address mux: to ensure that the memory address is output from the cpu into the memory during MEM
mux_32bit addressmux(
  .select(address_sel),
  .in_0(pcout), .in_1(memory_address),
  .out(address)
);

// module to select data to write into memory based on control signal write_data_sel.
writedata_selector writedata_sel(
  .read_data_b(read_data_b),          // from register_file.v, data from register rt
  .write_data_sel(write_data_sel),    // control signal from control.v
  .writedata(writedata)               // data to write into the memory, connceted to bus_memory.v
);

// pc
pc pc_inst(
  .clk(clk), .reset(reset),             // if reset is high, PC is reset to 0xBFC00000
  .clk_enable(clk_enable),
  .pcin(pcin),                          // the output of pcmux: either pc+4 or the target address stored in target_addr_holder
  .pcout(pcout)                         // connected to bus_memory.v
);

// pc_adder: increments PC by 4
pc_adder pcadder_inst(
  .pcout(pcout),
  .pc_plus4(pc_plus4)
);

// branch_cond: to check if conditions for branch to be taken has been met
branch_cond branchcond_inst(
  .branch(branch),                        // from control.v for branch instructions
  .opcode(instruction[31:26]), .b_code(instruction[20:16]),
  .equal(zero),                           // zero flag from alu.v, will be high if values in two registers are equal
  .read_data_a(read_data_a),              // data read from register rs.
  .condition_met(condition_met)           // control signal to PC_address_selector.v to select the branch target address.
);

// branch_addressor to calculate branch target address for branch instructions
branch_addressor b_calc(
  .immdt_32(immdt_32),                    // signed extended immediate: the output of imdtmux
  .pc_plus4(pc_plus4),                    // output of pc_adder.v
  .branch_addr(branch_addr)               // calculated branch target address, input to PC_address_selector.v
);

// jump_addressor to calculate jump target address for J and JAL instructions
jump_addressor j_calc(
  .j_immdt(instruction[25:0]),            // 26-bit immediate for J and JAL instructions.
  .pc_4msb(pc_plus4[31:28]),              // first 4 MSB of PC+4
  .jump_addr(jump_addr)                   // calculated jump target address, input to PC_address_selector.v
);

// PC_address_selector: manages which target address to store into register for delay slot
pc_address_selector pcsel_inst(
  .branch_addr(branch_addr),              // branch target address from branch_addressor.v
  .jump_addr(jump_addr),                  // jump target address from jump_addressor.v
  .read_data_a(read_data_a),              // value stored in register rs from register_file.v
  .pc_plus4(pc_plus4),                    // PC+4 from pc_adder.v. will add 4 to this to get PC+8
  .condition_met(condition_met),          // control signal from branch_cond.v, checks if conditions for branch has been met
  .jump(jump),                            // control signal from control.v, for J or JAL instructions
  .jumpreg(jumpreg),                      // control signal from control.v, for JR or JALR instructions
  .tgt_addr_0(tgt_addr_0)                 // output. connected to tgt_addr_holder.v
);

// Register to hold target address from PC_address_selector
target_addr_holder taddr_inst(
  .clk(clk), .clk_enable(clk_enable), .reset(reset),
  .tgt_addr_0(tgt_addr_0),                // from PC_address_selector.v
  .tgt_addr_1(tgt_addr_1)                 // connected to pcmux.
);

// pcmux to choose pcin to be either PC + 4 or target address for delay slot to work.
mux_32bit pcmux(
  .select(delay),                         // select signal delay, which goes to high for branch or J or JAL instructions
  .in_0(pc_plus4),                        // from pc_addeer.v, PC+4
  .in_1(tgt_addr_1),                      // target PC addresss stored in target_addr_holder.v, for delay slot
  .out(pcin)                              // input to pc.v, effectively the next value of pc
);

// control logic block: sends control signals to different modules in the cpu based on the state and the instruction so cpu does what it is supposed to do.
control control_inst(
  // inputs
  .reset(reset), .opcode(instruction[31:26]), .function_code(instruction[5:0]), .b_code(instruction[20:16]),
  .state(state), .waitrequest(waitrequest), .byte_addressing(byte_addressing),
  // memory related
  .read(read), .write(write),             // read and write enable signals to bus_memory.v\
  .write_data_sel(write_data_sel),        // control signal to writedata_selector.v, for store instructions
  .byteenable(byteenable),                // control signal to bus_memory.v for sb and sh instructions
  // register_file related
  .rd_select(rd_select),                  // select signal to destination_reg_selector.v to select destination register
  .reg_write_enable(reg_write_enable),    // write enable signal for register in register_file.v
  .datamem_to_reg(datamem_to_reg),        // control signal to reg_writedata_selector.v, for load instructions
  .link_to_reg(link_to_reg),              // control signal to reg_writedata_selector.v, for link instructions
  .mfhi(mfhi), .mflo(mflo),               // control signal to reg_writedata_selector.v, for mfhi and mflo instructions
  .lwl(lwl), .lwr(lwr),                   // control signals to register_file.v for lwl and lwr instructions
  // hi and lo registers related
  .hi_wren(hi_wren),                      // write enable signal for reg_hi.v, for mthi, multiplication and division instructions
  .lo_wren(lo_wren),                      // write enable signal for reg_lo.v, for mtlo, multiplication and division instructions
  .multdiv(multdiv),                      // control signal to reg_hi.v and reg_lo.v, for multiplication and divison instructions
  // alu related
  .imdt_sel(imdt_sel),                    // control signal to imdtmux, selects between sign extended or zero extended immediate for andi, ori, xori
  .alu_src(alu_src),                      // control signal to alumux, selects between read_data_b for R-type instructions or immdt_32 for I-type instructions
  .alu_op(alu_op),                        // control signal to alu_ctrl.v, 0 for load/store instructions, 1 for BEQ/BNE, 2 for R-type instructions, 3 for I-type instructions
  // PC address related
  .branch(branch),                        // control signal to branch_cond.v, for branch instructions
  .jump(jump),                            // control signal to PC_address_selector.v for J and JAL
  .jumpreg(jumpreg)                       // control signal to PC_address_selector.v for JR and JALR
);

// register_file: 32 registers, each register is 32 bits wide.
register_file regfile_inst(
  .clk(clk),
  .clk_enable(clk_enable),
  .reset(reset),
  .read_reg_a(instruction[25:21]), .read_reg_b(instruction[20:16]),
  .read_data_a(read_data_a), .read_data_b(read_data_b),
  .write_reg_rd(write_reg_rd),
  .reg_write_data(reg_write_data),
  .reg_write_enable(reg_write_enable),
  .register_v0(register_v0),
  .byte_addressing(byte_addressing), .lwl(lwl), .lwr(lwr)
);

// module to select the destination register to write into based on the type of instructions.
destination_reg_selector rd_selector(
  .read_reg_b(instruction[20:16]),        // register rt, instruction[20:16]
  .rtype_rd(instruction[15:11]),          // register rd, instruction[15:11]
  .rd_select(rd_select),                  // from control.v, select signal to select destination register
  .write_reg_rd(write_reg_rd)             // destination register, connected to register_file.v
);

// selects data to write into the destination register based on the different control signals.
reg_writedata_selector regwritedata_sel(
  // data to write into destination register
  .alu_out(alu_out),                                    // output of alu from alu.v
  .data_readdata(dr_readdata),                             // data read from memory for load instructions.
  .pc_plus4(pc_plus4),                                  // PC+4 from pc_adder.v. will add 4 to this to be PC+8 for link instructions.
  .hi_readdata(hi_readdata), .lo_readdata(lo_readdata), // data read from hi and lo registers for mfhi and mflo instructions
  // control signals
  .datamem_to_reg(datamem_to_reg),                      // from control.v, for load instructions (lw, lb, lbu, lh, lhu)
  .byte_addressing(byte_addressing),                    // last 2 LSB of data address to tell us which byte/halfword in the full word from the data memory to write into the destination register.
  .link_to_reg(link_to_reg),                            // from control.v, for link instructions (JAL, JALR, BGEZAL, BLTZAL)
  .mfhi(mfhi), .mflo(mflo),                             // from control.v, for mfhi and mflo instructions respectively
  // output
  .reg_write_data(reg_write_data)                       // data to write into destination register. connceted to register_file.v
);

//reg_hi
reg_hi reghi_inst(
  .clk(clk), .reset(reset), .clk_enable(clk_enable),
  .hi_wren(hi_wren),                 // from control.v, write enable signal for hi register
  .multdiv(multdiv),                 // from control.v, for multiply and divison instructions
  .read_data_a(read_data_a),         // from register_file.v, data read from register rs. for mthi instruction
  .hi(hi),                           // from alu.v. either the high-order 32-bit result of multiply instructions or 32-bit remainder of division instructions.
  .hi_readdata(hi_readdata)          // output of the hi register. connected to register_file.v for mfhi instruction.
);
//reg_lo
reg_lo reglo_inst(
  .clk(clk), .reset(reset), .clk_enable(clk_enable),
  .lo_wren(lo_wren),                 // from control.v, write enable signal for lo register
  .multdiv(multdiv),                 // from control.v, for multiply and divison instructions
  .read_data_a(read_data_a),         // from register_file.v, data read from register rs. for mtlo instruction
  .lo(lo),                           // from alu.v. either the low-order 32-bit result of multiply instructions or 32-bit quotient of division instructions.
  .lo_readdata(lo_readdata)          // output of the lo register. connected to register_file.v for mflo instruction.
);

// sign extends and zero extends the 16-bit immediate in i-type instructions to 32 bits. outputs will be connected to imdtmux.
immdt_extender imdtextd_inst(
  .immdt_16(instruction[15:0]),      // 16-bit immediate in I-type instructions
  .sign_immdt_32(signed_32),         // sign-extended immediate
  .zero_immdt_32(zero_32)            // zero-extended immediate
);
// mux to select between the sign-extended immediate or zero-extended immediate
mux_32bit imdtmux(
  .select(imdt_sel),                 // control signal from control.v
  .in_0(signed_32),                  // sign-extended immediate
  .in_1(zero_32),                    // zero-extended immediate
  .out(immdt_32)                     // either the sign or zero extended immediate. connected to alumux and branch_addressor.v
);

// mux to select the 2nd input to the ALU
mux_32bit alumux(
  .select(alu_src),                  // control signal from control.v
  .in_0(read_data_b),                // data read from register rt from register_file.v
  .in_1(immdt_32),                   // either the sign or zero extended immediate.
  .out(alu_in)                       // connected to alu.v
);

// alu control module. sends signal alu_cltr_in to alu.v, which decides what operation to do in the alu based on alu_op coming from control.v.
alu_ctrl aluctrl_inst(
  .alu_op(alu_op),                    // control signal from control.v
  .opcode(instruction[31:26]),
  .function_code(instruction[5:0]),
  .alu_ctrl_in(alu_ctrl_in)           // control signal to alu.v
);

// alu: does arithmetic, logical operations, shifts, comparing values in registers for set/branch instructions.
alu alu_inst(
  .alu_ctrl_in(alu_ctrl_in),          // control signal rom alu_ctrl.v
  .A(read_data_a),                    // from register_file.v. data read from register rs
  .B(alu_in),                         // either data read from register A or sign/zero-extended immediate, selected by control signal alu_src from control.v
  .shamt(instruction[10:6]),          // shift amount. instruction[10:6]
  .alu_out(alu_out),                  // output of alu.
  .zero(zero),                        // zero flag. signal to branch_cond.v. if zero is high, it means that the values in two registers are equal.
  .lo(lo), .hi(hi)                    // outputs to the lo and hi registers respectively for multiply and divide instructions.
);

endmodule
