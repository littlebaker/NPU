`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 14:06:37
// Design Name: 
// Module Name: PaddingArray
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


module PaddingArray(
    pa_input_clk,
    pa_input_nrst,
    pa_input_enable,
    pa_input_setp,
    pa_input_padding,
    pa_input_data,
    pa_output_result
    );

    input pa_input_clk;
    input pa_input_nrst;
    input pa_input_enable;
    input pa_input_setp;
    input [3:0] pa_input_padding;
    input [63:0] pa_input_data;
    output  [63:0] pa_output_result;

    reg [3:0] padding;
    reg [79:0] padding_buf;

    always@(posedge pa_input_clk)
    begin
        if(pa_input_setp)
        begin
            padding <= pa_input_padding;
        end
        else
        begin
            padding <= padding;
        end
    end

    always@(posedge pa_input_clk)
    begin
        if(!pa_input_nrst)
        begin
            padding_buf <= 0;
        end
        else
        begin
            if(pa_input_enable)
            begin
                case(padding)
                1:
                padding_buf <= {padding_buf[15-:8], pa_input_data, 8'b0};
                2:
                padding_buf <= {padding_buf[15-:16], pa_input_data};
                default:
                padding_buf <= padding_buf;
                endcase
            end
            else
            begin
                case(padding)
                1:
                padding_buf <= {padding_buf[15-:8], 72'b0};
                2:
                padding_buf <= {padding_buf[15-:16], 64'b0};
                default:
                padding_buf <= padding_buf;
                endcase
            end
        end
    end

    assign pa_output_result = padding_buf[79-:64];











endmodule
