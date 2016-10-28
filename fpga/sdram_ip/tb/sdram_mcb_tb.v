/****************************************************************************\
*
* Test bench for sdram_top_exp module
*
* by zcz on 2016/10/20 8:06:24
*
* 1. simple write and read test
* 2. mixed write and read in parallel
*
****************************************************************************/
`timescale 1ns/1ps

module sdram_mcb_tb();

parameter CLOCKPERIOD = 20;

reg         clk_50m;
reg         clk_100m;
reg         rst_n;

wire   	    S_CLK;		//sdram clock
wire   	    S_CKE;		//sdram clock enable
wire   	    S_NCS;		//sdram chip select
wire   	    S_NWE;		//sdram write enable
wire   	    S_NCAS;	   //sdram column address strobe
wire   	    S_NRAS;	   //sdram row address strobe
wire [1:0] 	S_DQM;		//sdram data enable
wire [1:0]	S_BA;		   //sdram bank address
wire [12:0]	S_A;		   //sdram address
wire [15:0]	S_DB;		   //sdram data
reg         wr_load     ;   // users request a new write operation
reg [23:0]  wr_addr     ;   // write base address, {Bank{1:0], Row[12:0], Col[8:0]}
reg [23:0]  wr_length   ;   // write length, 0's based.
reg         wr_req      ;   // write data input valid
reg [15:0]  din         ;   // write data input
wire        wr_done     ;   // replay users currenct write complete.
wire        wr_rdy      ;   // write fifo is valid
wire        wr_overrun  ;
reg         wr_flag     ;

reg         rd_load     ;
reg [23:0]  rd_addr     ;
reg [23:0]  rd_length   ;
reg         rd_req      ;   // users request data read
wire [15:0] dout        ;   // data output for read
wire        rd_done     ;   // replay users currenct write complete.
wire [9:0]  rd_fifo_cnt ;   // how many data units in rd fifo
wire        rd_underrun ;

localparam HOST_DATA_DEPTH = 65536;
reg [15:0]  host_data_array[HOST_DATA_DEPTH - 1:0];

sdram_mcb u0
(
    .clk_sdram      (clk_100m      ),   // input           100MHz
    .clk_sdram_ref  (clk_100m      ),   // input           100MHz
    .clk_wr         (clk_50m       ),   // input
    .clk_rd         (clk_50m       ),   // input
    .rst_n          (rst_n         ),   // input
    .wr_load        (wr_load       ),   // input           users request a new write operation
    .wr_addr        (wr_addr       ),   // input [23:0]    write base address, {Bank{1:0], Row[12:0], Col[8:0]}
    .wr_length      (wr_length     ),   // input [23:0]    write length, 0's based.
    .wr_req         (wr_req        ),   // input           write data input valid
    .din            (din           ),   // input [15:0]    write data input
    .wr_done        (wr_done       ),   // output          reply users currenct write complete.
    .wr_rdy         (wr_rdy        ),   // output          write fifo is valid
    .wr_overrun     (wr_overrun    ),   // output
    .rd_load        (rd_load       ),   // input
    .rd_addr        (rd_addr       ),   // input [23:0]
    .rd_length      (rd_length     ),   // input [23:0]
    .rd_req         (rd_req        ),   // input           users request data read
    .dout           (dout          ),   // output [15:0]   data output for read
    .rd_done        (rd_done       ),   // output          reply users currenct read complete.
    .rd_fifo_cnt    (rd_fifo_cnt   ),   // output [9:0]    how many data units in rd fifo
    .rd_fifo_empty  (rd_fifo_empty ),
    .rd_underrun    (rd_underrun   ),   // output

    .S_CLK      (S_CLK   ),        //sdram clock
    .S_CKE      (S_CKE   ),        //sdram clock enable
    .S_NCS      (S_NCS   ),        //sdram chip select
    .S_NWE      (S_NWE   ),        //sdram write enable
    .S_NCAS     (S_NCAS  ),       //sdram column address strobe
    .S_NRAS     (S_NRAS  ),       //sdram row address strobe
    .S_DQM      (S_DQM   ),        //sdram data enable
    .S_BA       (S_BA    ),           //sdram bank address
    .S_A        (S_A     ),           //sdram address
    .S_DB       (S_DB    )           //sdram data
);

sdram_model u1
(
    .sdram_clk          (S_CLK      ),
    .sdram_cke          (S_CKE      ),
    .sdram_cs_n         (S_NCS      ),
    .sdram_we_n         (S_NWE      ),
    .sdram_cas_n        (S_NCAS     ),
    .sdram_ras_n        (S_NRAS     ),
	.sdram_udqm			(1'd0       ),		//sdram data enable (H:8)
	.sdram_ldqm			(1'd0       ),		//sdram data enable (L:8)
    .sdram_ba           (S_BA       ),
    .sdram_addr         (S_A        ),
    .sdram_data         (S_DB       )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk_50m <= ~clk_50m;
always #(CLOCKPERIOD / 4) clk_100m <= ~clk_100m;

task tsk_init_host_data_array;
    integer _i;
    begin
        for( _i = 0; _i < HOST_DATA_DEPTH; _i = _i + 1)
            host_data_array[_i] = _i;
    end
endtask

/*
* Write data from host_data_array with the specified base_addr and data_length
* In:
* base_addr: starting address to write
* data_length: WORDs number
*/
task tsk_write;
    input [23:0] base_addr;
    input [23:0] data_length;
    integer     wr_cnt;
    begin
        if (wr_load || wr_req)
        begin
            $display("[%t] initial state of wr_load or wr_req should be 0", $realtime);
            $finish(2);
        end
        @(posedge clk_50m)
        wr_load     <= 1'b1;
        wr_addr     <= base_addr;
        wr_length   <= data_length;
        @(posedge clk_50m)
        wr_load     <= 1'b0;
        wr_cnt      = 0;
        while(wr_cnt < data_length) begin
            @(posedge clk_50m)
            wr_req      <= 1'b1;
            din         = host_data_array[wr_addr + wr_cnt];
            wr_cnt      = wr_cnt + 1;
        end
        @(posedge clk_50m)
        wr_req      <= 1'b0;

        wait (wr_done);
        @(posedge clk_50m);
    end
endtask

task tsk_simple_write_test;
    input [23:0] base_addr;
    input [23:0] data_length;
    begin
        $display("[%t] Begin simple write test. %6X WORDs from %6X", $realtime, data_length, base_addr);
        tsk_write(base_addr, data_length);
        $display("[%t] simple write test complete.", $realtime);
    end
endtask

/*
* Read data with the specified base_address and data lenght
* In:
* base_addr: starting address to read
* data_length: WORDs number
*/
task tsk_read;
    input [23:0] base_addr;
    input [23:0] data_length;
    integer     rd_cnt;
    reg         rd_req_d;
    begin
        if (rd_load || rd_req)
        begin
            $display("[%t] initial state of rd_load or rd_req should be 0", $realtime);
            $display("Test FAILED");
            $finish(2);
        end
        rd_cnt = 0;
        @(posedge clk_50m)
        rd_load     <= 1'b1;
        rd_addr     <= base_addr;
        rd_length   <= data_length;
        @(posedge clk_50m)
        rd_load     <= 1'b0;
        wait (rd_fifo_cnt > 0)
        rd_req_d    <= rd_req;
        fork
            while(rd_cnt < data_length) begin
                @(posedge clk_50m or rd_fifo_empty)
                if (rd_fifo_empty) rd_req = 1'b0;
                else               rd_req = 1'b1;
            end
            while(rd_cnt < data_length) begin
                @(posedge clk_50m)
                rd_req_d <= rd_req;
            end
            while(rd_cnt < data_length) begin
                @(posedge clk_50m)
                if (rd_req_d == 1'b1) begin
                    if (dout !== host_data_array[base_addr + rd_cnt]) begin
                        $display("[%t] %2d data %04X, expect %04X", $realtime, rd_cnt, dout, host_data_array[base_addr + rd_cnt]);
                        $display("Test FAILED");
                        $finish(2);
                    end
                    rd_cnt = rd_cnt + 1'd1;
                end
            end
        join
        @(posedge clk_50m);
    end
endtask

task tsk_delay_read;
    input [23:0] base_addr;
    input [23:0] data_length;
    input integer delay_cycles;
    integer     rd_cnt;
    integer     error_cnt;
    reg         rd_req_d;
    begin
        if (rd_load || rd_req)
        begin
            $display("[%t] initial state of rd_load or rd_req should be 0", $realtime);
            $display("Test FAILED");
            $finish(2);
        end
        rd_cnt = 0;
        @(posedge clk_50m)
        rd_load     = 1'b1;
        rd_addr     = base_addr;
        rd_length   = data_length;
        @(posedge clk_50m)
        rd_load     = 1'b0;
        wait (rd_fifo_cnt > 0);
        repeat (delay_cycles) @(posedge clk_50m);
        $display("[%t] task delay read begin to read", $realtime);
        fork
            while(rd_cnt < data_length) begin
                @(posedge clk_50m or rd_fifo_empty)
                if (rd_fifo_empty) rd_req = 1'b0;
                else               rd_req = 1'b1;
            end
            while(rd_cnt < data_length) begin
                @(posedge clk_50m)
                rd_req_d <= rd_req;
            end
            while(rd_cnt < data_length) begin
                @(posedge clk_50m)
                if (rd_req_d == 1'b1) begin
                    if (dout !== host_data_array[base_addr + rd_cnt]) begin
                        $display("[%t] %2d data %04X, expect %04X", $realtime, rd_cnt, dout, host_data_array[base_addr + rd_cnt]);
                        $display("Test FAILED");
                        $finish(2);
                    end
                    rd_cnt = rd_cnt + 1'd1;
                end
            end
        join
        @(posedge clk_50m);
    end
endtask

task tsk_simple_read_test;
    input [23:0] base_addr;
    input [23:0] data_length;
    begin
        $display("[%t] Begin simple read  test. %6X WORDs from %6X", $realtime, data_length, base_addr);
        tsk_read(base_addr, data_length);
        $display("[%t] simple read test complete.", $realtime);
    end
endtask

/*
* 1. Write data from 0 by spcified bytes
* 2. read and write in parallel
*    a) Read data from ADDR_A by specified bytes
*    b) write data from ADDR_B by specified bytes
* 3. repeat step 2 with ADDR_A/B toggle by specified times
*
* In: data_depth  : the number of WORDs each time of read/write
*     repeat_times: the number of repeat times
*/
task tsk_mixed_write_read_test;
    input [23:0] data_depth;
    input integer times;
    integer     rd_cnt;
    reg         rd_req_d;
    integer     wr_addr;
    integer     rd_addr;
    integer     n_;
    integer     i_;
    localparam     ADDR_A = 0;
    localparam     ADDR_B = 32768;
    begin
        $display("[%t] Begin mixed write/read test %d WORDs each time, by %d times", $realtime, data_depth, times);
        wr_addr = ADDR_A;
        #100 tsk_write(wr_addr, data_depth);
        n_ = 0;
        while(n_ < times) begin
            rd_addr = wr_addr;
            wr_addr = (wr_addr == ADDR_A) ? ADDR_B : ADDR_A;
            $display("[%t] No.%2d Write %6X  Read %6X", $realtime, n_, wr_addr, rd_addr);
            for(i_ = 0; i_ < data_depth; i_ = i_ + 1)
                host_data_array[wr_addr + i_] = $random;
            $display("[%t] No.%2d Write %6X  Read %6X complete", $realtime, n_, wr_addr, rd_addr);

            fork
                tsk_write(wr_addr, data_depth);
                tsk_read(rd_addr, data_depth);
            join
            n_ = n_ + 1;
        end
    end
endtask

task tsk_simulate_sdram_vga_test;
    input [23:0] data_depth;
    input integer times;
    integer     rd_cnt;
    reg         rd_req_d;
    integer     wr_addr;
    integer     rd_addr;
    integer     n_;
    integer     i_;
    localparam     ADDR_A = 0;
    localparam     ADDR_B = 32768;
    begin
        $display("[%t] Begin simulation for sdram_vga write/read test %d WORDs each time, by %d times", $realtime, data_depth, times);
        wr_addr = ADDR_A;
        #100 tsk_write(wr_addr, data_depth);
        n_ = 0;
        while(n_ < times) begin
            rd_addr = wr_addr;
            wr_addr = (wr_addr == ADDR_A) ? ADDR_B : ADDR_A;
            $display("[%t] No.%2d Write %6X  Read %6X", $realtime, n_, wr_addr, rd_addr);
            for(i_ = 0; i_ < data_depth; i_ = i_ + 1)
                host_data_array[wr_addr + i_] = $random;
            fork
                tsk_write(wr_addr, data_depth);
                tsk_delay_read(rd_addr, data_depth, 1500);
            join
            n_ = n_ + 1;
        end
    end
endtask

initial begin
    rst_n   <= 1'b0;
    clk_50m <= 1'b0;
    clk_100m <= 1'b0;
    wr_load     <= 1'b0;
    rd_load     <= 1'b0;
    wr_req      <= 1'b0;
    rd_req      <= 1'b0;

    tsk_init_host_data_array();

    #1000 rst_n <= 1'b1;

    wait (wr_rdy);
    #100 tsk_simple_write_test(24'h1f0, 1024*1);
    #100 tsk_simple_read_test (24'h1f0, 1024*1);

    #100 tsk_simple_write_test(24'h1f1, 24'h100);
    #100 tsk_simple_read_test (24'h1f1, 24'h100);

    // write and then read 0x1234 WORDs in parallel by 5 times.
    #100 tsk_mixed_write_read_test(24'h1234, 5);
    #100 tsk_simulate_sdram_vga_test(24'h800, 2);

    $display("[%t] Test PASSED", $realtime);
    $finish(0);
end
endmodule
