`timescale 1ns / 1ps

`include "param.v"

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
reg               up_wr_cmd_compl_i;
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
        up_wr_cmd_compl_i = 0;
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
task tsk_wr_addr_register;
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
            $display("[%8t] Write Addr_0 Test FAILED: rd_data_o %8x != expected %8x\n", $realtime, rd_data_o, data);
        end else begin
            $display("[%8t] Write Addr_0 Test PASSED: rd_data_o %8x == expected %8x\n", $realtime, rd_data_o, data);
        end
    end

endtask

// Simulate that host reads register. inbound_fsm should issue cmd to notify
// complete the read register request with CPLD.
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

        us_cmd_fifo_full_i = 0;
        req_compl_i = 1;
        req_compl_with_data_i = 1;
        @(posedge clk);
        req_compl_i = 0;
        req_compl_with_data_i = 0;
        fork
            while(compl_done_o !== 1) @(posedge clk);
            begin
                while(us_cmd_fifo_wr_en_o !== 1) @(posedge clk);
                if (INBOUND_FSMEx01.req_d != { req_tc_i, req_td_i, req_ep_i, req_attr_i, req_len_i, req_rid_i, req_tag_i, req_be_i, req_addr_i[5:0] } )
                    $display("[%8t] Read register FAILED: out %16x, expected %16x\n", $realtime, us_cmd_fifo_din_o, { req_tc_i, req_td_i, req_ep_i, req_attr_i, req_len_i, req_rid_i, req_tag_i, req_be_i, req_addr_i[7:0] });
                else begin
                    $display("[%8t] Read register PASSED\n", $realtime);
                end
            end
        join

    end
endtask

// write cmd register test
// 1. prepare ADDR0, ADDR1, len, register, then write cmd by 1.
// 2. check output for FIFO, 
//
// after some cycles, <- write ADDR0 and check.
// 3. set up_wr_cmd_compl_i, cmd_id
// 4. check state.
task tsk_wr_cmd_register;
    integer data[1:0];
    integer _i;
    integer cmd_type;
    integer len;
    integer cmd_id;
    integer addr;
    integer flag;
    reg [8*14:1] str;
    integer cmd_bitmap;

    begin
        wr_en_i = 1;
        wr_addr_i = 4;
        wr_be_i = 8'hFF;
        wr_data_i = 7;  // 128 bytes
        @(posedge clk);
        wr_en_i = 0;
        @(posedge clk);
        while(wr_busy_o == 1) @(posedge clk);

        for(_i = 0; _i < 2; _i = _i + 1)
        begin
            data[_i] = $random << 2;
            wr_en_i = 1;
            wr_addr_i = 16 + _i * 8;
            wr_be_i = 8'hFF;
            wr_data_i = data[_i];
            @(posedge clk);
            wr_en_i = 0;
            wait(wr_busy_o == 1);
            while(wr_busy_o == 1) @(posedge clk);
        end

        cmd_bitmap = 3;
        wr_en_i = 1;
        wr_be_i = 8'hFF;
        wr_addr_i = 0;
        wr_data_i = cmd_bitmap;
        @(posedge clk);
        fork
            begin
                repeat (50) @(posedge clk);
            end
            begin
                wr_en_i = 0;
                @(posedge clk);
                while(wr_busy_o == 1) @(posedge clk);
            end
            begin
                for(_i = 0; _i < 2; _i = _i + 1)
                begin
                    while(us_cmd_fifo_wr_en_o != 1) @(posedge clk);
                    cmd_type = us_cmd_fifo_din_o[63:62];
                    len      = us_cmd_fifo_din_o[61:57];
                    cmd_id   = us_cmd_fifo_din_o[56:55];
                    addr     = us_cmd_fifo_din_o[31:0];
                    if ((cmd_type != `US_CMD_WR32_TYPE) || (len != 7) || (cmd_id != _i) || (addr != data[_i])) begin
                        str = "FAILED";
                        flag = 1;
                    end else begin
                        str = "PASSED";
                        flag = 0;
                    end
                    $display("[%8t] No.%2d Write CMD Register %8s complete. Data into FIFO: cmd_type %2d  len %2d  cmd_id %2d addr %8x, data[%1d] %8x\n", $realtime, _i, str, cmd_type, len, cmd_id, addr, _i, data[_i]);
                    if (flag == 1) begin
                        #100 $finish(1);
                    end
                    @(posedge clk);
                end
                fork
                    repeat (20) @(posedge clk);
                    tsk_wr_addr_register();
                join

                for(_i = 0; _i < 2; _i = _i + 1)
                begin
                    cmd_id_i = _i;
                    up_wr_cmd_compl_i = 1;
                    @(posedge clk);
                    up_wr_cmd_compl_i = 0;
                    @(posedge clk);
                    if ((INBOUND_FSMEx01.state & ( 1 << _i))!= 0) begin
                        $display("[%8t] complete previous No.%1d write command FAILED, but state %2d, should be 0\n", $realtime, _i, INBOUND_FSMEx01.state);
                    end else begin
                        $display("[%8t] complete previous No.%1d write command PASSED.\n", $realtime, _i);
                    end
                end
            end
        join

    end
endtask

INBOUND_FSM	INBOUND_FSMEx01
(
	.clk                    	(	clk                    	),
	.rst_n                  	(	rst_n                  	),
	.rx_np_ok_o             	(	rx_np_ok_o             	),
	.up_wr_cmd_compl_i         	(	up_wr_cmd_compl_i            	),
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
    tsk_wr_addr_register();
    tsk_rd_register();
    tsk_wr_cmd_register();
    tsk_wr_cmd_register();

    #100 $display("[%8t] TEST Complete", $realtime);
    $finish(0);
end
endmodule
