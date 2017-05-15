`timescale 1ns/1ns

module MY_EP_MEM_CTRL (
    input                 clk,
    input                 rst_n,

    output                rx_np_ok,
    input                 cmd_compl_i; // 1: active
    input  [1:0]          cmd_id_i;   // cmd ID

    input                 req_compl_i,   // from RX engine
    input                 req_compl_with_data_i,
    output                compl_done_o,

    input  [2:0]          req_tc_i,
    input                 req_td_i,
    input                 req_ep_i,
    input  [1:0]          req_attr_i,
    input  [9:0]          req_len_i,
    input  [15:0]         req_rid_i,
    input  [7:0]          req_tag_i,
    input  [7:0]          req_be_i,
    input  [12:0]         req_addr_i,

    output                req_compl_o, // to TX engine
    output                req_compl_with_data_o,
    input                 compl_done_i,
    output  [2:0]         req_tc_o,
    output                req_td_o,
    output                req_ep_o,
    output  [1:0]         req_attr_o,
    output  [9:0]         req_len_o,
    output  [15:0]        req_rid_o,
    output  [7:0]         req_tag_o,
    output  [7:0]         req_be_o,
    output  [12:0]        req_addr_o,


    input       [10:0]    rd_addr_i, /* read port */
    input       [3:0]     rd_be_i,
    output reg  [31:0]    rd_data_o,

    input       [10:0]    wr_addr_i, /* write port */
    input       [7:0]     wr_be_i,
    input       [31:0]    wr_data_i,
    input                 wr_en_i,
    output wire           wr_busy_o

);

wire            us_cmd_fifo_full;
wire            us_cmd_fifo_prog_full;
wire            us_cmd_fifo_rd_en;
wire            us_cmd_fifo_wr_en;
wire [127:0]    us_cmd_fifo_din;
wire [127:0]    us_cmd_fifo_dout;
wire            us_cmd_fifo_empty;
wire [3:0]      us_fifo_data_count;


INBOUND_FSM inbound_fsm_i (
    .clk                        (clk                    ),    // input clk
    .rst_n                      (rst_n                  ),    // input rst
    .rx_np_ok_o                 (rx_np_ok               ),    // O
    .cmd_compl_i                (cmd_compl_i            ),    // 1: active
    .cmd_id_i                   (cmd_id_i               ),    // cmd ID
    .req_compl_i                (req_compl_i            ),    // from RX engine
    .req_compl_with_data_i      (req_compl_with_data_i  ),
    .compl_done_o               (comp_done_o            ),

    .rd_addr_i                  (rd_addr_i              ),
    .rd_be_i                    (rd_be_i                ),
    .rd_data_o                  (rd_data_o              ),
    .wr_addr_i                  (wr_addr_i              ),
    .wr_be_i                    (wr_be_i                ),
    .wr_data_i                  (wr_data_i              ),
    .wr_en_i                    (wr_en_i                ),
    .wr_busy_o                  (wr_busy_o              ),

    .req_tc_i                   (req_tc_i             ),
    .req_td_i                   (req_td_i             ),
    .req_ep_i                   (req_ep_i             ),
    .req_attr_i                 (req_attr_i           ),
    .req_len_i                  (req_len_i            ),
    .req_rid_i                  (req_rid_i            ),
    .req_tag_i                  (req_tag_i            ),
    .req_be_i                   (req_be_i             ),
    .req_addr_i                 (req_addr_i           ),
    .us_cmd_fifo_full_i         (us_cmd_fifo_full         ),
    .us_cmd_fifo_prog_full_i    (us_cmd_fifo_prog_full),
    .us_cmd_fifo_dout_o         (us_cmd_fifo_din      ),
    .us_cmd_fifo_wr_en_o        (us_cmd_fifo_wr_en    )
);

CMD_PROCESS_FSM cmd_process_fsm_i (
    .clk                        (clk                    ),    // input clk
    .rst_n                      (rst_n                  ),    // input rst
    .us_cmd_fifo_rd_en_o        (us_cmd_fifo_rd_en      ),
    .us_cmd_fifo_dout_i         (us_cmd_fifo_dout       ),
    .us_cmd_fifo_empty          (us_cmd_fifo_empty      ),
    .req_compl_o                (req_compl_o            ), // to TX engine
    .req_compl_with_data_o      (req_compl_with_data_o  ),
    .compl_done_i               (compl_done_i           ),
    .req_tc_o                   (req_tc_o               ),
    .req_td_o                   (req_td_o               ),
    .req_ep_o                   (req_ep_o               ),
    .req_attr_o                 (req_attr_o             ),
    .req_len_o                  (req_len_o              ),
    .req_rid_o                  (req_rid_o              ),
    .req_tag_o                  (req_tag_o              ),
    .req_be_o                   (req_be_o               ),
    .req_addr_o                 (req_addr_o             )
);

us_cmd_fifo us_cmd_fifo_i (
  .clk(clk), // input clk
  .rst(!rst_n), // input rst
  .din(us_cmd_fifo_din), // input [127 : 0] din
  .wr_en(us_cmd_fifo_wr_en), // input wr_en
  .rd_en(us_cmd_fifo_rd_en), // input rd_en
  .dout(us_cmd_fifo_dout), // output [127 : 0] dout
  .full(us_cmd_fifo_full), // output full
  .empty(us_cmd_fifo_empty), // output empty
  .data_count(us_fifo_data_count), // output [3 : 0] data_count
  .prog_full(us_cmd_fifo_prog_full) // output prog_full
);

endmodule
