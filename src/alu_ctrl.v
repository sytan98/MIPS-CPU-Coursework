module alu_ctrl(
    input logic [1:0] alu_op,
    input logic [5:0] function_code,
    input logic [5:0] opcode,
    output logic [5:0] alu_ctrl_in
)
    always_comb begin
        if (alu_op == 0)        alu_ctrl_in = 5'b00000;     
        else if (alu_op == 1)   alu_ctrl_in = 5'b00001;
        else if (alu_op == 2)
            case(function_code)
                33: alu_ctrl_in = 5'b00010 //addu
                35: alu_ctrl_in = 5'b00011 //subu
                36: alu_ctrl_in = 5'b00100 //and
                37: alu_ctrl_in = 5'b00101 //or
                38: alu_ctrl_in = 5'b00110 //xor
                0: alu_ctrl_in = 5'b00111 //sll
                4: alu_ctrl_in = 5'b01000 //sllv
                2: alu_ctrl_in = 5'b01001 //srl
                6: alu_ctrl_in = 5'b01010 //srlv
                3: alu_ctrl_in = 5'b01011 //sra
                7: alu_ctrl_in = 5'b01100 //srav
                42: alu_ctrl_in = 5'b01101 //slt
                43: alu_ctrl_in = 5'b01110 //sltu
                24: alu_ctrl_in = 5'b01111 //mult
                25: alu_ctrl_in = 5'b10000 //multu
                26: alu_ctrl_in = 5'b10001 //div
                27: alu_ctrl_in = 5'b10010 //divu
            endcase
        else
            case(opcode)
                9: alu_ctrl_in = 5'b10011 //addiu
                10: alu_ctrl_in = 5'b10100 //slti
                11: alu_ctrl_in = 5'b10101 //sltiu
                12: alu_ctrl_in = 5'b10110 //andiu
                13: alu_ctrl_in = 5'b10111 //ori
                14: alu_ctrl_in = 5'b11000 //xori
                15: alu_ctrl_in = 5'b11001 //lui
            endcase
        end
    end
