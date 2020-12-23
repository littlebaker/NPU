`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/21 14:29:26
// Design Name: 
// Module Name: ConvUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1 ns / 1 ps

	module ConvUnit #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		input wire is_kernel,
		input wire write_ok,
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	localparam NUMBER_OF_INPUT_WORDS  = 64;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [3:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1, // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
					WAIT_FOR_CAL_FIN = 2,
					WAIT_FOR_WRITE_FIN = 3;
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	  reg writes_done;
	// I/O Connections assignments


	// User variable
	reg [31: 0] data_read;
	reg [31: 0] read_address;
	reg [15:0] kernel_pointer;

	reg [3:0] stride;
	reg [15: 0] kernel_size;
	reg [15: 0] input_size; 

	reg [15: 0] x;
	reg [15: 0] y;
	reg [31: 0] data_front [0:4];
	reg [31: 0] data_back [0:4];
	reg [63: 0] data_buf [0:4];

	reg [7:0] data_cal_1 [0:4];
	reg [7:0] data_cal_2 [0:4];
	reg [7:0] data_cal_3 [0:4];
	reg [7:0] data_cal_4 [0:4];
	reg [7:0] data_cal_5 [0:4];

	reg [7:0] kernel_buf [0:24];

	reg [15:0] start_pos [0:4];
	reg [15: 0] start_bias [0:4];

	wire [127:0] mult_data_1;
	wire [127:0] mult_data_2;

	wire [127:0] mult_data_3;
	wire [127:0] mult_data_4;
	reg [199:0] cal_buf;

	wire [255:0] mult_result_1;
	wire [255:0] mult_result_2;

	wire [31:0] add_result_1;
	wire [31:0] add_result_2;

	wire enable_second_unit;

	reg [31:0] data_count;
	wire data_ok;
	reg addr_out;			// if all the address in this feature has been used.

	genvar i;

	assign enable_second_unit = (kernel_size==5);

	assign mult_data_1 = cal_buf[127:0];
	assign mult_data_3[199-128:0] = cal_buf[199:128];
	assign mult_data_2 = {
		kernel_buf[0], kernel_buf[1], kernel_buf[2], kernel_buf[3], 
		kernel_buf[4], kernel_buf[5], kernel_buf[6], kernel_buf[7], 
		kernel_buf[8], kernel_buf[9], kernel_buf[10], kernel_buf[11], 
		kernel_buf[12], kernel_buf[13], kernel_buf[14], kernel_buf[15]
	};
	assign mult_data_4 = {
		kernel_buf[16], kernel_buf[17], kernel_buf[18], kernel_buf[19], 
		kernel_buf[20], kernel_buf[21], kernel_buf[22], kernel_buf[23], 
		kernel_buf[24]
	};


	assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (S_AXIS_TVALID)
	            begin
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	            end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done)
	          begin
	            mst_exec_state <= WAIT_FOR_CAL_FIN;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end
			WAIT_FOR_CAL_FIN:
			if(addr_out)
			begin
				mst_exec_state <= WAIT_FOR_WRITE_FIN;
			end
			else
			begin
				mst_exec_state <= WAIT_FOR_CAL_FIN;
			end
			WAIT_FOR_WRITE_FIN:
			if(write_ok)
			begin
				mst_exec_state <= IDLE;
			end
			else
			begin
				mst_exec_state <= WAIT_FOR_WRITE_FIN;
			end

	    endcase
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

	always@(posedge S_AXIS_ACLK)
	begin
	  if(!S_AXIS_ARESETN)
	    begin
	      write_pointer <= 0;
		  kernel_pointer <= 0;
	      writes_done <= 1'b0;
	    end  
	  else
	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
	        if (fifo_wren)
	          begin
	            // write pointer is incremented after every write to the FIFO
	            // when FIFO write signal is enabled.
				if(is_kernel)
				begin
					kernel_pointer <= kernel_pointer +1;
				end
				else
				begin
	           		write_pointer <= write_pointer + 1;
				end
	            writes_done <= 1'b0;
	          end
	          if ((write_pointer == NUMBER_OF_INPUT_WORDS-1)|| S_AXIS_TLAST)
	            begin
	              // reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	              // has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	              writes_done <= 1'b1;
				  kernel_pointer <= 0;
				  write_pointer <= 0;
	            end
	      end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
	reg  [C_S_AXIS_TDATA_WIDTH-1:0] input_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];
	// reg [31-1:0] kernel_data_fifo [0:64];
 
	// Streaming input data is stored in FIFO

	always @( posedge S_AXIS_ACLK )
	begin
		if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
		begin
			if(is_kernel)
			begin
				// kernel_data_fifo[kernel_pointer] <= S_AXIS_TDATA;
				kernel_buf[0+kernel_pointer*4] <= S_AXIS_TDATA[0 +:8];
				kernel_buf[1+kernel_pointer*4] <= S_AXIS_TDATA[8 +:8];
				kernel_buf[2+kernel_pointer*4] <= S_AXIS_TDATA[16 +:8];
				kernel_buf[3+kernel_pointer*4] <= S_AXIS_TDATA[24 +:8];
			end
			else
			begin
				input_data_fifo[write_pointer] <= S_AXIS_TDATA;
			end
		end  
	end  

	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			data_count <= 0;
		end
		else
		begin
			if(fifo_wren)
			begin
				data_count <= data_count + 4;
			end
		end
	end

	assign data_ok = ((start_pos[4] + 4) <= data_count);

	always@( posedge S_AXIS_ACLK )
	begin 
		data_front[0] <= input_data_fifo[start_pos[0]>>2];
		data_front[1] <= input_data_fifo[start_pos[1]>>2];
		data_front[2] <= input_data_fifo[start_pos[2]>>2];
		data_front[3] <= input_data_fifo[start_pos[3]>>2];
		data_front[4] <= input_data_fifo[start_pos[4]>>2];

		data_back[0] <= input_data_fifo[start_pos[0]>>2 + 1];
		data_back[1] <= input_data_fifo[start_pos[1]>>2 + 1];
		data_back[2] <= input_data_fifo[start_pos[2]>>2 + 1];
		data_back[3] <= input_data_fifo[start_pos[3]>>2 + 1];
		data_back[4] <= input_data_fifo[start_pos[4]>>2 + 1];

	end

	// process data_buf
	always@(*)
	begin
		data_buf[0] = {data_front[0], data_back[0]};
		data_buf[1] = {data_front[1], data_back[1]};
		data_buf[2] = {data_front[2], data_back[2]};
		data_buf[3] = {data_front[3], data_back[3]};
		data_buf[4] = {data_front[4], data_back[4]};
	end

	// process start_pos and start_bias
	always@(*)
	begin
		start_pos[0] = (x*input_size+y);
		start_pos[1] = ((x+1)*input_size+y);
		start_pos[2] = ((x+2)*input_size+y);
		start_pos[3] = ((x+3)*input_size+y);
		start_pos[4] = ((x+4)*input_size+y);

		start_bias[0] = start_pos[0][1:0];
		start_bias[1] = start_pos[1][1:0];
		start_bias[2] = start_pos[2][1:0];
		start_bias[3] = start_pos[3][1:0];
		start_bias[4] = start_pos[4][1:0];

	end

	generate
		for(i=0;i<=4;i=i+1)
		begin:DATA_BLOCK
		always@(*)
		begin
			data_cal_1[i] = data_buf[0][(start_bias[0]+i)*8 +: 8];
			data_cal_2[i] = data_buf[1][(start_bias[1]+i)*8 +: 8];
			data_cal_3[i] = data_buf[2][(start_bias[2]+i)*8 +: 8];
			data_cal_4[i] <= data_buf[3][(start_bias[3]+i)*8 +: 8];
			data_cal_5[i] = data_buf[4][(start_bias[4]+i)*8 +: 8];
		end
		end
	endgenerate

	// load calculate data, base on kernel size
	always@(*)
	begin
		case(kernel_size)
		1:
		cal_buf = data_cal_1[0];
		2:
		cal_buf = {data_cal_1[0], data_cal_1[1], data_cal_2[0], data_cal_2[1]};
		3:
		cal_buf = {data_cal_1[0], data_cal_1[1], data_cal_1[2], 
					data_cal_2[0], data_cal_2[1], data_cal_2[2],
					data_cal_3[0], data_cal_3[1], data_cal_3[2]};
		4:
		cal_buf = {data_cal_1[0], data_cal_1[1], data_cal_1[2], data_cal_1[3], 
					data_cal_2[0], data_cal_2[1], data_cal_2[2], data_cal_2[3],
					data_cal_3[0], data_cal_3[1], data_cal_3[2], data_cal_3[3],
					data_cal_4[0], data_cal_4[1], data_cal_4[2], data_cal_4[3]};
		5:
		cal_buf = {data_cal_1[0], data_cal_1[1],data_cal_1[2],data_cal_1[3],data_cal_1[4],
					data_cal_2[0], data_cal_2[1],data_cal_2[2],data_cal_2[3],data_cal_2[4],
					data_cal_3[0], data_cal_3[1],data_cal_3[2],data_cal_3[3],data_cal_3[4],
					data_cal_4[0], data_cal_4[1],data_cal_4[2],data_cal_4[3],data_cal_4[4],
					data_cal_5[0], data_cal_5[1],data_cal_5[2],data_cal_5[3],data_cal_5[4]};

		default:
		cal_buf = 200'hx;

		endcase
	end

	// x, y address generate
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			x <= 0;
			y <= 0;
		end
		else
		begin
			if(!data_ok)
			begin
				x <= x;
				y <= y;
			end
			else
			begin
				if(y == input_size-kernel_size)
				begin
					y <= 0;
					if(x == input_size - kernel_size)
					begin
						x <= 0;
					end
					else
					begin
						x <= x+1;
					end
				end
				else
				begin
					y <= y+1;
				end
			end

		end
	end

	// instantiate 2 model
	mult_unit u0(
		.mu_input_clk				(S_AXIS_ACLK),
    	.mu_input_nrst				(S_AXIS_ARESETN),
    	.mu_input_enable			(data_ok),		// TODO: add some conditions
    	.mu_input_a					(mult_data_1),
    	.mu_input_b					(mult_data_2),
    	.mu_output_result			(mult_result_1)
	);

	mult_unit u1(
		.mu_input_clk				(S_AXIS_ACLK),
    	.mu_input_nrst				(S_AXIS_ARESETN),
    	.mu_input_enable			(enable_second_unit & data_ok),		// TODO: add some conditions
    	.mu_input_a					(mult_data_3),
    	.mu_input_b					(mult_data_4),
    	.mu_output_result			(mult_result_2)
	);

	sum_unit u2(
		.su_input_clk				(S_AXIS_ACLK),
    	.su_input_nrst				(S_AXIS_ARESETN),
    	.su_input_enable			(1),
    	.su_input_data				(mult_result_1),							// TODO: add conditions.
    	.su_input_ksize				(kernel_size),
    	.su_output_result			(add_result_1)
	);

	sum_unit u3(
		.su_input_clk				(S_AXIS_ACLK),
    	.su_input_nrst				(S_AXIS_ARESETN),
    	.su_input_enable			(enable_second_unit),
    	.su_input_data				(mult_result_2),							// TODO: add conditions.
    	.su_input_ksize				(3),
    	.su_output_result			(add_result_2)
	);

	

	// Add user logic here


	// User logic ends

	endmodule

