`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 22:06:20
// Design Name: 
// Module Name: tb_LayerTop
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


module tb_LayerTop;

// LayerTop_v2 Parameters
parameter PERIOD = 10;
parameter IDLE  = 0;

// LayerTop_v2 Inputs
reg   lt_input_clk                         ;
reg   lt_input_nrst                        ;
reg   lt_input_start                       ;

// LayerTop_v2 Outputs
wire  lt_output_ready                      ;    
reg     lt_input_en_act ;
reg [11:0]    lt_input_addr_act;
wire  [63:0]   lt_output_dout_act ;


initial
begin
    lt_input_clk = 0;
    forever #(PERIOD/2)  lt_input_clk=~lt_input_clk;
end

initial
begin
    lt_input_nrst = 0;
    #(PERIOD*2) lt_input_nrst  =  1;
end

LayerTop_v2  u_LayerTop_v2 (
    .lt_input_clk            ( lt_input_clk            ),
    .lt_input_nrst           ( lt_input_nrst           ),
    .lt_input_start          ( lt_input_start          ),

    .lt_output_ready         ( lt_output_ready         ),
    // .lt_output_data0         ( lt_output_data0  [63:0] ),
    // .lt_output_data1         ( lt_output_data1  [63:0] )
    .lt_input_en_act            (    lt_input_en_act ),
    .lt_input_addr_act          (    lt_input_addr_act),
    .lt_output_dout_act         (    lt_output_dout_act ) 
);

initial
begin
    lt_input_start = 0;
    #(PERIOD*2+1)
    lt_input_start = 1;
    #(PERIOD)
    lt_input_start = 0;


end

endmodule