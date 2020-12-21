// register that holds onto the instruction output from the memory.

module instr_register(
  input logic clk, reset, 
  input logic[2:0] state,               // cpu state
  input logic[31:0] ir_writedata,       // readdata from memory
  output logic[31:0] ir_readdata       // instruction held in instruction register
);
  
  
  logic[31:0] ir;
  assign ir_readdata = ir;

  always_ff @(posedge clk) begin
    if(reset) begin
      ir <= 0;
    end
    else if ( state == 1 ) begin
        ir <= ir_writedata;            //load the IR during LOAD state
    end
  end

endmodule
