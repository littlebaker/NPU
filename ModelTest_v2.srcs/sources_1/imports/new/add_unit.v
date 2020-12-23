`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/20 16:45:47
// Design Name: 
// Module Name: add_unit
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

(* use_dsp = "yes"*)
module add_unit(
    au_input_clk,
    au_input_nrst,
    au_input_enable,
    au_input_ksize,
    au_input_data0,
    au_input_data1,
    au_input_data2,
    au_input_data3,
    au_input_data4,
    au_output_active,
    au_output_result
    );

    input au_input_clk;
    input au_input_nrst;
    input au_input_enable;

    input [3:0] au_input_ksize;
    input [79:0] au_input_data0;
    input [79:0] au_input_data1;
    input [79:0] au_input_data2;
    input [79:0] au_input_data3;
    input [79:0] au_input_data4;
    output reg [31:0] au_output_result;
    output reg au_output_active;

    reg signed [15:0] d0 [0:4];
    reg signed [15:0] d1 [0:4];
    reg signed [15:0] d2 [0:4];
    reg signed [15:0] d3 [0:4];
    reg signed [15:0] d4 [0:4];

    reg signed [31:0] add_pipeline_r_1_1;
    reg signed [31:0] add_pipeline_r_1_2;
    reg signed [31:0] add_pipeline_r_1_3;
    reg signed [31:0] add_pipeline_r_1_4;
    reg signed [31:0] add_pipeline_r_1_5;

    reg signed [31:0] add_pipeline_c_1_2;
    reg signed [31:0] add_pipeline_c_1_3;
    reg signed [31:0] add_pipeline_c_1_4;
    reg signed [31:0] add_pipeline_c_1_5;

    reg signed [31:0] add_pipeline_2_1;
    reg signed [31:0] add_pipeline_2_2;
    reg signed [31:0] add_pipeline_2_3;
    reg signed [31:0] add_pipeline_2_4;
    reg signed [31:0] add_pipeline_2_5;

    reg signed [31:0] add_pipeline_3_1;
    reg signed [31:0] add_pipeline_3_2;
    reg signed [31:0] add_pipeline_3_3;
    reg signed [31:0] add_pipeline_3_4;
    reg signed [31:0] add_pipeline_3_5;


    reg [7:0] control_pipe [0:7];

    reg [7:0] control_input;

    always@(*)
    begin
        control_input = {3'b0, au_input_enable, au_input_ksize};
        //                       4                 3:0
    end
    
    genvar i;

    generate
    for(i=0;i<=6;i=i+1)
    begin:bulcdsf
        always@(posedge au_input_clk)
        begin
            if(!au_input_nrst)
            begin
                control_pipe[i+1] <= 0;
            end
            else
            begin
                control_pipe[i+1] <= control_pipe[i];
            end
        end
        
    end
    endgenerate
    always@(posedge au_input_clk)
    begin
        if(!au_input_nrst)
        begin
            control_pipe[0] <= 0;
        end
        else
        begin
            control_pipe[0] <= control_input;
        end
        
    end

    always@(posedge au_input_clk)
    begin
        // if(control_pipe[0][4])
        // begin
            // case(control_pipe[0][3:0])
            // 1:
            // begin
                add_pipeline_2_1 <= add_pipeline_r_1_1;
            // end
            // 2:
            // begin
                add_pipeline_2_2 <= add_pipeline_r_1_2 + add_pipeline_c_1_2;
            // end
            // 3:
            // begin
                add_pipeline_2_3 <= add_pipeline_r_1_3 + add_pipeline_c_1_3;
            // end
            // 4:
            // begin
                add_pipeline_2_4 <= add_pipeline_r_1_4 + add_pipeline_c_1_4;
            // end
            // 5:
            // begin
                add_pipeline_2_5 <= add_pipeline_r_1_5 + add_pipeline_c_1_5;
            // end
            // default:
            // begin
            //     add_pipeline_2_1 <= 0;
            //     add_pipeline_2_2 <= 0;
            //     add_pipeline_2_3 <= 0;
            //     add_pipeline_2_4 <= 0;
            //     add_pipeline_2_5 <= 0;
            // end
            // endcase
        // end
    end

    always@(posedge au_input_clk)
    begin
        // if(control_pipe[1][4])
        // begin
            // case(control_pipe[1][3:0])
            // 1:
            // begin
                add_pipeline_3_1 <= add_pipeline_2_1;
            // end
            // 2:
            // begin
                add_pipeline_3_2 <= add_pipeline_2_1 + add_pipeline_2_2;
            // end
            // 3:
            // begin
                add_pipeline_3_3 <= add_pipeline_2_1 + add_pipeline_2_2 + add_pipeline_2_3;
            // end
            // 4:
            // begin
                add_pipeline_3_4 <= add_pipeline_2_1 + add_pipeline_2_2 + add_pipeline_2_3 + add_pipeline_2_4;
            // end
            // 5:
            // begin
                add_pipeline_3_5 <= add_pipeline_2_1 + add_pipeline_2_2 + add_pipeline_2_3 + add_pipeline_2_4 + add_pipeline_2_5;
            // end
            // default:
            // begin
            //     add_pipeline_3_1 <= 0;
            //     add_pipeline_3_2 <= 0;
            //     add_pipeline_3_3 <= 0;
            //     add_pipeline_3_4 <= 0;
            //     add_pipeline_3_5 <= 0;
            // end
            // endcase
        // end
    end

    always@(*)
    begin
        if(control_pipe[2][4])
        begin
            au_output_active = 1;
        end
        else
        begin
            au_output_active = 0;
        end
    end

    always@(*)
    begin
        if(au_output_active)
        begin
            case(control_pipe[2][3:0])
            1:
            begin
                au_output_result = add_pipeline_3_1;
            end
            2:
            begin
                au_output_result = add_pipeline_3_2;
            end
            3:
            begin
                au_output_result = add_pipeline_3_3;
            end
            4:
            begin
                au_output_result = add_pipeline_3_4;
            end
            5:
            begin
                au_output_result = add_pipeline_3_5;
            end
            default:
            begin
                au_output_result = 0;
            end
            endcase
        end
        else
        begin
            au_output_result = 0;
        end
        
    end




    generate
    for(i=0;i<=4;i=i+1)
    begin:bulck
        always@(*)
        begin
            d0[i] = au_input_data0[16*i+15 -:16];
            d1[i] = au_input_data1[16*i+15 -:16];
            d2[i] = au_input_data2[16*i+15 -:16];
            d3[i] = au_input_data3[16*i+15 -:16];
            d4[i] = au_input_data4[16*i+15 -:16];
        end
    end

    endgenerate

    always@(posedge au_input_clk)
    begin
        if(au_input_enable)
        begin
            // case(au_input_ksize)
            // 1:
            // begin
            //     add_pipeline_r_1_1 <= d0[4];
            // end
            // 2:
            // begin
            //     add_pipeline_r_1_1 <= d0[4];
            //     add_pipeline_r_1_2 <= d1[4] + d1[3];
            //     add_pipeline_c_1_2 <= d0[3];
            // end
            // 3:
            // begin
            //     add_pipeline_r_1_1 <= d0[4];
            //     add_pipeline_r_1_2 <= d1[4] + d1[3];
            //     add_pipeline_c_1_2 <= d0[3];
            //     add_pipeline_r_1_3 <= d2[4] + d2[3] + d2[2];
            //     add_pipeline_c_1_3 <= d0[2] + d1[2];
            // end
            // 4:
            // begin
            //     add_pipeline_r_1_1 <= d0[4];
            //     add_pipeline_r_1_2 <= d1[4] + d1[3];
            //     add_pipeline_c_1_2 <= d0[3];
            //     add_pipeline_r_1_3 <= d2[4] + d2[3] + d2[2];
            //     add_pipeline_c_1_3 <= d0[2] + d1[2];
            //     add_pipeline_r_1_4 <= d3[4] + d3[3] + d3[2] + d3[1];
            //     add_pipeline_c_1_4 <= d0[1] + d1[1] + d2[1];
            // end
            // 5:
            begin
                add_pipeline_r_1_1 <= d0[4];
                add_pipeline_r_1_2 <= d1[4] + d1[3];
                add_pipeline_c_1_2 <= d0[3];
                add_pipeline_r_1_3 <= d2[4] + d2[3] + d2[2];
                add_pipeline_c_1_3 <= d0[2] + d1[2];
                add_pipeline_r_1_4 <= d3[4] + d3[3] + d3[2] + d3[1];
                add_pipeline_c_1_4 <= d0[1] + d1[1] + d2[1];
                add_pipeline_r_1_5 <= d4[4] + d4[3] + d4[2] + d4[1] + d4[0];
                add_pipeline_c_1_5 <= d0[0] + d1[0] + d2[0] + d3[0];
            end
            // default:
            // begin
            //     add_pipeline_r_1_1 <= 0;
            //     add_pipeline_r_1_2 <= 0;
            //     add_pipeline_c_1_2 <= 0;
            //     add_pipeline_r_1_3 <= 0;
            //     add_pipeline_c_1_3 <= 0;
            //     add_pipeline_r_1_4 <= 0;
            //     add_pipeline_c_1_4 <= 0;
            //     add_pipeline_r_1_5 <= 0;
            //     add_pipeline_c_1_5 <= 0;
            // end
            // endcase
        end
    end


    // always@(posedge au_input_clk)
    // begin
    //     if(!au_input_nrst)
    //     begin
    //         au_output_result <= 0;
    //     end
    //     else
    //     begin
    //         if(au_input_enable)
    //         begin
    //             case(au_input_ksize)
    //             1:
    //             au_output_result <= d0[4];
    //             2:
    //             au_output_result <= d0[4] + d0[3] + d1[4] + d1[3];
    //             3:
    //             au_output_result <= d0[4] + d0[3] + d0[2] + d1[4] + d1[3] + d1[2] + d2[4] + d2[3] + d2[2];
    //             4:
    //             au_output_result <= d0[4] + d0[3] + d0[2] + d0[1] + d1[4] + d1[3] +
    //                                  d1[2] + d1[1] + d2[4] + d2[3] + d2[2] + d2[1] + d3[4] + d3[3] + d3[2] + d3[1];
    //             5:
    //             au_output_result <= d0[4] + d0[3] + d0[2] + d0[1] + d0[0]
    //                                  + d1[4] + d1[3] + d1[2] + d1[1] + d1[0]
    //                                   + d2[4] + d2[3] + d2[2] + d2[1] +d2[0]
    //                                    + d3[4] + d3[3] + d3[2] + d3[1] + d3[0]
    //                                    + d4[4] + d4[3] + d4[2] + d4[1] + d4[0];
    //             default:
    //             au_output_result <= 0;

    //             endcase

    //         end
    //     end
    // end


    


endmodule
