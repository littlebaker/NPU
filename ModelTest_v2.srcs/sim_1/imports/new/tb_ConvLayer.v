`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 18:38:20
// Design Name: 
// Module Name: tb_ConvLayer
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


module tb_ConvLayer;

// ConvLayer Parameters
    parameter PERIOD  = 10;


    // ConvLayer Inputs
    reg   clk                         ;
    reg   rst_n                        ;

    reg cl_input_enable;
    reg cl_input_setarg;

    reg [31:0] cl_input_input_baseaddr;
    reg [31:0] cl_input_kernel_baseaddr;
    reg [7:0] cl_input_input_size;
    reg [7:0] cl_input_kernel_size;
    reg [7:0] cl_input_output_size;
    reg [15:0] cl_input_input_chan;
    reg [15:0] cl_input_output_chan;
    reg [7:0] cl_input_qin;
    reg [7:0] cl_input_qw;
    reg [7:0] cl_input_qout;
    reg [3:0] cl_input_padding;
    reg [3:0] cl_input_stride;
    reg cl_input_relu;
    wire cl_output_ready;

    wire cl_output_enb_kernel;
    wire [31:0] cl_output_addrb_kernel;
    wire [31:0] cl_input_doutb_kernel;

    wire cl_output_wen_act ;
    wire [31:0] cl_output_addra_act;
    wire [63:0] cl_output_dina_act;
    wire cl_output_enb_act;
    wire [31:0] cl_output_addrb_act;
    wire [63:0] cl_input_doutb_act;


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

    ConvLayer u_ConvLayer(
        .cl_input_clk             (clk             ),
        .cl_input_nrst            (rst_n            ),
        .cl_input_enable          (cl_input_enable          ),
        .cl_input_setarg          (cl_input_setarg          ),
        .cl_input_input_baseaddr  (cl_input_input_baseaddr  ),
        .cl_input_kernel_baseaddr (cl_input_kernel_baseaddr ),
        .cl_input_input_size      (cl_input_input_size      ),
        .cl_input_kernel_size     (cl_input_kernel_size     ),
        .cl_input_output_size     (cl_input_output_size     ),
        .cl_input_input_chan      (cl_input_input_chan      ),
        .cl_input_output_chan     (cl_input_output_chan     ),
        .cl_input_qin             (cl_input_qin             ),
        .cl_input_qw              (cl_input_qw              ),
        .cl_input_qout            (cl_input_qout            ),
        .cl_input_padding         (cl_input_padding         ),
        .cl_input_stride          (cl_input_stride          ),
        .cl_input_relu            (cl_input_relu            ),
        .cl_output_ready          (cl_output_ready          ),
        .cl_output_enb_kernel     (cl_output_enb_kernel     ),
        .cl_output_addrb_kernel   (cl_output_addrb_kernel   ),
        .cl_input_doutb_kernel    (cl_input_doutb_kernel    ),
        .cl_output_wen_act        (cl_output_wen_act        ),
        .cl_output_addra_act      (cl_output_addra_act      ),
        .cl_output_dina_act       (cl_output_dina_act       ),
        .cl_output_enb_act        (cl_output_enb_act        ),
        .cl_output_addrb_act      (cl_output_addrb_act      ),
        .cl_input_doutb_act       (cl_input_doutb_act       )
);

    blk_mem_kernel u_blk_mem_kernel(
        .clka                       (clk),
        .ena                        (cl_output_enb_kernel),
        // .wea                        (0),
        .addra                      (cl_output_addrb_kernel),
        // .dina                       (0),
        .douta                         (cl_input_doutb_kernel),
        .clkb                       (clk),
        .enb                        (0),
        .addrb                      (0),
        .doutb                      ()
    );
    
    blk_mem_act u_blk_mem_act(
        .clka                       (clk),
        .ena                        (0),
        .wea                        (0),
        .addra                      (0),
        .dina                       (0),
        .clkb                       (clk),
        .enb                        (cl_output_enb_act),
        .addrb                      (cl_output_addrb_act),
        .doutb                      (cl_input_doutb_act)
    );

    blk_mem_act u_blk_mem_act_write(
        .clka                       (clk),
        .ena                        (cl_output_wen_act),
        .wea                        (cl_output_wen_act),
        .addra                      (cl_output_addra_act),
        .dina                       (cl_output_dina_act),
        .clkb                       (clk),
        .enb                        (0),
        .addrb                      (0),
        .doutb                      ()
    );

    initial
    begin
        #(PERIOD*2+1);
        cl_input_enable          = 0;
        cl_input_setarg          = 0;
        cl_input_input_baseaddr  = 0;
        cl_input_kernel_baseaddr = 0;
        cl_input_input_size      = 32;
        cl_input_kernel_size     = 5;
        cl_input_output_size     = 32;
        cl_input_input_chan      = 1;
        cl_input_output_chan     = 32;
        cl_input_qin             = 7;
        cl_input_qw              = 7;
        cl_input_qout            = 5;
        cl_input_padding         = 2;
        cl_input_stride          = 1;
        cl_input_relu            = 1;
        #PERIOD;
        cl_input_setarg          = 1;
        #(PERIOD*5)

        cl_input_enable = 1;
        #PERIOD
        cl_input_enable = 0;
    end

endmodule
