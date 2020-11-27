module register_file(
  input logic clk,
  input logic reset,

  input logic[4:0]    read_reg_a,
  input logic[4:0]    read_reg_b, 
  input logic[4:0]    write_reg_rd,
  input logic         write_enable,
  input logic[31:0]   write_data,

  output logic[31:0]  read_data_a, read_data_b
);
  logic[31:0] regfile[31:0];

  initial begin
    regfile[0] <= 0;
  end

  assign read_data_a = reset==1 ? 0 : regfile[read_reg_a];
  assign read_data_b = reset==1 ? 0 : regfile[read_reg_b];

  integer index;
  always_ff @(posedge clk) begin
    if (reset==1) begin
        for (index=0; index<32; index=index+1) begin
            regfile[index]<=0;
        end
    end
    if (write_enable == 1) begin
      regfile[write_reg_rd] <= write_data;
    end
  end
  
endmodule
