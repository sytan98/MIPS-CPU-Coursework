// alu module. based on alu_ctrl_in coming from alu_ctrl.v, does operations on
// A: data read from register A and/or B: either data read from register B or the sign/zero-extended immediate.
// operations include arithmetic operations such as addition, subtraction, shifting, multiplication, division,
// logical operations such as and, or, xor, and comparing values in registers for set/branch instructions.

module alu(
    input logic[4:0] alu_ctrl_in,       // control signal rom alu_ctrl.v
    input logic[31:0] A,                // from register_file.v. data read from register rs
    input logic[31:0] B,                // either data read from register rt or sign/zero-extended immediate, selected by control signal alu_src from control.v
    input logic[4:0] shamt,             // shift amount. instruction[10:6]
    output logic[31:0] alu_out,         // output of alu.
    output logic zero,                  // zero flag. signal to branch_cond.v. if zero is high, it means that the values in two registers are equal.
    output logic[31:0] lo, hi           // outputs to the lo and hi registers respectively for multiply and divide instructions.
);
    logic[63:0] mult_div_out;           // holds 64-bit results of multiplication instructions or the remainder and quotient of division instructions
    assign lo = mult_div_out[31:0];     // low-order 32 bits of 64-bit result of multiplication instructions or 32-bit quotient for division instructions
    assign hi = mult_div_out[63:32];    // high-order 32 bits of 64-bit result of multiplication instructions or 32-bit remainder for division instructions
    assign zero = (alu_out == 0);       // zero flag that goes to high if alu_out is zero.

    always@(*) begin
        case (alu_ctrl_in)
            0,2,19: alu_out = A + B;                            // load/store instructions, addu, addiu
            1,3: alu_out = A - B;                               // branch instructions, subu
            4,22: alu_out = A & B;                              // and, andi
            5,23: alu_out = A | B;                              // or, ori
            6,24: alu_out = A ^ B;                              // xor, xori
			      7: alu_out = B << shamt;                            // sll
            8: alu_out = B << A[4:0];                           // sllv
            9: alu_out = B >> shamt;                            // srl
            10: alu_out = B >> A[4:0];                          // srlv
            11: alu_out = $signed(B) >>> shamt;                 // sra
            12: alu_out = $signed(B) >>> A[4:0];                // srav
            13,20: alu_out = $signed(A) < $signed(B) ? 1:0;     // slt, slti
            14,21: alu_out = A < B ? 1:0;                       // sltu, sltiu
            15: mult_div_out = $signed(A) * $signed(B);         // mult
            16: mult_div_out = A * B;                           // multu
            17: mult_div_out = {32'h00000000, $signed(A)/$signed(B)} | {$signed(A)%$signed(B), 32'h00000000}; // div
			      18: mult_div_out = {32'h00000000, A/B} | {A%B, 32'h00000000};                                     // divu
            25: alu_out = B << 16;                              // lui
			      default: alu_out = 0;
        endcase
    end
endmodule
