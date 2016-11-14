/****************************************************************************\
*
* An experiment to R/W SDRAM by sdram_top module.
*
* by zcz on 2016/10/20 8:05:07
*
****************************************************************************/
`timescale 1ns/1ps
//`define RW_INTERVAL
//`define SEVEN_SEG_DISP
`define MY_TEST

module sdram_top_exp
(
    input           clk_50m,
    input           sw_rst_n,
	//sdram control
	output			S_CLK,		//sdram clock
	output			S_CKE,		//sdram clock enable
	output			S_NCS,		//sdram chip select
	output			S_NWE,		//sdram write enable
	output			S_NCAS,	   //sdram column address strobe
	output			S_NRAS,	   //sdram row address strobe
	output [1:0] 	S_DQM,		//sdram data enable
	output [1:0]	S_BA,		   //sdram bank address
	output [12:0]	S_A,		   //sdram address
	inout  [15:0]	S_DB,		   //sdram data

    //output [7:0]    leds_o,
    //output [5:0]    sels_o,
    output          led_0,
    output          led_1
    //  output          led_2,
    //  output          led_3,
);
`ifdef MODELSIM_DBG
localparam ONE_SECOND_CYCLES = 27'd99_99;
`else
localparam ONE_SECOND_CYCLES = 27'd99_999_999;
`endif


/****************************************************************************\
*
* Clocks and global reset
*
*****************************************************************************/
wire    clk;
wire    rst_n;
wire    clk_100m;
wire    clk_100m_ref;
clk_gen clk_gen(
    .clk_50m_i      (clk_50m        ),
    .rst_n_i        (sw_rst_n       ),
    .clk            (clk            ),
    .clk_100m       (clk_100m       ),
    .clk_100m_ref   (clk_100m_ref   ),
    .rst_n          (rst_n          ),
    .sdram_rst_n    (sdram_rst_n    )
);

`ifdef MODELSIM_DBG
assign S_CLK = clk_100m_ref;
`else
ODDR2 #(
    .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1"
    .INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
    .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
    ) U_ODDR2_100MHZ
