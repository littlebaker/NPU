`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 20:58:42
// Design Name: 
// Module Name: tb_conv2
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


module tb_ConvUnit_v2;

    // ConvUnit_v2 Parameters
    parameter PERIOD                = 10  ;
    parameter C_S_AXIS_TDATA_WIDTH  = 64 ;

    // ConvUnit_v2 Inputs
    reg clk;
    reg rst_n;
    reg   is_kernel                            = 0 ;
    reg   write_ok                             = 0 ;
    reg   S_AXIS_ACLK                          = 0 ;
    reg   S_AXIS_ARESETN                       = 0 ;
    reg   [C_S_AXIS_TDATA_WIDTH-1 : 0]  S_AXIS_TDATA = 0 ;
    reg   [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0]  S_AXIS_TSTRB = 0 ;
    reg   S_AXIS_TLAST                         = 0 ;
    reg   S_AXIS_TVALID                        = 0 ;


    // ConvUnit_v2 Outputs
    wire  S_AXIS_TREADY                        ;
    wire [63:0] my_data;
    wire [31:0] result;
    wire is_result_ok;
    reg set_arg;
    reg [7:0] kernel_size;
    reg [7:0] input_size;
    reg [3:0] stride;
    reg [63:0] d [0:3];

    always@(*)
    begin
        S_AXIS_TDATA = d[0];
    end

    integer i;



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


    ConvUnit_v2 u_ConvUnit_v2(
    	.U_AXIS_IS_KERNEL       (is_kernel       ),
        .cu_input_write_back_ok (0 ),
        .cu_input_set_arg       (set_arg       ),
        .cu_input_kernel_size   (kernel_size   ),
        .cu_input_input_size    (input_size    ),
        .cu_input_stride        (stride        ),
        .cu_input_relu          (0         ),
        .result                 (result                 ),
        .is_result_ok           (is_result_ok           ),
        .S_AXIS_ACLK            (clk          ),
        .S_AXIS_ARESETN         (rst_n        ),
        .S_AXIS_TREADY          (S_AXIS_TREADY          ),
        .S_AXIS_TDATA           (S_AXIS_TDATA           ),
        .S_AXIS_TSTRB           (S_AXIS_TSTRB           ),
        .S_AXIS_TLAST           (S_AXIS_TLAST           ),
        .S_AXIS_TVALID          (S_AXIS_TVALID          )
    );
    
    

    initial
    begin
        #(2*PERIOD + 1);
        kernel_size = 5;
        input_size = 36;
        stride = 1;
        set_arg = 1;
        #(PERIOD)

        S_AXIS_TSTRB = 32'hffffffff;
        S_AXIS_TVALID = 1;
        is_kernel = 1;
        set_arg = 0;
        S_AXIS_TLAST = 0;
        d[0] = 64'h0100000000000000;
        d[1] = 64'h0;
        d[2] = 64'h0;
        d[3] = 64'h0;

        for(i=0;i<5;i=i+1)
        begin
            // d[0] = d[0];
            #(PERIOD);
            d[0] = 0;
        end
        is_kernel = 0;

        d[0] = 64'h0102030405060708;
        d[1] = 64'h090a0b0c0d0e0f10;
        d[2] = 64'h1112131415161718;
        d[3] = 64'h191a1b1c1d1e1f20;
        for(i=0;i<1400;i=i+1)
        begin
            #(PERIOD);
        end
        S_AXIS_TLAST = 1;
        #10;
        S_AXIS_TLAST = 0;
        S_AXIS_TVALID = 0;

        for(i=0;i<10000;i=i+1)
        begin
            #10 $display("%h", my_data);
        end

        // $finish;
    end

endmodule
