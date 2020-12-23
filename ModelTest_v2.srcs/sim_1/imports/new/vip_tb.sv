`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 20:39:24
// Design Name: 
// Module Name: vip_tb
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
import axi_vip_pkg::*;

import design_1_axi_vip_0_0_pkg::*;

// import design_1_axi_vip_1_0_pkg::*;


module vip_tb(

    );
    bit aclk    = 0;
    bit aresetn = 0;

    bit[31:0] 	addr1       = 32'h7600_0000;
    bit[31:0]   addr2       = 32'h7600_0020;
    bit[127:0] 	data_wr1    = 128'h0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
    bit[127:0]  data_wr2    = 128'h14141414141414141414141414141414;
    bit[31:0]   prot        = 0;
    bit[127:0] 	data_rd1;
    bit[127:0]   data_rd2;
    bit 	    resp;
    design_1_axi_vip_0_0_mst_t master_agent;

    xil_axi_uint				            mtestID;
    xil_axi_len_t                          mtestBurstLength;
    xil_axi_size_t                         mtestDataSize;
    xil_axi_burst_t                        mtestBurstType;
    xil_axi_lock_t                         mtestLOCK;
    xil_axi_cache_t                        mtestCacheType;
    xil_axi_prot_t                         mtestProtectionType;
    xil_axi_region_t                       mtestRegion;
    xil_axi_qos_t                          mtestQOS;
    xil_axi_data_beat [255:0]              mtestWUSER, mtestRUSER;
    xil_axi_data_beat                      mtestAWUSER;


    always begin
        #5ns;
        aclk = ~aclk;
    end 
    design_1_wrapper DUT
    (
        .aclk_0     (   aclk    ),
        .aresetn_0  (   aresetn )
    );

    initial begin
        mtestID = 0;
        mtestBurstLength = 1;
        // mtestBurstLength = 4/(2**mtestDataSize)-1;
        //mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
        mtestDataSize = XIL_AXI_SIZE_16BYTE;   
        mtestBurstType = XIL_AXI_BURST_TYPE_INCR; 
        mtestLOCK = XIL_AXI_ALOCK_NOLOCK; 
        mtestCacheType = 0; 
        mtestProtectionType = 0; 
        mtestRegion = 0;
        mtestQOS = 0;

        // Create an agent
        master_agent = new("master vip agent",DUT.design_1_i.axi_vip_DATA.inst.IF);
     
        // set tag for agents for easy debug
        master_agent.set_agent_tag("Master VIP");
     
        // set print out verbosity level.
        master_agent.set_verbosity(400);
     
        //Start the agent
        master_agent.start_master();
        
        #50ns
        aresetn = 1;

        // Use the tasks AXI4LITE_READ_BURST and AXI4LITE_WRITE_BURST to send read and write commands
        
        #100ns
        master_agent.AXI4_WRITE_BURST(mtestID,addr1,mtestBurstLength, mtestDataSize, mtestBurstType,
            mtestLOCK, mtestCacheType, mtestProtectionType, mtestRegion, mtestQOS, mtestAWUSER, {data_wr1, data_wr2}, mtestWUSER, resp);
        
        #100ns
        // master_agent.AXI4_WRITE_BURST(mtestID,addr2,mtestBurstLength, mtestDataSize, mtestBurstType,
        //     mtestLOCK, mtestCacheType, mtestProtectionType, mtestRegion, mtestQOS, mtestAWUSER, data_wr2, mtestWUSER, resp);

        
        #300ns
        master_agent.AXI4_READ_BURST(mtestID,addr1,mtestBurstLength, mtestDataSize, mtestBurstType,
            mtestLOCK, mtestCacheType, mtestProtectionType, mtestRegion, mtestQOS, mtestAWUSER, {data_rd1, data_rd2}, mtestWUSER, resp);
        
        #100ns
        // master_agent.AXI4_READ_BURST(mtestID,addr2,mtestBurstLength, mtestDataSize, mtestBurstType,
        //     mtestLOCK, mtestCacheType, mtestProtectionType, mtestRegion, mtestQOS, mtestAWUSER, data_rd2, mtestWUSER, resp);
        
        #200ns
        if( (data_wr1 == data_rd1) && (data_wr2 == data_rd2) )
            $display("****** Data match, test succeeded ******");
        else
            $display("****** Data do not match, test failed ******");
        $display("data_rd1:%d", data_rd1);
        $display("data_rd2:%d", data_rd2);
        
        $finish;
        
    end


endmodule
