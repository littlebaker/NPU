`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 22:42:18
// Design Name: 
// Module Name: mult_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:         multpilcation unit. 8bit input, 16bit output.
//                      SIMD.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* use_dsp = "yes"*)
module mult_unit #
(
    parameter SIMD_WIDTH = 128
)

(
    mu_input_clk,
    mu_input_nrst,
    mu_input_enable,
    mu_input_a,
    mu_input_b,
    mu_output_result
    // mu_output_low
    );

    input mu_input_clk;
    input mu_input_nrst;
    input mu_input_enable;
    input mu_input_a;
    input mu_input_b;
    output mu_output_result;
    // output mu_output_low;

    wire signed [SIMD_WIDTH-1: 0] mu_input_a;
    wire signed [SIMD_WIDTH-1: 0] mu_input_b;
    reg signed [SIMD_WIDTH*2-1: 0] mu_output_result;
    // reg signed [SIMD_WIDTH-1: 0] mu_output_low;

    genvar i;

    generate 
    begin: MULT_BLOCK
        for(i=0; i<= SIMD_WIDTH/8-1;i=i+1)
        always@(posedge mu_input_clk)
        begin
            if(!mu_input_nrst)
            begin
                // mu_output_low[8*i+7 -:8] <= 0;
                mu_output_result[16*i+15 -: 16] <= 0;
            end
            else
            begin
                if(mu_input_enable)
                    mu_output_result[16*i+15 -: 16] <= mu_input_a[8*i+7 -:8] * mu_input_b[8*i+7 -:8];
                else
                    mu_output_result[16*i+15 -: 16] <= mu_output_result[16*i+15 -: 16];
            end
        end
    end  
    endgenerate


endmodule
