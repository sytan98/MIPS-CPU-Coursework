module instr_register(
  input logic clk, reset, waitrequest,
  input logic[2:0] state,
  input logic[31:0] ir_writedata,
  output logic[31:0] ir_readdata
);
  logic[31:0] ir;
  assign ir_readdata = ir;

  always_ff @(posedge clk) begin
    if(reset) begin
      ir <= 0;
    end
    else if ( state == 4 ) begin
        ir <= ir_writedata; //load the IR

    end
  end

endmodule
