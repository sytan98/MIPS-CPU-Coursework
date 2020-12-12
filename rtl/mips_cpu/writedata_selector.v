// module to select data to write into memory based on control signal write_data_sel.

module writedata_selector(
  input logic[31:0] read_data_b,     // from register_file.v, data from register rt
  input logic [4:0] write_data_sel,  // from control.v,
  output logic[31:0] writedata       // output, connceted to memory
);

  always @(*) begin
    case (write_data_sel)
        0: writedata = read_data_b;                         // sw
        1: writedata = {24'h000000, read_data_b[7:0]};      // sb byteenable=4'b0001
        2: writedata = {16'h0000, read_data_b[7:0], 8'h00}; // sb byteenable=4'b0010
        3: writedata = {8'h00, read_data_b[7:0], 16'h0000}; // sb byteenable=4'b0100
        4: writedata = {read_data_b[7:0], 24'h000000};      // sb byteenable=4'b1000
        5: writedata = {16'h0000, read_data_b[15:0]};       // sh byteenable=4'b0011
        6: writedata = {read_data_b[15:0], 16'h0000};       // sh byteenable=4'b1100
        default: writedata = read_data_b;
    endcase
  end
endmodule
