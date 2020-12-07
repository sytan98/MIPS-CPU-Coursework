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
	parameter address_bit_size = 10; 

	logic[address_bit_size - 1: 0] mapped_address;		

	assign mapped_address = data_address[address_bit_size-1:0] - 32'hBFBFFFE0 ;

	logic[31:0] memory [0: (2**address_bit_size)/4-1];

  initial begin
    if (RAM_INIT_FILE != "") begin
      $readmemh(RAM_INIT_FILE, memory);
    end
  end

  assign data_readdata = data_read ? memory[mapped_address[address_bit_size-1:2]] : 32'hxxxx;

  always_ff @(posedge clk) begin
    if (data_write == 1) begin
      memory[mapped_address[address_bit_size-1:2]] <= data_writedata;
    end
  end

endmodule
