`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 19:40:04
// Design Name: 
// Module Name: generate_test
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


module generate_test(

    );
    genvar byte_index;
    reg [31:0] tb_input;
    reg tb_clk;
    reg [31:0] write_pointer;

    generate 
	  for(byte_index=0; byte_index<= (32/8-1); byte_index=byte_index+1)
	  begin:FIFO_GEN

	    reg  [8-1:0] stream_data_fifo [0 : 10];

	    // Streaming input data is stored in FIFO

	    always @( posedge tb_clk )
	    begin
            if(tb_input ==32'habcdef01)
                write_pointer <= 0;
            else
                write_pointer <= write_pointer +1;
	        stream_data_fifo[write_pointer] <= tb_input[(byte_index*8+7) -: 8];
	    end  
	  end		
	endgenerate

    initial
    begin
        tb_clk <= 0;
        forever
            #10 tb_clk <= ~tb_clk;
    end

    initial
    begin
        #1 tb_input <= 32'habcdef01;
        forever 
            #10 tb_input <= tb_input-1;
    end

    wire [31:0] whatever;
	assign whatever = FIFO_GEN[0].stream_data_fifo[write_pointer];


endmodule
