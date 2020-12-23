`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 23:25:32
// Design Name: 
// Module Name: testmodel
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


module RegArray(
    ra_input_clk,
    ra_input_nrst,
    ra_input_loaddst,
    ra_input_optmode,
    ra_input_stride,
    ra_input_data,
    ra_input_enable,
    ra_output_d1,
    ra_output_d2,
    ra_output_d3,
    ra_output_d4,
    ra_output_d5


    );

    input wire ra_input_clk;
    input wire ra_input_nrst;
    input wire ra_input_enable;

    wire [63:0] lb_output_d1;
    wire [63:0] lb_output_d2;
    wire [63:0] lb_output_d3;
    wire [63:0] lb_output_d4;
    wire [63:0] lb_output_d5;

    reg [63:0] sm_input_d1;
    reg [63:0] sm_input_d2;
    reg [63:0] sm_input_d3;
    reg [63:0] sm_input_d4;
    reg [63:0] sm_input_d5;

    input [63:0] ra_input_data;

    always@(*)
    begin
        sm_input_d1 = lb_output_d1;
        sm_input_d2 = lb_output_d2;
        sm_input_d3 = lb_output_d3;
        sm_input_d4 = lb_output_d4;
        sm_input_d5 = lb_output_d5;
    end


    input wire ra_input_loaddst;
    input wire [1:0] ra_input_optmode;
    input wire ra_input_stride ;

    output wire [63:0] ra_output_d1;
    output wire [63:0] ra_output_d2;
    output wire [63:0] ra_output_d3;
    output wire [63:0] ra_output_d4;
    output wire [63:0] ra_output_d5;


    ShiftMatrix u_ShiftMatrix(
    	.sm_input_clk     (ra_input_clk     ),
        .sm_input_nrst    (ra_input_nrst    ),
        .sm_input_loaddst (ra_input_loaddst ),
        .sm_input_optmode (ra_input_optmode ),
        .sm_input_stride  (ra_input_stride  ),
        .sm_input_d1      (sm_input_d1      ),
        .sm_input_d2      (sm_input_d2      ),
        .sm_input_d3      (sm_input_d3      ),
        .sm_input_d4      (sm_input_d4      ),
        .sm_input_d5      (sm_input_d5      ),
        .sm_output_d1     (ra_output_d1     ),
        .sm_output_d2     (ra_output_d2     ),
        .sm_output_d3     (ra_output_d3     ),
        .sm_output_d4     (ra_output_d4     ),
        .sm_output_d5     (ra_output_d5     )
    );
    
    
    LoadBlock u_LoadBlock(
    	.lb_input_clk    (ra_input_clk    ),
        .lb_input_nrst   (ra_input_nrst   ),
        .lb_input_enable (ra_input_enable ),
        .lb_input_d5     (ra_input_data     ),
        .lb_output_d1    (lb_output_d1    ),
        .lb_output_d2    (lb_output_d2    ),
        .lb_output_d3    (lb_output_d3    ),
        .lb_output_d4    (lb_output_d4    ),
        .lb_output_d5    (lb_output_d5    )
    );
    



endmodule
