`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 22:07:37
// Design Name: 
// Module Name: tb_MemoryGate
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


module tb_MemoryGate;

    // MemoryGate Parameters
    parameter PERIOD            = 10;


    // MemoryGate Inputs
    reg   clk                          ;
    reg   rst_n                        ;
    reg   mg_input_setarg                     ;
    reg   [3:0]  mg_input_padding             ;
    reg   [7:0]  mg_input_input_channel       ;
    reg   [7:0]  mg_input_output_channel      ;
    reg   [7:0]  mg_input_input_size          ;
    reg   [31:0]  mg_input_input_baseaddr     ;
    reg   [31:0]  mg_input_kernel_baseaddr    ;
    reg   [7:0]  mg_input_kernel_size         ;
    reg   [3:0]  mg_input_stride              ;
    reg   [7:0]  mg_input_enable              ;
    reg   [7:0]  mg_input_qin                 ;
    reg   [7:0]  mg_input_qw                  ;
    reg   [7:0]  mg_input_qout                ;
    reg   mg_input_relu                       ;
    wire   [31:0]  mg_input_doutb_kernel         ;
    wire   [63:0]  mg_input_doutb_act           ;


    // MemoryGate Outputs
    wire  mg_output_reading                    ;
    wire  mg_output_writing                    ;
    wire  mg_output_cal_fin                    ;
    wire  mg_output_enb_kernel                 ;
    wire  [12:0]  mg_output_addrb_kernel       ;
    wire  mg_output_wen_act                    ;
    wire  [8:0]  mg_output_addra_act          ;
    wire  [63:0]  mg_output_dina_act           ;
    wire  mg_output_enb_act                    ;
    wire  [8:0]  mg_output_addrb_act          ;

    reg   [7 : 0]  addrb                       = 0 ;

    integer i;
    wire  [31 : 0]  doutb                      ;
    wire [63:0] mg_input_doutb_act_new;


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

    MemoryGate u_MemoryGate(
    	.mg_input_clk             (clk             ),
        .mg_input_nrst            (rst_n            ),
        .mg_input_setarg          (mg_input_setarg          ),
        .mg_input_padding         (mg_input_padding         ),
        .mg_input_input_channel   (mg_input_input_channel   ),
        .mg_input_output_channel  (mg_input_output_channel  ),
        .mg_input_input_size      (mg_input_input_size      ),
        .mg_input_input_baseaddr  (mg_input_input_baseaddr  ),
        .mg_input_kernel_baseaddr (mg_input_kernel_baseaddr ),
        .mg_input_kernel_size     (mg_input_kernel_size     ),
        .mg_input_stride          (mg_input_stride          ),
        .mg_input_enable          (mg_input_enable          ),
        .mg_input_qin             (mg_input_qin             ),
        .mg_input_qw              (mg_input_qw              ),
        .mg_input_qout            (mg_input_qout            ),
        .mg_input_relu            (mg_input_relu            ),
        .mg_output_reading        (mg_output_reading        ),
        .mg_output_writing        (mg_output_writing        ),
        .mg_output_cal_fin        (mg_output_cal_fin        ),
        .mg_output_enb_kernel     (mg_output_enb_kernel     ),
        .mg_output_addrb_kernel   (mg_output_addrb_kernel   ),
        .mg_input_doutb_kernel    (mg_input_doutb_kernel    ),
        .mg_output_wen_act        (mg_output_wen_act        ),
        .mg_output_addra_act      (mg_output_addra_act      ),
        .mg_output_dina_act       (mg_output_dina_act       ),
        .mg_output_enb_act        (mg_output_enb_act        ),
        .mg_output_addrb_act      (mg_output_addrb_act      ),
        .mg_input_doutb_act       (mg_input_doutb_act       )
    );

    blk_mem_kernel u_blk_mem_kernel(
        .clka                       (clk),
        .ena                        (0),
        .wea                        (0),
        .addra                      (0),
        .dina                       (0),
        .clkb                       (clk),
        .enb                        (mg_output_enb_kernel),
        .addrb                      (mg_output_addrb_kernel[12 : 0]),
        .doutb                      (mg_input_doutb_kernel)
    );
    
    blk_mem_act u_blk_mem_act(
        .clka                       (clk),
        .ena                        (0),
        .wea                        (0),
        .addra                      (0),
        .dina                       (0),
        .clkb                       (clk),
        .enb                        (mg_output_enb_act),
        .addrb                      (mg_output_addrb_act[8 : 0]),
        .doutb                      (mg_input_doutb_act)
    );


    


    initial
    begin
        #(PERIOD*2 + 1);
        mg_input_setarg = 1;
        mg_input_padding = 2;
        mg_input_input_channel   = 1;
        mg_input_output_channel  = 1;
        mg_input_input_size      = 32;
        mg_input_input_baseaddr  = 0;
        mg_input_kernel_baseaddr = 0;
        mg_input_kernel_size     = 5;
        mg_input_stride     = 1;
        mg_input_qin  = 7;
        mg_input_qw   = 7;
        mg_input_qout = 5;
        mg_input_relu      = 1;

        #PERIOD;
        mg_input_setarg = 0;
        #(PERIOD*5);
        mg_input_enable = 1;
        
        #PERIOD

        for(i=1;i<100;i=i+1)
        begin
            
            #(PERIOD);
        end



        
    end

endmodule
