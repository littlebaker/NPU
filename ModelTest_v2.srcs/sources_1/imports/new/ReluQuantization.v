`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 20:56:47
// Design Name: 
// Module Name: ReluQuantization
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

(*use_dsp = "yes"*)
module ReluQuantization(
    rq_input_clk,
    rq_input_nrst,
    rq_input_enable,
    rq_input_qin,
    rq_input_qw,
    rq_input_qout,
    rq_input_relu,
    rq_input_data,
    rq_output_active,
    rq_output_result,
    );

    input rq_input_clk;
    input rq_input_nrst;
    input rq_input_enable;
    input [3:0] rq_input_qin;
    input [3:0] rq_input_qw;
    input  [3:0] rq_input_qout;
    input rq_input_relu;
    input signed [31:0] rq_input_data;
    output rq_output_active;
    output reg signed [7:0] rq_output_result;

    reg [7:0] delta_q;

    reg signed [31:0] relu_pipe1;
    reg signed [31:0] result_quantized;
    reg [1:0] control_pipe;

    always@(posedge rq_input_clk)
    begin
        if(!rq_input_nrst)
        begin
            control_pipe[0] <= 0;
            control_pipe[1] <= 0;
        end
        else
        begin
            control_pipe[1] <= control_pipe[0];
            control_pipe[0] <= rq_input_enable;
        end
    end

    always@(posedge rq_input_clk)
    begin
        if(!rq_input_nrst)
        begin
            delta_q <= 0;
            relu_pipe1 <=0;
        end
        else
        begin
            if(rq_input_enable)
            begin
                delta_q <= rq_input_qin + rq_input_qw - rq_input_qout;
                if(rq_input_relu && rq_input_data < 0)
                begin
                    relu_pipe1 <= 0;
                end
                else
                begin
                    relu_pipe1 <= rq_input_data;
                end
            end
            else
            begin
                delta_q <= 0;
                relu_pipe1 <=0;
            end
            
        end
    end

    always@(posedge rq_input_clk)
    begin
        if(!rq_input_nrst)
        begin
            result_quantized <= 0;
        end
        else
        begin
            if(control_pipe[0])
            begin
                result_quantized <= relu_pipe1 >> delta_q;
            end
        end
    end

    always@(*)
    begin
        if(result_quantized > 127)
        begin
            rq_output_result = 127;
        end
        else if(result_quantized < -128)
        begin
            rq_output_result = -128;
        end
        else
        begin
            rq_output_result = result_quantized[7:0];
        end
    end

    assign rq_output_active = control_pipe[1];

endmodule
