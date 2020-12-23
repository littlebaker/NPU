`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 09:44:07
// Design Name: 
// Module Name: act_write_wrapper
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


module act_write_wrapper(
    clka  ,
    ena   ,
    wea   ,
    addra ,
    dina  ,
    clkb  ,
    enb   ,
    addrb ,
    doutb 
    );

    input clka  ;
    input ena   ;
    input wea   ;
    input [11:0] addra ;
    input [63:0] dina  ;
    input clkb  ;
    input enb   ;
    input [11:0] addrb ;
    output [63:0] doutb ;



     blk_mem_act u_blk_mem_act_write(
        .clka                       (clka      ),
        .ena                        (ena       ),
        .wea                        (wea       ),
        .addra                      (addra     ),
        .dina                       (dina      ) ,
        .clkb                       (clkb      ),
        .enb                        (enb       ),
        .addrb                      (addrb     ),
        .doutb                      (doutb     )
    );
endmodule
