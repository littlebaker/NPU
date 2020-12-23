`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 23:08:55
// Design Name: 
// Module Name: tb_mult_unit
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


module tb_mult_unit(

    );

    reg tb_input_clk;
    reg tb_input_nrst;
    reg tb_input_enable;

    reg signed [127:0] tb_input_a;
    reg signed [127:0] tb_input_b;
    wire signed [127:0] tb_output_result;
    integer i,j;

    mult_unit u1(
        .mu_input_clk               (tb_input_clk),
        .mu_input_nrst              (tb_input_nrst),
        .mu_input_enable            (tb_input_enable),
        .mu_input_a                 (tb_input_a),
        .mu_input_b                 (tb_input_b),
        .mu_output_result           (tb_output_result)
    );

    initial
    begin
        tb_input_clk <=0;
        tb_input_enable <= 1;
        forever 
        #5 tb_input_clk <= ~tb_input_clk;
    end
    initial
    begin
        tb_input_nrst <= 0;
        #20 
        tb_input_nrst <= 1;
    end

    initial
    begin
        #41 
        for(i=0; i<30;i=i+1)
        begin
            for(j=0;j<=15;j=j+1)
            begin
                $display("ref=%h, output=%h, ref-output=%h", {8'b00,tb_input_a[j*8+7-:8]}*{8'b00,tb_input_b[j*8+7-:8]}, 
                    tb_output_result[j*16+15-:16], 
                    {8'b00,tb_input_a[j*8+7-:8]}*{8'b00,tb_input_b[j*8+7-:8]}- tb_output_result[j*16+15-:16]);
            end
            tb_input_a = {$random};
            tb_input_b = {$random};
            #10;
        end
        $finish;

    end



endmodule
