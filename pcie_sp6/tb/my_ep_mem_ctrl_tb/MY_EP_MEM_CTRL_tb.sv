`timescale 1ns / 1ps

module MY_EP_MEM_CTRL_tb();

parameter CLOCKPERIOD = 20;

logic               clk;
logic               rst_n;
logic               rx_np_ok;
logic   [1:0]       cmd_id_i;
logic               req_compl_i;
logic               req_compl_with_data_i;
logic               to_rxe_compl_done_o;
logic   [2:0]       req_tc_i;
logic               req_td_i;
logic               req_ep_i;
logic   [1:0]       req_attr_i;
logic   [9:0]       req_len_i;
logic   [15:0]      req_rid_i;
logic   [7:0]       req_tag_i;
logic   [7:0]       req_be_i;
logic   [12:0]      req_addr_i;
logic               req_compl_o;
logic               req_compl_with_data_o;
logic               txe_compl_done_i;
logic   [2:0]       req_tc_o;
logic               req_td_o;
logic               req_ep_o;
logic   [1:0]       req_attr_o;
logic   [9:0]       req_len_o;
logic   [15:0]      req_rid_o;
logic   [7:0]       req_tag_o;
logic   [7:0]       req_be_o;
logic   [12:0]      req_addr_o;
logic   [10:0]      rd_addr_i;
logic   [3:0]       rd_be_i;
logic   [31:0]      rd_data_o;
logic   [10:0]      wr_addr_i;
logic   [7:0]       wr_be_i;
logic   [31:0]      wr_data_i;
logic               wr_en_i;
logic               wr_busy_o;


MY_EP_MEM_CTRL	MY_EP_MEM_CTRLEx01
(
	.clk                  	(	clk                  	),
	.rst_n                	(	rst_n                	),
	.rx_np_ok             	(	rx_np_ok             	),
	.cmd_id_i             	(	cmd_id_i             	),
	.req_compl_i          	(	req_compl_i          	),
	.req_compl_with_data_i	(	req_compl_with_data_i	),
	.to_rxe_compl_done_o    (	to_rxe_compl_done_o     ),
	.req_tc_i             	(	req_tc_i             	),
	.req_td_i             	(	req_td_i             	),
	.req_ep_i             	(	req_ep_i             	),
	.req_attr_i           	(	req_attr_i           	),
	.req_len_i            	(	req_len_i            	),
	.req_rid_i            	(	req_rid_i            	),
	.req_tag_i            	(	req_tag_i            	),
	.req_be_i             	(	req_be_i             	),
	.req_addr_i           	(	req_addr_i           	),
	.req_compl_o          	(	req_compl_o          	),
	.req_compl_with_data_o	(	req_compl_with_data_o	),
	.txe_compl_done_i       (	txe_compl_done_i        ),
	.req_tc_o             	(	req_tc_o             	),
	.req_td_o             	(	req_td_o             	),
	.req_ep_o             	(	req_ep_o             	),
	.req_attr_o           	(	req_attr_o           	),
	.req_len_o            	(	req_len_o            	),
	.req_rid_o            	(	req_rid_o            	),
	.req_tag_o            	(	req_tag_o            	),
	.req_be_o             	(	req_be_o             	),
	.req_addr_o           	(	req_addr_o           	),
	.rd_addr_i            	(	rd_addr_i            	),
	.rd_be_i              	(	rd_be_i              	),
	.rd_data_o            	(	rd_data_o            	),
	.wr_addr_i            	(	wr_addr_i            	),
	.wr_be_i              	(	wr_be_i              	),
	.wr_data_i            	(	wr_data_i            	),
	.wr_en_i              	(	wr_en_i              	),
	.wr_busy_o            	(	wr_busy_o            	)
) ;

task tsk_init;
    begin
        req_compl_i = 0;
        req_compl_with_data_i = 0;

        req_tc_i    = 0;
        req_td_i    = 0;
        req_ep_i    = 0;
        req_attr_i  = 0;
        req_len_i   = 0;
        req_rid_i   = 0;
        req_tag_i   = 0;
        req_be_i    = 0;
        req_addr_i  = 0;

        txe_compl_done_i= 0;
        rd_addr_i = 0;
        rd_be_i = 0;

        wr_addr_i   = 0;
        wr_be_i     = 0;
        wr_data_i   = 0;
        wr_en_i     = 0;
    end
endtask
// write and read back addr_0
task tsk_wr_addr_register;
    integer data;
    integer addr;
    begin
        addr = 4;
        data = $random << 2;
        wr_en_i = 1;
        wr_addr_i = addr;
        wr_be_i = 8'hFF;
        wr_data_i = data;
        @(posedge clk);
        wr_en_i = 0;
        @(posedge clk);
        while(wr_busy_o == 1) @(posedge clk);
        rd_addr_i = addr;
        rd_be_i = 8'hFF;
        @(posedge clk);
        if (rd_data_o != data) begin
            $display("[%8t] Write Addr_0 Test FAILED: rd_data_o %8x != expected %8x\n", $realtime, rd_data_o, data);
        end else begin
            $display("[%8t] Write Addr_0 Test PASSED: rd_data_o %8x == expected %8x\n", $realtime, rd_data_o, data);
        end
    end

endtask

task tsk_rd_register;
    begin
        req_tc_i = 0;
        req_td_i = 0;
        req_ep_i = 0;
        req_attr_i = 0;
        req_len_i = 1;
        req_rid_i = 0;
        req_tag_i = 5;
        req_be_i  = 8'h0F;
        req_addr_i = 13'h10;

        req_compl_i = 1;
        req_compl_with_data_i = 1;
        @(posedge clk);
        req_compl_i = 0;
        req_compl_with_data_i = 0;
        fork
            begin
                repeat (10) @(posedge clk);
                if (MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.state != MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.STATE_WAIT_TX_CPL_DONE)
                    $display("[%8t] cmd_process_fsm should wait for TX CPL, but %2d\n", $realtime, MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.state);
                txe_compl_done_i = 1; @(posedge clk);
                txe_compl_done_i = 0; @(posedge clk);
                if (MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.state != MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.STATE_IDLE)
                    $display("[%8t] cmd_process_fsm should be IDLE, but %2d\n", $realtime, MY_EP_MEM_CTRLEx01.cmd_process_fsm_inst.state);
            end
        join

    end
endtask
// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    tsk_init();
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)
    tsk_wr_addr_register();
    tsk_rd_register();

    #100 $display("[%t] TEST Complete", $realtime);
    $finish(0);
end
endmodule
