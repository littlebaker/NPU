`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 14:35:59
// Design Name: 
// Module Name: tb_PaddingArray
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


module tb_PaddingArray;

// PaddingArray Parameters
parameter PERIOD  = 10;


    // PaddingArray Inputs
    reg   clk                         ;
    reg   rst_n                        ;
    reg   pa_input_enable                      ;
    reg   pa_input_setp                        ;
    reg   [3:0]  pa_input_padding              ;
    reg   [63:0]  pa_input_data                ;

    // PaddingArray Outputs
    wire  [63:0]  pa_output_result             ;    


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

    PaddingArray  u_PaddingArray (
        .pa_input_clk            ( clk             ),
        .pa_input_nrst           ( rst_n          ),
        .pa_input_enable         ( pa_input_enable          ),
        .pa_input_setp           ( pa_input_setp            ),
        .pa_input_padding        ( pa_input_padding  [3:0]  ),
        .pa_input_data           ( pa_input_data     [63:0] ),

        .pa_output_result        ( pa_output_result  [63:0] )
    );

    initial
    begin
        pa_input_setp = 0;
        pa_input_padding = 2;
        pa_input_enable =0;
        #(PERIOD*2+1);
        pa_input_setp = 1;
        pa_input_padding = 2;
        #(PERIOD);
        pa_input_enable = 1;
        for(i=0;i<10;i=i+1)
        begin
            pa_input_data = i+2;
            #PERIOD;
        end

        pa_input_enable = 0;
        for(i=0;i<10;i=i+1)
        begin
            pa_input_data = i;
            #PERIOD;
        end
        $finish;
    end

endmodule