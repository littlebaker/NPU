`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 19:36:09
// Design Name: 
// Module Name: ShiftMatrix
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


module ShiftMatrix(
    sm_input_clk,
    sm_input_nrst,
    sm_input_loaddst,
    sm_input_optmode,
    sm_input_stride,
    sm_input_d1,
    sm_input_d2,
    sm_input_d3,
    sm_input_d4,
    sm_input_d5,

    sm_output_d1,
    sm_output_d2,
    sm_output_d3,
    sm_output_d4,
    sm_output_d5
    );

    input sm_input_clk;
    input sm_input_nrst;
    input sm_input_loaddst;
    input sm_input_optmode;
    input [3:0] sm_input_stride;

    input sm_input_d1;
    input sm_input_d2;
    input sm_input_d3;
    input sm_input_d4;
    input sm_input_d5;

    output sm_output_d1;
    output sm_output_d2;
    output sm_output_d3;
    output sm_output_d4;
    output sm_output_d5;

    wire [1:0] sm_input_optmode;
    wire [63:0] sm_input_d1;
    wire [63:0] sm_input_d2;
    wire [63:0] sm_input_d3;
    wire [63:0] sm_input_d4;
    wire [63:0] sm_input_d5;

    wire [63:0] sm_output_d1;
    wire [63:0] sm_output_d2;
    wire [63:0] sm_output_d3;
    wire [63:0] sm_output_d4;
    wire [63:0] sm_output_d5;

    wire [63:0] data_shift_1;
    wire [63:0] data_shift_2;
    wire [63:0] data_shift_3;
    wire [63:0] data_shift_4;
    wire [63:0] data_shift_5;

    reg [1:0] cal_block_opt;
    reg [1:0] shift_block_opt;

    always@(*)
    begin
        case(sm_input_optmode)
        0:                  // do nothing
        begin
            cal_block_opt = 0;
            shift_block_opt = 0;
        end
        1:                  // slowstart
        begin
            if(sm_input_loaddst == 0)
            begin
                cal_block_opt = 1;          // dst:0 cal_block load
                shift_block_opt = 0;        // dst:1 shift_block load
            end
            else
            begin
                cal_block_opt = 0;
                shift_block_opt = 1;
            end
        end
        2:                  // cal_block shift & shift_block load
        begin
            cal_block_opt = 2;
            shift_block_opt = 1;
        end

        3:                  // only shift, no load
        begin
            cal_block_opt = 2;
            shift_block_opt = 2;
        end

        endcase


    end

    


    ShiftArray u0(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (cal_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d1),
        .sa_input_datashiftin           (data_shift_1[63 -:16]),
        .sa_output_dataout              (sm_output_d1)
    );
    ShiftArray u1(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (cal_block_opt),  
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d2),
        .sa_input_datashiftin           (data_shift_2[63 -:16]),
        .sa_output_dataout              (sm_output_d2)
    );
    ShiftArray u2(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (cal_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d3),
        .sa_input_datashiftin           (data_shift_3[63 -:16]),
        .sa_output_dataout              (sm_output_d3)
    );
    ShiftArray u3(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (cal_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d4),
        .sa_input_datashiftin           (data_shift_4[63 -:16]),
        .sa_output_dataout              (sm_output_d4)
    );
    ShiftArray u4(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (cal_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d5),
        .sa_input_datashiftin           (data_shift_5[63 -:16]),
        .sa_output_dataout              (sm_output_d5)
    );

    // shift blocks
    ShiftArray u5(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (shift_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d1),
        .sa_input_datashiftin           (0),
        .sa_output_dataout              (data_shift_1)
    );
    ShiftArray u6(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (shift_block_opt),  
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d2),
        .sa_input_datashiftin           (0),
        .sa_output_dataout              (data_shift_2)
    );
    ShiftArray u7(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (shift_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d3),
        .sa_input_datashiftin           (0),
        .sa_output_dataout              (data_shift_3)
    );
    ShiftArray u8(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (shift_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d4),
        .sa_input_datashiftin           (0),
        .sa_output_dataout              (data_shift_4)
    );
    ShiftArray u9(
        .sa_input_clk                   (sm_input_clk),
        .sa_input_nrst                  (sm_input_nrst),
        .sa_input_optmode               (shift_block_opt), 
        .sa_input_stride                (sm_input_stride),
        .sa_input_dataloadin            (sm_input_d5),
        .sa_input_datashiftin           (0),
        .sa_output_dataout              (data_shift_5)
    );




endmodule
