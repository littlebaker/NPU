`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 15:27:02
// Design Name: 
// Module Name: PreLoader
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


module MemoryGate(
    mg_input_clk,
    mg_input_nrst,
    mg_input_setarg,
    mg_input_padding,
    mg_input_input_size,
    mg_input_kernel_size,

    mg_input_stride,
    mg_input_enable,
    mg_input_qin,
    mg_input_qw,
    mg_input_qout,
    mg_input_relu,

    mg_output_ready,            
    mg_output_reading,
    mg_output_cal_fin,


    mg_output_enb_kernel,
    mg_output_addrb_kernel,
    mg_input_doutb_kernel,

    mg_output_result,
    mg_output_is_result_ok,

    mg_output_enb_act,
    mg_output_addrb_act,
    mg_input_doutb_act



    );
    input mg_input_clk;
    input mg_input_nrst;
    input mg_input_setarg;
    input [3:0] mg_input_padding;
    input [7:0] mg_input_input_size;
    input [7:0] mg_input_kernel_size;
    input [3:0] mg_input_stride;
    input [7:0] mg_input_enable;
    input [7:0] mg_input_qin ;
    input [7:0] mg_input_qw  ;
    input [7:0] mg_input_qout;
    input mg_input_relu;

    output mg_output_reading;
    output mg_output_ready;

    output mg_output_enb_kernel;
    output [31:0] mg_output_addrb_kernel;
    input [31:0] mg_input_doutb_kernel;

    output [7:0] mg_output_result;
    output mg_output_is_result_ok;
    output mg_output_cal_fin;

    output mg_output_enb_act;
    output [31:0] mg_output_addrb_act;
    input [63:0] mg_input_doutb_act;

    wire [7:0] result      ;
    wire is_result_ok;
    wire [3:0] arg_pipe;
 

    reg [7:0] state;

    // reg [7:0] input_channel;
    // reg [7:0] output_channel;
    reg [7:0] input_size;
    reg [3:0] padding;
    reg [7:0] kernel_size;
    reg [7:0] stride;

    // kernel load control
    wire kernel_en;
    reg [31:0] kernel_addr;
    reg [31:0] dout_kernel;
    reg [7:0] kernel_count;

    parameter IDLE = 0;
    parameter LOAD_DATA = 1;
    parameter LOAD_INPUT = 2;
    parameter WAIT_FOR_CAL_FIN = 3;
    parameter WAIT_FOR_READ = 4;

    reg kernel_load_fin;
    reg act_load_fin;
    wire cal_fin;
    reg write_back_fin;

    // act load control
    wire act_en;
    reg [31:0] act_addr;
    reg dout_act;
    reg [31:0] act_count;
    
    // axis bus
    // reg axis_is_kernel;
    // wire axis_tready;
    // wire [63:0] axis_tdata;
    // reg axis_tlast;
    // reg axis_tvalid;
    // wire [3:0] axis_tvalid_pipe;

    // pipe and max_num
    wire [15:0] kernel_pipe;
    wire [15:0] act_pipe;
    wire [15:0] valid_pipe;
    (*use_dsp="yes"*) reg [7:0] kernel_max_num;
    (*use_dsp="yes"*) reg [31:0] act_max_num;

    wire [63:0] pa_output_result;

    reg [7:0] padding_state;
    parameter pIDLE = 0;
    parameter pBEFORE = 1;
    parameter pBETWEEN = 2;
    parameter pAFTER = 3;
    parameter pFIN = 4;

    wire before_padding_fin;
    reg [7:0] before_padding_count;
    wire between_padding_fin;
    reg [15:0] between_padding_count;
    wire after_padding_fin;
    reg [7:0] after_padding_count;

    reg [7:0] real_input_size;
    reg [7:0] index_width;
    reg [7:0] raw_width;

    // input_buffer
    reg input_wen;
    reg [31:0] input_write_pointer;
    reg [63:0] input_buf_data;
    wire input_ren;
    reg [31:0] input_read_pointer;

    wire [31:0] cu_output_addr_act;
    wire cu_output_en_act;
    wire [63:0] cu_input_dout_act;
    reg cu_input_enable;

    reg [7:0] line_count;
    reg [15:0] total_act_count;

    // mg_output_ready
    assign mg_output_ready = state == IDLE;

    // padding_count
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            before_padding_count <=0;
            between_padding_count <= 0;
            after_padding_count <= 0;
        end
        else
        begin
            if(padding_state == pBEFORE)
            begin
                before_padding_count <= before_padding_count + 1;
            end
            else
            begin
                before_padding_count <=0;
            end
            if(padding_state == pBETWEEN)
            begin
                between_padding_count <= between_padding_count + 1;
            end
            else
            begin
                between_padding_count <=0;
            end
            if(padding_state == pAFTER)
            begin
                after_padding_count <= after_padding_count + 1;
            end
            else
            begin
                after_padding_count <=0;
            end
        end
    end

    // cu_input_enable
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            cu_input_enable <= 0;
        end
        else
        begin
            if(padding_state == pAFTER && after_padding_count ==0)
            begin
                cu_input_enable <= 1;
            end
            else
            begin
                cu_input_enable <= 0;
            end
        end
    end

    assign before_padding_fin = before_padding_count >= index_width * padding;
    assign between_padding_fin = between_padding_count >= input_size * index_width;
    assign after_padding_fin = after_padding_count >= index_width * padding;

    // input_wen
    always@(*)
    begin
        case(padding_state)
        pBEFORE:
        begin
            input_wen = !before_padding_fin;
        end
        pBETWEEN:
        begin
            // TODO: add pipe control
            input_wen = valid_pipe[2];
        end
        pAFTER:
        begin
            input_wen = !after_padding_fin;
        end
        default:
        begin
            input_wen = 0;
        end

        endcase
    end

    // input_write_pointer
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            input_write_pointer <= 0;
        end
        else
        begin
            case(padding_state)
            pBEFORE:
            begin
                if(!before_padding_fin)
                begin
                    input_write_pointer <= input_write_pointer + 1;
                end
                
            end
            pBETWEEN:
            if(valid_pipe[2])
            begin
                input_write_pointer <= input_write_pointer + 1;
            end
            pAFTER:
            begin
                input_write_pointer <= input_write_pointer + 1;
            end
            default:
            begin
                input_write_pointer <= 0;
            end
            endcase
        end
    end
    
    // input_buf_data
    always@(*)
    begin
        case(padding_state)
        pBEFORE:
        begin
            input_buf_data = 0;
        end
        pBETWEEN:
        if(valid_pipe[2])
        begin
            input_buf_data = pa_output_result;
        end
        pAFTER:
        begin
            input_buf_data = 0;
        end
        default:
        begin
            input_buf_data = 0;
        end
        endcase

    end

    // kernel_max_num   
    always@(posedge mg_input_clk)
    begin
        if(state == IDLE)
        begin
            kernel_max_num <= kernel_size * kernel_size / 4 + 1;
        end
        
    end

    // act_max_num
    always@(posedge mg_input_clk)
    begin
        if(state == IDLE)
        begin
            if(input_size[2:0] == 0)
            begin
                act_max_num <= input_size[7:3] * input_size;
            end
            else
            begin
                act_max_num <= input_size[7:3] * input_size + input_size;
            end
        end
        
    end

    // real_input_size
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            real_input_size <= 0;
        end
        else
        begin
            if(state == IDLE)
            begin
                real_input_size <= input_size + 2 * padding;
            end
            
        end
    end

    // cal_fin
    assign cal_fin = mg_output_cal_fin; 


    // index_width
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            index_width <= 0;
            raw_width <= 0;
        end
        else
        begin
            if(state == IDLE)
            begin
                if(real_input_size[2:0] == 0)
                begin
                    index_width <= real_input_size[7:3];
                end
                else
                begin
                    index_width <= real_input_size[7:3] + 1;
                end

                if(input_size [2:0] == 0)
                begin
                    raw_width <= input_size[7:3];
                end
                else
                begin
                    raw_width <= input_size[7:3] + 1;
                end
            end
        end
    end

    assign mg_output_reading = (state == LOAD_INPUT);

    // total_act_count
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            total_act_count <= 0;
        end
        else
        begin
            if(state == IDLE)
            begin
                total_act_count <= (input_size + 2* padding) * index_width;
            end
        end
    end

    // set arg
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            // input_channel <= 0;
            // output_channel <= 0;
            padding <= 0;
            input_size <= 0;
            kernel_size <= 0;
            stride <= 0;
        end
        else if(state == IDLE && mg_input_setarg)
        begin
            // input_channel <= mg_input_input_channel;
            // output_channel <= mg_input_output_channel;
            padding <= mg_input_padding;
            input_size <= mg_input_input_size;
            kernel_size <= mg_input_kernel_size;
            stride <= mg_input_stride;
        end
        else
        begin
            // input_channel <= input_channel;
            // output_channel <= output_channel;
            padding <= padding;
            input_size <= input_size;
            kernel_size <= kernel_size;
            stride <= stride;
        end
    end

    // kernel data load control
    assign kernel_en = (state == LOAD_DATA) && (kernel_count < kernel_max_num);
    assign mg_output_enb_kernel = kernel_pipe[0];
    assign mg_output_addrb_kernel = kernel_addr;
    always@(*)
    begin
        dout_kernel = mg_input_doutb_kernel;
    end

    // line_count
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            line_count <= 0;
        end
        else
        begin
            if(padding_state == pBETWEEN)
            begin
                if(line_count == index_width -1)
                begin
                    line_count <= 0;
                end
                else
                begin
                    line_count <= line_count + 1;
                end
            end
        end
    end

    // act data load control
    assign act_en = (padding_state == pBETWEEN) && (line_count < raw_width) && (line_count < index_width);
    assign mg_output_enb_act = act_pipe[0];
    assign mg_output_addrb_act = act_addr;
    always@(*)
    begin
        dout_act = pa_output_result;
    end
    

    // state transfer
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            state <= IDLE;
        end
        else
        begin
            case(state)
            IDLE:
            if(mg_input_enable)
            begin
                state <= LOAD_DATA;
            end
            else
            begin
                state <= IDLE;
            end

            LOAD_DATA:
            if(kernel_load_fin && act_load_fin)
            begin
                state <= WAIT_FOR_CAL_FIN;
            end
            else
            begin
                state <= LOAD_DATA;
            end

            WAIT_FOR_CAL_FIN:
            if(cal_fin)
            begin
                state <= WAIT_FOR_READ;
            end
            else
            begin
                state <= WAIT_FOR_CAL_FIN;
            end

            WAIT_FOR_READ:
            begin
                state <= IDLE;
            end


            endcase
        end
    end

    // padding_state transfer
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            padding_state <= pIDLE;
        end
        else
        begin
            case(padding_state)
            pIDLE:
            if(state == LOAD_DATA)
            begin
                padding_state <= pBEFORE;
            end

            pBEFORE:
            if(before_padding_fin)
            begin
                padding_state <= pBETWEEN;
            end
            
            
            pBETWEEN:
            if(between_padding_fin && valid_pipe[2] == 0)
            begin
                padding_state <= pAFTER;
            end

            pAFTER:
            if(after_padding_fin)
            begin
                padding_state <= pFIN;
            end

            pFIN:
            if(state == IDLE)
            begin
                padding_state <= pIDLE;
            end

            endcase
        end
    end

    // kernel_addr
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            kernel_addr <= 0;
        end
        else
        begin
            if(state == LOAD_DATA && kernel_count < kernel_max_num)
            begin
                kernel_addr <= kernel_count;
            end
            else
            begin
                kernel_addr <= 0;
            end
        end
    end

    // act_addr
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            act_addr <= 0;
        end
        else
        begin
            if(padding_state == pBETWEEN)
            begin
                if(act_en)
                begin
                    act_addr <= act_count;
                end
                else
                begin
                    act_addr <= act_addr;
                end
            end
            else
            begin
                act_addr <= 0;
            end
        end
    end

    // act_count
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            act_count <= 0;
        end
        else
        begin
            if(padding_state == pBETWEEN)
            begin
                if(act_en)
                begin
                    act_count <= act_count + 1;
                end
                else
                begin
                    act_count <= act_count;
                end
            end
            else
            begin
                act_count <= 0;
            end
        end


    end

    // kernel_count
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            kernel_count <= 0;
        end
        else
        begin
            if(state == LOAD_DATA)
            begin
                kernel_count <= kernel_count + 1;
            end
            else
            begin
                kernel_count <= 0;
            end

        end
    end

    // kernel_load_fin
    always@(*)
    begin
        kernel_load_fin = kernel_count >= kernel_max_num;
    end

    // act_load_fin
    always@(*)
    begin
        act_load_fin = padding_state == pFIN;
    end
    
    // // axi_tvalid
    // always@(posedge mg_input_clk)
    // begin
    //     if(!mg_input_nrst)
    //     begin
    //         axis_tvalid <= 0;
    //     end
    //     else
    //     begin
    //         if(padding_state == pBETWEEN && act_count >= 2)
    //         begin
    //             axis_tvalid <= 1;
    //         end
    //         else if(input_read_pointer >= total_act_count - 1)
    //         begin
    //             axis_tvalid <= 0;
    //         end
    //         else
    //         begin
    //             axis_tvalid <= axis_tvalid;
    //         end
    //     end
    // end

    // axis_tlast
    // always@(posedge mg_input_clk)
    // begin
    //     if(!mg_input_nrst)
    //     begin
    //         axis_tlast <= 0;
    //     end
    //     else
    //     begin
    //         if(input_read_pointer == total_act_count -1)
    //         begin
    //             axis_tlast <= 1;
    //         end
    //         else 
    //         begin
    //             axis_tlast <= 0;
    //         end
    //     end
    // end

    // assign input_ren = axis_tvalid && axis_tready;
    
    // input_read_pointer
    always@(posedge mg_input_clk)
    begin
        if(!mg_input_nrst)
        begin
            input_read_pointer <= 0;
        end
        else
        begin
            if(input_ren)
            begin
                input_read_pointer <= input_read_pointer + 1;
            end
            else
            begin
                input_read_pointer <= 0;
            end
        end
    end



    // instances
    ActivePipeline 
	#(
		.WIDTH (16)
	)
	u_kernel_pipeline(
		.ap_input_clk    (mg_input_clk      ),
		.ap_input_nrst   (mg_input_nrst   ),
		.ap_input_enable (1 ),
		.ap_input_data   (kernel_en   ),		
		.ap_output_conf  (kernel_pipe  )
	);

     ActivePipeline 
	#(
		.WIDTH (16)
	)
	u_act_pipeline(
		.ap_input_clk    (mg_input_clk      ),
		.ap_input_nrst   (mg_input_nrst   ),
		.ap_input_enable (1 ),
		.ap_input_data   (act_en   ),		
		.ap_output_conf  (act_pipe  )
	);



    ConvUnit_v2 u_ConvUnit_v2(
    	.U_AXIS_IS_KERNEL       (kernel_pipe[1]       ),  
        .cu_input_set_arg       (arg_pipe[3]       ),   
        .cu_input_enable        (cu_input_enable        ),      // TODO
        .cu_input_kernel_size   (mg_input_kernel_size   ),
        .cu_input_input_size    (real_input_size    ),
        .cu_input_stride        (mg_input_stride        ),
        .cu_input_qin           (mg_input_qin           ),
        .cu_input_qw            (mg_input_qw            ),
        .cu_input_qout          (mg_input_qout          ),
        .cu_input_relu          (mg_input_relu          ),
        .result                 (result                 ), 
        .is_result_ok           (is_result_ok           ), 
        .cu_output_cal_fin      (mg_output_cal_fin      ),
        .U_KERNEL_TDATA         (dout_kernel         ),  
        .S_AXIS_ACLK            (mg_input_clk            ),
        .S_AXIS_ARESETN         (mg_input_nrst         ),
        .cu_output_addr_act     (cu_output_addr_act     ),      // TODO
        .cu_output_en_act       (cu_output_en_act       ),      // TODO
        .cu_input_dout_act      (cu_input_dout_act      )       // TODO
    );
    

    PaddingArray u_PaddingArray(
    	.pa_input_clk     (mg_input_clk     ),
        .pa_input_nrst    (mg_input_nrst    ),
        .pa_input_enable  (act_pipe[1]  ),  
        .pa_input_setp    (mg_input_setarg    ),  
        .pa_input_padding (mg_input_padding ),
        .pa_input_data    (mg_input_doutb_act    ),
        .pa_output_result (pa_output_result )    
    );

    ActivePipeline 
    #(
        .WIDTH (16 )
    )
    u_tvalid(
    	.ap_input_clk    (mg_input_clk    ),
        .ap_input_nrst   (mg_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (padding_state == pBETWEEN && !between_padding_fin  ),
        .ap_output_conf  (valid_pipe  )
    );
    
    
    blk_mem_input_buffer u_input_buffer(
        .clka                           (mg_input_clk),
        .ena                            (input_wen),
        .wea                            (input_wen),
        .addra                          (input_write_pointer),
        .dina                           (input_buf_data),
        .clkb                           (mg_input_clk),
        .enb                            (cu_output_en_act),
        .addrb                          (cu_output_addr_act),
        .doutb                          (cu_input_dout_act) 
    );
    
    ActivePipeline 
    #(
        .WIDTH (4 )
    )
    u_ActivePipeline(
    	.ap_input_clk    (mg_input_clk    ),
        .ap_input_nrst   (mg_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (mg_input_setarg   ),
        .ap_output_conf  (arg_pipe  )
    );

    // ActivePipeline 
    // #(
    //     .WIDTH (4 )
    // )
    // u_t_valid(
    // 	.ap_input_clk    (mg_input_clk    ),
    //     .ap_input_nrst   (mg_input_nrst   ),
    //     .ap_input_enable (1 ),
    //     .ap_input_data   (axis_tvalid   ),
    //     .ap_output_conf  (axis_tvalid_pipe  )
    // );
    
    

    assign mg_output_result = result;
    assign mg_output_is_result_ok = is_result_ok;

endmodule
