`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 14:54:11
// Design Name: 
// Module Name: ControlPipeline
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


module ControlPipeline(
    cp_input_clk,
    cp_input_nrst,
    cp_input_enable,
    cp_input_data,
    cp_output_s1,
    cp_output_s2,
    cp_output_s3,
    cp_output_s4
    );

    input cp_input_clk;
    input cp_input_nrst;
    input cp_input_enable;
    input [15:0] cp_input_data;
    output reg [15:0] cp_output_s1;
    output reg [15:0] cp_output_s2;
    output reg [15:0] cp_output_s3;
    output reg [15:0] cp_output_s4;


    always@(posedge cp_input_clk)
    begin
        if(!cp_input_nrst)
        begin
            cp_output_s1 <= 0;
            cp_output_s2 <= 0;
            cp_output_s3 <= 0;
            cp_output_s4 <= 0;
        end
        else
        begin
            if(cp_input_enable)
            begin
                cp_output_s1 <= cp_input_data;
                cp_output_s2 <= cp_output_s1;
                cp_output_s3 <= cp_output_s2;
                cp_output_s4 <= cp_output_s3;
            end
        end
    end



endmodule
