`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/20 22:16:16
// Design Name: 
// Module Name: sum_unit
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

(*use_dsp = "yes"*)
module sum_unit(
    su_input_clk,
    su_input_nrst,
    su_input_enable,
    su_input_data,
    su_input_ksize,
    su_output_result
    );

    input su_input_clk;
    input su_input_nrst;
    input su_input_data;
    input su_input_ksize;
    input su_input_enable;

    output su_output_result;

    wire [255:0] su_input_data;
    wire [15:0 ]  su_input_ksize;
    
    reg [31:0] su_output_result;
    reg [255:0] mask;
    wire [255:0] data;

    assign data = su_input_data;

    // always@(*)
    // begin
    //     case(su_input_ksize)
    //     1:
    //     mask = 128'hff;
    //     2:
    //     mask = 128'hffffffff;
    //     3:
    //     mask = 128'hffffffffffffffffff;
    //     4:
    //     mask = 128'hffffffffffffffffffffffffffffffff;
    //     default:
    //     mask = 0;
    // end

    always@(posedge su_input_clk)
    begin
        if(!su_input_nrst)
        begin
            su_output_result <= 0;
        end
        else
        begin
            if(su_input_enable)
            begin
                case(su_input_ksize)
                1:
                su_output_result <= data[15-:16];
                2:
                su_output_result <= data[15-:16]+data[31-:16]+data[47-:16]+data[63-:16];
                3:
                su_output_result <= data[15-:16]+data[31-:16]+data[47-:16]+data[63-:16] + data[79-:16]+data[95-:16]+data[111-:16]+data[127-:16] + data[143-:16];
                4:
                su_output_result <= data[15-:16]+data[31-:16]+data[47-:16]+data[63-:16] + data[79-:16]+data[95-:16]+data[111-:16]+data[127-:16] + data[143-:16] + 
                                    data[159-:16]+data[175-:16]+data[191-:16]+data[207-:16] + data[223-:16]+data[239-:16]+data[255-:16];
                default:
                su_output_result <= 0;
                endcase
            end
            else
            begin
                su_output_result <= 0;

            end
            
        end

    end

endmodule
