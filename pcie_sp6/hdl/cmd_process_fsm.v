`timescale 1ns/1ns

module CMD_PROCESS_FSM(
    input               clk                        ,    // input clk
    input               rst_n                      ,    // input rst
    output reg          up_wr_cmd_compl_o          ,
    output              us_cmd_fifo_rd_en_o        ,
    output [1:0]        cmd_id_o                   ,
    input [127:0]       us_cmd_fifo_dout_i         ,
    input               us_cmd_fifo_empty          ,
    output reg          req_compl_o                , // to TX engine
    output reg          req_compl_with_data_o      ,
    input               txe_compl_done_i           ,
    output reg          up_wr_req_o                ,    // TODO, reg output is better.
    output reg [31:0]   up_wr_host_mem_addr_o      ,
    output     [4:0]    up_wr_local_mem_addr_o     , // high bits local memory addr [9~5]
    output reg [2:0]    req_tc_o                   ,
    output reg          req_td_o                   ,
    output reg          req_ep_o                   ,
    output reg [1:0]    req_attr_o                 ,
    output reg [9:0]    req_len_o                  ,
    output reg [15:0]   req_rid_o                  ,
    output reg [7:0]    req_tag_o                  ,
    output reg [7:0]    req_be_o                   ,
    output reg [12:0]   req_addr_o                 
);

localparam STATE_IDLE               = 3'd0;
localparam STATE_FETCH_CMD          = 3'd1;
localparam STATE_ISSUE_TX_REQ       = 3'd2;
localparam STATE_WAIT_TX_CPL_DONE   = 3'd3;
localparam STATE_WAIT_TX_UP_WR_DONE = 3'd4;
reg [2:0] state;
reg [2:0] state_next;

wire [1:0] cmd_type;
reg  [4:0] len;
reg  [1:0] cmd_id;

`include "param.v"

assign cmd_type = us_cmd_fifo_dout_i[63:62];
assign up_wr_local_mem_addr_o = 'b0;
assign cmd_id_o = cmd_id;

always @(posedge clk) begin
    if (~rst_n) begin
        up_wr_cmd_compl_o <= 0;
    end else if ((state == STATE_WAIT_TX_UP_WR_DONE) && (state_next == STATE_IDLE)) begin
        up_wr_cmd_compl_o <= 1;
    end else begin
        up_wr_cmd_compl_o <= 0;
    end
end

assign us_cmd_fifo_rd_en_o = ((state == STATE_IDLE) && (~us_cmd_fifo_empty)) ? 1 : 0;

always @(posedge clk) begin
    if (!rst_n) begin
        req_compl_with_data_o <= 0;
    end else if ((state_next == STATE_ISSUE_TX_REQ) && (cmd_type == `US_CMD_CPLD_TYPE)) begin
        req_compl_with_data_o <= 1;
    end else begin
        req_compl_with_data_o <= 0;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        req_compl_o <= 0;
    end else if ((state_next == STATE_ISSUE_TX_REQ) && ((cmd_type == `US_CMD_CPL_TYPE) || (cmd_type == `US_CMD_CPLD_TYPE))) begin
        req_compl_o <= 1;
    end else begin
        req_compl_o <= 0;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        up_wr_req_o <= 0;
    end else if ((state_next == STATE_ISSUE_TX_REQ) && (cmd_type == `US_CMD_WR32_TYPE)) begin
        up_wr_req_o <= 1;
    end else begin
        up_wr_req_o <= 0;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        req_tc_o  <= 0;
        req_td_o  <= 0;
        req_ep_o  <= 0;
        req_attr_o<= 0;
        req_len_o <= 0;
        req_rid_o <= 0;
        req_tag_o <= 0;
        req_be_o  <= 0;
        req_addr_o<= 0;
        len       <= 0;
        cmd_id    <= 0;
        up_wr_host_mem_addr_o <= 'b0;
    end else if(state_next == STATE_ISSUE_TX_REQ)begin
        len       <= us_cmd_fifo_dout_i[61:57];
        cmd_id    <= us_cmd_fifo_dout_i[56:55];
        req_tc_o  <= us_cmd_fifo_dout_i[54:52];
        req_td_o  <= us_cmd_fifo_dout_i[51];
        req_ep_o  <= us_cmd_fifo_dout_i[50];
        req_attr_o<= us_cmd_fifo_dout_i[49:48];
        req_len_o <= us_cmd_fifo_dout_i[47:38];
        req_rid_o <= us_cmd_fifo_dout_i[37:22];
        req_tag_o <= us_cmd_fifo_dout_i[21:14];
        req_be_o  <= us_cmd_fifo_dout_i[13:6];
        req_addr_o<= us_cmd_fifo_dout_i[5:0];
        up_wr_host_mem_addr_o <= us_cmd_fifo_dout_i[31:0];
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        state <= STATE_IDLE;
    end else begin
        state <= state_next;
    end
end

always @(*) begin
    case (state)
        STATE_IDLE              : state_next = (~us_cmd_fifo_empty) ? STATE_FETCH_CMD : state;
        STATE_FETCH_CMD         : state_next = STATE_ISSUE_TX_REQ;
        STATE_ISSUE_TX_REQ      : state_next = ((cmd_type == `US_CMD_CPL_TYPE) || (cmd_type == `US_CMD_CPLD_TYPE)) ? STATE_WAIT_TX_CPL_DONE : ((cmd_type == `US_CMD_WR32_TYPE) ? STATE_WAIT_TX_UP_WR_DONE : 'bx);
        STATE_WAIT_TX_CPL_DONE  : state_next = (txe_compl_done_i) ? STATE_IDLE : state;
        STATE_WAIT_TX_UP_WR_DONE: state_next = (txe_compl_done_i) ? STATE_IDLE : state;
        default: state_next = 'bx;
    endcase
end

// synthesis translate_off
reg [8*20:0] cmd_process_state_ascii;
always @(*) begin
    case (state)
        STATE_IDLE              : cmd_process_state_ascii = "IDLE";
        STATE_FETCH_CMD         : cmd_process_state_ascii = "FETCH_CMD";
        STATE_ISSUE_TX_REQ      : cmd_process_state_ascii = "ISSUE_TX_CMD";
        STATE_WAIT_TX_CPL_DONE  : cmd_process_state_ascii = "WAIT_TX_CPL";
        STATE_WAIT_TX_UP_WR_DONE: cmd_process_state_ascii = "WAIT_TX_UPWR";
    endcase
end
// synthesis translate_on
endmodule
