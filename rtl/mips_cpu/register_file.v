// register file containing 32 32-bit wide registers.

module register_file(
  input logic clk,
  input logic clk_enable,
  input logic reset,

  input logic[4:0]    read_reg_a,          // register rs, instruction[25:21]
  input logic[4:0]    read_reg_b,          // register rt, instruction[20:16]

  input logic[4:0]    write_reg_rd,        // destination register, from destination_reg_selector.v

  input logic         reg_write_enable,    // write enable signal for register from control.v
  input logic[31:0]   reg_write_data,      // data to be written into destination reigster, comes from reg_writedata_selector.v

  input logic[1:0]    byte_addressing,     // last 2 LSB of data address. control signal to tell us what to do for LWL/LWR instructions.
  input logic         lwl, lwr,            // from control.v. tells us if instruction is LWL or LWR.

  output logic[31:0]  read_data_a,         // data read from register rs
  output logic[31:0]  read_data_b,         // data read from register rt

  output logic[31:0] register_v0           // data read from register 2 / v0.
);
  logic[31:0] regfile[31:0];               // instantiating 32 32-bit wide registers
  initial begin
    regfile[0] = 0;                        // hardwiring register 0 to contain 0
  end

  // combinatorial reading of registers
  assign read_data_a = (reset==1) ? 0 : regfile[read_reg_a];
  assign read_data_b = (reset==1) ? 0 : regfile[read_reg_b];
  assign register_v0 = (reset==1) ? 0 : regfile[2];

  integer index;
  always @(posedge clk) begin
    if (reset==1) begin                    // reset sets all registers to 0.
        for (index=0; index<32; index=index+1) begin
            regfile[index]<=0;
        end
    end

    else if (write_reg_rd != 0) begin     // does not allow writes to register 0, hence register 0 will always contain 0.

      // lwl instruction. depending on the last 2 LSB of the data address, we write the data memory into different bits of the register.
      if ( (reg_write_enable == 1) & (clk_enable == 1) & (lwl == 1) ) begin
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

      // lwr instruction. depending on the last 2 LSB of the data address, we write the data memory into different bits of the register.
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

      // writing into destination register
      else if ( (reg_write_enable == 1) & (clk_enable == 1) ) begin
        // $display("REGISTER %d BEING WRITTEN WITH %h", write_reg_rd,reg_write_data );
        regfile[write_reg_rd] <= reg_write_data;
      end

    end

  end

endmodule
