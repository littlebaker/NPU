`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 23:52:59
// Design Name: 
// Module Name: ROM_test
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


module ROM_test(
    rt_input_clk,
    rt_input_ena,
    rt_input_addra,
    rt_output_douta,
    rt_input_enb,
    rt_input_addrb,
    rt_output_doutb
    );

    input rt_input_clk;
    input rt_input_ena;
    input [31:0] rt_input_addra;
    output [31:0] rt_output_douta;
    input rt_input_enb;
    input [31:0] rt_input_addrb;
    output [31:0] rt_output_doutb;

    blk_mem_kernel u_blk_mem_kernel(
        .clka                       (rt_input_clk),
        .ena                        (rt_input_ena),
        // .wea                        (0),
        .addra                      (rt_input_addra),
        // .dina                       (0),
        .douta                         (rt_output_douta),
        .clkb                       (rt_input_clk),
        .enb                        (rt_input_enb),
        .addrb                      (rt_input_addrb),
        .doutb                      (rt_output_doutb)
    );



endmodule
