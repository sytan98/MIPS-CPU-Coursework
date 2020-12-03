module data_memory(
  input logic clk,

  input logic[31:0] data_address,

  input logic data_read,
  input logic data_write,

  input logic[31:0] data_writedata,
  output logic[31:0] data_readdata
  // output logic clk_enable
);
  parameter RAM_INIT_FILE = "";
	parameter bit_size = 32;
	parameter mem_size = 16; //1073741824

  logic[bit_size - 1:0] memory[0: 2**mem_size - 1];
	// logic[31:0] memory[0:1073741824];

  initial begin
    if (RAM_INIT_FILE != "") begin
      $readmemh(RAM_INIT_FILE, memory);
    end
  end

  assign data_readdata = data_read ? memory[data_address[17:2]] : 32'hxxxx;

  always_ff @(posedge clk) begin
    if (data_write == 1) begin
      memory[data_address[17:2]] <= data_writedata;
    end
  end

endmodule
