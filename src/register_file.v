module register_file(
  input logic clk,
  input logic clk_enable,
  input logic reset,

  input logic[4:0]    read_reg_a,
  input logic[4:0]    read_reg_b,
  input logic[4:0]    write_reg_rd,
  input logic         reg_write_enable,
  input logic[31:0]   reg_write_data,

  output logic[31:0]  read_data_a, read_data_b,

  output logic[31:0] register_v0
);
  logic[31:0] regfile[31:0];

  initial begin
    regfile[0] = 0;
  end

  assign read_data_a = (reset==1) ? 0 : regfile[read_reg_a];
  assign read_data_b = (reset==1) ? 0 : regfile[read_reg_b];

  assign register_v0 = reset==1 ? 0 : regfile[2];

  integer index;
  always @(posedge clk) begin
    if (reset==1) begin
        for (index=0; index<32; index=index+1) begin
            regfile[index]<=0;
        end
    end
    else if (reg_write_enable == 1 & clk_enable == 1) begin
      $display("REGISTER %d BEING WRITTEN WITH %h", write_reg_rd,reg_write_data );
      regfile[write_reg_rd] <= reg_write_data;
    end
  end

endmodule
