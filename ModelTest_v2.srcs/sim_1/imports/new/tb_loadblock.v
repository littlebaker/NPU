`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 19:11:57
// Design Name: 
// Module Name: tb_loadblock
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


module tb_LoadBlock; 

    // LoadBlock Parameters
    parameter PERIOD  = 10;

    reg clk;
    reg rst_n;

    // LoadBlock Inputs
    reg   lb_input_clk                         = 0 ;
    reg   lb_input_nrst                        = 0 ;
    reg   lb_input_enable                      = 0 ;
    reg  [63:0] lb_input_d5                          = 0 ;

    // LoadBlock Outputs
    wire [63:0] lb_output_d1                         ;
    wire [63:0] lb_output_d2                         ;
    wire [63:0] lb_output_d3                         ;
    wire [63:0] lb_output_d4                         ;
    wire [63:0] lb_output_d5                         ;

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

    LoadBlock  u_LoadBlock (
        .lb_input_clk            ( clk      ),
        .lb_input_nrst           ( rst_n     ),
        .lb_input_enable         ( lb_input_enable   ),
        .lb_input_data             ( lb_input_d5       ),

        .lb_output_d1            ( lb_output_d1      ),
        .lb_output_d2            ( lb_output_d2      ),
        .lb_output_d3            ( lb_output_d3      ),
        .lb_output_d4            ( lb_output_d4      ),
        .lb_output_d5            ( lb_output_d5      )
    );

    initial
    begin
        lb_input_enable = 0;
        lb_input_d5 = 0;
        #(PERIOD*2+1) 
        for(i =0;i<5;i=i+1)
        begin
            lb_input_d5 = lb_input_d5 + 1;
            #(PERIOD);
        end
        lb_input_enable = 1;
        for(i =0;i<5;i=i+1)
        begin
            lb_input_d5 = lb_input_d5 + 1;
            #(PERIOD);
        end
        $finish;
    end

endmodule
