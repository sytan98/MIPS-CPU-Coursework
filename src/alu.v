module alu(
    input logic[5:0] alu_ctrl_in,
    input logic[31:0] A, 
    input logic[31:0] B,
    output logic[31:0] alu_out,
    output logic zero
);
    assign zero = (alu_out == 0);
    always_comb begin
        case (alu_ctrl_in)
            0: ALUOut = A & B;
			1: ALUOut = A | B;
			2: ALUOut = A + B;
			6: ALUOut = A - B;
			7: ALUOut = A < B ? 1:0;
			12: ALUOut = ~(A | B);
			default: ALUOut = 0;
        endcase
    end
end