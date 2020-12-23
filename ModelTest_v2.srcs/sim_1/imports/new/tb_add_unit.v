`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 18:48:19
// Design Name: 
// Module Name: tb_add_unit
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


module tb_add_unit;

// add_unit Parameters
    parameter PERIOD  = 10;


    // add_unit Inputs
    reg   au_input_clk                         = 0 ;
    reg   au_input_nrst                        = 0 ;
    reg   au_input_enable                      = 0 ;
    reg   [3:0]  au_input_ksize                = 0 ;
    reg   [79:0]  au_input_data0               = 0 ;
    reg   [79:0]  au_input_data1               = 0 ;
    reg   [79:0]  au_input_data2               = 0 ;
    reg   [79:0]  au_input_data3               = 0 ;
    reg   [79:0]  au_input_data4               = 0 ;
    

    // add_unit Outputs
    wire  [31:0]  au_output_result             ;
    wire au_output_active;
    reg clk;
    reg rst_n;
    integer i;


    initial
    begin
        clk = 0;
        forever #(PERIOD/2)  clk=~clk;
    end

    initial
    begin
        rst_n = 0;
        #(PERIOD*2) rst_n  =  1;
    end

    add_unit  u_add_unit (
        .au_input_clk            ( clk             ),
        .au_input_nrst           ( rst_n            ),
        .au_input_enable         ( 1          ),
        .au_input_ksize          ( au_input_ksize    [3:0]  ),
        .au_input_data0          ( au_input_data0    [79:0] ),
        .au_input_data1          ( au_input_data1    [79:0] ),
        .au_input_data2          ( au_input_data2    [79:0] ),
        .au_input_data3          ( au_input_data3    [79:0] ),
        .au_input_data4          ( au_input_data4    [79:0] ),
        .au_output_active          (au_output_active ),
        .au_output_result        ( au_output_result  [31:0] )
    );

    initial
    begin
        au_input_data0 = { 16'd1, 16'd2, 16'd3, 16'd4, 16'd5};
        au_input_data1 = { 16'd1, 16'd2, 16'd3, 16'd4, 16'd5};
        au_input_data2 = { 16'd1, 16'd2, 16'd3, 16'd4, 16'd5};
        au_input_data3 = { 16'd1, 16'd2, 16'd3, 16'd4, 16'd5};
        au_input_data4 = { 16'd1, 16'd2, 16'd3, 16'd4, 16'd5};
        #(PERIOD*2 + 1)
        au_input_enable= 1;

        for(i=0; i<6;i=i+1)
        begin
            au_input_ksize = i;
            #PERIOD;

        end
#PERIOD;#PERIOD;#PERIOD;#PERIOD;#PERIOD;#PERIOD;
        $finish;
    end

endmodule
