`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 18:47:35
// Design Name: 
// Module Name: ShiftArray
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


module ShiftArray(
    sa_input_clk,
    sa_input_nrst,
    sa_input_optmode, 
    sa_input_stride,
    sa_input_dataloadin,
    sa_input_datashiftin,
    sa_output_dataout
    );

    input sa_input_clk;
    input sa_input_nrst;
    input sa_input_optmode;         // shift or from datain. 0: shift; 1: datain
    input [3:0] sa_input_stride;          // 0: shift 1; 1: shift 2
    input sa_input_dataloadin;
    input sa_input_datashiftin;

    output sa_output_dataout;

    // wire [1:0] sa_input_stride;
    wire [1:0] sa_input_optmode;
    wire [63:0] sa_input_dataloadin;
    wire [15:0] sa_input_datashiftin;
    reg [63:0] sa_output_dataout;

    always@(posedge sa_input_clk)
    begin
        if(!sa_input_nrst)
        begin
            sa_output_dataout <= 0;
        end
        else
        begin
            case(sa_input_optmode)
            0:                  // keep value
                sa_output_dataout <= sa_output_dataout;
            
            1:                  // reset value
                sa_output_dataout <= sa_input_dataloadin;

            2,3:                // shift mode
                if(sa_input_stride == 1)
                begin
                    sa_output_dataout <=  {sa_output_dataout[55:0],sa_input_datashiftin[15:8]};
                end
                else
                begin
                    sa_output_dataout <=  {sa_output_dataout[47:0],sa_input_datashiftin[15:0]};
                end
            endcase
        end
    end


endmodule
