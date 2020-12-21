// register that holds onto the instruction output from the memory.

module instr_register(
  input logic clk, reset, waitrequest,
  input logic[2:0] state,               // cpu state
  input logic[31:0] ir_writedata,       // readdata from memory
  output logic[31:0] ir_readdata,        // instruction held in instruction register
  output logic regcheck
);
  
  
  logic[31:0] ir;
  logic waitreg;
  assign ir_readdata = ir;

  always_ff @(posedge clk) begin
    waitreg <= waitrequest;
    if(reset) begin
      ir <= 0;
      regcheck <= 0;
    end
    // else if ( (state == 2 & waitrequest == 0) | (state == 3 & dr_writedata!=32'hxxxxxxxx) )begin
    else if ( (state == 0 & waitreg == 1 & waitrequest == 0 ) | (state == 1 & waitreg == 0 & waitrequest==0 & regcheck!=1)  )  begin
        regcheck <= 1;
        ir <= ir_writedata;            //load the IR
    end
    if (state == 3) begin
      regcheck <= 0;
    end
  end


  // always_ff @(posedge clk) begin
  //   if(reset) begin
  //     ir <= 0;
  //   end
  //   else if ( state == 1 ) begin
  //       ir <= ir_writedata;            //load the IR during LOAD state
  //   end
  // end

endmodule
