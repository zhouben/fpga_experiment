//-----------------------------------------------------------------------------
//
// (c) Copyright 2001, 2002, 2003, 2004, 2005, 2007, 2008, 2009 Xilinx, Inc. All rights reserved.
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
// File       : PIO_32_TX_ENGINE.v
// Description: 32 bit LocalLink Transmit Unit.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module PIO_32_TX_ENGINE (
  input                   clk,
  input                   rst_n,

  // AXIS
  input                   s_axis_tx_tready,
  output      [31:0]      s_axis_tx_tdata,
  output  reg [3:0]       s_axis_tx_tkeep,
  output  reg             s_axis_tx_tlast,
  output  reg             s_axis_tx_tvalid,
  output                  tx_src_dsc,

  input                   req_compl_i,
  input                   req_compl_with_data_i,
  output reg              compl_done_o,

  input       [2:0]       req_tc_i,
  input                   req_td_i,
  input                   req_ep_i,
  input       [1:0]       req_attr_i,
  input       [9:0]       req_len_i,
  input       [15:0]      req_rid_i,
  input       [7:0]       req_tag_i,
  input       [7:0]       req_be_i,
  input       [12:0]      req_addr_i,

  output wire [10:0]      rd_addr_o,
  output wire [3:0]       rd_be_o,
  input       [31:0]      rd_data_i,

  input                   up_wr_req_i,
  input       [31:0]      up_wr_host_mem_addr_i,    // in units of byte
  output      [4:0]       up_wr_local_mem_addr_o,   // in units of DWORD
  input       [31:0]      up_wr_data_i,

  input       [15:0]      completer_id_i,
  input                   cfg_bus_mstr_enable_i
  );

  // Clock-to-out delay
  localparam TCQ                    = 1;

  // TLP Header format/type values
  localparam PIO_32_CPLD_FMT_TYPE   = 7'b10_01010;
  localparam PIO_32_CPL_FMT_TYPE    = 7'b00_01010;
  localparam PIO_32_WR32_FMT_TYPE   = 7'b10_00000;

  // State values
  localparam PIO_32_TX_RST_STATE    = 4'd0;
  localparam PIO_32_TX_CPL_CPLD_DW1 = 4'd1;
  localparam PIO_32_TX_CPL_CPLD_DW2 = 4'd2;
  localparam PIO_32_TX_CPLD_DW3     = 4'd3;
  localparam PIO_32_TX_WAIT_STATE   = 4'd4;
  localparam PIO_32_TX_MWR_DW1      = 4'd5;
  localparam PIO_32_TX_MWR_DW2      = 4'd6;
  localparam PIO_32_TX_MWR_ADDR     = 4'd7;
  localparam PIO_32_TX_MWR_DATA     = 4'd8;

  // Local registers
  reg [11:0]          byte_count;
  reg [6:0]           lower_addr;
  reg [3:0]           state;
  reg [3:0]           state_next;
  reg                 cpl_w_data;
  reg                 req_compl_q;
  reg                 req_compl_with_data_q;

  //
  // Unused discontinue signal
  //

  assign tx_src_dsc = 1'b0;

  //
  // Present address and byte enable to memory module
  //
  assign rd_addr_o = req_addr_i[12:2];
  assign rd_be_o   = req_be_i[3:0];

  //
  // Calculate byte count based on byte enable
  //
  always @* begin
    casex (rd_be_o[3:0])
      4'b1xx1 : byte_count = 12'h004;
      4'b01x1 : byte_count = 12'h003;
      4'b1x10 : byte_count = 12'h003;
      4'b0011 : byte_count = 12'h002;
      4'b0110 : byte_count = 12'h002;
      4'b1100 : byte_count = 12'h002;
      4'b0001 : byte_count = 12'h001;
      4'b0010 : byte_count = 12'h001;
      4'b0100 : byte_count = 12'h001;
      4'b1000 : byte_count = 12'h001;
      4'b0000 : byte_count = 12'h001;
    endcase
  end

  //
  // Calculate lower address based on byte enable
  // This assumes that only PIO write responses ask
  // for a completion without data.
  //
  always @* begin
    casex ({req_compl_with_data_i, rd_be_o[3:0]})
      5'b0_xxxx : lower_addr = 8'h0;
      5'bx_0000 : lower_addr = {req_addr_i[6:2], 2'b00};
      5'bx_xxx1 : lower_addr = {req_addr_i[6:2], 2'b00};
      5'bx_xx10 : lower_addr = {req_addr_i[6:2], 2'b01};
      5'bx_x100 : lower_addr = {req_addr_i[6:2], 2'b10};
      5'bx_1000 : lower_addr = {req_addr_i[6:2], 2'b11};
    endcase
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      req_compl_q           <= #TCQ 1'b0;
      req_compl_with_data_q <= #TCQ 1'b1;
    end else begin
      req_compl_q           <= #TCQ req_compl_i;
      req_compl_with_data_q <= #TCQ req_compl_with_data_i;
    end
  end

