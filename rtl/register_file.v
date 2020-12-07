module register_file(
  input logic clk,
  input logic clk_enable,
  input logic reset,

  input logic[4:0]    read_reg_a,
  input logic[4:0]    read_reg_b,
  input logic[4:0]    write_reg_rd,
  input logic         reg_write_enable,
  input logic[31:0]   reg_write_data,

  input logic[1:0]   byte_addressing,
  input logic        lwl, lwr,

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

    // lwl
    else if ( (reg_write_enable == 1) & (clk_enable == 1) & (lwl == 1) ) begin
      if (byte_addressing == 2'b00) begin
        regfile[write_reg_rd][31:24] <= reg_write_data[7:0];
      end
      else if (byte_addressing == 2'b01) begin
        regfile[write_reg_rd][31:16] <= reg_write_data[15:0];
      end
      else if (byte_addressing == 2'b10) begin
        regfile[write_reg_rd][31:8] <= reg_write_data[23:0];
      end
      else if (byte_addressing == 2'b11) begin
        regfile[write_reg_rd][31:0] <= reg_write_data[31:0];
      end
    end

    // lwr
    else if ( (reg_write_enable == 1) & (clk_enable == 1) & (lwr == 1) ) begin
      if (byte_addressing == 2'b00) begin
        regfile[write_reg_rd][31:0] <= reg_write_data[31:0];
      end
      else if (byte_addressing == 2'b01) begin
        regfile[write_reg_rd][23:0] <= reg_write_data[31:8];
      end
      else if (byte_addressing == 2'b10) begin
        regfile[write_reg_rd][15:0] <= reg_write_data[31:16];
      end
      else if (byte_addressing == 2'b11) begin
        regfile[write_reg_rd][7:0] <= reg_write_data[31:24];
      end
    end
    
    else if ( (reg_write_enable == 1) & (clk_enable == 1) ) begin
      // $display("REGISTER %d BEING WRITTEN WITH %h", write_reg_rd,reg_write_data );
      regfile[write_reg_rd] <= reg_write_data;
    end
  end

endmodule
