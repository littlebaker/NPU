// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Tue Dec 22 13:58:44 2020
// Host        : LITTLEBAKER running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.sim/sim_1/impl/func/xsim/tb_ROM_test_func_impl.v
// Design      : ROM_test
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z035ffg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "c0ddaf55" *) (* POWER_OPT_BRAM_CDC = "0" *) (* POWER_OPT_BRAM_SR_ADDR = "0" *) 
(* POWER_OPT_LOOPED_NET_PERCENTAGE = "0" *) 
(* NotValidForBitStream *)
module ROM_test
   (rt_input_clk,
    rt_input_ena,
    rt_input_addra,
    rt_output_douta,
    rt_input_enb,
    rt_input_addrb,
    rt_output_doutb);
  input rt_input_clk;
  input rt_input_ena;
  input [31:0]rt_input_addra;
  output [31:0]rt_output_douta;
  input rt_input_enb;
  input [31:0]rt_input_addrb;
  output [31:0]rt_output_doutb;

  wire [31:0]rt_input_addra;
  wire [7:0]rt_input_addra_IBUF;
  wire [31:0]rt_input_addrb;
  wire [7:0]rt_input_addrb_IBUF;
  wire rt_input_clk;
  wire rt_input_clk_IBUF;
  wire rt_input_ena;
  wire rt_input_ena_IBUF;
  wire rt_input_enb;
  wire rt_input_enb_IBUF;
  wire [31:0]rt_output_douta;
  wire [31:0]rt_output_douta_OBUF;
  wire [31:0]rt_output_doutb;
  wire [31:0]rt_output_doutb_OBUF;
  wire NLW_u_blk_mem_kernel_clkb_UNCONNECTED;

  IBUF \rt_input_addra_IBUF[0]_inst 
       (.I(rt_input_addra[0]),
        .O(rt_input_addra_IBUF[0]));
  IBUF \rt_input_addra_IBUF[1]_inst 
       (.I(rt_input_addra[1]),
        .O(rt_input_addra_IBUF[1]));
  IBUF \rt_input_addra_IBUF[2]_inst 
       (.I(rt_input_addra[2]),
        .O(rt_input_addra_IBUF[2]));
  IBUF \rt_input_addra_IBUF[3]_inst 
       (.I(rt_input_addra[3]),
        .O(rt_input_addra_IBUF[3]));
  IBUF \rt_input_addra_IBUF[4]_inst 
       (.I(rt_input_addra[4]),
        .O(rt_input_addra_IBUF[4]));
  IBUF \rt_input_addra_IBUF[5]_inst 
       (.I(rt_input_addra[5]),
        .O(rt_input_addra_IBUF[5]));
  IBUF \rt_input_addra_IBUF[6]_inst 
       (.I(rt_input_addra[6]),
        .O(rt_input_addra_IBUF[6]));
  IBUF \rt_input_addra_IBUF[7]_inst 
       (.I(rt_input_addra[7]),
        .O(rt_input_addra_IBUF[7]));
  IBUF \rt_input_addrb_IBUF[0]_inst 
       (.I(rt_input_addrb[0]),
        .O(rt_input_addrb_IBUF[0]));
  IBUF \rt_input_addrb_IBUF[1]_inst 
       (.I(rt_input_addrb[1]),
        .O(rt_input_addrb_IBUF[1]));
  IBUF \rt_input_addrb_IBUF[2]_inst 
       (.I(rt_input_addrb[2]),
        .O(rt_input_addrb_IBUF[2]));
  IBUF \rt_input_addrb_IBUF[3]_inst 
       (.I(rt_input_addrb[3]),
        .O(rt_input_addrb_IBUF[3]));
  IBUF \rt_input_addrb_IBUF[4]_inst 
       (.I(rt_input_addrb[4]),
        .O(rt_input_addrb_IBUF[4]));
  IBUF \rt_input_addrb_IBUF[5]_inst 
       (.I(rt_input_addrb[5]),
        .O(rt_input_addrb_IBUF[5]));
  IBUF \rt_input_addrb_IBUF[6]_inst 
       (.I(rt_input_addrb[6]),
        .O(rt_input_addrb_IBUF[6]));
  IBUF \rt_input_addrb_IBUF[7]_inst 
       (.I(rt_input_addrb[7]),
        .O(rt_input_addrb_IBUF[7]));
  IBUF rt_input_clk_IBUF_inst
       (.I(rt_input_clk),
        .O(rt_input_clk_IBUF));
  IBUF rt_input_ena_IBUF_inst
       (.I(rt_input_ena),
        .O(rt_input_ena_IBUF));
  IBUF rt_input_enb_IBUF_inst
       (.I(rt_input_enb),
        .O(rt_input_enb_IBUF));
  OBUF \rt_output_douta_OBUF[0]_inst 
       (.I(rt_output_douta_OBUF[0]),
        .O(rt_output_douta[0]));
  OBUF \rt_output_douta_OBUF[10]_inst 
       (.I(rt_output_douta_OBUF[10]),
        .O(rt_output_douta[10]));
  OBUF \rt_output_douta_OBUF[11]_inst 
       (.I(rt_output_douta_OBUF[11]),
        .O(rt_output_douta[11]));
  OBUF \rt_output_douta_OBUF[12]_inst 
       (.I(rt_output_douta_OBUF[12]),
        .O(rt_output_douta[12]));
  OBUF \rt_output_douta_OBUF[13]_inst 
       (.I(rt_output_douta_OBUF[13]),
        .O(rt_output_douta[13]));
  OBUF \rt_output_douta_OBUF[14]_inst 
       (.I(rt_output_douta_OBUF[14]),
        .O(rt_output_douta[14]));
  OBUF \rt_output_douta_OBUF[15]_inst 
       (.I(rt_output_douta_OBUF[15]),
        .O(rt_output_douta[15]));
  OBUF \rt_output_douta_OBUF[16]_inst 
       (.I(rt_output_douta_OBUF[16]),
        .O(rt_output_douta[16]));
  OBUF \rt_output_douta_OBUF[17]_inst 
       (.I(rt_output_douta_OBUF[17]),
        .O(rt_output_douta[17]));
  OBUF \rt_output_douta_OBUF[18]_inst 
       (.I(rt_output_douta_OBUF[18]),
        .O(rt_output_douta[18]));
  OBUF \rt_output_douta_OBUF[19]_inst 
       (.I(rt_output_douta_OBUF[19]),
        .O(rt_output_douta[19]));
  OBUF \rt_output_douta_OBUF[1]_inst 
       (.I(rt_output_douta_OBUF[1]),
        .O(rt_output_douta[1]));
  OBUF \rt_output_douta_OBUF[20]_inst 
       (.I(rt_output_douta_OBUF[20]),
        .O(rt_output_douta[20]));
  OBUF \rt_output_douta_OBUF[21]_inst 
       (.I(rt_output_douta_OBUF[21]),
        .O(rt_output_douta[21]));
  OBUF \rt_output_douta_OBUF[22]_inst 
       (.I(rt_output_douta_OBUF[22]),
        .O(rt_output_douta[22]));
  OBUF \rt_output_douta_OBUF[23]_inst 
       (.I(rt_output_douta_OBUF[23]),
        .O(rt_output_douta[23]));
  OBUF \rt_output_douta_OBUF[24]_inst 
       (.I(rt_output_douta_OBUF[24]),
        .O(rt_output_douta[24]));
  OBUF \rt_output_douta_OBUF[25]_inst 
       (.I(rt_output_douta_OBUF[25]),
        .O(rt_output_douta[25]));
  OBUF \rt_output_douta_OBUF[26]_inst 
       (.I(rt_output_douta_OBUF[26]),
        .O(rt_output_douta[26]));
  OBUF \rt_output_douta_OBUF[27]_inst 
       (.I(rt_output_douta_OBUF[27]),
        .O(rt_output_douta[27]));
  OBUF \rt_output_douta_OBUF[28]_inst 
       (.I(rt_output_douta_OBUF[28]),
        .O(rt_output_douta[28]));
  OBUF \rt_output_douta_OBUF[29]_inst 
       (.I(rt_output_douta_OBUF[29]),
        .O(rt_output_douta[29]));
  OBUF \rt_output_douta_OBUF[2]_inst 
       (.I(rt_output_douta_OBUF[2]),
        .O(rt_output_douta[2]));
  OBUF \rt_output_douta_OBUF[30]_inst 
       (.I(rt_output_douta_OBUF[30]),
        .O(rt_output_douta[30]));
  OBUF \rt_output_douta_OBUF[31]_inst 
       (.I(rt_output_douta_OBUF[31]),
        .O(rt_output_douta[31]));
  OBUF \rt_output_douta_OBUF[3]_inst 
       (.I(rt_output_douta_OBUF[3]),
        .O(rt_output_douta[3]));
  OBUF \rt_output_douta_OBUF[4]_inst 
       (.I(rt_output_douta_OBUF[4]),
        .O(rt_output_douta[4]));
  OBUF \rt_output_douta_OBUF[5]_inst 
       (.I(rt_output_douta_OBUF[5]),
        .O(rt_output_douta[5]));
  OBUF \rt_output_douta_OBUF[6]_inst 
       (.I(rt_output_douta_OBUF[6]),
        .O(rt_output_douta[6]));
  OBUF \rt_output_douta_OBUF[7]_inst 
       (.I(rt_output_douta_OBUF[7]),
        .O(rt_output_douta[7]));
  OBUF \rt_output_douta_OBUF[8]_inst 
       (.I(rt_output_douta_OBUF[8]),
        .O(rt_output_douta[8]));
  OBUF \rt_output_douta_OBUF[9]_inst 
       (.I(rt_output_douta_OBUF[9]),
        .O(rt_output_douta[9]));
  OBUF \rt_output_doutb_OBUF[0]_inst 
       (.I(rt_output_doutb_OBUF[0]),
        .O(rt_output_doutb[0]));
  OBUF \rt_output_doutb_OBUF[10]_inst 
       (.I(rt_output_doutb_OBUF[10]),
        .O(rt_output_doutb[10]));
  OBUF \rt_output_doutb_OBUF[11]_inst 
       (.I(rt_output_doutb_OBUF[11]),
        .O(rt_output_doutb[11]));
  OBUF \rt_output_doutb_OBUF[12]_inst 
       (.I(rt_output_doutb_OBUF[12]),
        .O(rt_output_doutb[12]));
  OBUF \rt_output_doutb_OBUF[13]_inst 
       (.I(rt_output_doutb_OBUF[13]),
        .O(rt_output_doutb[13]));
  OBUF \rt_output_doutb_OBUF[14]_inst 
       (.I(rt_output_doutb_OBUF[14]),
        .O(rt_output_doutb[14]));
  OBUF \rt_output_doutb_OBUF[15]_inst 
       (.I(rt_output_doutb_OBUF[15]),
        .O(rt_output_doutb[15]));
  OBUF \rt_output_doutb_OBUF[16]_inst 
       (.I(rt_output_doutb_OBUF[16]),
        .O(rt_output_doutb[16]));
  OBUF \rt_output_doutb_OBUF[17]_inst 
       (.I(rt_output_doutb_OBUF[17]),
        .O(rt_output_doutb[17]));
  OBUF \rt_output_doutb_OBUF[18]_inst 
       (.I(rt_output_doutb_OBUF[18]),
        .O(rt_output_doutb[18]));
  OBUF \rt_output_doutb_OBUF[19]_inst 
       (.I(rt_output_doutb_OBUF[19]),
        .O(rt_output_doutb[19]));
  OBUF \rt_output_doutb_OBUF[1]_inst 
       (.I(rt_output_doutb_OBUF[1]),
        .O(rt_output_doutb[1]));
  OBUF \rt_output_doutb_OBUF[20]_inst 
       (.I(rt_output_doutb_OBUF[20]),
        .O(rt_output_doutb[20]));
  OBUF \rt_output_doutb_OBUF[21]_inst 
       (.I(rt_output_doutb_OBUF[21]),
        .O(rt_output_doutb[21]));
  OBUF \rt_output_doutb_OBUF[22]_inst 
       (.I(rt_output_doutb_OBUF[22]),
        .O(rt_output_doutb[22]));
  OBUF \rt_output_doutb_OBUF[23]_inst 
       (.I(rt_output_doutb_OBUF[23]),
        .O(rt_output_doutb[23]));
  OBUF \rt_output_doutb_OBUF[24]_inst 
       (.I(rt_output_doutb_OBUF[24]),
        .O(rt_output_doutb[24]));
  OBUF \rt_output_doutb_OBUF[25]_inst 
       (.I(rt_output_doutb_OBUF[25]),
        .O(rt_output_doutb[25]));
  OBUF \rt_output_doutb_OBUF[26]_inst 
       (.I(rt_output_doutb_OBUF[26]),
        .O(rt_output_doutb[26]));
  OBUF \rt_output_doutb_OBUF[27]_inst 
       (.I(rt_output_doutb_OBUF[27]),
        .O(rt_output_doutb[27]));
  OBUF \rt_output_doutb_OBUF[28]_inst 
       (.I(rt_output_doutb_OBUF[28]),
        .O(rt_output_doutb[28]));
  OBUF \rt_output_doutb_OBUF[29]_inst 
       (.I(rt_output_doutb_OBUF[29]),
        .O(rt_output_doutb[29]));
  OBUF \rt_output_doutb_OBUF[2]_inst 
       (.I(rt_output_doutb_OBUF[2]),
        .O(rt_output_doutb[2]));
  OBUF \rt_output_doutb_OBUF[30]_inst 
       (.I(rt_output_doutb_OBUF[30]),
        .O(rt_output_doutb[30]));
  OBUF \rt_output_doutb_OBUF[31]_inst 
       (.I(rt_output_doutb_OBUF[31]),
        .O(rt_output_doutb[31]));
  OBUF \rt_output_doutb_OBUF[3]_inst 
       (.I(rt_output_doutb_OBUF[3]),
        .O(rt_output_doutb[3]));
  OBUF \rt_output_doutb_OBUF[4]_inst 
       (.I(rt_output_doutb_OBUF[4]),
        .O(rt_output_doutb[4]));
  OBUF \rt_output_doutb_OBUF[5]_inst 
       (.I(rt_output_doutb_OBUF[5]),
        .O(rt_output_doutb[5]));
  OBUF \rt_output_doutb_OBUF[6]_inst 
       (.I(rt_output_doutb_OBUF[6]),
        .O(rt_output_doutb[6]));
  OBUF \rt_output_doutb_OBUF[7]_inst 
       (.I(rt_output_doutb_OBUF[7]),
        .O(rt_output_doutb[7]));
  OBUF \rt_output_doutb_OBUF[8]_inst 
       (.I(rt_output_doutb_OBUF[8]),
        .O(rt_output_doutb[8]));
  OBUF \rt_output_doutb_OBUF[9]_inst 
       (.I(rt_output_doutb_OBUF[9]),
        .O(rt_output_doutb[9]));
  (* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *) 
  blk_mem_kernel u_blk_mem_kernel
       (.addra(rt_input_addra_IBUF),
        .addrb(rt_input_addrb_IBUF),
        .clka(rt_input_clk_IBUF),
        .clkb(NLW_u_blk_mem_kernel_clkb_UNCONNECTED),
        .douta(rt_output_douta_OBUF),
        .doutb(rt_output_doutb_OBUF),
        .ena(rt_input_ena_IBUF),
        .enb(rt_input_enb_IBUF));