(
      .Q(S_CLK),   // 1-bit DDR output data
      .C0(clk_100m_ref),   // 1-bit clock input
      .C1(~clk_100m_ref),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D0(1'b1), // 1-bit data input (associated with C0)
      .D1(1'b0), // 1-bit data input (associated with C1)
      .R(1'b0),   // 1-bit reset input
      .S(1'b0)    // 1-bit set input
);
`endif
//assign S_CLK = clk_100m_ref;


/****************************************************************************\
*
* Counter for 7-segment display
*
*****************************************************************************/
`ifdef SEVEN_SEG_DISP
localparam CNT_MAX = (26'd20_000_000 - 1);

wire        wen;
reg [7:0]   second;
reg [25:0]  cnt;

assign wen = (cnt == 26'd1);

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin cnt <= 26'd0; second <= 8'd0; end
    else begin
        if( cnt == CNT_MAX) begin cnt <= 26'd0; second <= second + 8'd1; end
        else                begin cnt <= cnt + 26'd1; end
    end
end

wire [31:0] ssd_data;   // seven segement display data input
wire        ssd_wen;    // seven segement display write enable

assign ssd_data = {8'd0, second, second, second};
//assign ssd_data = {12'd0, i, 1'd0, sys_data_out[15:9], sys_data_in[17:10]};

assign ssd_wen  = wen;
seven_seg_interface seven_seg_interface(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   (ssd_data),
    .wen    (ssd_wen),
    .base   (1'b0   ),
    .rdy    (       ),
    .done   (       ),
    .leds_o (leds_o ),
    .sels_o (sels_o )
);
`endif

`ifdef MY_TEST

/****************************************************************************\
*
* SDRAM write/read
*
*****************************************************************************/

wire        sdram_wr_req   ;
wire        sdram_rd_req   ;
wire        sdram_wr_ack   ;
wire        sdram_rd_ack   ;
wire [23:0] sys_wraddr     ;
wire [23:0] sys_rdaddr     ;
reg  [15:0] sys_data_in    ;
wire [15:0] sys_data_out   ;
reg  [15:0] sys_data_verify;
wire        sdram_init_done;
wire[ 9:0]  sdwr_byte      ;
wire[ 9:0]  sdrd_byte      ;

reg [26:0]  cnt; // 100_000_000
wire        wr_kickoff;    // 0: write, 1: read
reg [1:0]   addr;
reg         error;
reg         wr_flag;
reg [1:0]   state;
reg [1:0]   sdram_wr_ack_d;

localparam INIT     = 2'd0;
localparam IDLE     = 2'd1;
localparam WR_OPT   = 2'd2;
localparam RD_OPT   = 2'd3;

assign sys_wraddr = {1'b0, 12'd0, addr[1], addr[0], 9'd0};
assign sys_rdaddr = {1'b0, 12'd0, addr[1], addr[0], 9'd0};
assign sdwr_byte  = 10'd512;
assign sdrd_byte  = 10'd512;

assign wr_kickoff = (cnt == ONE_SECOND_CYCLES) ? 1'b1 : 1'b0;
assign sdram_wr_req = (state == WR_OPT) ? 1'b1 : 1'b0;
assign sdram_rd_req = (state == RD_OPT) ? 1'b1 : 1'b0;
assign S_DQM = 2'd0;

// counter for each second
always @(posedge clk_100m, negedge rst_n) begin
    if (~rst_n)                         cnt <= 27'd0;
    else if (cnt == ONE_SECOND_CYCLES)  cnt <= 27'd0;
    else                                cnt <= cnt + 27'd1;
end

// toggle wr_flag every second.
always @(posedge clk_100m, negedge rst_n) begin
    if (~rst_n)                         wr_flag <= 1'b0;
    else if (cnt == ONE_SECOND_CYCLES)  wr_flag <= ~wr_flag;
end
always @(posedge clk_100m, negedge rst_n) begin
    if (~rst_n) sdram_wr_ack_d  <= 2'b0;
    else        sdram_wr_ack_d  <= {sdram_wr_ack_d[0], sdram_wr_ack};
end

/*
* Write 256 bytes and then read 256 bytes from the same address
* Then jump next addr do the same job
*/
always @(posedge clk_100m, negedge rst_n) begin
    if (~rst_n) begin
        addr        <= 2'd0;
        error       <= 1'b0;
        state       <= INIT;
        sys_data_in <= 16'd0;
    end else begin
        case (state)
            INIT: begin
                if(sdram_init_done) state <= IDLE;
            end
            IDLE: begin
                if (wr_kickoff) begin
                    if (wr_flag) begin
                        state <= RD_OPT;
                    end else begin
                        state <= WR_OPT;
                        sys_data_verify <= sys_data_in;
                    end
                end
            end
            WR_OPT: begin
                if (sys_data_in[8:0] == 9'h1ff) begin
                    state   <= IDLE;
                    sys_data_in <= sys_data_in + 16'd1;
                end else begin
                    if (sdram_wr_ack_d[0]) begin
                        sys_data_in <= sys_data_in + 16'd1;
                    end
                end
            end
            RD_OPT: begin
                if (sys_data_verify[8:0] == 9'h1ff) begin
                    addr    <= addr + 2'd1;
                    state   <= IDLE;
                end else begin
                    if (sdram_rd_ack) begin
                        if (sys_data_out != sys_data_verify) begin
                            error   <= 1'b1;
                            $display("[%t] Failed to verify data, read %08X, expect %08X", $realtime, sys_data_out, sys_data_verify);
                            $display("Test FAILED");
                            $finish(1);
                        end
                        sys_data_verify <= sys_data_verify + 16'd1;
                    end
                end
            end
        endcase
    end
end

sdram_top sdram_top
(
	//global clock
	.clk				(clk_100m       ),			//sdram reference clock
	.rst_n				(rst_n          ),			//global reset

	//internal interface
	.sdram_wr_req		(sdram_wr_req   ), 	//sdram write request
	.sdram_rd_req		(sdram_rd_req   ), 	//sdram write ack
	.sdram_wr_ack		(sdram_wr_ack   ), 	//sdram read request
	.sdram_rd_ack		(sdram_rd_ack   ),		//sdram read ack
	.sys_wraddr			(sys_wraddr     ), 	//sdram write address
	.sys_rdaddr			(sys_rdaddr     ), 	//sdram read address
	.sys_data_in		(sys_data_in    ),    	//fifo 2 sdram data input
	.sys_data_out		(sys_data_out   ),   	//sdram 2 fifo data input
	.sdram_init_done	(sdram_init_done),	//sdram init done

	//burst length
	.sdwr_byte			(sdwr_byte      ),		//sdram write burst length
	.sdrd_byte			(sdrd_byte      ),		//sdram read burst length

	//sdram interface
//	.sdram_clk			(sdram_clk),		//sdram clock
	.sdram_cke			(S_CKE          ),		//sdram clock enable
	.sdram_cs_n			(S_NCS          ),		//sdram chip select
	.sdram_we_n			(S_NWE          ),		//sdram write enable
	.sdram_ras_n		(S_NRAS         ),		//sdram column address strobe
	.sdram_cas_n		(S_NCAS         ),		//sdram row address strobe
	.sdram_ba			(S_BA           ),			//sdram data enable (H:8)
	.sdram_addr			(S_A            ),		//sdram data enable (L:8)
	.sdram_data			(S_DB           )		//sdram bank address
//	.sdram_udqm			(sdram_udqm),		//sdram address
//	.sdram_ldqm			(sdram_ldqm)		//sdram data
);


assign led_1 = error;
assign led_0 = rst_n;
wire [63:0] ASYNC_OUT;

`ifndef MODELSIM_DBG
/***************************************************************************\
*
* ICON, ILA, VIO for debug
*
****************************************************************************/
wire [35:0] CONTROL0;
wire [35:0] CONTROL1;
wire [ 7:0] ASYNC_IN;
wire [31:0] ila_trig0;
wire [31:0] ila_trig1;
wire [31:0] ila_trig2;
wire [31:0] ila_trig3;
wire [31:0] ila_trig4;

assign ila_trig1 = { S_CKE,  S_BA   , S_A    , S_DB   };
assign ila_trig0 = {
    sys_data_verify[15:0] ,
    sdram_rd_ack          ,   // 15
    wr_flag               ,
    sdram_wr_ack          ,
    sdram_wr_ack_d[0]     ,
    addr,
    state,
    S_NCS  ,                // 7
    S_NRAS ,
    S_NCAS ,
    S_NWE  ,
    wr_kickoff,
    sdram_init_done,
    sdram_rst_n,
    rst_n
    };

assign ila_trig2 = {
    sys_data_out,
    sys_data_in
    };

assign ila_trig3 = {
    5'd0,
    cnt
    };

assign ila_trig4 = {
    8'd0,
    sys_wraddr
    };

alinx_icon my_icon_inst (
    .CONTROL0(CONTROL0), // INOUT BUS [35:0]
    .CONTROL1(CONTROL1) // INOUT BUS [35:0]
);

alinx_vio my_vio_inst (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .ASYNC_IN(ASYNC_IN), // IN BUS [7:0]
    .ASYNC_OUT(ASYNC_OUT) // OUT BUS [63:0]
);

alinx_ila my_ila_inst (
    .CONTROL(CONTROL1), // INOUT BUS [35:0]
    .CLK(clk_100m), // IN
    .TRIG0(ila_trig0), // IN BUS [3:0]
    .TRIG1(ila_trig1),// IN BUS [31:0]
    .TRIG2(ila_trig2), // IN BUS [31:0]
    .TRIG3(ila_trig3),// IN BUS [31:0]
    .TRIG4(ila_trig4) // IN BUS [31:0]
);
`endif
`endif
endmodule
