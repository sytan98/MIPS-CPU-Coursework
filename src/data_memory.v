module data_memory(
  input logic clk,

  input logic[31:0] data_address,

  input logic data_read,
  input logic data_write,

  input logic[31:0] data_writedata,
  output logic[31:0] data_readdata
);
  parameter RAM_INIT_FILE = "";

	logic[31:0] memory[0:1073741824];

  initial begin
    if (RAM_INIT_FILE != "") begin
      $readmemh(RAM_INIT_FILE, memory);
    end
  end

  always_ff @(posedge clk) begin
    if (data_write == 1) begin
      memory[data_address[31:2]] <= data_writedata;
    end
  end

  always_ff @(negedge clk) begin
    if (data_read == 1) begin
      data_readdata <= memory[data_address[31:2]];
    end
  end

endmodule
