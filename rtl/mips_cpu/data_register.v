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
  assign dr_readdata = dr;

  always_ff @(posedge clk) begin
    if(reset) begin
      dr <= 0;
    end
    else if ( state == 3 ) begin
        dr <= dr_writedata;            //load the IR during LOAD state
    end
  end

endmodule
