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

	logic[7:0] bytes [0: (2**address_bit_size-1)];

  initial begin
    if (RAM_INIT_FILE != "") begin
      $readmemh(RAM_INIT_FILE, memory);
    end
  end

  assign data_readdata = data_read ? {bytes[mapped_address+3], bytes[mapped_address+2], bytes[mapped_address+1], bytes[mapped_address]} : 32'hxxxx;

  always_ff @(posedge clk) begin
    if (data_write == 1) begin
      bytes[mapped_address] <= data_writedata[7:0];
      bytes[mapped_address+1] <= data_writedata[15:8];
      bytes[mapped_address+2] <= data_writedata[23:16];
      bytes[mapped_address+3] <= data_writedata[31:24];
    end
  end

endmodule
