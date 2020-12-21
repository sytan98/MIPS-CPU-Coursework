// register that holds onto the data output from the memory.

module data_register(
  input logic clk, reset, waitrequest,
  input logic[2:0] state,               // cpu state
  input logic[31:0] dr_writedata,       // readdata from memory
  output logic[31:0] dr_readdata,        // data held in data register
  output logic regcheck
);
  logic[31:0] dr;
  logic waitreg;
  //logic regcheck;
  assign dr_readdata = dr;

  always_ff @(posedge clk) begin
    waitreg <= waitrequest;
    if(reset) begin
      dr <= 0;
    end
    // else if ( (state == 2 & waitrequest == 0) | (state == 3 & dr_writedata!=32'hxxxxxxxx) )begin
    else if ( (state == 2 & waitreg == 1 & waitrequest == 0 ) | (state == 3 & waitreg == 0 & waitrequest==0 & regcheck!=1)  )  begin
        regcheck <= 1;
        dr <= dr_writedata;            //load the DR during MEM state and when waitrequest == 0
    end
    if (state == 0) begin
      regcheck <= 0;
    end
  end

endmodule
