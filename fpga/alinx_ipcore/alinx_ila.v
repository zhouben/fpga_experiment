///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.7
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : alinx_ila.v
// /___/   /\     Timestamp  : Mon Oct 24 22:19:08 中国标准时间 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module alinx_ila(
    CONTROL,
    CLK,
    TRIG0,
    TRIG1,
    TRIG2,
    TRIG3,
    TRIG4) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [31 : 0] TRIG0;
input [31 : 0] TRIG1;
input [31 : 0] TRIG2;
input [31 : 0] TRIG3;
input [31 : 0] TRIG4;

endmodule
