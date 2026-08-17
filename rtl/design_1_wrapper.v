//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Mon Aug  3 10:56:26 2026
//Host        : ThillaiRajan running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_100MHz,
    reset_rtl_0,
    vid_active_video,
    vid_data,
    vid_hblank,
    vid_hsync,
    vid_vblank,
    vid_vsync);
  input clk_100MHz;
  input reset_rtl_0;
  output vid_active_video;
  output [23:0]vid_data;
  output vid_hblank;
  output vid_hsync;
  output vid_vblank;
  output vid_vsync;

  wire clk_100MHz;
  wire reset_rtl_0;
  wire vid_active_video;
  wire [23:0]vid_data;
  wire vid_hblank;
  wire vid_hsync;
  wire vid_vblank;
  wire vid_vsync;

  design_1 design_1_i
       (.clk_100MHz(clk_100MHz),
        .reset_rtl_0(reset_rtl_0),
        .vid_active_video(vid_active_video),
        .vid_data(vid_data),
        .vid_hblank(vid_hblank),
        .vid_hsync(vid_hsync),
        .vid_vblank(vid_vblank),
        .vid_vsync(vid_vsync));
endmodule
