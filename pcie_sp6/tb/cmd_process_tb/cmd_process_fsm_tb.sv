/*
* do nothing but empty framework
*/
`timescale 1ns / 1ps

module cmd_process_fsm_tb();

parameter CLOCKPERIOD = 20;

logic        clk     ;
logic        rst_n   ;
logic               us_cmd_fifo_rd_en_o;
logic   [127:0]     us_cmd_fifo_dout_i;
logic               us_cmd_fifo_empty;
logic               req_compl_o;
logic               req_compl_with_data_o;
logic               compl_done_i;
logic               req_tc_o;
logic               req_td_o;
logic               req_ep_o;
logic               req_attr_o;
logic               req_len_o;
logic               req_rid_o;
logic               req_tag_o;
logic               req_be_o;
logic               req_addr_o;


CMD_PROCESS_FSM	CMD_PROCESS_FSMEx01
(
	.clk                  	(	clk                  	),
	.rst_n                	(	rst_n                	),
	.us_cmd_fifo_rd_en_o  	(	us_cmd_fifo_rd_en_o  	),
	.us_cmd_fifo_dout_i   	(	us_cmd_fifo_dout_i   	),
	.us_cmd_fifo_empty    	(	us_cmd_fifo_empty    	),
	.req_compl_o          	(	req_compl_o          	),
	.req_compl_with_data_o	(	req_compl_with_data_o	),
	.compl_done_i         	(	compl_done_i         	),
	.req_tc_o             	(	req_tc_o             	),
	.req_td_o             	(	req_td_o             	),
	.req_ep_o             	(	req_ep_o             	),
	.req_attr_o           	(	req_attr_o           	),
	.req_len_o            	(	req_len_o            	),
	.req_rid_o            	(	req_rid_o            	),
	.req_tag_o            	(	req_tag_o            	),
	.req_be_o             	(	req_be_o             	),
	.req_addr_o           	(	req_addr_o           	)
) ;

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)

    #100 $display("[%t] TEST PASSED", $realtime);
    $stop;
end
endmodule
