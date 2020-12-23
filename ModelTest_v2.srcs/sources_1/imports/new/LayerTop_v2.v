`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 21:50:53
// Design Name: 
// Module Name: LayerTop_v2
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


module LayerTop_v2(
    lt_input_clk,
    lt_input_nrst,
    lt_input_start,
    lt_output_ready,

    lt_input_en_act ,
    lt_input_addr_act,
    lt_output_dout_act 
    );

    input lt_input_clk;
    input lt_input_nrst;
    input lt_input_start;
    output lt_output_ready;
    input lt_input_en_act  ;
    input [11:0] lt_input_addr_act;
    output [63:0] lt_output_dout_act;

    wire cl_output_ready       ; 
	wire cl_output_enb_kernel  ; 
	wire [31:0] cl_output_addrb_kernel; 
	wire [31:0] cl_input_doutb_kernel ; 
	wire cl_output_wen_act     ; 
	wire [31:0] cl_output_addra_act   ; 
	wire [63:0] cl_output_dina_act    ; 
	wire cl_output_enb_act     ; 
	wire [31:0] cl_output_addrb_act   ; 
	wire [63:0] cl_input_doutb_act    ; 

    // wire [63:0] act_write_dout;

    reg [7:0] state;
    reg [7:0] arg_count;
    // reg [31:0] read_addr;
    // reg read_en;

    parameter IDLE = 0,
        SETARG = 1,
        RUNNING = 2,
        READING = 3;

    assign lt_output_ready = cl_output_ready && (state == IDLE);

    always@(posedge lt_input_clk)
    begin
        if(!lt_input_nrst)
        begin
            state <= IDLE;
        end
        else
        begin
            case(state)
            IDLE:
            if(lt_input_start)
            begin
                state <= SETARG;
            end
            else
            begin
                state <= IDLE;
            end
            SETARG:
            if(arg_count == 7)
            begin
                state <= RUNNING;
            end
            else
            begin
                state <= SETARG;
            end
            RUNNING:
            if(cl_output_ready)
            begin
                state <= IDLE;
            end
            else
            begin
                state <= RUNNING;
            end
            


            endcase
        end
    end

    // arg_count
    always@(posedge lt_input_clk)
    begin
        if(!lt_input_nrst)
        begin
            arg_count <= 0;
        end
        else
        begin
            if(state==SETARG)
            begin
                arg_count <= arg_count + 1;
            end
            else
            begin
                arg_count <= 0;
            end
        end
    end

    // output_data
    // always@(posedge lt_input_clk)
    // begin
    //     if(!lt_input_nrst)
    //     begin
    //         lt_output_data0 <= 1;
    //         lt_output_data1 <= 64'hffffffffffffffff;
    //     end
    //     else
    //     begin
    //         lt_output_data0 <= act_write_dout;
 
    //     end
    // end


    // // read_en
    // always@(*)
    // begin
    //     read_en = state == READING;
    // end

    // // read_addr
    // always@(posedge lt_input_clk)
    // begin
    //     if(!lt_input_nrst)
    //     begin
    //         read_addr <=0;
    //     end
    //     else
    //     begin
    //         if(state == READING)
    //         begin
    //             if(read_en)
    //             begin
    //                 read_addr <= read_addr + 1;
    //             end
    //         end
    //         else
    //         begin
    //             read_addr <= 0;
    //         end
    //     end
    // end

	ConvLayer u_ConvLayer(
        .cl_input_clk            	 (lt_input_clk             ),
        .cl_input_nrst           	 (lt_input_nrst            ),
        .cl_input_enable         	 (arg_count == 5          ),
        .cl_input_setarg         	 (arg_count == 0 && state == SETARG          ),
        .cl_input_input_baseaddr 	 (0  ),
        .cl_input_kernel_baseaddr	 (0 ),
        .cl_input_input_size     	 (32      ),
        .cl_input_kernel_size    	 (5     ),
        .cl_input_output_size    	 (32     ),
        .cl_input_input_chan     	 (1      ),
        .cl_input_output_chan    	 (32     ),
        .cl_input_qin            	 (7             ),
        .cl_input_qw             	 (7              ),
        .cl_input_qout           	 (5            ),
        .cl_input_padding        	 (2         ),
        .cl_input_stride         	 (1          ),
        .cl_input_relu           	 (1            ),
        .cl_output_ready         	 (cl_output_ready          ),
        .cl_output_enb_kernel    	 (cl_output_enb_kernel     ),
        .cl_output_addrb_kernel  	 (cl_output_addrb_kernel   ),
        .cl_input_doutb_kernel   	 (cl_input_doutb_kernel    ),
        .cl_output_wen_act       	 (cl_output_wen_act        ),
        .cl_output_addra_act     	 (cl_output_addra_act      ),
        .cl_output_dina_act      	 (cl_output_dina_act       ),
        .cl_output_enb_act       	 (cl_output_enb_act        ),
        .cl_output_addrb_act     	 (cl_output_addrb_act      ),
        .cl_input_doutb_act      	 (cl_input_doutb_act       )
);

    blk_mem_kernel u_blk_mem_kernel(
        .clka                       (lt_input_clk),
        .ena                        (cl_output_enb_kernel),
        // .wea                        (0),
        .addra                      (cl_output_addrb_kernel),
        // .dina                       (0),
        .douta                         (cl_input_doutb_kernel),
        .clkb                       (lt_input_clk),
        .enb                        (0),
        .addrb                      (0),
        .doutb                      ()
    );
    
    blk_mem_act u_blk_mem_act(
        .clka                       (lt_input_clk),
        .ena                        (0),
        .wea                        (0),
        .addra                      (0),
        .dina                       (0),
        .clkb                       (lt_input_clk),
        .enb                        (cl_output_enb_act),
        .addrb                      (cl_output_addrb_act),
        .doutb                      (cl_input_doutb_act)
    );

    blk_mem_act u_blk_mem_act_write(
        .clka                       (lt_input_clk),
        .ena                        (cl_output_wen_act  ),
        .wea                        (cl_output_wen_act  ),
        .addra                      (cl_output_addra_act),
        .dina                       (cl_output_dina_act ) ,
        .clkb                       (lt_input_clk),
        .enb                        ( lt_input_en_act   ),
        .addrb                      ( lt_input_addr_act ),
        .doutb                      (lt_output_dout_act   )
    );



endmodule
