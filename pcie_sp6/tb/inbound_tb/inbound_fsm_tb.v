`timescale 1ns / 1ps

module inbound_fsm_tb();

parameter CLOCKPERIOD = 20;

reg         clk     ;
reg         rst_n   ;
wire        rdy     ;
reg         wen     ;
reg [31:0]  din     ;
wire [31:0] dout    ;
wire        done    ;

wire              rx_np_ok_o;
reg               cmd_compl_i;
reg   [1:0]       cmd_id_i;
reg               req_compl_i;
reg               req_compl_with_data_i;
wire              compl_done_o;
reg   [10:0]      rd_addr_i;
reg   [3:0]       rd_be_i;
wire  [31:0]      rd_data_o;
reg   [10:0]      wr_addr_i;
reg   [7:0]       wr_be_i;
reg   [31:0]      wr_data_i;
reg               wr_en_i;
wire              wr_busy_o;
reg   [2:0]       req_tc_i;
reg               req_td_i;
reg               req_ep_i;
reg   [1:0]       req_attr_i;
reg   [9:0]       req_len_i;
reg   [15:0]      req_rid_i;
reg   [7:0]       req_tag_i;
reg   [7:0]       req_be_i;
reg   [12:0]      req_addr_i;
reg               us_cmd_fifo_full_i;
reg               us_cmd_fifo_prog_full_i;
wire  [127:0]     us_cmd_fifo_din_o;
wire              us_cmd_fifo_wr_en_o;

task tsk_init;
    begin
        cmd_compl_i = 0;
        req_compl_i = 0;
        req_compl_with_data_i = 0;
        wr_en_i     = 0;
        wr_data_i   = 0;
        wr_be_i     = 0;
        wr_addr_i   = 0;
        req_tc_i    = 0;
        req_td_i    = 0;
        req_ep_i    = 0;
        req_attr_i  = 0;
        req_len_i   = 0;
        req_rid_i   = 0;
        req_tag_i   = 0;
        req_be_i    = 0;
        req_addr_i  = 0;
        us_cmd_fifo_full_i = 0;
        us_cmd_fifo_prog_full_i = 0;
    end
endtask
// write and read back addr_0
task tsk_wr_addr;
    integer data;
    begin
        data = $random << 2;
        wr_en_i = 1;
        wr_addr_i = 16;
        wr_be_i = 8'hFF;
        wr_data_i = data;
        @(posedge clk);
        wr_en_i = 0;
        @(posedge clk);
        while(wr_busy_o == 1) @(posedge clk);
        rd_addr_i = 16;
        rd_be_i = 8'hFF;
        @(posedge clk);
        if (rd_data_o != data) begin
            $display("[%t] W/R Test FAILED: rd_data_o %8x != expected %8x\n", $realtime, rd_data_o, data);
        end else begin
            $display("[%t] W/R Test PASSED: rd_data_o %8x == expected %8x\n", $realtime, rd_data_o, data);
        end
    end

endtask

INBOUND_FSM	INBOUND_FSMEx01
(
	.clk                    	(	clk                    	),
	.rst_n                  	(	rst_n                  	),
	.rx_np_ok_o             	(	rx_np_ok_o             	),
	.cmd_compl_i            	(	cmd_compl_i            	),
	.cmd_id_i               	(	cmd_id_i               	),
	.req_compl_i            	(	req_compl_i            	),
	.req_compl_with_data_i  	(	req_compl_with_data_i  	),
	.compl_done_o           	(	compl_done_o           	),
	.rd_addr_i              	(	rd_addr_i              	),
	.rd_be_i                	(	rd_be_i                	),
	.rd_data_o              	(	rd_data_o              	),
	.wr_addr_i              	(	wr_addr_i              	),
	.wr_be_i                	(	wr_be_i                	),
	.wr_data_i              	(	wr_data_i              	),
	.wr_en_i                	(	wr_en_i                	),
	.wr_busy_o              	(	wr_busy_o              	),
	.req_tc_i               	(	req_tc_i               	),
	.req_td_i               	(	req_td_i               	),
	.req_ep_i               	(	req_ep_i               	),
	.req_attr_i             	(	req_attr_i             	),
	.req_len_i              	(	req_len_i              	),
	.req_rid_i              	(	req_rid_i              	),
	.req_tag_i              	(	req_tag_i              	),
	.req_be_i               	(	req_be_i               	),
	.req_addr_i             	(	req_addr_i             	),
	.us_cmd_fifo_full_i     	(	us_cmd_fifo_full_i     	),
	.us_cmd_fifo_prog_full_i	(	us_cmd_fifo_prog_full_i	),
    .us_cmd_fifo_din_o          (	us_cmd_fifo_din_o       ),
	.us_cmd_fifo_wr_en_o    	(	us_cmd_fifo_wr_en_o    	)
) ;



// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    tsk_init();
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)
    @(posedge clk)
    tsk_wr_addr();

    #1000 $display("[%t] TEST Complete", $realtime);
    $finish(0);
end
endmodule