endmodule

(* CHECK_LICENSE_TYPE = "blk_mem_kernel,blk_mem_gen_v8_4_1,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *) 
module blk_mem_kernel
   (clka,
    ena,
    addra,
    douta,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_WRITE_MODE READ_WRITE" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_WRITE_MODE READ_WRITE" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire NLW_U0_clkb_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_deepsleep_UNCONNECTED;
  wire NLW_U0_eccpipece_UNCONNECTED;
  wire NLW_U0_injectdbiterr_UNCONNECTED;
  wire NLW_U0_injectsbiterr_UNCONNECTED;
  wire NLW_U0_regcea_UNCONNECTED;
  wire NLW_U0_regceb_UNCONNECTED;
  wire NLW_U0_rsta_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_aclk_UNCONNECTED;
  wire NLW_U0_s_aresetn_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_arvalid_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_awvalid_UNCONNECTED;
  wire NLW_U0_s_axi_bready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_injectdbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_injectsbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rready_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wlast_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axi_wvalid_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_shutdown_UNCONNECTED;
  wire NLW_U0_sleep_UNCONNECTED;
  wire [31:0]NLW_U0_dina_UNCONNECTED;
  wire [31:0]NLW_U0_dinb_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_arlen_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_arsize_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_awlen_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_awsize_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_wea_UNCONNECTED;
  wire [0:0]NLW_U0_web_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.244 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_kernel.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_kernel.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "4" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  blk_mem_kernel_blk_mem_gen_v8_4_1 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(NLW_U0_clkb_UNCONNECTED),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(NLW_U0_deepsleep_UNCONNECTED),
        .dina(NLW_U0_dina_UNCONNECTED[31:0]),
        .dinb(NLW_U0_dinb_UNCONNECTED[31:0]),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(NLW_U0_eccpipece_UNCONNECTED),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(NLW_U0_injectdbiterr_UNCONNECTED),
        .injectsbiterr(NLW_U0_injectsbiterr_UNCONNECTED),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(NLW_U0_regcea_UNCONNECTED),
        .regceb(NLW_U0_regceb_UNCONNECTED),
        .rsta(NLW_U0_rsta_UNCONNECTED),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(NLW_U0_rstb_UNCONNECTED),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(NLW_U0_s_aclk_UNCONNECTED),
        .s_aresetn(NLW_U0_s_aresetn_UNCONNECTED),
        .s_axi_araddr(NLW_U0_s_axi_araddr_UNCONNECTED[31:0]),
        .s_axi_arburst(NLW_U0_s_axi_arburst_UNCONNECTED[1:0]),
        .s_axi_arid(NLW_U0_s_axi_arid_UNCONNECTED[3:0]),
        .s_axi_arlen(NLW_U0_s_axi_arlen_UNCONNECTED[7:0]),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize(NLW_U0_s_axi_arsize_UNCONNECTED[2:0]),
        .s_axi_arvalid(NLW_U0_s_axi_arvalid_UNCONNECTED),
        .s_axi_awaddr(NLW_U0_s_axi_awaddr_UNCONNECTED[31:0]),
        .s_axi_awburst(NLW_U0_s_axi_awburst_UNCONNECTED[1:0]),
        .s_axi_awid(NLW_U0_s_axi_awid_UNCONNECTED[3:0]),
        .s_axi_awlen(NLW_U0_s_axi_awlen_UNCONNECTED[7:0]),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize(NLW_U0_s_axi_awsize_UNCONNECTED[2:0]),
        .s_axi_awvalid(NLW_U0_s_axi_awvalid_UNCONNECTED),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(NLW_U0_s_axi_bready_UNCONNECTED),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(NLW_U0_s_axi_injectdbiterr_UNCONNECTED),
        .s_axi_injectsbiterr(NLW_U0_s_axi_injectsbiterr_UNCONNECTED),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(NLW_U0_s_axi_rready_UNCONNECTED),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata(NLW_U0_s_axi_wdata_UNCONNECTED[31:0]),
        .s_axi_wlast(NLW_U0_s_axi_wlast_UNCONNECTED),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(NLW_U0_s_axi_wstrb_UNCONNECTED[0]),
        .s_axi_wvalid(NLW_U0_s_axi_wvalid_UNCONNECTED),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(NLW_U0_shutdown_UNCONNECTED),
        .sleep(NLW_U0_sleep_UNCONNECTED),
        .wea(NLW_U0_wea_UNCONNECTED[0]),
        .web(NLW_U0_web_UNCONNECTED[0]));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module blk_mem_kernel_blk_mem_gen_generic_cstr
   (douta,
    doutb,
    clka,
    ena,
    enb,
    addra,
    addrb);
  output [31:0]douta;
  output [31:0]doutb;
  input clka;
  input ena;
  input enb;
  input [7:0]addra;
  input [7:0]addrb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;

  blk_mem_kernel_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .douta(douta),
        .doutb(doutb),
        .ena(ena),
        .enb(enb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_mem_kernel_blk_mem_gen_prim_width
   (douta,
    doutb,
    clka,
    ena,
    enb,
    addra,
    addrb);
  output [31:0]douta;
  output [31:0]doutb;
  input clka;
  input ena;
  input enb;
  input [7:0]addra;
  input [7:0]addrb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;

  blk_mem_kernel_blk_mem_gen_prim_wrapper_init \prim_init.ram 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .douta(douta),
        .doutb(doutb),
        .ena(ena),
        .enb(enb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module blk_mem_kernel_blk_mem_gen_prim_wrapper_init
   (douta,
    doutb,
    clka,
    ena,
    enb,
    addra,
    addrb);
  output [31:0]douta;
  output [31:0]doutb;
  input clka;
  input ena;
  input enb;
  input [7:0]addra;
  input [7:0]addrb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h101FF4F51D000000111F12311D190300E0DDDF12E5F10C030610FAFB0907EBF3),
    .INIT_01(256'hFEF600E90404F9EBFA000000EE090EF8F30CF7F31E0C03F3F9F0E0F7FAFA1B00),
    .INIT_02(256'hDDEA0B2DEBF62F1F151C0A0328000000C7E0152BFB192C29151B20EDDEF20E14),
    .INIT_03(256'hFF2E35E2F312CCEAD5FDE1E12F29FBDFE20000000A2D04DA2911EAD30AF1D513),
    .INIT_04(256'h2B19FDE1011C2A140E3F0716DB0C1CF1FE05F5D9CA0000002413F6E90724170A),
    .INIT_05(256'h2B1D30291113F7F9C5CCE121EFFEFCE223DDECD1E9F8152CD3000000FD21FAE4),
    .INIT_06(256'hFB000000E8C8D9D809DEF0E906FD261616232317FC1519180F0A042407000000),
    .INIT_07(256'h08EEFCF5E1000000031C0BFD050114E304FE000EFE040805ED17020D0B1BF5E9),
    .INIT_08(256'hF3F8F31AF60217F8F8000000CBDFC9D905F8FC1E0D1726FF2E1E0719F3121B1B),
    .INIT_09(256'h140B17FC0802ECEEEF0AEEFA07000000E5E4E109F5FF1B1718221CF10503F70D),
    .INIT_0A(256'h100508201407F40510E0FD11EFF5EF06FB000000ED0EF80F07070701080208F2),
    .INIT_0B(256'h151C16E9311CF70327EA0B25FDDF023A0015181E1A0000001109F30BFFFC120A),
    .INIT_0C(256'hE7F5D9DAFFDAE302F5293108121EF2E902130418FF180813F0000000FE1628FB),
    .INIT_0D(256'h07000000CEA8A3C3DDC6AAAA2A0921FB4D484B4343282D29C6FF0835E4000000),
    .INIT_0E(256'hEFFCF2F71E000000C9BBD7EAD7EB0528202714CA1A21F8F922172A272A1E0F26),
    .INIT_0F(256'hF81A171C111B2F21EF00000012F70702EDFC0DEEF108EEEE00F2F90407F30811),
    .INIT_10(256'h02064040F103F1EAE5C4D1C8170000000B130607FED8DBFEF7CAED18E7DC0002),
    .INIT_11(256'h0B031D0A14280A2534F71113CB09122712000000E0DF001F0F1B021035150A04),
    .INIT_12(256'hFBE9F815DDEC0EFFDBEB1B03EF2426EAF9270AFDEF000000F7DEE4CD0300FCF6),
    .INIT_13(256'h3428FDF51B0E1300151FF8310C0BE4F9FEE0DEE9E3D2F1DD1E0000000AE8FBFF),
    .INIT_14(256'h22000000E4E82341CFF44A2FFE3044C80C37CFE22CD9C9DB01E6D9FFFB000000),
    .INIT_15(256'hF22005E9F6000000F72609F4220113031C071118F8FE1105EC041701E6E4E50A),
    .INIT_16(256'hCAFC2433160C1EEAF700000010F80CE70905FCEEEAED09FDF7070900FD161101),
    .INIT_17(256'h0B1010FAF522F402120A15121A000000E90104180013111F2405101C02020510),
    .INIT_18(256'hEDF223FAF81AFDF4F4FEFF0DF905E9FD0C000000E410F004F80B1E06EF1C0D03),
    .INIT_19(256'h220FD8ECFEECD518EDD82D29E6123707122C0709FB0000000FF0FBF5FD020D19),
    .INIT_1A(256'h03F51910041F0104042306F31100FB100CF5FC20E0021A1BE50000002424EDE0),
    .INIT_1B(256'h01000000F5ECECFD05130900F60A080206F4FB00E4EE1509F31AF61006000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(36),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(36),
    .WRITE_WIDTH_B(36)) 
    \DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,addra,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,addrb,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(douta),
        .DOBDO(doutb),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena),
        .ENBWREN(enb),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module blk_mem_kernel_blk_mem_gen_top
   (douta,
    doutb,
    clka,
    ena,
    enb,
    addra,
    addrb);
  output [31:0]douta;
  output [31:0]doutb;
  input clka;
  input ena;
  input enb;
  input [7:0]addra;
  input [7:0]addrb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;

  blk_mem_kernel_blk_mem_gen_generic_cstr \valid.cstr 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .douta(douta),
        .doutb(doutb),
        .ena(ena),
        .enb(enb));
endmodule

(* C_ADDRA_WIDTH = "8" *) (* C_ADDRB_WIDTH = "8" *) (* C_ALGORITHM = "1" *) 
(* C_AXI_ID_WIDTH = "4" *) (* C_AXI_SLAVE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_BYTE_SIZE = "9" *) (* C_COMMON_CLK = "1" *) (* C_COUNT_18K_BRAM = "0" *) 
(* C_COUNT_36K_BRAM = "1" *) (* C_CTRL_ECC_ALGO = "NONE" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DISABLE_WARN_BHV_COLL = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_ELABORATION_DIR = "./" *) 
(* C_ENABLE_32BIT_ADDRESS = "0" *) (* C_EN_DEEPSLEEP_PIN = "0" *) (* C_EN_ECC_PIPE = "0" *) 
(* C_EN_RDADDRA_CHG = "0" *) (* C_EN_RDADDRB_CHG = "0" *) (* C_EN_SAFETY_CKT = "0" *) 
(* C_EN_SHUTDOWN_PIN = "0" *) (* C_EN_SLEEP_PIN = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.244 mW" *) 
(* C_FAMILY = "zynq" *) (* C_HAS_AXI_ID = "0" *) (* C_HAS_ENA = "1" *) 
(* C_HAS_ENB = "1" *) (* C_HAS_INJECTERR = "0" *) (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
(* C_HAS_MEM_OUTPUT_REGS_B = "0" *) (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
(* C_HAS_REGCEA = "0" *) (* C_HAS_REGCEB = "0" *) (* C_HAS_RSTA = "0" *) 
(* C_HAS_RSTB = "0" *) (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
(* C_INITA_VAL = "0" *) (* C_INITB_VAL = "0" *) (* C_INIT_FILE = "blk_mem_kernel.mem" *) 
(* C_INIT_FILE_NAME = "blk_mem_kernel.mif" *) (* C_INTERFACE_TYPE = "0" *) (* C_LOAD_INIT_FILE = "1" *) 
(* C_MEM_TYPE = "4" *) (* C_MUX_PIPELINE_STAGES = "0" *) (* C_PRIM_TYPE = "1" *) 
(* C_READ_DEPTH_A = "256" *) (* C_READ_DEPTH_B = "256" *) (* C_READ_WIDTH_A = "32" *) 
(* C_READ_WIDTH_B = "32" *) (* C_RSTRAM_A = "0" *) (* C_RSTRAM_B = "0" *) 
(* C_RST_PRIORITY_A = "CE" *) (* C_RST_PRIORITY_B = "CE" *) (* C_SIM_COLLISION_CHECK = "ALL" *) 
(* C_USE_BRAM_BLOCK = "0" *) (* C_USE_BYTE_WEA = "0" *) (* C_USE_BYTE_WEB = "0" *) 
(* C_USE_DEFAULT_DATA = "0" *) (* C_USE_ECC = "0" *) (* C_USE_SOFTECC = "0" *) 
(* C_USE_URAM = "0" *) (* C_WEA_WIDTH = "1" *) (* C_WEB_WIDTH = "1" *) 
(* C_WRITE_DEPTH_A = "256" *) (* C_WRITE_DEPTH_B = "256" *) (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
(* C_WRITE_MODE_B = "WRITE_FIRST" *) (* C_WRITE_WIDTH_A = "32" *) (* C_WRITE_WIDTH_B = "32" *) 
(* C_XDEVICEFAMILY = "zynq" *) (* ORIG_REF_NAME = "blk_mem_gen_v8_4_1" *) (* downgradeipidentifiedwarnings = "yes" *) 
module blk_mem_kernel_blk_mem_gen_v8_4_1
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    deepsleep,
    shutdown,
    rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [0:0]wea;
  input [7:0]addra;
  input [31:0]dina;
  output [31:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [0:0]web;
  input [7:0]addrb;
  input [31:0]dinb;
  output [31:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [7:0]rdaddrecc;
  input sleep;
  input deepsleep;
  input shutdown;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input s_aresetn;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [7:0]s_axi_rdaddrecc;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;

  blk_mem_kernel_blk_mem_gen_v8_4_1_synth inst_blk_mem_gen
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .douta(douta),
        .doutb(doutb),
        .ena(ena),
        .enb(enb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_4_1_synth" *) 
module blk_mem_kernel_blk_mem_gen_v8_4_1_synth
   (douta,
    doutb,
    clka,
    ena,
    enb,
    addra,
    addrb);
  output [31:0]douta;
  output [31:0]doutb;
  input clka;
  input ena;
  input enb;
  input [7:0]addra;
  input [7:0]addrb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;

  blk_mem_kernel_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .douta(douta),
        .doutb(doutb),
        .ena(ena),
        .enb(enb));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
