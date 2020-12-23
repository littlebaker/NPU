`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 10:57:07
// Design Name: 
// Module Name: Priority_encoder
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


module Priority_encoder #
(
    parameter WIDTH = 8
    )
    (
        pe_input_data,
        pe_output_res
    );

    input pe_input_data;
    output pe_output_res;

    wire [WIDTH-1:0] pe_input_data;
    reg [WIDTH-1:0] pe_output_res;

    genvar encoder_var;

    always@(*)
        pe_output_res[0] = (pe_input_data[0] == 0);
        
    generate 
        for(encoder_var=1;encoder_var<=WIDTH-1;encoder_var=encoder_var+1)
        begin: ENCODER_BLOCK
        always@(*)
        begin
            pe_output_res[encoder_var] = (pe_input_data[encoder_var] == 0) && (pe_output_res[encoder_var-1:0] == 0);

        end
        end
    endgenerate



endmodule
