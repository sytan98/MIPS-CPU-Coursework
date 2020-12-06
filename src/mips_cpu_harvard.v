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

logic[31:0] pc;
logic[31:0] regs[31:0];
logic[31:0] hi;
logic[31:0] lo;
logic[63:0] mul_result;
logic jump;
logic[31:0] jump_address;


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

typedef enum logic[5:0] {
        ADDIU = 6'b001001,
        ANDI = 6'b001100,
        BEQ = 6'b000100,
        BQEZ_AL_BLTZ_AL = 6'b000001,
        BGTZ = 6'b000111,
        BLEZ = 6'b000110,
        BNE = 6'b000101,
        LB = 6'b100000,
        LBU = 6'b100100,
        LH = 6'b100001,
        LHU = 6'b100101,
        LUI = 6'b001111,
        LW = 6'b100011,
        LWL = 6'b100010,
        LWR = 6'b100110,
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
logic[13:0] data_address_temp;

assign instr_opcode = instr_readdata[31:26];
assign instr_i_opcode = instr_readdata[31:26];

        assign rs = instr_readdata[25:21];
        assign rt = instr_readdata[20:16];
        assign rd = instr_readdata[15:11];
        assign sa = instr_readdata[10:6];
        assign func = instr_readdata[5:0];
        assign immediate = instr_readdata[15:0];
        assign address = instr_readdata[25:0];

assign instr_address = pc;
assign register_v0 = regs[2];
assign data_address_temp = regs[rs] + immediate;
assign data_address = data_address_temp&(32'hfffffffc);

assign data_write = (instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&~instr_opcode[1]&~instr_opcode[0]) | (instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&~instr_opcode[1]&instr_opcode[0]) | (instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&instr_opcode[1]&instr_opcode[0]);

assign data_read = !data_write; //could make it 1 only for load instructions

assign data_writedata = instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&~instr_opcode[1]&~instr_opcode[0] ? 32'h000000ff&regs[rt] : 
                        (instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&~instr_opcode[1]&instr_opcode[0] ? 32'h0000ffff&regs[rt] :
                        (instr_opcode[5]&~instr_opcode[4]&instr_opcode[3]&~instr_opcode[2]&instr_opcode[1]&instr_opcode[0] ? regs[rt] : 32'h00000000));

logic[31:0] npc;
assign npc = pc+4;

integer i;

initial begin
        state = HALTED;
        active = 0;
        
end

always @(posedge clk) begin
        if (reset) begin
            //$display("accessed");
            state <= EXEC;
            pc <= 32'hbfc00000;        //CORRECT 32'hbfc00000;
            for (i=0; i<32; i++) begin
                regs[i] <= 0;
            end
            lo<=32'h00000000;
            hi<=32'h00000000;
            active <= 1;
        end
        else if (state==HALTED) begin
            //do nothing    
        end
        else if (state==FETCH) begin 
            //not needed since we have combinatorial reads from RAMS 
        end
        else if (pc==0) begin 
        state <= HALTED;
        active <= 0;
        end
        else if (clk_enable == 0) begin
            //wait, do nothing, do not update any register (including pc)
        end 
        else if (state==EXEC & clk_enable==1) begin
            //$display("exec state");
            if(instr_opcode == 6'b000000) begin
                case(func)
                        ADDU: begin
                            regs[rd] <= regs[rs] + regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                            //$display("rd after addu: %h", regs[rd]);                    
                        end
                        AND: begin
                            regs[rd] <= regs[rs] & regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        DIV: begin
                            lo <= $signed(regs[rs])/$signed(regs[rt]);
                            hi <= $signed(regs[rs])%$signed(regs[rt]);
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        DIVU: begin
                            lo <= regs[rs]/regs[rt];
                            hi <= regs[rs]%regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end     
                                //$display("rs divided: %h", regs[rs]);
                               // $display("rt divider: %h", regs[rt]); 
                        end
                        JALR: begin
                            regs[rd]<=pc+8;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                            jump_address <= regs[rs];
                            jump <= 1;
                        end
                        JR: begin
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                            jump_address <= regs[rs];
                            jump <= 1;
                        end
                        MTHI: begin
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
                        OR: begin 
                            regs[rd] <= regs[rs]|regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SLL: begin  
                            regs[rd] <= regs[rt] << sa;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SLLV: begin 
                            regs[rd] <= regs[rt] << regs[rs][4:0];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SLT: begin
                            if($signed(regs[rs])<$signed(regs[rt])) begin
                                regs[rd] <= 1;
                            end
                            else begin
                                regs[rd] <= 0;
                            end 
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SLTU: begin 
                            if(regs[rs]<regs[rt]) begin
                                regs[rd] <= 1;
                            end
                            else begin
                                regs[rd] <= 0;
                            end 
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SRA: begin 
                            regs[rd] <= $signed(regs[rt]) >>> sa;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SRAV: begin 
                            regs[rd] <= $signed(regs[rt]) >>> regs[rs][4:0];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SRL: begin 
                            regs[rd] <= regs[rt] >> sa;
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SRLV: begin  
                            regs[rd] <= regs[rt] >> regs[rs][4:0];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        SUBU: begin 
                            regs[rd] <= regs[rs] - regs[rt];
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end           
                        end
                        XOR: begin
                            regs[rd] <= regs[rt]^regs[rs];
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
            else if(instr_opcode == 6'b000010) begin
                
                if(jump == 1)begin
                    pc <= jump_address;
                    jump <= 0;
                end
                else begin
                    pc <= npc;
                end 
                jump_address[31:28] <= pc[31:28];
                jump_address[27:2] <= address;
                jump_address[1:0] <= 0;         
                jump <= 1;
            end
            else if(instr_opcode == 6'b000011) begin
                regs[31]<=pc+8;
                if(jump == 1)begin
                    pc <= jump_address;
                    jump <= 0;
                end
                else begin
                    pc <= npc;
                end           
                jump_address[31:28] <= pc[31:28];
                jump_address[27:2] <= address;
                jump_address[1:0] <= 0;
                jump <= 1;            
            end
            else begin 
                case(instr_i_opcode)
                    ADDIU: begin
                        if(immediate[15]==1) begin 
                            regs[rt] = regs[rs] + (32'hffff0000|immediate);   
                        end
                        else begin
                            regs[rt] = regs[rs] + immediate;
                        end
                        //$display("rs = %h", (regs[rs]));
                        //$display("immediate = %h", 32'hffff0000|immediate);
                        //$display("rt = %h", (regs[rt]));
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    ANDI: begin
                        regs[rt] = regs[rs]&immediate;
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    BEQ: begin
                        if(jump == 1)begin
                            pc <= jump_address;
                            jump <= 0;
                        end
                        else begin
                            pc <= npc;
                        end 
                        if(regs[rs]==regs[rt]) begin
                            if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                        end
                    end
                    BQEZ_AL_BLTZ_AL: begin
                        if(rt==5'b00001) begin
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                 pc <= npc;
                            end 
                            if($signed(regs[rs])>=0) begin
                                 if(immediate[15]==1) begin 
                                 jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                                 jump <= 1;
                                end
                                else begin
                                jump_address <= pc+4+(immediate<<2);
                                jump <= 1;
                                end
                            end
                        end
                        else if(rt==5'b10001) begin
                            if(jump == 1) begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end 
                            if($signed(regs[rs])>=0) begin
                                regs[31] <= pc+8;
                                 if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                            end
                        end
                        else if(rt==5'b00000) begin
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                            if($signed(regs[rs])<0) begin
                                 if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                            end
                        end
                        else if(rt==5'b10000) begin   
                            if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end 
                            if($signed(regs[rs])<0) begin
                                regs[31] <= pc+8;
                                 if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                            end
                        end
                    end
                    BGTZ: begin
                        if(jump == 1)begin
                            pc <= jump_address;
                            jump <= 0;
                        end
                        else begin
                            pc <= npc;
                        end 
                        if($signed(regs[rs])>0) begin
                             if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                        end
                    end
                    BLEZ: begin
                        if(jump == 1)begin
                            pc <= jump_address;
                            jump <= 0;
                        end
                        else begin
                            pc <= npc;
                        end 
                        if($signed(regs[rs])<=0) begin
                             if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                        end
                    end
                    BNE: begin
                        if(jump == 1)begin
                            pc <= jump_address;
                            jump <= 0;
                        end
                        else begin
                            pc <= npc;
                        end 
                        if(regs[rs]!=regs[rt]) begin
                             if(immediate[15]==1) begin 
                            jump_address <= pc+4+(32'hfffc0000|(immediate<<2));
                            jump <= 1;
                            end
                            else begin
                            
                            jump_address <= pc+4+(immediate<<2);
                            jump <= 1;
                            end
                        end
                    end
                    LB: begin
                        if(data_address_temp[1:0] == 2'b00) begin  
                            regs[rt]<=$signed(data_readdata[7:0]);
                        end
                        else if(data_address_temp[1:0] == 2'b01) begin  
                            regs[rt]<=$signed(data_readdata[15:8]);
                        end
                        else if(data_address_temp[1:0] == 2'b10) begin  
                            regs[rt]<=$signed(data_readdata[23:16]);
                        end
                        else if(data_address_temp[1:0] == 2'b11) begin  
                            regs[rt]<=$signed(data_readdata[31:24]);
                        end
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    LBU: begin
                    if(data_address_temp[1:0] == 2'b00) begin  
                            regs[rt]<=data_readdata[7:0];
                        end
                        else if(data_address_temp[1:0] == 2'b01) begin  
                            regs[rt]<=data_readdata[15:8];
                        end
                        else if(data_address_temp[1:0] == 2'b10) begin  
                            regs[rt]<=data_readdata[23:16];
                        end
                        else if(data_address_temp[1:0] == 2'b11) begin  
                            regs[rt]<=data_readdata[31:24];
                        end
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    LH: begin
                        if(data_address_temp[1] == 1'b0) begin  
                            
                            regs[rt]<=$signed(data_readdata[15:0]);
                        end
                        else if(data_address_temp[1] == 1'b1) begin  
                        regs[rt]<=$signed(data_readdata[31:16]);
                       end
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                        
                    end
                    LHU: begin
                        if(data_address_temp[1] == 1'b0) begin  
                            regs[rt]<=data_readdata[15:0];
                        end
                        else if(data_address_temp[1] == 1'b1) begin  
                            regs[rt]<=data_readdata[31:16];
                        end
                        $display("regs[rs]: %h", regs[rs]);
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    LUI: begin
                        regs[rt] <= (immediate<<16);
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    LW: begin
                        regs[rt]<=data_readdata;
                        if(jump == 1)begin
                            pc <= jump_address;
                            jump <= 0;
                        end
                        else begin
                            pc <= npc;
                        end
                    end
                    LWL: begin
                        if(data_address_temp[1:0] == 2'b00) begin 
                            regs[rt][31:24] <= data_readdata[7:0];
                        end 
                        else if(data_address_temp[1:0] == 2'b01) begin 
                            regs[rt][31:16] <= data_readdata[15:0];
                        end 
                        else if(data_address_temp[1:0] == 2'b10) begin 
                            regs[rt][31:8] <= data_readdata[23:0];
                        end
                        else if(data_address_temp[1:0] == 2'b11) begin 
                            regs[rt][31:0] <= data_readdata[31:0];
                        end
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    LWR: begin
                        if(data_address_temp[1:0] == 2'b00) begin 
                            regs[rt][31:0] <= data_readdata[31:0];
                        end 
                        else if(data_address_temp[1:0] == 2'b01) begin 
                            regs[rt][23:0] <= data_readdata[31:8];
                        end 
                        else if(data_address_temp[1:0] == 2'b10) begin 
                            regs[rt][15:0] <= data_readdata[31:16];
                        end
                        else if(data_address_temp[1:0] == 2'b11) begin 
                            regs[rt][7:0] <= data_readdata[31:24];
                        end
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    ORI: begin
                        regs[rt] = regs[rs]|immediate;
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                            else begin
                                pc <= npc;
                            end
                    end
                    SB: begin
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    SH: begin
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    SW: begin
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    SLTI: begin
                        if($signed(regs[rs])<$signed(immediate)) begin
                            regs[rt]<=1;
                        end
                        else begin 
                            regs[rt]<=0;
                        end

                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    SLTIU: begin 
                        
                        if(immediate[15]==1) begin 
                            if(regs[rs] < (32'hffff0000|immediate)) begin
                                regs[rt]<=1;
                            end
                            else begin 
                                regs[rt]<=0;
                           end                        
                        end
                        else begin
                            if(regs[rs]<immediate) begin
                                regs[rt]<=1;
                            end
                            else begin 
                                regs[rt]<=0;
                            end
                        end
                        
                        if(jump == 1)begin
                                pc <= jump_address;
                                jump <= 0;
                            end
                        else begin
                            pc <= npc;
                        end
                    end
                    XORI: begin
                        regs[rt] = regs[rs]^immediate;
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
        end
    end
endmodule

