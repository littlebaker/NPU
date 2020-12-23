`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 21:31:02
// Design Name: 
// Module Name: LoadBlock
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


module LoadBlock(
    lb_input_clk,
    lb_input_nrst,
    lb_input_enable,
    lb_input_data,
    lb_input_restart,
    lb_output_d1,
    lb_output_d2,
    lb_output_d3,
    lb_output_d4,
    lb_output_d5
    );

    input lb_input_clk;
    input lb_input_nrst;
    input lb_input_enable;
    input lb_input_data;
    input lb_input_restart;

    output lb_output_d1;
    output lb_output_d2;
    output lb_output_d3;
    output lb_output_d4;
    output lb_output_d5;

    wire [63:0] lb_input_data;

    wire [63:0] lb_output_d1;
    wire [63:0] lb_output_d2;
    wire [63:0] lb_output_d3;
    wire [63:0] lb_output_d4;
    wire [63:0] lb_output_d5;

    reg [15:0] count;

    wire [4:0] load_enable;

    assign load_enable[0] = lb_input_enable && (count == 0);
    assign load_enable[1] = lb_input_enable && (count == 1);
    assign load_enable[2] = lb_input_enable && (count == 2);
    assign load_enable[3] = lb_input_enable && (count == 3);
    assign load_enable[4] = lb_input_enable && (count == 4);
 
    always@(posedge lb_input_clk)
    begin
        if(!lb_input_nrst || lb_input_restart)
        begin   
            count <= 0;
        end
        else
        begin
            if(lb_input_enable)
            begin
                if(count == 4)
                begin
                    count <= 0;
                end
                else
                begin
                    count <= count + 1;
                end
            end
            else
            begin
                count <= count;
            end
            
        end
    end

    ShiftArray u0(
    	.sa_input_clk         (lb_input_clk       ),
        .sa_input_nrst        (lb_input_nrst        ),
        .sa_input_optmode     ({1'b0, load_enable[0]}    ),
        .sa_input_stride      (0    ),
        .sa_input_dataloadin  (lb_input_data  ),
        .sa_input_datashiftin (0),
        .sa_output_dataout    (lb_output_d1 )
    );
    
    ShiftArray u1(
    	.sa_input_clk         (lb_input_clk       ),
        .sa_input_nrst        (lb_input_nrst        ),
        .sa_input_optmode     ({1'b0, load_enable[1]}    ),
        .sa_input_stride      (0    ),
        .sa_input_dataloadin  (lb_input_data  ),
        .sa_input_datashiftin (0),
        .sa_output_dataout    (lb_output_d2 )
    );
    ShiftArray u2(
    	.sa_input_clk         (lb_input_clk       ),
        .sa_input_nrst        (lb_input_nrst        ),
        .sa_input_optmode     ({1'b0, load_enable[2]}    ),
        .sa_input_stride      (0    ),
        .sa_input_dataloadin  (lb_input_data ),
        .sa_input_datashiftin (0),
        .sa_output_dataout    (lb_output_d3 )
    );
    ShiftArray u3(
    	.sa_input_clk         (lb_input_clk       ),
        .sa_input_nrst        (lb_input_nrst        ),
        .sa_input_optmode     ({1'b0, load_enable[3]}    ),
        .sa_input_stride      (0    ),
        .sa_input_dataloadin  (lb_input_data  ),
        .sa_input_datashiftin (0),
        .sa_output_dataout    (lb_output_d4 )
    );
    ShiftArray u4(
    	.sa_input_clk         (lb_input_clk       ),
        .sa_input_nrst        (lb_input_nrst        ),
        .sa_input_optmode     ({1'b0, load_enable[4]}    ),
        .sa_input_stride      (0    ),
        .sa_input_dataloadin  (lb_input_data  ),
        .sa_input_datashiftin (0),
        .sa_output_dataout    (lb_output_d5 )
    );




endmodule
