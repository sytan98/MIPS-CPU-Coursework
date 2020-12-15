// alu control module. sends signal alu_cltr_in to alu.v, which decides what operation to do in the alu based on alu_op coming from control.v.

module alu_ctrl(
    input logic [1:0] alu_op,             // from control.v
    input logic [5:0] function_code,      // instruction[5:0]
    input logic [5:0] opcode,             // instruction[31:26]
    output logic [4:0] alu_ctrl_in        // control signal to alu.v
);
    always_comb begin
        if (alu_op == 0) begin            // load/store instructions
            alu_ctrl_in = 0;
        end
        else if (alu_op == 1) begin       // BEQ/BNE instructions
            alu_ctrl_in = 1;
        end
        else if (alu_op == 2) begin       // R-type and I-type instructions
          if (opcode == 0) begin
            case(function_code)           // R-type instructions
                33: alu_ctrl_in = 2;      // addu
                35: alu_ctrl_in = 3;      // subu
                36: alu_ctrl_in = 4;      // and
                37: alu_ctrl_in = 5;      // or
                38: alu_ctrl_in = 6;      // xor
                0:  alu_ctrl_in = 7;      // sll
                4:  alu_ctrl_in = 8;      // sllv
                2:  alu_ctrl_in = 9;      // srl
                6:  alu_ctrl_in = 10;     // srlv
                3:  alu_ctrl_in = 11;     // sra
                7:  alu_ctrl_in = 12;     // srav
                42: alu_ctrl_in = 13;     // slt
                43: alu_ctrl_in = 14;     // sltu
                24: alu_ctrl_in = 15;     // mult
                25: alu_ctrl_in = 16;     // multu
                26: alu_ctrl_in = 17;     // div
                27: alu_ctrl_in = 18;     // divu
            endcase
          end
        end
        else if (alu_op == 3) begin
            case(opcode)                  // I-type instructions
                9:  alu_ctrl_in = 19;     // addiu
                10: alu_ctrl_in = 20;     // slti
                11: alu_ctrl_in = 21;     // sltiu
                12: alu_ctrl_in = 22;     // andiu
                13: alu_ctrl_in = 23;     // ori
                14: alu_ctrl_in = 24;     // xori
                15: alu_ctrl_in = 25;     // lui
            endcase
        end
    end
endmodule
