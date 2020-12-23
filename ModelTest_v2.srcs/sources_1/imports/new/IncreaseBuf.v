`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 19:34:31
// Design Name: 
// Module Name: IncreaseBuf
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


module IncreaseBuf(
    ib_input_clk,
    ib_input_nrst,
    ib_input_keep,      // decides whether to continue summing or erase
    ib_input_img_fin,   // signal: input of one image is finished
    ib_input_is_ok,     // result_is_ok 
    ib_input_data,      // result
    ib_input_tready,    
    ib_output_tvalid,   // tready+tvalid togethor controlls bram_read
    ib_output_tdata,    // FINAL OUTPUT FOR CHECKING
    ib_output_num_count // number of received data
    );

    input ib_input_clk;
    input ib_input_nrst;
    input ib_input_keep;
    input ib_input_img_fin;
    input ib_input_is_ok;
    input [7:0] ib_input_data;
    input ib_input_tready;
    
    output reg ib_output_tvalid;
    output [63:0] ib_output_tdata;      // output read from bram port b
    output [15:0] ib_output_num_count;  // number of received data
    
    reg [15:0] buf_count;       // = 0-7
    
    reg [63:0] data_in;         // input data from bram port a
    reg [15:0] write_pointer;   // address for writing input for bram port a
    wire [63:0] data_load;      // output from bram port a
    wire bram_read;             // enable read from bram port b
    reg [15:0] read_pointer;    // read address for bram port b
    reg [15:0] write_pointer_pipe;
    reg [7:0] data_buf [0:7];   // 8 data buffers saving 8 input data at a time
    
    reg [63:0] add_buf;         // buffer that stores the sum data
    reg [15:0] ib_output_num_count;
    
    // reg write_en;           
    // reg [7:0] write_data;  // UNUSED VARIABLES
    wire [3:0] wen_pipe;     // wen_pipe[0] = write enable port a
    reg [3:0] state;
    reg [15:0] max_write_pointer;
    
    genvar i;

    localparam IDLE = 0,
    WRITING = 1;

    // ib_output_number_count; // TODO: output_num_count always 0 or 1
    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst) begin
            begin
                ib_output_num_count <= 0;
            end
        end
        else 
        begin
            if (state == WRITING) begin
                 // when ib_input_is_ok, receive new reselt data every clock cycle
                 if(ib_input_is_ok)
                 begin
                     ib_output_num_count <= ib_output_num_count + 1;
                 end
            end
        end
    end

    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            state <= IDLE;
        end
        else
        begin
            // when receive input_is_ok signal, goes from IDLE to WRITING
            case(state)
            IDLE:
            if(ib_input_is_ok)
            begin
                state <= WRITING;
            end
            // returns to IDLE state when finish reading one image
            WRITING:
            if(ib_input_img_fin)
            begin
                state <= IDLE;
            end
            default:
            begin
                state <= IDLE;
            end
            endcase
        end
    end

    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            write_pointer_pipe <= 0;
        end
        else
        begin
            if(ib_input_is_ok)
            begin
                write_pointer_pipe <= write_pointer + 1;
            end
            else
            begin
                write_pointer_pipe <= write_pointer;
            end
            
        end
    end

    // buf count
    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            buf_count <= 0;
        end
        else
        begin
            if(ib_input_is_ok)
            begin
                if(buf_count == 7)
                begin
                    buf_count <= 0;
                end
                else
                begin
                    buf_count <= buf_count + 1;
                end
            end
            else if(state != WRITING)
            begin
                buf_count <= 0;
            end
            
        end
    end

    generate 
    for(i=0;i<8;i=i+1)
    begin:whatever
        always@(*)
        begin
        // starting point of part select variable 63-8*i and 8 is the width of part select (constant) 
            add_buf[63-8*i -:8] = data_load[63-8*i -:8] + data_buf[i]; 
        end
    end
    endgenerate

    // data buf
    always@(posedge ib_input_clk)
    begin
        if(ib_input_is_ok)
        begin
            case(buf_count)
            0:
            data_buf[0] <= ib_input_data;
            1:
            data_buf[1] <= ib_input_data;
            2:
            data_buf[2] <= ib_input_data;
            3:
            data_buf[3] <= ib_input_data;
            4:
            data_buf[4] <= ib_input_data;
            5:
            data_buf[5] <= ib_input_data;
            6:
            data_buf[6] <= ib_input_data;
            7:
            data_buf[7] <= ib_input_data;
            endcase
        end
    end

    // data_in
    always@(*)
    begin
        if(ib_input_keep)
        begin
            data_in = add_buf;
        end
        else
        begin
            data_in = {data_buf[0],data_buf[1],data_buf[2],data_buf[3],data_buf[4],data_buf[5],data_buf[6],data_buf[7]};
        end
    end


    // tvalid
    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            ib_output_tvalid <= 0;
        end
        else
        begin
            case(state)
            IDLE:
            if(ib_input_is_ok)
            begin
                ib_output_tvalid <= 0;
            end
            WRITING:
            if(ib_input_img_fin)
            begin
                ib_output_tvalid <= 1;
            end
            endcase
        end
    end
    
    assign bram_read = ib_output_tvalid && ib_input_tready;

    // write_pointer
    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            write_pointer <= 0;
        end
        else
        begin
            if(state == WRITING)
            begin
                if(wen_pipe[0])
                begin
                    write_pointer <= write_pointer + 1;
                end
            end
            else
            begin
                write_pointer <= 0;
            end

            
        end
    end

    // max_write_pointer
    always@(posedge ib_input_clk)
    begin
        if(state == WRITING)
        begin
            max_write_pointer <= write_pointer;
        end
    end

    // read_pointer
    always@(posedge ib_input_clk)
    begin
        if(!ib_input_nrst)
        begin
            read_pointer <= 0;
        end
        else
        begin
            if(bram_read)
            begin
                read_pointer <= read_pointer + 1;
            end
            else
            begin
                read_pointer <= 0;
            end
        end
    end


    


    blk_mem_increase_buf u_bib (
        .clka                   (ib_input_clk),
        .ena                    (buf_count == 0 || buf_count == 7),
        .wea                    (wen_pipe[0]),
        .addra                  (write_pointer),
        .dina                   (data_in),                 // TODO
        .douta                  (data_load),
        .clkb                   (ib_input_clk),
        .enb                    (bram_read),
        .web                    (1'h0),
        .addrb                  (read_pointer),
        .dinb                   (64'h0),
        .doutb                  (ib_output_tdata)
    );

    ActivePipeline 
    #(
        .WIDTH (4)
    )
    u_ActivePipeline(
    	.ap_input_clk    (ib_input_clk    ),
        .ap_input_nrst   (ib_input_nrst   ),
        .ap_input_enable (1 ),
        .ap_input_data   (buf_count == 7 && state == WRITING  ),
        .ap_output_conf  (wen_pipe  )
    );
    


endmodule
