`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 09:34:25
// Design Name: 
// Module Name: Scheduler
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


module Scheduler #
(
    parameter SIMD_WIDTH = 128,
    parameter ID_WIDTH = 32,
    parameter UNIT_NUM = 8

)
(
    scheduler_input_clk,
    scheduler_input_nrst,
    scheduler_input_ID,
    scheduler_input_wvalid,
    scheduler_input_rvalid,
    scheduler_input_dataA,
    scheduler_input_dataB,
    scheduler_output_result,
    scheduler_output_ID,
    scheduler_output_wready,
    scheduler_rready
    );

    input scheduler_input_clk;
    input scheduler_input_nrst;
    input scheduler_input_ID;
    input scheduler_input_wvalid;
    input scheduler_input_rvalid;
    input scheduler_input_dataA;
    input scheduler_input_dataB;
    output scheduler_output_result;
    output scheduler_output_ID;
    output scheduler_output_wready;
    output scheduler_rready;

    wire [ID_WIDTH-1:0] scheduler_input_ID;
    wire [SIMD_WIDTH-1:0] scheduler_input_dataA;
    wire [SIMD_WIDTH-1:0] scheduler_input_dataB;
    reg [SIMD_WIDTH*2-1:0] scheduler_output_result;
    reg [ID_WIDTH-1:0] scheduler_input_ID;

    reg [UNIT_NUM-1:0] work_status;
    reg [UNIT_NUM-1:0] unit_enable;








    
endmodule
