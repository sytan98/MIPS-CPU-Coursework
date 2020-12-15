module bus_memory(
	input logic clk,
	input logic[31:0] address,
	input logic write,
    input logic read,
	input logic[3:0] num_stalls,
    output logic waitrequest,
    input logic[31:0] writedata,
    input logic[3:0] byteenable,
    output logic[31:0] readdata
);
	// Memory (256 x 4 x 8-bit bytes) address is 32 bits (used only 10), word is 32 bits
	// Full memory supposed to be able to store 2^30 words but we reduce it to store 2^8 (256) words.
	// 10 bits used for address as it is byte addressing.
	parameter ROM_INIT_FILE = "";
	parameter RAM_INIT_FILE = "";
	parameter address_bit_size = 11;
	parameter reset_vector = 128; // this is word addressing, technically should be 0xbfc00000

	logic[3:0] num_stall_reg;
	// instructions start at word 128
	// this divides memory equally between data(first half excluding address 0) and instructions (second half starting at word 128)


	// If address > BFC00000, it is instruction address and needs to be mapped to start at word 128
	// otherwise, it is a data address (keep the same)

	logic[address_bit_size - 1: 0] mapped_address;

	assign mapped_address = (address >=32'hBFC00000) ? address[address_bit_size-1:0] - 32'hBFC00000+32'h00000200 : address[address_bit_size-1:0];

	// Update readdata - only available one cycle after read request

	logic[7:0] bytes [0: (2**address_bit_size-1)*4];

	//mem state
	typedef enum logic[1:0] {
			IDLE = 2'b00,
			BUSY = 2'b01,
			CHILL = 2'b10
	} state_t;

	logic[1:0] state;
 	// Stall stores the value of waitrequest
 	logic[3:0] stall;

	initial begin
		state = IDLE;
		stall = 0;
	end

	// end
	always_comb begin
		if (read == 1 || write==1) begin
			if (state != CHILL) begin
				waitrequest = 1;
			end
			else begin
				waitrequest = 0;
			end
		end
		else begin
			waitrequest = 0;
		end
	end
	assign check_state = state;

  	//write writedata to mapped_address word
	always @(posedge clk) begin
		$display("From bus memory, read=%h", read);
		$display("From bus memory, write=%h", write);
		$display("From bus memory, state=%h", state);
		$display("From bus memory, num_stall_reg=%h", num_stall_reg);
		$display("From bus memory, stall=%h", stall);

		if (state == IDLE & num_stalls != 0) begin
			if (stall==0 & (write==1 || read==1)) begin // if read/write are asserted, start waitrequest
				stall<=1;
				state <= BUSY;
				num_stall_reg <= num_stalls;
			end
		end
		else if (num_stalls == 0 & state != BUSY) begin
			$display("From bus memory, perfect memory");
			if (write == 1) begin // write
				if (byteenable[0]) bytes[mapped_address] <=  writedata[7:0];
	      		if (byteenable[1]) bytes[mapped_address+1] <= writedata[15:8];
	      		if (byteenable[2]) bytes[mapped_address+2] <= writedata[23:16];
	      		if (byteenable[3]) bytes[mapped_address+3] <= writedata[31:24];
				stall<=0;
				state <= CHILL;
			end
			else if (read == 1) begin // read
				readdata <= {byteenable[3] ? bytes[mapped_address+3] : 8'h00,
							byteenable[2] ? bytes[mapped_address+2] : 8'h00,
							byteenable[1] ? bytes[mapped_address+1] : 8'h00,
							byteenable[0] ? bytes[mapped_address] : 8'h00};
				stall<=0;
				state <= CHILL;
			end
		end
		else if (state == BUSY) begin
			if ((write == 1 | read == 1) & stall != num_stall_reg) begin
				stall <= stall + 1;
			end
			else if (write == 1 & stall==num_stall_reg) begin // write
				if (byteenable[0]) bytes[mapped_address] <=  writedata[7:0];
	      		if (byteenable[1]) bytes[mapped_address+1] <= writedata[15:8];
	      		if (byteenable[2]) bytes[mapped_address+2] <= writedata[23:16];
	      		if (byteenable[3]) bytes[mapped_address+3] <= writedata[31:24];
				// bytes[mapped_address] <= writedata[7:0] & byteenable[0];
				// bytes[mapped_address+1] <= writedata[15:8] & byteenable[1];
				// bytes[mapped_address+2] <= writedata[23:16] & byteenable[2];
				// bytes[mapped_address+3] <= writedata[31:24] & byteenable[3];
				stall<=0;
				state <= CHILL;
			end
			else if (read == 1 & stall==num_stall_reg) begin // read
				readdata <= {byteenable[3] ? bytes[mapped_address+3] : 8'h00,
							byteenable[2] ? bytes[mapped_address+2] : 8'h00,
							byteenable[1] ? bytes[mapped_address+1] : 8'h00,
							byteenable[0] ? bytes[mapped_address] : 8'h00};
				stall<=0;
				state <= CHILL;
			end
			else begin
				stall <= 0;
				state <= CHILL;
			end
		end
		else if (state == CHILL) begin
			state <= IDLE;
		end

  	end

  	// if (write == 1 && stall==1) begin // write
      		// if (byteenable[0]) bytes[mapped_address] <=  writedata[7:0];
      		// if (byteenable[1]) bytes[mapped_address+1] <= writedata[15:8];
      		// if (byteenable[2]) bytes[mapped_address+2] <= writedata[23:16];
      		// if (byteenable[3]) bytes[mapped_address+3] <= writedata[31:24];
     //  		stall<=0;
    	// end
    	// if (read == 1 && stall==1) begin // read
     //  		readdata <= {bytes[mapped_address+3], bytes[mapped_address+2], bytes[mapped_address+1], bytes[mapped_address]};
     //  		stall<=0;
    	// end

  	//Initialise memory:

	initial begin
		if (ROM_INIT_FILE != "") begin // instruction memory
			$readmemh(ROM_INIT_FILE, bytes, reset_vector*4); // multiply by 4 to get byte addressing
		end
		// if (RAM_INIT_FILE != "") begin
      	// 	$readmemh(RAM_INIT_FILE, bytes, 4); // data memory - don't write to address 0
    	// end
	end


endmodule