reg [4:0]   up_wr_count;
reg [4:0]   up_wr_count_next;
reg [31:0]  s_axis_tx_tdata_q;

assign s_axis_tx_tdata = (state == PIO_32_TX_MWR_DATA) ? up_wr_data_i : s_axis_tx_tdata_q;
assign up_wr_local_mem_addr_o = up_wr_count_next;

/**** 3-blocks ***/
always @(posedge clk) begin
    if (!rst_n) begin
        state <= PIO_32_TX_RST_STATE;
    end else begin
        state <= state_next;
    end
end

// output
always @(posedge clk) begin
    if (!rst_n) begin
        s_axis_tx_tlast   <= #TCQ 1'b0;
        s_axis_tx_tvalid  <= #TCQ 1'b0;
        s_axis_tx_tdata_q <= #TCQ 32'h0;
        s_axis_tx_tkeep   <= #TCQ 4'hF;
        compl_done_o      <= #TCQ 1'b0;
        cpl_w_data        <= #TCQ 1'b0;
        up_wr_count       <= #TCQ 'b0;
    end else begin
        s_axis_tx_tlast   <= #TCQ s_axis_tx_tlast ;
        s_axis_tx_tvalid  <= #TCQ s_axis_tx_tvalid;
        s_axis_tx_tdata_q <= #TCQ s_axis_tx_tdata_q;
        s_axis_tx_tkeep   <= #TCQ s_axis_tx_tkeep ;
        compl_done_o      <= #TCQ compl_done_o;
        case (state_next)
            PIO_32_TX_RST_STATE: begin
                s_axis_tx_tlast   <= #TCQ 1'b0;
                s_axis_tx_tvalid  <= #TCQ 1'b0;
                s_axis_tx_tdata_q <= #TCQ 32'h0;
                s_axis_tx_tkeep   <= #TCQ 4'hF;
                compl_done_o      <= #TCQ ((state == PIO_32_TX_WAIT_STATE) || (state == PIO_32_TX_MWR_DATA)) ? 1'b1 : 1'b0;
            end
            PIO_32_TX_CPL_CPLD_DW1: begin
                if (state == PIO_32_TX_RST_STATE) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {1'b0,
                        (req_compl_with_data_q ? PIO_32_CPLD_FMT_TYPE : PIO_32_CPL_FMT_TYPE),
                        {1'b0},
                        req_tc_i,
                        {4'b0},
                        req_td_i,
                        req_ep_i,
                        req_attr_i,
                        {2'b0},
                        req_len_i
                    };
                    cpl_w_data       <= #TCQ req_compl_with_data_q;
                end
            end
            PIO_32_TX_CPL_CPLD_DW2: begin
                if (state == PIO_32_TX_CPL_CPLD_DW1) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {completer_id_i,
                        {3'b0},
                        {1'b0},
                        byte_count
                    };
                end
            end
            PIO_32_TX_CPLD_DW3    : begin
                if (state == PIO_32_TX_CPL_CPLD_DW2) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {req_rid_i,
                        req_tag_i,
                        {1'b0},
                        lower_addr
                    };
                    s_axis_tx_tlast <= #TCQ 1'b0;
                end
            end
            PIO_32_TX_WAIT_STATE  : begin
                case (state)
                    PIO_32_TX_CPL_CPLD_DW2: begin
                        s_axis_tx_tlast  <= #TCQ 1'b1;
                        s_axis_tx_tvalid <= #TCQ 1'b1;
                        s_axis_tx_tdata_q<= #TCQ {req_rid_i,
                            req_tag_i,
                            {1'b0},
                            lower_addr
                        };
                    end
                    PIO_32_TX_CPLD_DW3: begin
                        s_axis_tx_tlast  <= #TCQ 1'b1;
                        s_axis_tx_tvalid <= #TCQ 1'b1;
                        s_axis_tx_tdata_q<= #TCQ rd_data_i;
                    end
                endcase
            end
            PIO_32_TX_MWR_DW1 : begin
                if (state == PIO_32_TX_RST_STATE) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {1'b0,
                        PIO_32_WR32_FMT_TYPE,
                        {1'b0},
                        req_tc_i,
                        {4'b0},
                        req_td_i,
                        req_ep_i,
                        req_attr_i,
                        {2'b0},
                        10'd32
                    };
                end
            end
            PIO_32_TX_MWR_DW2 : begin
                if (state == PIO_32_TX_MWR_DW1) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {completer_id_i, 8'b0, 8'hFF }; // RequestID, Tag, Last/First BE
                end
            end
            PIO_32_TX_MWR_ADDR : begin
                if (state == PIO_32_TX_MWR_DW2) begin
                    s_axis_tx_tlast  <= #TCQ 1'b0;
                    s_axis_tx_tvalid <= #TCQ 1'b1;
                    s_axis_tx_tdata_q<= #TCQ {up_wr_host_mem_addr_i[31:2], 2'b0};
                end
            end
            PIO_32_TX_MWR_DATA : begin
                s_axis_tx_tlast  <= #TCQ (up_wr_count_next == 'd31) ? 1'b1 : 1'b0;
                s_axis_tx_tvalid <= #TCQ 1'b1;
                up_wr_count      <= up_wr_count_next;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        PIO_32_TX_MWR_DATA: begin
            if (s_axis_tx_tready) begin
                up_wr_count_next = up_wr_count + 1;
            end else begin
                up_wr_count_next = up_wr_count;
            end
        end
        default : up_wr_count_next = 0;
    endcase
end

// state transaction
always @(*) begin
    state_next = #TCQ state;
    case (state)
        PIO_32_TX_RST_STATE : begin
            if (req_compl_q) begin
                state_next  = #TCQ PIO_32_TX_CPL_CPLD_DW1;
            end else if (up_wr_req_i) begin
                state_next = #TCQ PIO_32_TX_MWR_DW1;
            end
        end
        PIO_32_TX_CPL_CPLD_DW1 : begin
            if (s_axis_tx_tready) begin
                state_next = #TCQ PIO_32_TX_CPL_CPLD_DW2;
            end
        end
        PIO_32_TX_CPL_CPLD_DW2 : begin
            if (s_axis_tx_tready) begin
                if (cpl_w_data) begin
                    state_next  = #TCQ PIO_32_TX_CPLD_DW3;
                end else
                    state_next  = #TCQ PIO_32_TX_WAIT_STATE;
            end
        end
        PIO_32_TX_CPLD_DW3 : begin
            if (s_axis_tx_tready) begin
                state_next  = #TCQ PIO_32_TX_WAIT_STATE;
            end
        end
        PIO_32_TX_WAIT_STATE : begin
            if (s_axis_tx_tready) begin
                state_next = #TCQ PIO_32_TX_RST_STATE;
            end
        end
        PIO_32_TX_MWR_DW1 : begin
            if (s_axis_tx_tready) begin
                state_next  = #TCQ PIO_32_TX_MWR_DW2;
            end
        end
        PIO_32_TX_MWR_DW2 : begin
            if (s_axis_tx_tready) begin
                state_next  = #TCQ PIO_32_TX_MWR_ADDR;
            end
        end
        PIO_32_TX_MWR_ADDR : begin
            if (s_axis_tx_tready) begin
                state_next  = #TCQ PIO_32_TX_MWR_DATA;
            end
        end
        PIO_32_TX_MWR_DATA : begin
            if (s_axis_tx_tready) begin
                if (up_wr_count == 'd31) begin
                    state_next  = #TCQ PIO_32_TX_RST_STATE;
                end
            end
        end
    endcase
end

//
//  Generate Completion with 1 DW Payload or Completion with
//  no data
//
`ifdef OLD_SINGLE_FSM
always @(posedge clk) begin
  if (!rst_n) begin


    state             <= #TCQ PIO_32_TX_RST_STATE;
  end else begin
    compl_done_o      <= #TCQ 1'b0;

    case (state)
      PIO_32_TX_RST_STATE : begin

        if (req_compl_q && req_compl_with_data_q) begin
          // Begin a CplD TLP
          s_axis_tx_tlast  <= #TCQ 1'b0;
          s_axis_tx_tvalid <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ {1'b0,
                                    PIO_32_CPLD_FMT_TYPE,
                                    {1'b0},
                                    req_tc_i,
                                    {4'b0},
                                    req_td_i,
                                    req_ep_i,
                                    req_attr_i,
                                    {2'b0},
                                    req_len_i
                                    };
          cpl_w_data       <= #TCQ req_compl_with_data_q;
          state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
        end else if (req_compl_q && !req_compl_with_data_q) begin
          // Begin a Cpl TLP
          s_axis_tx_tlast  <= #TCQ 1'b0;
          s_axis_tx_tvalid <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ {1'b0,
                                    PIO_32_CPL_FMT_TYPE,
                                    {1'b0},
                                    req_tc_i,
                                    {4'b0},
                                    req_td_i,
                                    req_ep_i,
                                    req_attr_i,
                                    {2'b0},
                                    req_len_i
                                    };
          cpl_w_data       <= #TCQ req_compl_with_data_q;
          state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
        end else begin
          s_axis_tx_tlast   <= #TCQ 1'b0;
          s_axis_tx_tvalid  <= #TCQ 1'b0;
          s_axis_tx_tdata   <= #TCQ 32'h0;
          s_axis_tx_tkeep   <= #TCQ 4'hF;
          state             <= #TCQ PIO_32_TX_RST_STATE;
        end
      end // PIO_32_TX_RST_STATE

      PIO_32_TX_CPL_CPLD_DW1 : begin
        if (s_axis_tx_tready) begin
          // Output next DW of TLP
          s_axis_tx_tlast  <= #TCQ 1'b0;
          s_axis_tx_tvalid <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ {completer_id_i,
                                    {3'b0},
                                    {1'b0},
                                    byte_count
                                    };
          state            <= #TCQ PIO_32_TX_CPL_CPLD_DW2;
        end else begin
          // Wait for core to accept previous DW
          state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
        end
      end // PIO_32_TX_CPL_CPLD_DW1

      PIO_32_TX_CPL_CPLD_DW2 : begin
        if (s_axis_tx_tready) begin
          // Output next DW of TLP
          s_axis_tx_tlast  <= #TCQ 1'b0;
          s_axis_tx_tvalid <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ {req_rid_i,
                                    req_tag_i,
                                    {1'b0},
                                    lower_addr
                                    };

          if (cpl_w_data) begin
            // For a CplD, there is one more DW
            s_axis_tx_tlast <= #TCQ 1'b0;
            state           <= #TCQ PIO_32_TX_CPLD_DW3;
          end else begin
            // For a Cpl, this is the final DW
            s_axis_tx_tlast <= #TCQ 1'b1;
            state           <= #TCQ PIO_32_TX_WAIT_STATE;
          end
        end else begin
          // Wait for core to accept previous DW
          state            <= #TCQ PIO_32_TX_CPL_CPLD_DW2;
        end
      end // PIO_32_TX_CPL_CPLD_DW2

      PIO_32_TX_CPLD_DW3 : begin
        if (s_axis_tx_tready) begin
          // Output next DW of TLP
          s_axis_tx_tlast  <= #TCQ 1'b1;
          s_axis_tx_tvalid <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ rd_data_i;
          state            <= #TCQ PIO_32_TX_WAIT_STATE;
        end else begin
          // Wait for core to accept previous DW
          state            <= #TCQ PIO_32_TX_CPLD_DW3;
        end
      end // PIO_32_TX_CPLD_DW3

      PIO_32_TX_WAIT_STATE : begin
        if (s_axis_tx_tready) begin
          // Core has accepted final DW of TLP
          s_axis_tx_tlast  <= #TCQ 1'b0;
          s_axis_tx_tvalid <= #TCQ 1'b0;
          compl_done_o     <= #TCQ 1'b1;
          s_axis_tx_tdata  <= #TCQ 32'h0;
          state            <= #TCQ PIO_32_TX_RST_STATE;
        end else begin
          // Wait for core to accept previous DW
          state            <= #TCQ PIO_32_TX_WAIT_STATE;
        end
      end // PIO_32_TX_WAIT_STATE
      default:
        state              <= #TCQ PIO_32_TX_RST_STATE;
    endcase // (state)
  end // rst_n
end
`endif

endmodule // PIO_32_TX_ENGINE

