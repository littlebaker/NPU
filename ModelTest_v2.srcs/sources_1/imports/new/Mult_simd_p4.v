`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 16:23:36
// Design Name: 
// Module Name: Mult_simd_p4
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


module Mult_simd_p4 #
(
    parameter SIMD_WIDTH = 128
)
(
    msp4_input_clk,
    msp4_input_nrst,
    msp4_input_enable,
    msp4_input_a0,
    msp4_input_b0,
    msp4_input_a1,
    msp4_input_b1,
    msp4_input_a2,
    msp4_input_b2,
    msp4_input_a3,
    msp4_input_b3,
    msp4_output_r0,
    msp4_output_r1,
    msp4_output_r2,
    msp4_output_r3,
    );

    input msp4_input_clk;
    input msp4_input_nrst;
    input msp4_input_enable;
    input msp4_input_a0;
    input msp4_input_b0;
    input msp4_input_a1;
    input msp4_input_b1;
    input msp4_input_a2;
    input msp4_input_b2;
    input msp4_input_a3;
    input msp4_input_b3;

    output msp4_output_r0;
    output msp4_output_r1;
    output msp4_output_r2;
    output msp4_output_r3;

    wire [3:0] msp4_input_enable;
    wire [SIMD_WIDTH-1:0] msp4_input_a0;
    wire [SIMD_WIDTH-1:0] msp4_input_b0;
    wire [SIMD_WIDTH-1:0] msp4_input_a1;
    wire [SIMD_WIDTH-1:0] msp4_input_b1;
    wire [SIMD_WIDTH-1:0] msp4_input_a2;
    wire [SIMD_WIDTH-1:0] msp4_input_b2;
    wire [SIMD_WIDTH-1:0] msp4_input_a3;
    wire [SIMD_WIDTH-1:0] msp4_input_b3;

    wire [SIMD_WIDTH*2-1:0] msp4_output_r0;
    wire [SIMD_WIDTH*2-1:0] msp4_output_r1;
    wire [SIMD_WIDTH*2-1:0] msp4_output_r2;
    wire [SIMD_WIDTH*2-1:0] msp4_output_r3;

    mult_unit #(
        .SIMD_WIDTH             (SIMD_WIDTH)
    )   u0
    (
        .mu_input_clk           (msp4_input_clk),
        .mu_input_nrst          (msp4_input_nrst),
        .mu_input_enable        (msp4_input_enable[0]),
        .mu_input_a             (msp4_input_a0),
        .mu_input_b             (msp4_input_b0),
        .mu_output_result       (msp4_output_r0)
    );

    mult_unit #(
        .SIMD_WIDTH             (SIMD_WIDTH)
    )    u1
    (
        .mu_input_clk           (msp4_input_clk),
        .mu_input_nrst          (msp4_input_nrst),
        .mu_input_enable        (msp4_input_enable[1]),
        .mu_input_a             (msp4_input_a1),
        .mu_input_b             (msp4_input_b1),
        .mu_output_result       (msp4_output_r1)
    );
    
    mult_unit #(
        .SIMD_WIDTH             (SIMD_WIDTH)
    )    u2
    (
        .mu_input_clk           (msp4_input_clk),
        .mu_input_nrst          (msp4_input_nrst),
        .mu_input_enable        (msp4_input_enable[2]),
        .mu_input_a             (msp4_input_a2),
        .mu_input_b             (msp4_input_b2),
        .mu_output_result       (msp4_output_r2)
    );
    
    mult_unit #(
        .SIMD_WIDTH             (SIMD_WIDTH)
    )    u3
    (
        .mu_input_clk           (msp4_input_clk),
        .mu_input_nrst          (msp4_input_nrst),
        .mu_input_enable        (msp4_input_enable[3]),
        .mu_input_a             (msp4_input_a3),
        .mu_input_b             (msp4_input_b3),
        .mu_output_result       (msp4_output_r3)
    );


endmodule
