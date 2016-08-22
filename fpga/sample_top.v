//-----------------------------------------------------------------------------
//
// (c) Copyright 2008, 2009 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Spartan-6 Integrated Block for PCI Express
// File       : sample_top.v
// Description: PCI Express Endpoint example FPGA design
//
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module sample_top #(
    parameter FAST_TRAIN = "FALSE",
    parameter FREQ_DIV   = 10_000_000 - 1
) (
    input     clk_20M,
    input     clk_50M,

    input     sw_0,
    input     sw_1,

    output    led_0,
    output    led_1,
    output    led_2,
    output    led_3
);

wire  clk;
wire  sw_reset;

wire  led_0_n;
wire  led_1_n;
wire  led_2_n;
wire  led_3_n;
reg [23:0] count; //10M
reg [1:0]  led_cnt;

//-------------------------------------------------------
// Clock Input Buffer for differential system clock
//-------------------------------------------------------
IBUFG u1 ( .O( clk), .I( clk_50M ) );

//-------------------------------------------------------
// Output buffers for diagnostic LEDs
//-------------------------------------------------------
OBUF   led_0_obuf (.O(led_0), .I(led_0_n));
OBUF   led_1_obuf (.O(led_1), .I(led_1_n));
OBUF   led_2_obuf (.O(led_2), .I(led_2_n));
OBUF   led_3_obuf (.O(led_3), .I(led_3_n) );

// blink_led blink_led_u1(
//     .clk( user_clk),
//     .rst( user_reset ),
//     .xfer_state( s_axis_tx_last || m_axis_rx_tlast ),
//     .led_en( xferring_flag )
// );
assign sw_reset = sw_0;
assign led_0_n = (led_cnt == 2'd0) ? 1'b0 : 1'b1;
assign led_1_n = (led_cnt == 2'd1) ? 1'b0 : 1'b1;
assign led_2_n = (led_cnt == 2'd2) ? 1'b0 : 1'b1;
assign led_3_n = (led_cnt == 2'd3) ? 1'b0 : 1'b1;

always @(posedge clk) begin
    if (~sw_reset) begin
        led_cnt <= 2'd0;
        count   <= 0;
    end
    else begin
        if (count == FREQ_DIV) begin
            count <= 0;
            led_cnt <= led_cnt + 2'd1;
        end
        else begin
            count <= count + 24'd1;
        end
    end
end
endmodule
