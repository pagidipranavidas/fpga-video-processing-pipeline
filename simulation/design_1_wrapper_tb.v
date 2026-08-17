`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2026 12:44:49
// Design Name: 
// Module Name: design_1_wrapper_tb
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


module design_1_wrapper_tb();
    // Inputs
    reg clk_100MHz;
    reg reset_rtl_0;
    // Outputs
    wire vid_active_video;
    wire [23:0] vid_data;
    wire vid_hblank;
    wire vid_hsync;
    wire vid_vblank;
    wire vid_vsync;
    // DUT
    design_1_wrapper DUT
    (
        .clk_100MHz(clk_100MHz),
        .reset_rtl_0(reset_rtl_0),

        .vid_active_video(vid_active_video),
        .vid_data(vid_data),
        .vid_hblank(vid_hblank),
        .vid_hsync(vid_hsync),
        .vid_vblank(vid_vblank),
        .vid_vsync(vid_vsync)
    );
    
    // 100 MHz Clock
    initial
    begin
        clk_100MHz = 1'b0;
        forever #5 clk_100MHz = ~clk_100MHz;
    end

    // Reset
    initial
    begin
        reset_rtl_0 = 1'b1;
        // Hold reset for 100 clk edges
         repeat (100) @(posedge clk_100MHz);
        reset_rtl_0 = 1'b0;
    end

    // Simulation Time
    initial
    begin
        // Run simulation for 5 ms
        #150_000_000;
        $display("Simulation Completed");
        $finish;
    end
endmodule
