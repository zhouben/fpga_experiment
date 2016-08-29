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
    parameter FREQ_DIV   = 10_000_000 - 1,
    parameter FREQ_DIV_I2C = 250 - 1,
    parameter I2C_ADDRESS = 7'h2F
) (
    //input     clk_20M,
    input     clk_50M,

    input     sw_0,
    //input     sw_1,
    input     scl,
    inout     sda,

    output    sda_shadow,
    output    scl_shadow,

    input     sw_ext_1,
    input     sw_ext_2,
    input     sw_ext_3,
    input     sw_ext_4,

    output    led_ext_1,
    output    led_ext_2,
    output    led_ext_3,
    output    led_ext_4,
    output    led_ext_5,
    output    led_ext_6,
    output    led_ext_7,
    output    led_ext_8,

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

wire slave_write_en;
wire slave_sda_out;
wire slave_sda_oen;
wire slave_scl_out;
wire slave_scl_oen;
wire slave_done;
wire slave_busy;

wire ram_ena;
wire ram_wea;
wire [2:0] ram_addra;
wire [7:0] ram_dina;
wire [7:0] ram_douta;

wire [35:0] CONTROL0;
wire [35:0] CONTROL1;
wire [ 7:0] ASYNC_IN;
wire [ 2:0] ASYNC_OUT;
wire [ 3:0] ila_trig0;
wire [31:0] ila_data;

(* keep="true" *) wire [7:0] slave_reg_addr;
(* keep="true" *) wire [7:0] slave_data_out;

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
OBUF   led_3_obuf (.O(led_3), .I(led_3_n));

PULLUP led_ext_1_inst(led_ext_1);
PULLUP led_ext_2_inst(led_ext_2);
PULLUP led_ext_3_inst(led_ext_3);
PULLUP led_ext_4_inst(led_ext_4);
PULLUP led_ext_5_inst(led_ext_5);
PULLUP led_ext_6_inst(led_ext_6);
PULLUP led_ext_7_inst(led_ext_7);
PULLUP led_ext_8_inst(led_ext_8);

PULLUP pullup_i2c1(sda);

// i2c Slave
i2c_slave #(
    .ADDR_BYTES(1),
    .DATA_BYTES(1)
) i2c_slave (
    .clk        (clk),
    .reset      (sw_reset),

    .open_drain (1'b1),

    .chip_addr  (I2C_ADDRESS),
    .reg_addr   (slave_reg_addr),
    .data_in    (8'hAB),
    .write_en   (slave_write_en),
    .data_out   (slave_data_out),
    .done       (slave_done),
    .busy       (slave_busy),

    .sda_in     (sda),
    .scl_in     (scl),
    .sda_out    (slave_sda_out),
    .sda_oen    (slave_sda_oen),
    .scl_out    (slave_scl_out),
    .scl_oen    (slave_scl_oen)
);

my_icon my_icon_inst (
    .CONTROL0(CONTROL0), // INOUT BUS [35:0]
    .CONTROL1(CONTROL1) // INOUT BUS [35:0]
);
my_vio my_vio_inst (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .ASYNC_IN(ASYNC_IN), // IN BUS [7:0]
    .ASYNC_OUT(ASYNC_OUT) // OUT BUS [2:0]
);
my_ila my_ila_inst (
    .CONTROL(CONTROL1), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .DATA(ila_data), // IN BUS [31:0]
    .TRIG0(ila_trig0) // IN BUS [3:0]
);
my_ram my_ram_inst (
  .clka(clk), // input clka
  .ena(ram_ena), // input ena
  .wea(ram_wea), // input [0 : 0] wea
  .addra(ram_addra), // input [2 : 0] addra
  .dina(ram_dina), // input [7 : 0] dina
  .douta(ram_douta) // output [7 : 0] douta
);

always @(posedge clk) begin
    if (~sw_reset)              count <= 0;
    else if (count == FREQ_DIV) count <= 0;
    else                        count <= count + 24'd1;
end

always @(posedge clk) begin
    if (~sw_reset)              led_cnt <= 0;
    else if (count == FREQ_DIV) led_cnt <= led_cnt + 2'd1;
end

assign sw_reset = sw_0 & ASYNC_OUT[0];
assign led_0_n = (led_cnt == 2'd0) ? 1'b0 : 1'b1;
assign led_1_n = (led_cnt == 2'd1) ? 1'b0 : 1'b1;
assign led_2_n = (led_cnt == 2'd2) ? 1'b0 : 1'b1;
assign led_3_n = (led_cnt == 2'd3) ? 1'b0 : 1'b1;
assign led_ext_1 = (sw_ext_1) ? 1'bz : 1'b0;
assign led_ext_2 = (sw_ext_2) ? 1'bz : 1'b0;
assign led_ext_3 = (sw_ext_3) ? 1'bz : 1'b0;
assign led_ext_4 = (sw_ext_4) ? 1'bz : 1'b0;

assign led_ext_5 = (led_cnt == 2'd3) ? 1'b0 : 1'bz;
assign led_ext_6 = (led_cnt == 2'd2) ? 1'b0 : 1'bz;
//assign led_ext_7 = (led_cnt == 2'd1) ? 1'b0 : 1'bz;
//assign led_ext_8 = (led_cnt == 2'd0) ? 1'b0 : 1'bz;
assign led_ext_7 = (ASYNC_OUT[1]) ? 1'b0 : 1'bz;
assign led_ext_8 = (ASYNC_OUT[2]) ? 1'b0 : 1'bz;

assign ram_ena = slave_busy;
assign ram_wea = slave_write_en;
assign ram_addra = slave_reg_addr;
assign ram_dina  = slave_data_out;

assign sda = (slave_sda_oen) ? 1'bz : slave_sda_out;
assign sda_shadow = sda;
assign scl_shadow = scl;
//assign ila_trig0[0] = sda;
assign ila_trig0[3:0] = count[3:0];
assign ila_data[31  ] = clk;
assign ila_data[30:25] = count[5:0];
assign ila_data[24:8] = {
    scl,
    scl,
    slave_write_en,
    slave_done,
    slave_busy,
    slave_sda_out,
    slave_sda_oen,
    slave_scl_out,
    slave_scl_oen,
    slave_data_out};

assign ila_data[ 7:0] = ram_douta;
assign ASYNC_IN = ram_douta;
endmodule
