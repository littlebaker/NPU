`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 11:03:14
// Design Name: 
// Module Name: tb_priority_encoder
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


module tb_priority_encoder(

    );

    reg [7:0] tb_input_data;
    wire [7:0] tb_output_res;

    integer i;

    Priority_encoder u1(
        .pe_input_data          (tb_input_data),
        .pe_output_res          (tb_output_res)
    );

    initial
    begin
        for(i=0;i<30; i=i+1)
        begin
            #10 tb_input_data <= $random;
        end
    end




endmodule
