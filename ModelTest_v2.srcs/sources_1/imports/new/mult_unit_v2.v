`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 15:52:06
// Design Name: 
// Module Name: mult_unit_v2
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
module mult_unit_v2(
    mu_input_clk,
    mu_input_nrst,
    mu_input_enable,
    mu_input_a0,
    mu_input_a1,
    mu_input_a2,
    mu_input_a3,
    mu_input_a4,

    mu_input_b0,
    mu_input_b1,
    mu_input_b2,
    mu_input_b3,
    mu_input_b4,
    mu_output_result0,
    mu_output_result1,
    mu_output_result2,
    mu_output_result3,
    mu_output_result4
    );

    input mu_input_clk;
    input mu_input_nrst;
    input mu_input_enable;
    input signed [39:0] mu_input_a0;
    input signed [39:0] mu_input_a1;
    input signed [39:0] mu_input_a2;
    input signed [39:0] mu_input_a3;
    input signed [39:0] mu_input_a4;

    input signed [39:0] mu_input_b0;
    input signed [39:0] mu_input_b1;
    input signed [39:0] mu_input_b2;
    input signed [39:0] mu_input_b3;
    input signed [39:0] mu_input_b4;
    output reg [79:0] mu_output_result0;
    output reg [79:0] mu_output_result1;
    output reg [79:0] mu_output_result2;
    output reg [79:0] mu_output_result3;
    output reg [79:0] mu_output_result4;


    genvar i;

    generate 
    begin: MULT_BLOCK
        for(i=0; i<= 40/8-1;i=i+1)
        always@(posedge mu_input_clk)
        begin
            if(!mu_input_nrst)
            begin
                // mu_output_low[8*i+7 -:8] <= 0;
                mu_output_result0[16*i+15 -: 16] <= 0;
                mu_output_result1[16*i+15 -: 16] <= 0;
                mu_output_result2[16*i+15 -: 16] <= 0;
                mu_output_result3[16*i+15 -: 16] <= 0;
                mu_output_result4[16*i+15 -: 16] <= 0;
            end
            else
            begin
                if(mu_input_enable)
                begin
                    mu_output_result0[16*i+15 -: 16] <= $signed(mu_input_a0[8*i+7 -:8]) *  $signed(mu_input_b0[8*i+7 -:8]);
                    mu_output_result1[16*i+15 -: 16] <= $signed(mu_input_a1[8*i+7 -:8]) *  $signed(mu_input_b1[8*i+7 -:8]);
                    mu_output_result2[16*i+15 -: 16] <= $signed(mu_input_a2[8*i+7 -:8]) *  $signed(mu_input_b2[8*i+7 -:8]);
                    mu_output_result3[16*i+15 -: 16] <= $signed(mu_input_a3[8*i+7 -:8]) *  $signed(mu_input_b3[8*i+7 -:8]);
                    mu_output_result4[16*i+15 -: 16] <= $signed(mu_input_a4[8*i+7 -:8]) *  $signed(mu_input_b4[8*i+7 -:8]);
                end
                   
                
            end
        end
    end  
    endgenerate



endmodule
