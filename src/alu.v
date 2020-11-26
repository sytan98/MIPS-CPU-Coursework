module alu(
    input logic[5:0] alu_ctrl_in,
    input logic[31:0] A, 
    input logic[31:0] B,
    input logic[5:0] shamt,
    output logic[31:0] alu_out,
    output logic zero,
    output logic[63:0] mult_out
);
    
    assign zero = (alu_out == 0);
    always_comb begin
        case (alu_ctrl_in)
            0,2,19: alu_out = A + B; //load instructions, addu, addiu
			1: zero = (A - B) == 0 ? 1: 0;//branch instructions
            3: alu_out = A - B; //subu
            4,22: alu_out = A & B; //and
            5,23: alu_out = A | B; //or
            6,24: alu_out = A ^ B; //xor
			7,8: alu_out = B << A; //sll, sllv
            9,10: alu_out = B >> A; //srl, srlv
            11,12: alu_out = A >>> B; //sra, srav
            13, 20: alu_out = $signed(A) < $signed(B) ? 1:0; //slt, slti

            14, 21: alu_out = A < B ? 1:0; //sltu, sltiu
            15: mult_out = $signed(A) * $signed(B);//mult
            16: mult_out = A * B;//multu
            17: alu_out = $signed(A) / $signed(B); //div
			18: alu_out = A/ B; //divu
            25: alu_out = B << 16; //lui

			default: alu_out = 0; 
        endcase
    end
end