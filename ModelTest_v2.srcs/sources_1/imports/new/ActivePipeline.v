`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 19:12:03
// Design Name: 
// Module Name: ActivePipeline
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


module ActivePipeline #
(
    parameter WIDTH = 16

)
(
    ap_input_clk,
    ap_input_nrst,
    ap_input_enable,
    ap_input_data,
    ap_output_conf
    );

    input ap_input_clk;
    input ap_input_nrst;
    input ap_input_enable;
    input ap_input_data;
    output reg [WIDTH-1:0] ap_output_conf;
    
    genvar i;

    generate
    for(i=1;i<=WIDTH-1;i=i+1)
    begin:whatever
        always@(posedge ap_input_clk)
        begin
            if(!ap_input_nrst)
            begin
                ap_output_conf[i] <= 0;
            end
            else
            begin
                if(ap_input_enable)
                begin
                    ap_output_conf[i] <= ap_output_conf[i-1];
                end
            end
        end
    end
    endgenerate

    always@(posedge ap_input_clk)
        begin
            if(!ap_input_nrst)
            begin
                ap_output_conf[0] <= 0;
            end
            else
            begin
                if(ap_input_enable)
                begin
                    ap_output_conf[0] <= ap_input_data;
                end
            end
        end
    


endmodule
