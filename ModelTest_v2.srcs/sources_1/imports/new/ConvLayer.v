`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/11 14:39:56
// Design Name: 
// Module Name: ConvLayer
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


 module ConvLayer(
    cl_input_clk,
    cl_input_nrst,
    cl_input_enable,
    cl_input_setarg,

    cl_input_input_baseaddr,
    cl_input_kernel_baseaddr,
    cl_input_input_size,
    cl_input_kernel_size,
    cl_input_output_size,
    cl_input_input_chan,
    cl_input_output_chan,
    cl_input_qin,
    cl_input_qw,
    cl_input_qout,
    cl_input_stride,
    cl_input_padding,
    cl_input_relu,
    
    cl_output_ready,

    // memory ports
    cl_output_enb_kernel,
    cl_output_addrb_kernel,
    cl_input_doutb_kernel,

    cl_output_wen_act,   
    cl_output_addra_act, 
    cl_output_dina_act,  

    cl_output_enb_act,
    cl_output_addrb_act,
    cl_input_doutb_act

    );

    input cl_input_clk;
    input cl_input_nrst;
    input cl_input_enable;
    input cl_input_setarg;

    input [31:0] cl_input_input_baseaddr;
    input [31:0] cl_input_kernel_baseaddr;
    input [7:0] cl_input_input_size;
    input [7:0] cl_input_kernel_size;
    input [7:0] cl_input_output_size;
    input [15:0] cl_input_input_chan;
    input [15:0] cl_input_output_chan;
    input [7:0] cl_input_qin;
    input [7:0] cl_input_qw;
    input [7:0] cl_input_qout;
    input [3:0] cl_input_padding;
    input [3:0] cl_input_stride;
    input cl_input_relu;
    output cl_output_ready;

    output cl_output_enb_kernel;
    output reg [31:0] cl_output_addrb_kernel;
    input [31:0] cl_input_doutb_kernel;

    output cl_output_wen_act ;
    output reg [31:0] cl_output_addra_act;
    output reg [63:0] cl_output_dina_act;
    output cl_output_enb_act;
    output reg [31:0] cl_output_addrb_act;
    input [63:0] cl_input_doutb_act;


    // ports declaration
    reg [31:0] input_baseaddr;
    reg [31:0] kernel_baseaddr;
    reg [7:0] input_size;
    reg [7:0] output_size;
    reg [7:0] kernel_size;
    reg [15:0] input_channel;
    reg [15:0] output_channel;
    reg [7:0] qin;
    reg [7:0] qout;
    reg [7:0] qw;
    reg [3:0] stride;
    reg [3:0] padding;

    reg [15:0] input_chan_count;        // TODO
    reg [15:0] output_chan_count;       // TODO

    reg [7:0] up_gate_mask;
    reg [7:0] down_gate_mask;

    reg [7:0] state;
    reg [7:0] cal_state;

    wire mg_output_enb_kernel_0;
    wire [2:0] mg_output_addrb_kernel_0;
    wire [31:0] mg_input_doutb_kernel_0;
    wire mg_output_enb_kernel_1;
    wire [2:0] mg_output_addrb_kernel_1;
    wire [31:0] mg_input_doutb_kernel_1;
    wire mg_output_enb_kernel_2;
    wire [2:0] mg_output_addrb_kernel_2;
    wire [31:0] mg_input_doutb_kernel_2;
    wire mg_output_enb_kernel_3;
    wire [2:0] mg_output_addrb_kernel_3;
    wire [31:0] mg_input_doutb_kernel_3;
    wire mg_output_enb_kernel_4;
    wire [2:0] mg_output_addrb_kernel_4;
    wire [31:0] mg_input_doutb_kernel_4;
    wire mg_output_enb_kernel_5;
    wire [2:0] mg_output_addrb_kernel_5;
    wire [31:0] mg_input_doutb_kernel_5;
    wire mg_output_enb_kernel_6;
    wire [2:0] mg_output_addrb_kernel_6;
    wire [31:0] mg_input_doutb_kernel_6;
    wire mg_output_enb_kernel_7;
    wire [2:0] mg_output_addrb_kernel_7;
    wire [31:0] mg_input_doutb_kernel_7;

    reg [7:0] kernel_preload_en;
    wire [2:0] kernel_preload_addr;
    wire [31:0] kernel_preload_data;

    reg act_preload_en;
    reg [31:0] act_preload_addr;
    reg [63:0] act_preload_data;

    wire [15:0] kernel_count_s1;
    wire [15:0] kernel_count_s2;
    wire [15:0] kernel_count_s3;
    wire [15:0] kernel_count_s4;

    wire [15:0] kernel_index_s1;
    wire [15:0] kernel_index_s2;
    wire [15:0] kernel_index_s3;
    wire [15:0] kernel_index_s4;

    reg [3:0] read_state;    

    localparam IDLE = 0;
    localparam PROCESSING = 1;
    localparam FIN = 2;

    localparam cIDLE = 0;
    localparam cLOAD_KERNEL= 1;
    localparam cLOAD_INPUT = 2;
    localparam cSET_ARG = 3;
    localparam cWAIT_CAL_FIN = 4;
    localparam cWAIT_READ = 5;
    localparam cFIN = 6;

    localparam rIDLE = 0;
    localparam rFIN = 9;

    wire kernel_load_fin;
    wire input_load_fin;
    reg read_fin;
    reg [15:0] output_map_size;

    reg [15:0] input_map_size;
    wire [15:0] kernel_map_size;

    reg [7:0] kernel_load_index;
    reg [7:0] kernel_load_count;
    reg [15:0] act_load_count;

    wire mg_output_enb_act;
    wire [31:0] mg_output_addrb_act;
    wire [63:0] mg_input_doutb_act;

    reg [7:0] ib_input_tready ;
    wire [7:0] ib_output_tvalid;
    wire [63:0] ib_output_tdata0 ;
    wire [63:0] ib_output_tdata1 ;
    wire [63:0] ib_output_tdata2 ;
    wire [63:0] ib_output_tdata3 ;
    wire [63:0] ib_output_tdata4 ;
    wire [63:0] ib_output_tdata5 ;
    wire [63:0] ib_output_tdata6 ;
    wire [63:0] ib_output_tdata7 ;

    wire stage_fin;

    // some constants
    reg [3:0] kernel_load_time;
    reg [15:0] input_total_size;
    reg [7:0] index_width;
    reg [7:0] output_width;

    
    wire [3:0] kernel_en_pipe;
    wire [3:0] act_en_pipe;

    wire sub_module_setarg;
    wire arg_set;
    reg [3:0] set_arg_count;

    wire [7:0] mg_output_ready;

    reg input_cal_fin;          // TODO
    wire single_cal_fin;         // TODO;
    reg [3:0] write_back_index; 
    wire [7:0] mg_output_cal_fin;

    wire [7:0] mg_output_result0     ;
    wire [7:0] mg_output_result1     ;
    wire [7:0] mg_output_result2     ;
    wire [7:0] mg_output_result3     ;
    wire [7:0] mg_output_result4     ;
    wire [7:0] mg_output_result5     ;
    wire [7:0] mg_output_result6     ;
    wire [7:0] mg_output_result7     ;
    wire [7:0] mg_output_is_result_ok;

    reg [7:0] read_index;       // TODO
    reg [15:0] read_count;      // TODO
    reg single_read_fin;        // TODO
    wire total_read_fin;
    wire [3:0] write_back_en_pipe;
    wire ib_input_keep;
    wire input_chan_cal_fin;

    // ib_input_keep
    assign ib_input_keep = input_chan_count != 0;

    genvar i;

    // write_back_index

    // set_arg_count
    always@(posedge cl_input_clk)
    begin
        if(cal_state == cSET_ARG)
        begin
            set_arg_count <= set_arg_count + 1;
        end
        else
        begin
            set_arg_count <= 0;
        end
    end

    // output_size
    // always@(posedge cl_input_clk)
    // begin
    //     if(!cl_input_nrst)
    //     begin
    //         output_size <= 0;
    //     end
    //     else
    //     begin
    //         if(state == IDLE)
    //         begin
    //             output_size <= (input_size + 2 * padding - kernel_size + 1) / stride;
    //         end
    //     end
    // end
    // cl_output_ready
    assign cl_output_ready = state == IDLE;

    // output_width
    always@(posedge cl_input_clk)
    begin
        if(state == IDLE)
        begin
            if(output_size[2:0] == 0)
            begin
                output_width <= output_size[7:3];
            end
            else
            begin
                output_width <= output_size[7:3] + 1;
            end
        end
    end

    // sub_module_setarg
    assign sub_module_setarg = (cal_state == cSET_ARG) && (set_arg_count == 0);

    // arg_set
    assign arg_set = set_arg_count == 6;

    // kernel_map_size
    assign kernel_map_size = kernel_load_time;

    // index_width
    always@(posedge cl_input_clk)
    begin
        if(state == IDLE)
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
    end

    // input_total_size
    always@(posedge cl_input_clk)
    begin
        if(state == IDLE)
        begin
            input_total_size <= input_size * index_width;
        end
    end

    // output_map_size
    always@(posedge cl_input_clk)
    begin
        if(state == IDLE)
        begin
            output_map_size <= output_size * output_width;
        end
    end

    // input_map_size
    always@(posedge cl_input_clk)
    begin
        if(state == IDLE)
        begin
            if(input_total_size[2:0] == 0)
            begin
                input_map_size <= input_total_size;
            end
            else
            begin
                input_map_size <= input_total_size + 1;
            end
        end
    end

    // state transfer
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            state <= IDLE;
        end
        else
        begin
            case(state)
            IDLE:
            if(cl_input_enable)
            begin
                state <= PROCESSING;
            end
            else
            begin
                state <= IDLE;
            end

            PROCESSING:
            if(cal_state == cFIN)
            begin
                state <= FIN;
            end
            else
            begin
                state <= PROCESSING;
            end

            FIN:
            begin
                state <= IDLE;
            end
            default:
            begin
                state <= IDLE;
            end
            endcase
        end
    end

    // cal_state
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            cal_state <= cIDLE;
        end
        else
        begin
            case(cal_state)
            cIDLE:
            if(cl_input_enable && mg_output_ready == 8'hFF)
            begin
                cal_state <= cLOAD_KERNEL;
            end

            cLOAD_KERNEL:
            if(kernel_load_fin)
            begin
                // 如果input_channel就为1，就不需要重复load
                if(output_chan_count != 0 && input_channel == 1)
                begin
                    cal_state <= cSET_ARG;
                end
                else
                begin
                    cal_state <= cLOAD_INPUT;
                end
            end

            cLOAD_INPUT:
            if(input_load_fin)
            begin
                cal_state <= cSET_ARG;
            end

            cSET_ARG:
            if(arg_set)
            begin
                cal_state <= cWAIT_CAL_FIN;
            end

            cWAIT_CAL_FIN:
            if(input_chan_cal_fin)
            begin
                cal_state <= cWAIT_READ;
            end
            else if(single_cal_fin)
            begin
                cal_state <= cLOAD_KERNEL;
            end


            cWAIT_READ:
            if(read_fin)
            begin
                if(input_cal_fin)
                begin
                    cal_state <= cFIN;
                end
                else
                begin
                    cal_state <= cLOAD_KERNEL;
                end
                
            end

            cFIN:
            begin
                cal_state <= cIDLE;
            end
            default:
            begin
                cal_state <= cIDLE;
            end

            endcase 
        end
    end

    // single_cal_fin
    assign single_cal_fin = mg_output_cal_fin[0];

    // kernel_load_index
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            kernel_load_index <= 0;
        end
        else
        begin
            if(cal_state == cLOAD_KERNEL)
            begin
                if(stage_fin)
                begin
                    if(kernel_load_index == 7)
                    begin
                        kernel_load_index <= 0;
                    end
                    else
                    begin
                        kernel_load_index <= kernel_load_index + 1;
                    end
                end
                else
                begin
                    kernel_load_index <= kernel_load_index;
                end
            end
            else
            begin
                kernel_load_index <= 0;
            end
            
        end
    end

    // kernel_load_count
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            kernel_load_count <= 0;
        end
        else
        begin
            if(cal_state == cLOAD_KERNEL)
            begin
                if(!stage_fin)
                begin
                    kernel_load_count <= kernel_load_count + 1;
                end
                else
                begin
                    kernel_load_count <= 0;
                end
            end
            else
            begin
                kernel_load_count <= 0;
            end
        end
    end

    // act_load_count
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            act_load_count <= 0;
        end
        else
        begin
            if(cal_state == cLOAD_INPUT)
            begin
                act_load_count <= act_load_count + 1;
            end
            else
            begin
                act_load_count <= 0;
            end
        end
    end

    // cl_output_addrb_act
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            cl_output_addrb_act <= 0;
        end
        else
        begin
            if(cal_state == cLOAD_INPUT)
            begin
                cl_output_addrb_act <= input_baseaddr + input_chan_count * input_map_size + act_load_count;
            end
        end
    end

    // cl_output_enb_act
    assign cl_output_enb_act = act_en_pipe[0];

    //act_preload_addr
    always@(posedge cl_input_clk)
    begin
        if(act_en_pipe[1])
        begin
            act_preload_addr <= act_preload_addr + 1;
        end
        else
        begin
            act_preload_addr <= 0;
        end
    end

    // input_load_fin
    assign input_load_fin = (cal_state == cLOAD_INPUT) && (act_load_count >= input_map_size);

    // stage_fin
    assign stage_fin = kernel_load_count == kernel_load_time;

    // kernel_load_fin
    assign kernel_load_fin = (kernel_load_index == 7) && stage_fin ;

    // kernel_load_time
    always@(*)
    begin
        case(kernel_size)
        1:
        kernel_load_time = 1;
        2:
        kernel_load_time = 1;
        3:
        kernel_load_time = 3;
        4:
        kernel_load_time = 4;
        5:
        kernel_load_time = 7;
        default:
        kernel_load_time = 8;


        endcase
    end
    
    // cl_output_addrb_kernel
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            cl_output_addrb_kernel <= 0;
        end
        else
        begin
            if(cal_state == cLOAD_KERNEL)
            begin
                cl_output_addrb_kernel <= kernel_baseaddr + (output_chan_count + kernel_load_index) * input_channel * kernel_map_size + 
                input_chan_count * kernel_map_size + kernel_load_count;
            end
        end
    end

    // input_chan_cal_fin
    assign input_chan_cal_fin = single_cal_fin && (input_chan_count == input_channel - 1);

    // input_chan_count
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            input_chan_count <= 0;
        end
        else
        begin
            if(single_cal_fin)
            begin
                if(input_chan_count < input_channel -1)
                begin
                    input_chan_count <= input_chan_count + 1;
                end
                else
                begin
                    input_chan_count <= 0;
                end
            end
        end
    end

    // output_chan_count
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            output_chan_count <= 0;
        end
        else
        begin
            if(read_fin)
            begin
                if(output_chan_count + 8 < output_channel && input_chan_count >= input_channel -1)
                begin
                    output_chan_count <= output_chan_count + 8;
                end
                
            end
        end
    end

    // input_cal_fin
    always@(posedge cl_input_clk)
    begin
        if(cal_state == IDLE)
        begin
            input_cal_fin <= 0;
        end
        else if(output_chan_count + 8 >= output_channel && input_chan_cal_fin)
        begin
            input_cal_fin <= 1;
        end
    end

    // cl_output_addra_act
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            cl_output_addra_act <= 0;
        end
        else
        begin
            if(cal_state == cWAIT_READ)
            begin
                cl_output_addra_act <= (output_chan_count + read_index) * output_map_size + read_count;
            end
        end
    end

    // read_count
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            read_count <= 0;
        end
        else
        begin
            if(cal_state == cWAIT_READ)
            begin
                if(read_count == output_map_size)
                begin
                    read_count <= 0;
                end
                else
                begin
                    if(ib_output_tvalid[0])
                    begin
                        read_count <= read_count + 1;
                    end
                end
            end
            else
            begin
                read_count <= 0;
            end
        end
    end

    // read_index
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            read_index <= 0;
        end
        else
        begin
            if(cal_state == cWAIT_READ)
            begin
                if(read_count == output_map_size)
                begin
                    if(read_index == 7)
                    begin
                        read_index <= 0;
                    end
                    else
                    begin
                        read_index <= read_index + 1;
                    end                
                end
                else
                begin
                    read_index <= read_index;
                end
            end
            else
            begin
                read_index <= 0;
            end
        end
    end

    // single_read_fin
    always@(*)
    begin
        single_read_fin = (cal_state == cWAIT_READ && read_count == output_map_size);
    end

    // read_fin
    always@(*)
    begin
        read_fin = single_read_fin && (read_index == 7);
    end

    // total_read_fin
    assign total_read_fin = read_fin && (output_chan_count + 8 >= output_channel);

    // cl_output_enb_kernel;
    assign cl_output_enb_kernel = kernel_en_pipe[0];


    // kernel_preload_data
    assign kernel_preload_data = cl_input_doutb_kernel;

    // kernel_preload_en
    always@(*)
    begin
        kernel_preload_en[0] = (kernel_index_s2 == 0) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[1] = (kernel_index_s2 == 1) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[2] = (kernel_index_s2 == 2) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[3] = (kernel_index_s2 == 3) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[4] = (kernel_index_s2 == 4) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[5] = (kernel_index_s2 == 5) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[6] = (kernel_index_s2 == 6) && kernel_en_pipe[1];
    end
    always@(*)
    begin
        kernel_preload_en[7] = (kernel_index_s2 == 7) && kernel_en_pipe[1];
    end



    // kernel_preload_addr
    assign kernel_preload_addr = kernel_count_s2;

    // cl_output_wen_act
    assign cl_output_wen_act = write_back_en_pipe[0];

    // ib_input_tready
    generate
    for(i=0;i<8;i=i+1)
    begin
        always@(*)
        begin
            if(cal_state == cWAIT_READ && ib_output_tvalid[i] && read_index == i)
            begin
                ib_input_tready[i] = 1;
            end
            else
            begin
                ib_input_tready[i] = 0;
            end
        end
    end
    endgenerate

    // ib_output_tdata
    always@(*)
    begin
        case(read_index)
        0:
        begin
            cl_output_dina_act = ib_output_tdata0;
        end
        1:
        begin
            cl_output_dina_act = ib_output_tdata1;
        end
        2:
        begin
            cl_output_dina_act = ib_output_tdata2;
        end
        3:
        begin
            cl_output_dina_act = ib_output_tdata3;
        end
        4:
        begin
            cl_output_dina_act = ib_output_tdata4;
        end
        5:
        begin
            cl_output_dina_act = ib_output_tdata5;
        end
        6:
        begin
            cl_output_dina_act = ib_output_tdata6;
        end
        7:
        begin
            cl_output_dina_act = ib_output_tdata7;
        end
        default:
        begin
            cl_output_dina_act = 0;
        end

        endcase
    end



    // set arg
    always@(posedge cl_input_clk)
    begin
        if(!cl_input_nrst)
        begin
            input_channel <= 0;
            output_channel <= 0;
            padding <= 0;
            input_size <= 0;
            qin <= 0;
            qout <= 0;
            qw <= 0;
            output_size <=0; 
            input_baseaddr <= 0;
            kernel_baseaddr <= 0;
            kernel_size <= 0;
            stride <= 0;
        end
        else if(state == IDLE && cl_input_setarg)
        begin
            qin <= cl_input_qin;
            qout <= cl_input_qout;
            qw <= cl_input_qw;
            input_channel <= cl_input_input_chan;
            output_channel <= cl_input_output_chan;
            padding <= cl_input_padding;
            output_size <= cl_input_output_size;
            input_size <= cl_input_input_size;
            input_baseaddr <= cl_input_input_baseaddr;
            kernel_baseaddr <= cl_input_kernel_baseaddr;
            kernel_size <= cl_input_kernel_size;
            stride <= cl_input_stride;
        end
        else
        begin
            input_channel <= input_channel;
            output_channel <= output_channel;
            padding <= padding;
            input_size <= input_size;
            output_size <= output_size;
            input_baseaddr <= input_baseaddr;
            kernel_baseaddr <= kernel_baseaddr;
            kernel_size <= kernel_size;
            stride <= stride;
        end
    end


    MemoryGate u_MemoryGate0 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ), 
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[0]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[0]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_0     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_0   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_0    ),

        .mg_output_result         (mg_output_result0       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[0] ),    // TODO

        .mg_output_enb_act        (mg_output_enb_act        ),
        .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );

    MemoryGate u_MemoryGate1 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ), 
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[1]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[1]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_1     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_1   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_1    ),

        .mg_output_result         (mg_output_result1       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[1] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate2 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ), 
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[2]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[2]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_2     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_2   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_2    ),

        .mg_output_result         (mg_output_result2       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[2] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate3 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ), 
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[3]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[3]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_3     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_3   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_3    ),

        .mg_output_result         (mg_output_result3       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[3] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate4 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ), 
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ), 
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[4]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[4]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_4     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_4   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_4    ),

        .mg_output_result         (mg_output_result4       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[4] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate5 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ),  
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[5]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[5]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_5     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_5   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_5    ),

        .mg_output_result         (mg_output_result5       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[5] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate6 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ),  
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[6]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[6]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_6     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_6   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_6    ),

        .mg_output_result         (mg_output_result6       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[6] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );
        
    MemoryGate u_MemoryGate7 (
    	.mg_input_clk             (cl_input_clk             ),
        .mg_input_nrst            (cl_input_nrst            ),
        .mg_input_setarg          (sub_module_setarg          ),
        .mg_input_padding         (cl_input_padding         ),
        .mg_input_input_size      (cl_input_input_size      ),
        .mg_input_kernel_size     (cl_input_kernel_size     ),
        .mg_input_stride          (cl_input_stride          ),
        .mg_input_enable          (arg_set          ),  
        .mg_input_qin             (cl_input_qin             ),
        .mg_input_qw              (cl_input_qw              ),
        .mg_input_qout            (cl_input_qout            ),
        .mg_input_relu            (cl_input_relu            ),
        // .mg_output_reading        (mg_output_reading      ),    // TODO
        .mg_output_ready          (mg_output_ready[7]        ),    // TODO
        .mg_output_cal_fin        (mg_output_cal_fin[7]),

        .mg_output_enb_kernel     (mg_output_enb_kernel_7     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel_7   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel_7    ),

        .mg_output_result         (mg_output_result7       ),    // TODO
        .mg_output_is_result_ok   (mg_output_is_result_ok[7] ),    // TODO

        // .mg_output_enb_act        (mg_output_enb_act        ),
        // .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );

    

    blk_mem_cl_act_buf u_act_buf(
        .clka                   (cl_input_clk),
        .ena                    (act_en_pipe[1]  ),
        .wea                    (act_en_pipe[1]  ),
        .addra                  (act_preload_addr),
        .dina                   (cl_input_doutb_act),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_act  ),
        .addrb                  (mg_output_addrb_act),
        .doutb                  (mg_input_doutb_act )
    );

    blk_mem_cl_kernel_buf u_kernel_buf0(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[0]),
        .wea                    (kernel_preload_en[0]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_0  ),
        .addrb                  (mg_output_addrb_kernel_0),
        .doutb                  (mg_input_doutb_kernel_0 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf1(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[1]),
        .wea                    (kernel_preload_en[1]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_1  ),
        .addrb                  (mg_output_addrb_kernel_1),
        .doutb                  (mg_input_doutb_kernel_1 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf2(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[2]),
        .wea                    (kernel_preload_en[2]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_2  ),
        .addrb                  (mg_output_addrb_kernel_2),
        .doutb                  (mg_input_doutb_kernel_2 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf3(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[3]),
        .wea                    (kernel_preload_en[3]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_3  ),
        .addrb                  (mg_output_addrb_kernel_3),
        .doutb                  (mg_input_doutb_kernel_3 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf4(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[4]),
        .wea                    (kernel_preload_en[4]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_4  ),
        .addrb                  (mg_output_addrb_kernel_4),
        .doutb                  (mg_input_doutb_kernel_4 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf5(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[5]),
        .wea                    (kernel_preload_en[5]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_5  ),
        .addrb                  (mg_output_addrb_kernel_5),
        .doutb                  (mg_input_doutb_kernel_5 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf6(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[6]),
        .wea                    (kernel_preload_en[6]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_6  ),
        .addrb                  (mg_output_addrb_kernel_6),
        .doutb                  (mg_input_doutb_kernel_6 )
    );

    blk_mem_cl_kernel_buf u_kernel_buf7(
        .clka                   (cl_input_clk),
        .ena                    (kernel_preload_en[7]),
        .wea                    (kernel_preload_en[7]),
        .addra                  (kernel_preload_addr ),
        .dina                   (kernel_preload_data ),
        .clkb                   (cl_input_clk),
        .enb                    (mg_output_enb_kernel_7  ),
        .addrb                  (mg_output_addrb_kernel_7),
        .doutb                  (mg_input_doutb_kernel_7 )
    );

    ActivePipeline 
    #(
        .WIDTH (4 )
    )
    u_ActivePipeline(
    	.ap_input_clk    (cl_input_clk    ),
        .ap_input_nrst   (cl_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (cal_state == cLOAD_KERNEL && (!stage_fin)   ),    
        .ap_output_conf  (kernel_en_pipe  )     
    );

    ControlPipeline u_kernel_index(
    	.cp_input_clk    (cl_input_clk    ),
        .cp_input_nrst   (cl_input_nrst   ),
        .cp_input_enable (1 ),
        .cp_input_data   ({8'b0, kernel_load_index}   ),
        .cp_output_s1    (kernel_index_s1    ),
        .cp_output_s2    (kernel_index_s2    ),
        .cp_output_s3    (kernel_index_s3    ),
        .cp_output_s4    (kernel_index_s4    )
    );

    ControlPipeline u_kernel_count(
    	.cp_input_clk    (cl_input_clk    ),
        .cp_input_nrst   (cl_input_nrst   ),
        .cp_input_enable (1 ),
        .cp_input_data   ({8'b0, kernel_load_count}   ),
        .cp_output_s1    (kernel_count_s1    ),
        .cp_output_s2    (kernel_count_s2    ),
        .cp_output_s3    (kernel_count_s3    ),
        .cp_output_s4    (kernel_count_s4    )
    );
    
    ActivePipeline 
    #(
        .WIDTH (4 )
    )
    u_act_load_en(
    	.ap_input_clk    (cl_input_clk    ),
        .ap_input_nrst   (cl_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (cal_state == cLOAD_INPUT   ),
        .ap_output_conf  (act_en_pipe  )
    );

    // (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf0(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[0]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[0]      ), // TODO
        .ib_input_data       (mg_output_result0       ),      // TODO
        .ib_input_tready     (ib_input_tready[0]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[0]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata0     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );
    
    // (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf1(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[1]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[1]      ), // TODO
        .ib_input_data       (mg_output_result1       ),      // TODO
        .ib_input_tready     (ib_input_tready[1]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[1]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata1     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );
    
    // (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf2(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[2]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[2]      ), // TODO
        .ib_input_data       (mg_output_result2       ),      // TODO
        .ib_input_tready     (ib_input_tready[2]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[2]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata2     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

// (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf3(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[3]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[3]      ), // TODO
        .ib_input_data       (mg_output_result3       ),      // TODO
        .ib_input_tready     (ib_input_tready[3]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[3]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata3     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

// (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf4(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[4]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[4]      ), // TODO
        .ib_input_data       (mg_output_result4       ),      // TODO
        .ib_input_tready     (ib_input_tready[4]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[4]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata4     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

// (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf5(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[5]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[5]      ), // TODO
        .ib_input_data       (mg_output_result5       ),      // TODO
        .ib_input_tready     (ib_input_tready[5]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[5]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata5     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

// (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf6(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[6]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[6]      ), // TODO
        .ib_input_data       (mg_output_result6       ),      // TODO
        .ib_input_tready     (ib_input_tready[6]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[6]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata6     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

// (* keep_hierarchy = "yes" *)
    IncreaseBuf u_IncreaseBuf7(
    	.ib_input_clk        (cl_input_clk        ),
        .ib_input_nrst       (cl_input_nrst       ),
        .ib_input_keep       (ib_input_keep       ),            // TODO
        .ib_input_img_fin    (mg_output_cal_fin[7]    ),        // TODO
        .ib_input_is_ok      (mg_output_is_result_ok[7]      ), // TODO
        .ib_input_data       (mg_output_result7       ),      // TODO
        .ib_input_tready     (ib_input_tready[7]     ),            // TODO
        .ib_output_tvalid    (ib_output_tvalid[7]    ),            // TODO
        .ib_output_tdata     (ib_output_tdata7     )            // TODO
        // .ib_output_num_count (ib_output_num_count )             // TODO
    );

    ActivePipeline 
    #(
        .WIDTH (4 )
    )
    u_read_en(
    	.ap_input_clk    (cl_input_clk    ),
        .ap_input_nrst   (cl_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (cal_state==cWAIT_READ && read_count != output_map_size && ib_output_tvalid[0]),
        .ap_output_conf  (write_back_en_pipe  )
    );
    

endmodule
