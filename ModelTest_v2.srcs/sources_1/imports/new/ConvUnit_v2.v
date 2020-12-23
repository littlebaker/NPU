`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/23 22:34:52
// Design Name: 
// Module Name: ConvUnit_v2
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


module ConvUnit_v2 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 64
	)
	(
		// Users to add ports here
		input wire U_AXIS_IS_KERNEL,
		input wire cu_input_set_arg,
		input wire cu_input_enable,
		input wire [7:0] cu_input_kernel_size,
		input wire [7:0] cu_input_input_size,
		input wire [3:0] cu_input_stride,
		input wire [7:0] cu_input_qin,		
		input wire [7:0] cu_input_qw,
		input wire [7:0] cu_input_qout,		
		input wire cu_input_relu,
		output  [31: 0] result,
		output is_result_ok,
		output cu_output_cal_fin,

		input wire [31:0] U_KERNEL_TDATA,


		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		// output wire  S_AXIS_TREADY,
		// // Data in
		// input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// // Byte qualifier
		// input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// // Indicates boundary of last packet
		// input wire  S_AXIS_TLAST,
		// // Data is in valid
		// input wire  S_AXIS_TVALID

		output [31:0] cu_output_addr_act,
		output cu_output_en_act,
		input [63:0] cu_input_dout_act

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
	localparam NUMBER_OF_INPUT_WORDS  = 1024;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [3:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1, // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
					PROCESSING = 2,
					WAIT_FOR_READING = 3,
					READ_DATA = 4;

	parameter sLOADING = 1;
	parameter sIDLE = 0;
	parameter sSLOWSTART = 1;
	parameter sCAL_LOAD = 2;
	parameter sCAL_NOLOAD = 3;
	parameter sWAITFIN = 4;
	parameter sFIN = 5;

	// // FIFO implementation signals
	// genvar byte_index;     
	// // FIFO write enable
	// wire fifo_wren;
	// // FIFO full flag
	// reg fifo_full_flag;
	// // FIFO write pointer
	// reg [bit_num-1:0] write_pointer;
	// // sink has accepted all the streaming data and stored in FIFO
	//   reg writes_done;
	// // I/O Connections assignments


	// User variable
	reg [15:0] data_count;
	wire data_ok;
	wire read_en;
	reg [31:0] raddr;
	reg reads_done;

	reg [7:0] kernel_size;
	reg [7:0] input_size;
	reg [3:0] stride;
	
	reg is_relu;

	wire [63:0] rdata;
	reg [63:0] indata;

	wire [63:0] sm_output_d1; 
	wire [63:0] sm_output_d2; 
	wire [63:0] sm_output_d3; 
	wire [63:0] sm_output_d4; 
	wire [63:0] sm_output_d5;

	wire [63:0] lb_output_d1;
	wire [63:0] lb_output_d2;
	wire [63:0] lb_output_d3;
	wire [63:0] lb_output_d4;
	wire [63:0] lb_output_d5;

	reg [63:0] kernel_d1;
	reg [63:0] kernel_d2;
	reg [63:0] kernel_d3;
	reg [63:0] kernel_d4;
	reg [63:0] kernel_d5;

	wire [79:0] mu_output_result0;
	wire [79:0] mu_output_result1;
	wire [79:0] mu_output_result2;
	wire [79:0] mu_output_result3;
	wire [79:0] mu_output_result4;

	wire [31:0] au_output_result;

	reg [63:0] kernel_mem [0:4];

	reg sm_input_loaddst;
	reg [1:0] sm_input_optmode;
	reg [3:0] sm_input_stride ;
	reg lb_input_enable;
	reg lb_input_restart;

	reg [3:0] data_load_state;
	reg [3:0] calculation_state;
	reg slow_start_fin;
	reg load_fin;
	reg line_fin;
	wire single_load_fin;
	reg calculation_fin;
	reg last_line;

	reg [7:0] x_index;
	reg [7:0] y_index;

	reg [7:0] index_width;

	reg [3:0] slow_start_count [0:1];
	reg [3:0] load_count;
	reg [3:0] load_wait_time;
	reg [15:0] cal_count_line;
	reg [3:0] loaded_groups;
	reg [3:0] kernel_counter;
	wire kernel_wren;
	wire start_load;
	wire [15:0] cal_fin_pipe;

	wire [15:0] slow_start_pipeline;
	wire [15:0] cal_pipeline;
	wire calculating;

	reg [3:0] slow_start_clks;

	wire [15:0] cp_input_data;

	wire [15:0] cp_output_s1;
	wire [15:0] cp_output_s2;
	wire [15:0] cp_output_s3;
	wire [15:0] cp_output_s4;

	reg [7:0] qin;
	reg [7:0] qw;
	reg [7:0] qout;

	wire au_output_active;
	wire rq_output_active;
	wire [7:0] rq_output_result;

	reg [3:0] kernel_count;
	reg [319:0] kernel_buf;
	

	// TODO: change kernel transfer, 1 clk, finish
	// kernel_count
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			kernel_count <= 0;
		end
		else
		begin
			if(kernel_wren)
			begin
				kernel_count <= kernel_count + 1;
			end
			else
			begin
				kernel_count <= 0;
			end
		end
	end

	// kernel_buf
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			kernel_buf <= 0;
		end
		else
		begin
			if(kernel_wren)
			begin
				case(kernel_count)
				0:
				kernel_buf[319-:32] <= U_KERNEL_TDATA;
				1:
				kernel_buf[287-:32] <= U_KERNEL_TDATA;
				2:
				kernel_buf[255-:32] <= U_KERNEL_TDATA;
				3:
				kernel_buf[223-:32] <= U_KERNEL_TDATA;
				4:
				kernel_buf[191-:32] <= U_KERNEL_TDATA;
				5:
				kernel_buf[159-:32] <= U_KERNEL_TDATA;
				6:
				kernel_buf[127-:32] <= U_KERNEL_TDATA;
				7:
				kernel_buf[95-:32] <= U_KERNEL_TDATA;
				
				default:
				kernel_buf <= kernel_buf;


				endcase
			end
		end
	end

	
	// set args like kernel size
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			kernel_size <= 0;
			input_size <= 0;
			is_relu <= 0;
			stride <= 0;
			qin <= 0;
			qw <= 0;
			qout <= 0;
		end
		else
		begin
			if(calculation_state == sIDLE && cu_input_set_arg)
			begin
				kernel_size <= cu_input_kernel_size;
				input_size <= cu_input_input_size;
				is_relu <= cu_input_relu;
				stride <= cu_input_stride;
				qin <= cu_input_qin;
				qw <= cu_input_qw;
				qout <= cu_input_qout;
			end
		end
	end

	always@(posedge S_AXIS_ACLK)
	begin
		if(input_size[2:0] == 0)
		begin
			index_width <= input_size[7:3];
		end
		else
		begin
			index_width <= input_size[7:3] + 1;
		end
	end

	// assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	// always @(posedge S_AXIS_ACLK) 
	// begin  
	//   	if (!S_AXIS_ARESETN) 
	//   	// Synchronous reset (active low)
	//     begin
	//       	mst_exec_state <= IDLE;
	//     end  
	//   	else
	//     case (mst_exec_state)
	//       IDLE: 
	//         // The sink starts accepting tdata when 
	//         // there tvalid is asserted to mark the
	//         // presence of valid streaming data 
	//           	if (cu_input_enable)
	//             begin
	//               	mst_exec_state <= PROCESSING;
	//             end
	//           	else
	//             begin
	//               	mst_exec_state <= IDLE;
	//             end

	// 		PROCESSING:
	// 		// TODO : we do not nees WAIT_FOR_READING
	// 			if(calculation_state == sFIN)
	// 			begin
	// 				mst_exec_state <= WAIT_FOR_READING;
	// 			end
	// 			else
	// 			begin
	// 				mst_exec_state <= PROCESSING;
	// 			end
	// 		WAIT_FOR_READING:
	// 			begin
	// 				mst_exec_state <= IDLE;
	// 			end
				
	//     endcase
	// end

	// state machine for data_load_state
	// always@(posedge S_AXIS_ACLK)
	// begin
	// 	if(!S_AXIS_ARESETN || (mst_exec_state != PROCESSING))
	// 	begin
	// 		data_load_state <= sLOADING;
	// 	end
	// 	else
	// 	begin
	// 		if(writes_done)
	// 		begin
	// 			data_load_state <= sFIN;
	// 		end
	// 		else
	// 		begin
	// 			data_load_state <= sLOADING;
	// 		end
	// 	end
	// end

	// state machine for calculation_state
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			calculation_state <= sIDLE;
		end
		else
		begin
			case(calculation_state)
			sIDLE:
			if(cu_input_enable)
			begin
				calculation_state <= sSLOWSTART;
			end
			else
			begin
				calculation_state <= sIDLE;
			end
				
			
			sSLOWSTART:
			if(!slow_start_fin)
			begin
				calculation_state <= sSLOWSTART;
			end
			else
			begin
				if(index_width <= 2)
				begin
					calculation_state <= sCAL_NOLOAD;
				end
				else
				begin
					calculation_state <= sCAL_LOAD;
				end
				
			end
			
			sCAL_LOAD:
			if(load_fin)
			begin
				calculation_state <= sCAL_NOLOAD;
			end
			else
			begin
				calculation_state <= sCAL_LOAD;
			end

			sCAL_NOLOAD:
			if(calculation_fin)
			begin
				calculation_state <= sFIN;
			end
			else if(line_fin)
			begin
				calculation_state <= sSLOWSTART;
			end
			else
			begin
				calculation_state <= sCAL_NOLOAD;
			end

			sFIN:
			begin
				calculation_state <= sIDLE;
			end
			default:
				calculation_state <= sIDLE;

			endcase
		end
	end

	// slow_start and count
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN || calculation_state != sSLOWSTART)
		begin
			slow_start_count[0] <= 0;
			slow_start_count[1] <= 0;
		end
		else
		begin
			if(slow_start_count[0] >= kernel_size)
			begin
				slow_start_count[1] <= slow_start_count[1] + 1;
				slow_start_count[0] <= slow_start_count[0];
			end
			else
			begin
				slow_start_count[0] <= slow_start_count[0] + 1;
				slow_start_count[1] <= slow_start_count[1];
			end

		end
	end

	// slow_start_fin
	always@(*)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(slow_start_count[0] >= kernel_size && slow_start_count[1] >= kernel_size)
			begin
				slow_start_fin = 1;
			end
			else
			begin
				slow_start_fin = 0;
			end
		end
		
	end

	// load_wait_time, depend on stride
	always@(posedge S_AXIS_ACLK)
	begin
		if(calculation_state == sIDLE)
		begin
			if(stride == 2)
			begin
				load_wait_time <= 4;
			end
			else
			begin
				load_wait_time <= 8;
			end
		end
	end

	// load_count in calculation
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN || calculation_state != sCAL_LOAD)
		begin
			load_count <= 0;
		end
		else
		begin
			if(load_count == 8)
			begin
				load_count <= 1;
			end
			else
			begin
				load_count <= load_count + 1;
			end

		end
	end


	// last_line
	always@(posedge S_AXIS_ACLK)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(index_width <= 2 && x_index >= input_size - kernel_size - stride + 1)
			begin
				last_line <= 1;
			end
			else
			begin
				last_line <= last_line;
			end
				
		end
		else if(calculation_state == sCAL_LOAD || calculation_state == sCAL_NOLOAD)
		begin
			if(x_index >= input_size - kernel_size - stride + 1 && y_index >= index_width)
			begin
				last_line <= 1;
			end
			else
			begin
				last_line <= last_line;
			end

		end
		else
		begin
			last_line <= 0;
		end
	end

	// load_fin logic
	assign single_load_fin = (load_count >= load_wait_time);
	always@(*)
	begin
		if(calculation_state == sCAL_LOAD)
		begin
			if(y_index >= index_width)
			begin
				load_fin = 1;
			end
			else
			begin
				load_fin = 0;
			end
		end
		else
		begin
			load_fin = 0;
		end

	end

	// cal_count_line
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			cal_count_line <= 0;
		end
		else
		begin
			if(calculation_state == sCAL_LOAD || calculation_state == sCAL_NOLOAD)
			begin
				if(line_fin)
				begin
					cal_count_line <= 0;
				end
				else
				begin
					if(cal_count_line == 0)
					begin
						cal_count_line <= kernel_size; 
					end
					else
					begin
						cal_count_line <= cal_count_line + stride;
					end
				end
			end
			else
			begin
				cal_count_line <= 0;
			end
		end
	end

	// line_fin
	always@(*)
	begin
		if(cal_count_line >= input_size - 1) // TODO ?? 
		begin
			line_fin = 1;
		end
		else
		begin
			line_fin = 0;
		end
	end

	// x_index & y_index !!! important
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			x_index <= 0;
			y_index <= 0;
		end
		else
		begin
			case(calculation_state)
			sSLOWSTART:
			if(slow_start_fin)
			begin
				if(index_width <= 2)
				begin
					x_index <= x_index + stride;
					y_index <= 0;
				end
				else
				begin
					x_index <= x_index;
					y_index <= y_index + 2;
				end
			end

			sCAL_LOAD:
			if(load_fin)
			begin
				x_index <= x_index + stride;
				y_index <= 0;
			end
			else if(load_count == load_wait_time - 1) // instead of using single_load_fin, this can change x every 8 clk
			begin
				x_index <= x_index;
				y_index <= y_index + 1;
			end

			sFIN:
			begin
				x_index <= 0;
				y_index <= 0;
			end

			endcase

		end
	end

	// calculation_fin
	always@(*)
	begin
		if(last_line && line_fin)
		begin
			calculation_fin = 1;
		end
		else
		begin
			calculation_fin = 0;
		end
		
	end




	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	// assign axis_tready = ((mst_exec_state == PROCESSING || mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

	// // write_pointer & writes_done
	// always@(posedge S_AXIS_ACLK)
	// begin
	// 	if(!S_AXIS_ARESETN)
	// 	begin
	// 		write_pointer <= 0;
	// 		writes_done <= 1'b0;
	// 	end  
	// 	else if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	// 	begin
	// 		if (fifo_wren)
	// 		begin
	// 			write_pointer <= write_pointer + 1;
	// 			writes_done <= 1'b0;
	// 		end
	// 		else
	// 			begin
	// 			// reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	// 			// has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	// 			writes_done <= 1'b1;
	// 			write_pointer <= 0;
	// 			end
	// 	end  
	// end

	// read_en
	assign read_en = (calculation_state == sSLOWSTART || calculation_state == sCAL_LOAD);
	assign start_load = (calculation_state == sSLOWSTART || calculation_state == sCAL_LOAD);
	assign calculating = (calculation_state == sCAL_NOLOAD || calculation_state == sCAL_LOAD);

	// FIFO write enable generation
	// assign fifo_wren = S_AXIS_TVALID && axis_tready;
	assign kernel_wren = U_AXIS_IS_KERNEL;

	// FIFO Implementation
	// reg  [C_S_AXIS_TDATA_WIDTH-1:0] input_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];
	// We use explicit bram as the cache


 
	// Streaming input data is stored in FIFO


	// always@(posedge S_AXIS_ACLK)
	// begin
	// 	if(!S_AXIS_ARESETN)
	// 	begin
	// 		data_count <= 0;
	// 	end
	// 	else
	// 	begin
	// 		if(fifo_wren)
	// 		begin
	// 			if(!U_AXIS_IS_KERNEL)
	// 				data_count <= data_count + 8;
	// 		end
	// 	end
	// end

	// lb_input_enable
	always@(*)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(!slow_start_fin)
			begin
				lb_input_enable = 1;
			end
			else
			begin
				lb_input_enable = 0;
			end
		end
		else if(calculation_state == sCAL_LOAD)
		begin
			if(load_count < kernel_size || load_count == 8)
			begin
				lb_input_enable = 1;
			end
			else
			begin
				lb_input_enable = 0;
			end
		end
		else
		begin
			lb_input_enable = 0;
		end
	end

	// lb_input_restart
	always@(*)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(slow_start_count[0] == kernel_size -1 || slow_start_count[1] == kernel_size-1)
			begin
				lb_input_restart = 1;
			end
			else
			begin
				lb_input_restart = 0;
			end
		end
		else if(calculation_state == sCAL_LOAD)
		begin
			if(load_count == load_wait_time -1 )
			begin
				lb_input_restart = 1;
			end
			else
			begin
				lb_input_restart = 0;
			end
		end
		else
		begin
			lb_input_restart = 0;
		end
	end

	// sm_input_loaddst
	always@(*)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(slow_start_count[1] == 0)
			begin
				sm_input_loaddst = 0;
			end
			else
			begin
				sm_input_loaddst = 1;
			end
		end
		
	end


	// sm_input_optmode
	always@(*)
	begin
		if(calculation_state == sSLOWSTART)
		begin
			if(slow_start_count[0]== kernel_size && (slow_start_count[1]==0 || slow_start_count[1] == kernel_size))
			begin
				sm_input_optmode = 1;
			end
			else
			begin
				sm_input_optmode = 0;
			end
		end
		else if(calculation_state == sCAL_LOAD)
		begin
			if(load_count == load_wait_time - 1)
			begin
				sm_input_optmode = 2;
			end
			else
			begin
				sm_input_optmode = 3;
			end
		end
		else if(calculation_state == sCAL_NOLOAD)
		begin
			sm_input_optmode = 3;
		end
		else
		begin
			sm_input_optmode = 3;
		end
	end

	// // kernel data load
	// TODO
	always@(*)
	begin
		case(kernel_size)
		5:
		begin
			kernel_d1[63-:40] = kernel_buf[319-:40];
			kernel_d2[63-:40] = kernel_buf[279-:40];
			kernel_d3[63-:40] = kernel_buf[239-:40];
			kernel_d4[63-:40] = kernel_buf[199-:40];
			kernel_d5[63-:40] = kernel_buf[159-:40];
		end
		4:
		begin
			kernel_d1[63-:32] = kernel_buf[319-:32];
			kernel_d2[63-:32] = kernel_buf[287-:32];
			kernel_d3[63-:32] = kernel_buf[255-:32];
			kernel_d4[63-:32] = kernel_buf[223-:32];
			
		end
		3:
		begin
			kernel_d1[63-:24] = kernel_buf[319-:24];
			kernel_d2[63-:24] = kernel_buf[295-:24];
			kernel_d3[63-:24] = kernel_buf[271-:24];
		end
		2:
		begin
			kernel_d1[63-:16] = kernel_buf[319-:16];
			kernel_d2[63-:16] = kernel_buf[303-:16];
		end
		1:
		begin
			kernel_d1[63-:8] = kernel_buf[319-:8];
		end
		endcase
	end

	// raddr generate
	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			raddr <= 0;
		end
		else
		begin
			if(calculation_state == sSLOWSTART)
			begin
				if(slow_start_count[0] != kernel_size)
				begin
					raddr <= (x_index + slow_start_count[0]) * index_width + y_index;
				end
				else
				begin
					raddr <= (x_index + slow_start_count[1]) * index_width + y_index + 1;
				end
			end
			else
			begin
				if(calculation_state == sCAL_LOAD)
				begin
					if(lb_input_enable)
					begin
						if(load_count == 8)
						begin
							raddr <= (x_index) * index_width + y_index;
						end
						else
						begin
							raddr <= (x_index + load_count) * index_width + y_index;
						end
					end
					else
					begin
						raddr <= raddr;
					end
					
				end
				else
				begin
					raddr <= raddr;
				end
			end
		end
	end
	
	// TODO:
	//	
	//	read_en
	//	sm_input_loaddst
	//	sm_input_optmode
	//	lb_input_enable
	//	lb_input_restart
	//	
	// 
	assign cp_input_data = {lb_input_restart, sm_input_optmode, sm_input_loaddst, lb_input_enable, 1'b0};
	//								5				[4:3]			2				1			0	


	// moduel instances  
	// (*keep_hierarchy = "yes"*)

	// blk_mem_gen_0  u_blk_mem_gen_0 (
	// 	.clka                    (S_AXIS_ACLK),
	// 	.ena                     (fifo_wren),
	// 	.wea                     (fifo_wren),
	// 	.addra                   (write_pointer),
	// 	.dina                    (S_AXIS_TDATA),
	// 	.clkb                    (S_AXIS_ACLK),
	// 	.enb                     (cp_output_s1[1]),
	// 	.addrb                   (raddr),

	// 	.doutb                   (rdata)
	// );

	assign cu_output_en_act = cp_output_s1[1];
	assign cu_output_addr_act = raddr;
	assign rdata = cu_input_dout_act;

	// TODO: kernel 改成挨着传
	// (*keep_hierarchy = "yes"*)
	// LoadBlock u_kernel_buf(
	// 	.lb_input_clk    	(S_AXIS_ACLK    ),
	// 	.lb_input_nrst   	(S_AXIS_ARESETN   ),
	// 	.lb_input_enable 	(U_AXIS_IS_KERNEL ),
	// 	.lb_input_data   	(S_AXIS_TDATA     ),
	// 	.lb_input_restart	(!U_AXIS_IS_KERNEL),
	// 	.lb_output_d1    	(kernel_buf[319-:64]    ),
	// 	.lb_output_d2    	(kernel_buf[255-:64]    ),
	// 	.lb_output_d3    	(kernel_buf[191-:64]    ),
	// 	.lb_output_d4    	(kernel_buf[127-:64]    ),
	// 	.lb_output_d5    	(kernel_buf[63-:64]    )
	// );
	
	// (*keep_hierarchy = "yes"*)
	ShiftMatrix u_ShiftMatrix(
		.sm_input_clk     (S_AXIS_ACLK     ),
		.sm_input_nrst    (S_AXIS_ARESETN    ),
		.sm_input_loaddst (cp_output_s2[2] ),
		.sm_input_optmode (cp_output_s2[4:3] ),
		.sm_input_stride  (stride ),
		.sm_input_d1      (lb_output_d1      ),
		.sm_input_d2      (lb_output_d2      ),
		.sm_input_d3      (lb_output_d3      ),
		.sm_input_d4      (lb_output_d4      ),
		.sm_input_d5      (lb_output_d5      ),
		.sm_output_d1     (sm_output_d1     ),
		.sm_output_d2     (sm_output_d2     ),
		.sm_output_d3     (sm_output_d3     ),
		.sm_output_d4     (sm_output_d4     ),
		.sm_output_d5     (sm_output_d5     )
	);

	// (*keep_hierarchy = "yes"*)
	LoadBlock u_load_buf(
		.lb_input_clk    	(S_AXIS_ACLK    ),
		.lb_input_nrst   	(S_AXIS_ARESETN   ),
		.lb_input_enable 	(cp_output_s2[1] ),			
		.lb_input_data   	(rdata     ),
		.lb_input_restart	(cp_output_s2[5]),
		.lb_output_d1    	(lb_output_d1    ),
		.lb_output_d2    	(lb_output_d2    ),
		.lb_output_d3    	(lb_output_d3    ),
		.lb_output_d4    	(lb_output_d4    ),
		.lb_output_d5    	(lb_output_d5    )
	);
	
	// (*keep_hierarchy = "yes"*)
	mult_unit_v2 u_mult_unit_v2(
		.mu_input_clk      (S_AXIS_ACLK      ),
		.mu_input_nrst     (S_AXIS_ARESETN     ),	
		.mu_input_enable   (cal_pipeline[1]   ),			
		.mu_input_a0       (sm_output_d1[63: 24]       ),
		.mu_input_a1       (sm_output_d2[63: 24]       ),
		.mu_input_a2       (sm_output_d3[63: 24]       ),
		.mu_input_a3       (sm_output_d4[63: 24]       ),
		.mu_input_a4       (sm_output_d5[63: 24]       ),
		.mu_input_b0       (kernel_d1[63: 24]       ),	
		.mu_input_b1       (kernel_d2[63: 24]       ),	
		.mu_input_b2       (kernel_d3[63: 24]       ),	
		.mu_input_b3       (kernel_d4[63: 24]       ),	
		.mu_input_b4       (kernel_d5[63: 24]       ),	
		.mu_output_result0 (mu_output_result0 ),
		.mu_output_result1 (mu_output_result1 ),
		.mu_output_result2 (mu_output_result2 ),
		.mu_output_result3 (mu_output_result3 ),
		.mu_output_result4 (mu_output_result4 )
	);


	ActivePipeline 
	#(
		.WIDTH (16)
	)
	u_cal_pipeline(
		.ap_input_clk    (S_AXIS_ACLK      ),
		.ap_input_nrst   (S_AXIS_ARESETN   ),
		.ap_input_enable (1 ),
		.ap_input_data   (calculating   ),		
		.ap_output_conf  (cal_pipeline  )
	);
	
	// (*keep_hierarchy = "yes"*)
	ControlPipeline u_ControlPipeline(
		.cp_input_clk    (S_AXIS_ACLK    ),
		.cp_input_nrst   (S_AXIS_ARESETN   ),
		.cp_input_enable (1 ),
		.cp_input_data   (cp_input_data   ),
		.cp_output_s1    (cp_output_s1    ),
		.cp_output_s2    (cp_output_s2    ),
		.cp_output_s3    (cp_output_s3    ),
		.cp_output_s4    (cp_output_s4    )
	);
	
	add_unit u_add_unit(
		.au_input_clk     (S_AXIS_ACLK       ),
		.au_input_nrst    (S_AXIS_ARESETN    ),
		.au_input_enable  (cal_pipeline[2]  ),
		.au_input_ksize   (kernel_size      ),
		.au_input_data0   (mu_output_result0   ),
		.au_input_data1   (mu_output_result1   ),
		.au_input_data2   (mu_output_result2   ),
		.au_input_data3   (mu_output_result3   ),
		.au_input_data4   (mu_output_result4   ),
		.au_output_result (au_output_result ),
		.au_output_active (au_output_active )
	);
	
	ReluQuantization u_ReluQuantization(
		.rq_input_clk     (S_AXIS_ACLK     ),
		.rq_input_nrst    (S_AXIS_ARESETN    ),
		.rq_input_enable  (au_output_active  ),
		.rq_input_qin     (qin     ),
		.rq_input_qw      (qw      ),
		.rq_input_qout    (qout    ),
		.rq_input_relu    (is_relu   ),
		.rq_input_data    (au_output_result    ),
		.rq_output_active (rq_output_active ),
		.rq_output_result (rq_output_result )
	);
	
	ActivePipeline 
	#(
		.WIDTH (16 )
	)
	u_cal_fin_pipe(
		.ap_input_clk    (S_AXIS_ACLK    ),
		.ap_input_nrst   (S_AXIS_ARESETN   ),
		.ap_input_enable (1 ),
		.ap_input_data   (calculation_fin   ),
		.ap_output_conf  (cal_fin_pipe  )
	);
	
	

	// Add user logic here
	assign result = rq_output_result;
	assign is_result_ok = rq_output_active;
	assign cu_output_cal_fin = cal_fin_pipe[15];

	// User logic ends

	endmodule
