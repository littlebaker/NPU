`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/23 22:06:34
// Design Name: 
// Module Name: tb_mem
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


module tb_mem(

    );

// blk_mem_gen_0 Parameters
parameter PERIOD  = 10;


// blk_mem_gen_0 Inputs
reg clk;
reg rst_n;
reg   clka                                 = 0 ;
reg   ena                                  = 0 ;
reg   [0 : 0]  wea                         = 0 ;
reg   [5 : 0]  addra                       = 0 ;
reg   [63 : 0]  dina                      = 0 ;
reg   clkb                                 = 0 ;
reg   enb                                  = 0 ;
reg   [7 : 0]  addrb                       = 0 ;

// blk_mem_gen_0 Outputs
wire  [31 : 0]  doutb                      ;

integer i;
reg [63:0] a, b, c,d;


initial
begin
    clk <= 0;
    forever #(PERIOD/2)  clk <= ~clk;
end

initial
begin
    rst_n <= 0;
    #(PERIOD*2) rst_n  <=  1;
end

blk_mem_kernel  u_blk_mem_gen_0 (
    .clka                    ( clk             ),
    .ena                     ( 0              ),
    .wea                     ( 0   ),
    .addra                   ( 0   ),
    .dina                    ( 0 ),
    .clkb                    ( clk             ),
    .enb                     ( enb              ),
    .addrb                   ( {4'b0, addrb}  ),

    .doutb                   ( doutb  [31 : 0]  )
);

initial
begin
    wea = 0;
    ena = 0;
    enb = 0;
    a =0;
    b=1;
    c=2;
    d=3;
    addra = 0;
    addrb = 0;
    #(PERIOD*2);
    #1;
    wea <= 0;
    ena = 0;
    for(i=0;i<=15;i=i+1)
    begin
        a = a+1;
        b=b+1;
        c=c+1;
        d=d+1;
        dina = {a,b,c,d};
        #(PERIOD) addra = addra +1; 

    end

    ena = 0;
    wea = 0;
    enb = 1;
    for(i=0;i<=63;i=i+1)
    begin
        #(PERIOD) addrb = addrb +1; 
        
        $display("the num is %h", doutb);

    end


    $finish;
end

endmodule