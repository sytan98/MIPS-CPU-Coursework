// alu module. based on alu_ctrl_in coming from alu_ctrl.v, does operations on
// A: data read from register A and/or B: either data read from register B or the sign/zero-extended immediate.
// operations include addition, subtraction, shifting, multiplication, division,
// logical operations such as and, or, xor, and comparing values in registers for set/branch instructions.
module alu(
    input logic[4:0] alu_ctrl_in, //from alu_ctrl_in
    input logic[31:0] A,          //data read from register A
    input logic[31:0] B,          //either data read from register A or sign/zero-extended immediate - selected by control signal alu_src
    input logic[4:0] shamt,
    output logic[31:0] alu_out,
    output logic zero,            //signal to branch_cond.v. if zero is high, it means that the values in two registers are equal.
    output logic[31:0] lo, hi     //outputs to the lo and hi registers respectively for mult and div instructions.
);
    logic[63:0] mult_div_out;
    assign lo = mult_div_out[31:0];
    assign hi = mult_div_out[63:32];
    assign zero = (alu_out == 0);
    always@(*) begin
        case (alu_ctrl_in)
            0,2,19: alu_out = A + B; //load instructions, addu, addiu
            1,3: alu_out = A - B; //branch instructions, subu
            4,22: alu_out = A & B; //and, andi
            5,23: alu_out = A | B; //or, ori
            6,24: alu_out = A ^ B; //xor, xori
			7: alu_out = B << shamt; //sll
            8: alu_out = B << A[4:0]; //sllv
            9: alu_out = B >> shamt; //srl
            10: alu_out = B >> A[4:0];//srlv
            11: alu_out = $signed(B) >>> shamt; //sra
            12: alu_out = $signed(B) >>> A[4:0]; //srav
            13, 20: alu_out = $signed(A) < $signed(B) ? 1:0; //slt, slti
            14, 21: alu_out = A < B ? 1:0; //sltu, sltiu
            15: mult_div_out = $signed(A) * $signed(B);//mult
            16: mult_div_out = A * B;//multu
            17: mult_div_out = {32'h00000000, $signed(A)/$signed(B)} | {$signed(A)%$signed(B), 32'h00000000};//div
			      18: mult_div_out = {32'h00000000, A/B} | {A%B, 32'h00000000}; //divu
            25: alu_out = B << 16; //lui

			default: alu_out = 0;
        endcase
    end
endmodule
