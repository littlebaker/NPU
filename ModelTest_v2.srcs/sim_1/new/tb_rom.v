`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/22 13:35:19
// Design Name: 
// Module Name: tb_rom
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


module tb_ROM_test;

// ROM_test Parameters
parameter PERIOD  = 10;


// ROM_test Inputs
reg   rt_input_clk                        ;
reg   rt_input_ena                        ;
reg   [31:0]  rt_input_addra              ;
reg   rt_input_enb                        ;
reg   [31:0]  rt_input_addrb              ;

// ROM_test Outputs
wire  [31:0]  rt_output_douta              ;    
wire  [31:0]  rt_output_doutb              ;   

integer i;


initial
begin
    rt_input_clk = 0;
    forever #(PERIOD/2)  rt_input_clk=~rt_input_clk;
end

// initial
// begin
//     #(PERIOD*2) rst_n  =  1;
// end

ROM_test  u_ROM_test (
    .rt_input_clk            ( rt_input_clk            ),
    .rt_input_ena            ( rt_input_ena            ),
    .rt_input_addra          ( rt_input_addra   [31:0] ),
    .rt_input_enb            ( rt_input_enb            ),
    .rt_input_addrb          ( rt_input_addrb   [31:0] ),

    .rt_output_douta         ( rt_output_douta  [31:0] ),
    .rt_output_doutb         ( rt_output_doutb  [31:0] )
);

initial
begin
    rt_input_ena = 0;
    rt_input_enb = 1;
    rt_input_addra = 0;
    rt_input_addrb = 0;
    #(1)
    for(i=0;i<100;i=i+1)
    begin
        #(PERIOD) rt_input_addrb = i;
    end
    
end

endmodule
