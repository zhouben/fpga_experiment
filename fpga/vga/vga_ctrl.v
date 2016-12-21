`timescale 1ns / 1ps
module vga_ctrl#
(
    parameter DISPLAY_RESOLUTION = 1024*768,
    parameter FRAME_SYNC_CYCLE = 4  // frame_sync is active by this cycle number once new frame arrives.
)
(
    input               clk         ,
    input               rst_n       ,
    input [15:0]        din         ,
    output reg          frame_sync  ,
    output              data_lock   ,   // 1: this module is reading data for display.
    output reg          data_req    ,
    output reg          vga_hsync   ,
    output reg          vga_vsync   ,
    output     [4:0]    vga_red     ,
    output     [5:0]    vga_green   ,
    output     [4:0]    vga_blue
);

// configuration for 1024 * 768
parameter line_period   = 1344;
parameter hsync_pulse   =  136;
parameter h_back_porch  =  160;
parameter h_active_pix  = 1024;
parameter h_front_porch =   24;
parameter frame_period  =  806;  // how many line in one frame
parameter vsync_pulse   =    6;
parameter v_back_porch  =   29;
parameter v_active_pix  =  768;
parameter v_front_porch =    3;


parameter h_start       = hsync_pulse + h_back_porch;
parameter h_end         = line_period - h_front_porch;
parameter v_start       = vsync_pulse + v_back_porch;
parameter v_end         = frame_period - v_front_porch;

`define LINE_END    (x_cnt == (line_period - 1))
`define FRAME_END   (y_cnt == (frame_period - 1))
`define LINE_START  (x_cnt_next == 11'd0)
`define X_PULSE_END (x_cnt_next == hsync_pulse)
`define FRAME_START (y_cnt_next == 10'd0)
`define Y_PULSE_END (y_cnt_next == vsync_pulse)
`define FRAME_SYNC_COND ((y_cnt_next == 0) && (x_cnt_next < FRAME_SYNC_CYCLE))

`define Y_ACTIVE  ((y_cnt_next >= v_start) && (y_cnt_next < v_end))
`define X_ACTIVE  ((x_cnt >= h_start) && (x_cnt < h_end))
`define X_ACTIVE_PRE  ((x_cnt_next + 1 >= h_start) && (x_cnt_next + 1 < h_end))

reg [10:0] x_cnt_next;
reg [ 9:0] y_cnt_next;
reg [10:0] x_cnt;
reg [ 9:0] y_cnt;
reg [15:0] pixel;

assign data_lock = ((y_cnt > v_start - 1) && (y_cnt < v_end)) ? 1'b1 : 1'b0;

// new frame sync signal, duratte by FRAME_SYNC_CYCLE
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        frame_sync <= 1'b0;
    end else if `FRAME_SYNC_COND begin
        frame_sync <= 1'b1;
    end else begin
        frame_sync <= 1'b0;
    end
end

always @(*) begin
    if (`LINE_END) x_cnt_next   <= 11'd0;
    else    x_cnt_next   <= x_cnt + 11'd1;
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        x_cnt <= 11'd0;
    end else begin
        x_cnt <= x_cnt_next;
    end
end

always @(*) begin
    if (`LINE_END) begin
        if (`FRAME_END)  y_cnt_next <= 10'd0;
        else             y_cnt_next <= y_cnt + 10'd1;
    end else y_cnt_next <= y_cnt;
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        y_cnt <= 10'd0;
    end else begin
        y_cnt <= y_cnt_next;
    end
end

// horizonal sync signal
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        vga_hsync   <= 1'b1;
    end else begin
        if `LINE_START begin
            vga_hsync <= 1'b0;
        end else if `X_PULSE_END begin
            vga_hsync <= 1'b1;
        end else vga_hsync <= vga_hsync;
    end
end

// vertical sync signal
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        vga_vsync   <= 1'b1;
    end else begin
        if (`LINE_START && `FRAME_START) vga_vsync <= 1'b0;
        else if (`LINE_START && `Y_PULSE_END) vga_vsync <= 1'b1;
        else vga_vsync <= vga_vsync;
    end
end

// data_req, for external din
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) data_req <= 1'b0;
    else if (`X_ACTIVE_PRE && `Y_ACTIVE) data_req <= 1'b1;
    else data_req <= 1'b0;
end

assign {vga_blue, vga_green, vga_red} =
    (`X_ACTIVE && `Y_ACTIVE) ? din : 16'd0;
/* RGB signals */
/*
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        vga_red   <= 5'd0;
        vga_green <= 6'd0;
        vga_blue  <= 5'd0;
    end else begin
        if (data_req) begin
            vga_red   <= din[ 4: 0];
            vga_green <= din[10: 5];
            vga_blue  <= din[15:11];
        end else begin
            vga_red   <= 5'b0;
            vga_green <= 6'b0;
            vga_blue  <= 5'b0;
        end
    end
end
*/

/*
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
    end else begin
    end
end
*/

endmodule
