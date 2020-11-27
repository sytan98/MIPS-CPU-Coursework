module mips_cpu_harvard(
    /* Standard signals */
    input logic     clk,
    input logic     reset,
    output logic    active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic     clk_enable,

    /* Combinatorial read access to instructions */
    output logic[3:0]  instr_address,
    input logic[31:0]   instr_readdata,

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0]  data_address,
    output logic        data_write,
    output logic        data_read,
    output logic[31:0]  data_writedata,
    input logic[31:0]  data_readdata
);

logic[3:0] pc, pc_next;
logic[31:0] regs[31:0];
logic[31:0] hi;
logic[31:0] lo;
logic[63:0] mul_result;
logic jump;
logic[3:0] jump_address;

assign instr_address = pc;
assign register_v0 = regs[2];
assign data_address = regs[rs] + immediate;
assign data_write = 0;
assign data_read = 0;
assign data_writedata = regs[0]; 

typedef enum logic[1:0] {
        FETCH = 2'b00,
        EXEC = 2'b01,
        HALTED = 2'b11
} state_t;


typedef enum logic[5:0] {
        ADDU = 6'b100001,
        AND = 6'b100100,
        DIV = 6'b011010,
        DIVU = 6'b011011,
        JALR = 6'b001001,
        JR = 6'b001000,
        MTHI = 6'b010001,
        MTLO = 6'b010011,
        MFHI = 6'b010000,
        MFLO = 6'b010010,
        MULT = 6'b011000,
        MULTU = 6'b011001,
        OR = 6'b100101,
        SLL = 6'b000000,
        SLLV = 6'b000100,
        SLT = 6'b101010,
        SLTU = 6'b101011,
        SRA = 6'b000011,
        SRAV = 6'b000111,
        SRL = 6'b000010,
        SRLV = 6'b000110,
        SUBU = 6'b100011,
        XOR = 6'b100110
} r_function;

/*
typedef enum logic[5:0] {
        J = 6'b000010,
        JAL = 6'b000011
} j_function;
*/
typedef enum logic[5:0] {
        ADDUI = 6'b001000,
        ANDI = 6'b001100,
        BEQ = 6'b000100,
        BQEZ_AL_BLTZ_AL = 6'b000001,
        BQTZ = 6'b000111,
        BLEZ = 6'b000110,
        BNE = 6'b000101,
        LB = 6'b100000,
        LBU = 6'b100100,
        LH = 6'b100001,
        LHU = 6'b100101,
        LUI = 6'b001111,
        LW = 6'b100011,
        LWL = 6'b111111,
        LWR = 6'b111110,
        ORI = 6'b001101,
        SB = 6'b101000,
        SH = 6'b101001,
        SW = 6'b101011,
        SLTI = 6'b001010,
        SLTIU = 6'b001011,
        XORI = 6'b001110
} i_opcode;

logic[1:0] state;
logic[5:0] instr_opcode;
i_opcode instr_i_opcode;
logic[4:0] rs;
logic[4:0] rt;
logic[4:0] rd;
logic[4:0] sa;
r_function func;
logic[15:0] immediate;
logic[25:0] address;

assign instr_opcode = instr_readdata[31:26];
assign instr_i_opcode = instr_readdata[31:26];

        assign rs = instr_readdata[25:21];
        assign rt = instr_readdata[20:16];
        assign rd = instr_readdata[15:11];
        assign sa = instr_readdata[10:6];
        assign func = instr_readdata[5:0];
        assign immediate = instr_readdata[15:0];
        assign address = instr_readdata[25:0];


logic[3:0] npc;
assign npc = pc+1;

integer i;

initial begin
        state = HALTED;
        active = 0;
        
end

always @(posedge clk) begin
        if (reset) begin
            $display("CPU : INFO  : Resetting.");
            state <= EXEC;
            pc <= 0;  //WRONG: BFC00000
            regs[0] <= 32'b00000000000000000000000000000011;
            regs[1] <= 32'b00000000000000000000000000000111;
            regs[2] <= 32'b00000000000000000000000000000000;
            for (i=3; i<32; i++) begin
                regs[i] <= 0;
            end
            lo<=0;
            hi<=0;
            active <= 1;
        end
        else if (state==HALTED) begin
            //do nothing    
        end
        else if (state==FETCH) begin 
            //for now, do nothing as it's a single-cycle MIPS CPU
            //if combinatorial delay due to RAM is huge, make RAM synchronous and have to states: fetching instruction and executing instruction) 
        end
        else if (state==EXEC) begin
            //$display("CPU : INFO  : Executing, opcode=%h, acc=%h, imm=%h, readdata=%x", instr_opcode, acc, instr_constant, readdata);
            if(instr_opcode == 6'b000000) begin
                case(func)
                        ADDU: begin
                            //WORKS
                            //$display("executing addu instruction");
                            regs[rd] <= regs[rs] + regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end                    
                        end
                        AND: begin  //WRONG?? loop: one AND for each bit??
                            //PENDING CHECK
                            regs[rd] <= regs[rs] && regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        DIV: begin 
                            //tested 7/2 >> WORKS
                            //tested -7/2 >> WORKS
                            //tested 7/-2 >> WORKS 
                            hi <= $signed(regs[rs])/$signed(regs[rt]);
                            lo <= $signed(regs[rs])%$signed(regs[rt]);
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        DIVU: begin
                            //tested 7/2 >> works
                            //tested large values (with MSB=1) >> works
                            hi <= regs[rs]/regs[rt];
                            lo <= regs[rs]%regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        JALR: begin
                            //pending check on delay, prob. works
                            //fix address (4MSB from PC, <<2)
                            regs[rd]=npc+4;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                            jump_address <= regs[rs][3:0];
                            jump <= 1;
                        end
                        JR: begin
                            //pending check on delay, prob. works
                            //fix address (4MSB from PC, <<2)
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                            jump_address <= regs[rs][3:0];
                            jump <= 1;
                        end
                        MTHI: begin
                            //WORKS
                            hi <= regs[rs];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end 
                        end
                        MTLO: begin
                            //WORKS
                            lo <= regs[rs];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end 
                        end
                        MFHI: begin
                            //WORKS  
                            regs[rd] <= hi;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                        end
                        MFLO: begin
                            //WORKS  
                            regs[rd] <= lo;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                        end
                        MULT: begin
                            //PENDING CHECK
                            mul_result = $signed(regs[rs])*$signed(regs[rt]); 
                            hi <= mul_result[63:32];
                            lo <= mul_result[31:0];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end  
                        end
                        MULTU: begin
                            //WORKS (7*2=14)
                            mul_result = regs[rs]*regs[rt]; 
                            hi <= mul_result[63:32];
                            lo <= mul_result[31:0];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end   
                        end
                        OR: begin  //WRONG?? DOES IT WORK BIT-BY-BIT??
                        //PENDING CHECK
                            regs[rd] <= regs[rs] || regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end





                    endcase
            end
            else if(instr_opcode ==6'b000010 || instr_opcode == 6'b000011) begin 
                active <= 0;
                state <= HALTED;
            end
            else begin 
                case(instr_i_opcode)
                    ADDUI: begin

                    end
                    ANDI: begin

                    end

                endcase
            end
        end

        else begin
            $display("CPU : ERROR : Processor in unexpected state %b", state);
            $finish;
        end
    end
endmodule

