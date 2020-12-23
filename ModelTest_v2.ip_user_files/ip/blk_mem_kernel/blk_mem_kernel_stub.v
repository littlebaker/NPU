// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Dec 22 21:21:31 2020
// Host        : LITTLEBAKER running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_kernel/blk_mem_kernel_stub.v
// Design      : blk_mem_kernel
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z035ffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module blk_mem_kernel(clka, ena, addra, douta, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[7:0],douta[31:0],clkb,enb,addrb[7:0],doutb[31:0]" */;
  input clka;
  input ena;
  input [7:0]addra;
  output [31:0]douta;
  input clkb;
  input enb;
  input [7:0]addrb;
  output [31:0]doutb;
endmodule
