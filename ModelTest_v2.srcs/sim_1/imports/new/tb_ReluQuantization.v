`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 21:29:03
// Design Name: 
// Module Name: tb_ReluQuantization
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


module tb_ReluQuantization;

// ReluQuantization Parameters
    parameter PERIOD  = 10;


    // ReluQuantization Inputs
    reg   clk                         = 0 ;
    reg   rst_n                        = 0 ;
    reg   rq_input_enable                      = 0 ;
    reg   [3:0]  rq_input_qin                  = 0 ;
    reg   [3:0]  rq_input_qw                   = 0 ;
    reg   [3:0]  rq_input_qout                 = 0 ;
    reg   rq_input_relu                        = 0 ;
    reg   [31:0]  rq_input_data                = 0 ;

    // ReluQuantization Outputs
    wire rq_output_active;
    wire  [7:0]  rq_output_result              ;


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

    ReluQuantization  u_ReluQuantization (
        .rq_input_clk            ( clk             ),
        .rq_input_nrst           ( rst_n            ),
        .rq_input_enable         ( rq_input_enable          ),
        .rq_input_qin            ( rq_input_qin      [3:0]  ),
        .rq_input_qw             ( rq_input_qw       [3:0]  ),
        .rq_input_qout           ( rq_input_qout     [3:0]  ),
        .rq_input_relu           ( rq_input_relu            ),
        .rq_input_data           ( rq_input_data     [31:0] ),
        .rq_output_active           (rq_output_active),
        .rq_output_result        ( rq_output_result  [7:0]  )
    );

    initial
    begin
        #(PERIOD * 2 + 1)
        rq_input_enable = 0;
        rq_input_qin = 7;
        rq_input_qw = 7;
        rq_input_qout = 5;
        rq_input_relu = 1;
        rq_input_data = -257;

        #PERIOD;
        rq_input_enable = 1;
        rq_input_relu = 1;
        #PERIOD;
        rq_input_data = 4096;
        #PERIOD;
        rq_input_data = 4096*2;
        #PERIOD;
        rq_input_data = -4096*2;
        #PERIOD;

        $finish;
    end

endmodule
