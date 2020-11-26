module register_file(
  input logic clk,
  input logic reset,

  input logic[4:0]    read_reg_rs, read_reg_rt, write_reg_rd,
  input logic         write_enable,
  input logic[31:0]   write_data,

  output logic[31:0]  rs_readdata, rt_readdata
);
  logic[31:0] regfile[31:0];

  initial begin
    regfile[0] <= 0;
  end

  assign rs_readdata = reset==1 ? 0 : regfile[read_reg_rs];
  assign rt_readdata = reset==1 ? 0 : regfile[read_reg_rt];

  always_ff @(posedge clk) begin
    if (reset) then begin
      integer i;
      for (i=0; i<32; i++) begin
        regfile[i]=0;
      end
    end
    else if (write_enable == 1) begin
      regfile[write_reg_rd] <= write_data;
    end
  end
endmodule
