/****************************************************************************\
*
* Description	: SDRAM controller block
* Revision		: V1.0
* Date          : 2016/10/30 19:10:33
* Auther        : Zhou Changzhi
*
* Diagram:
* Users <--> sdram_mcb <--> sdram_top <--> SDRAM
*
* This module contains two fifos, read and write, with the depth of 1024.
* Users can request read/write with enough number of WORD data (16 bits) with
* wr_load/wr_addr/wr_length or rd_load/rd_addr/rd_length
* After that,
* 1) As for read, once data is ready, users can read data by rd_req/dout
* 2) As for write, once wr_rdy is active, users can write data by
* wr_req/wr_length.
*
\*--------------------------------------------------------------------------*/

`timescale 1ns/1ps
module sdram_mcb(
    input           clk_sdram       , // 100MHz
    input           clk_sdram_ref   ,
    input           clk_wr          ,
    input           clk_rd          ,
    input           rst_n           ,

    // users interface
    output          mem_rdy         ,
    input           wr_load         ,   // users request a new write operation
    input [23:0]    wr_addr         ,   // write base address, {Bank{1:0], Row[12:0], Col[8:0]}
    input [23:0]    wr_length       ,   // write length, 0's based.
    input           wr_req          ,   // write data input valid
    input [15:0]    din             ,   // write data input
    output          wr_done         ,   // reply users currenct write complete.
    output          wr_rdy          ,   // write fifo is valid
    output          wr_overrun      ,

    output [23:0]   dbg_wr_addr     ,
    output [23:0]   dbg_rd_addr     ,

    input           rd_load         ,
    input [23:0]    rd_addr         ,
    input [23:0]    rd_length       ,
    input           rd_req          ,   // users request data read
    output [15:0]   dout            ,   // data output for read
    output          rd_done         ,   // replay users currenct write complete.
    output [9:0]    rd_fifo_cnt     ,   // how many data units in rd fifo
    output          rd_fifo_empty   ,
    output          rd_underrun     ,

    // sdram interface
	output			S_CLK           ,   //sdram clock
	output			S_CKE           ,   //sdram clock enable
	output			S_NCS           ,   //sdram chip select
	output			S_NWE           ,   //sdram write enable
	output			S_NCAS          ,   //sdram column address strobe
	output			S_NRAS          ,   //sdram row address strobe
	output [1:0] 	S_DQM           ,   //sdram data enable
	output [1:0]	S_BA            ,   //sdram bank address
	output [12:0]	S_A             ,   //sdram address
	inout  [15:0]	S_DB                //sdram data

);

localparam IDLE          = 4'd0;
localparam PRE_WR        = 4'd1;
localparam WRITING       = 4'd2;
localparam WR_STAGE_CPLT = 4'd3;
localparam WR_DONE       = 4'd4;
localparam PRE_RD        = 4'd5;
localparam READING       = 4'd6;
localparam RD_STAGE_CPLT = 4'd7;
localparam RD_DONE       = 4'd8;

// rd/wr clock domain
reg [23:0]  wr_addr_d1;
reg [23:0]  wr_addr_d2;
reg [23:0]  wr_length_d1;
reg [23:0]  wr_length_d2;
reg         wr_load_d1;
reg         wr_load_d2;
reg         wr_load_d3;
wire        wr_load_pulse;
reg [23:0]  wr_addr_r;
reg [23:0]  wr_length_r;
wire [9:0]  stage_wr_bytes;
reg [9:0]   stage_sdram_wr_cnt;

wire        wr_done_internal;
reg         wr_done_d1;
reg         wr_done_d2;
reg         wr_done_d3;

reg [9:0]   sdwr_byte;
reg         sdram_wr_req;
wire        wr_fifo_ren;
wire[15:0]  wr_fifo_dout;
wire        wr_fifo_full;
wire        wr_fifo_almost_full;
wire        wr_fifo_overflow;
reg         wr_pending; // current wr transaction is still going on.
wire        wr_fifo_empty;
wire [9:0]  wr_fifo_rd_count;
wire [9:0]  wr_fifo_wr_count;
reg  [9:0]  wr_fifo_wr_count_d1;
reg  [9:0]  wr_fifo_wr_count_d2;

reg [3:0]   state;
reg [3:0]   state_next;
reg [1:0]   cnt;
reg  [1:0]  cnt_next;
reg         rw_toggle;
reg         rw_toggle_next;
wire        sdram_init_done;

reg [23:0]  rd_addr_d1;
reg [23:0]  rd_addr_d2;
reg [23:0]  rd_length_d1;
reg [23:0]  rd_length_d2;
reg         rd_load_d1;
reg         rd_load_d2;
reg         rd_load_d3;
wire        rd_load_pulse;
reg [23:0]  rd_addr_r;
reg [23:0]  rd_length_r;
wire [9:0]  stage_rd_bytes;
reg [9:0]   stage_sdram_rd_cnt;

reg [9:0]   sdrd_byte;
reg         sdram_rd_req;
reg         rd_pending; // current rd transaction is still going on.
wire        rd_fifo_wen;
wire        rd_fifo_full;
wire [15:0] rd_fifo_din;
wire [9:0]  rd_fifo_wr_count;
wire [9:0]  rd_fifo_rd_count;

assign S_CLK   = clk_sdram_ref;
assign S_DQM   = 2'b0;  //sdram data enable
assign mem_rdy = sdram_init_done;

/****************************************************************************\
*                                                                            *
*                       Debug module                                         *
*                                                                            *
\****************************************************************************/
assign dbg_wr_addr = wr_addr_r;
assign dbg_rd_addr = rd_addr_r;

/****************************************************************************\
*                                                                            *
*                       Write Part (WrFIFO and Write Logic)                  *
*                                                                            *
\****************************************************************************/
assign wr_load_pulse    = wr_load_d2 & ~wr_load_d3;
assign wr_done_internal = (state == WR_DONE) ? 1'b1 : 1'b0;
assign wr_done          = wr_done_d2 & ~wr_done_d3;
assign stage_wr_bytes   = (10'd512 - {1'b0, wr_addr_r[8:0]}) < wr_length_r ? (10'd512 - {1'b0, wr_addr_r[8:0]}) : wr_length_r;
assign wr_rdy = (sdram_init_done && ~wr_fifo_almost_full);

always @(posedge clk_wr, negedge rst_n) begin
    if (~rst_n) begin
        wr_done_d1  <= 1'b0;
        wr_done_d2  <= 1'b0;
        wr_done_d3  <= 1'b0;
    end else begin
        wr_done_d1  <= wr_done_internal;
        wr_done_d2  <= wr_done_d1;
        wr_done_d3  <= wr_done_d2;
    end
end

// sync wr_addr and wr_length with internal clock domain
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        wr_addr_d1      <= 24'd0;
        wr_addr_d2      <= 24'd0;
        wr_length_d1    <= 24'd0;
        wr_length_d2    <= 24'd0;
        wr_load_d1      <= 1'b0;
        wr_load_d2      <= 1'b0;
        wr_load_d3      <= 1'b0;
    end else begin
        wr_addr_d1      <= wr_addr;
        wr_addr_d2      <= wr_addr_d1;
        wr_length_d1    <= wr_length;
        wr_length_d2    <= wr_length_d1;
        wr_load_d1      <= wr_load;
        wr_load_d2      <= wr_load_d1;
        wr_load_d3      <= wr_load_d2;
    end
end

// register wr_addr_r and wr_length_r
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        wr_addr_r   <= 24'd0;
        wr_length_r <= 24'd0;
    end else begin
        if (wr_load_pulse && ~wr_pending) begin
            wr_addr_r   <= wr_addr_d2;
            wr_length_r <= wr_length_d2;
        end else if (WR_STAGE_CPLT == state_next)begin
            wr_length_r <= wr_length_r - stage_sdram_wr_cnt;
            wr_addr_r   <= wr_addr_r + stage_sdram_wr_cnt;
        end
    end
end

// wr_pending
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        wr_pending  <= 1'b0;
    end else begin
        if (wr_load_pulse && ~wr_pending) begin
            wr_pending <= 1'b1;
        end else if (state_next == WR_DONE) begin
            wr_pending <= 1'b0;
        end
    end
end

// stage_sdram_wr_cnt
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        stage_sdram_wr_cnt   <= 10'b0;
    end else begin
        case (state_next)
            PRE_WR: begin
                stage_sdram_wr_cnt <= 10'b0;
            end
            WRITING: begin
                if(wr_fifo_ren) begin
                    stage_sdram_wr_cnt <= stage_sdram_wr_cnt + 10'd1;
                end
            end
        endcase
    end
end

// sdram_wr_req
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n)                     sdram_wr_req <= 1'b0;
    else if(PRE_WR == state_next)   sdram_wr_req <= 1'b1;
    else if((WRITING == state_next) && (sdram_wr_req == 1'b1) && (wr_fifo_ren == 1'b1)) sdram_wr_req <= 1'b0;
    else                            sdram_wr_req <= sdram_wr_req;
end

// sdwr_byte
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n)                     sdwr_byte <= 10'd0;
    else if(PRE_WR == state_next)   sdwr_byte <= stage_wr_bytes;
    else                            sdwr_byte <= sdwr_byte;
end

// sync wr_fifo_wr_count from RW clock doman to SDRAM domain
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        wr_fifo_wr_count_d1 <= 10'd0;
        wr_fifo_wr_count_d2 <= 10'd0;
    end else begin
        wr_fifo_wr_count_d1 <= wr_fifo_wr_count;
        wr_fifo_wr_count_d2 <= wr_fifo_wr_count_d1;
    end
end

// rw_toggle
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        rw_toggle   <= 1'b0;
    end else begin
        rw_toggle   <= rw_toggle_next;
    end
end

/****************************************************************************\
*                                                                            *
*            Main FSM (Combination and Sequential Logic)                     *
*                                                                            *
\****************************************************************************/
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        cnt   <= 2'd0;
    end else begin
        cnt   <= cnt_next;
    end
end

always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        state   <= IDLE;
    end else begin
        state   <= state_next;
    end
end

always @(*) begin
    rw_toggle_next  <= rw_toggle;
    cnt_next        <= cnt;
    state_next      <= state;
    case (state)
        IDLE: begin
            state_next <= IDLE;
            case ({rw_toggle, wr_pending, rd_pending})
                3'b000, 3'b100          : begin
                    state_next <= IDLE;
                end
                3'b010, 3'b110: begin
                    if( wr_fifo_rd_count >= stage_wr_bytes ) begin
                        /*wr_fifo_wr_count_d2*/
                        state_next <= PRE_WR;
                    end
                end
                3'b001, 3'b101: begin
                    if(rd_fifo_wr_count + stage_rd_bytes < 1023) begin
                        state_next <= PRE_RD;
                    end
                end
                3'b111, 3'b011: begin
                    if(rd_fifo_wr_count + stage_rd_bytes < 1023) begin
                        state_next <= PRE_RD;
                    end else if( wr_fifo_rd_count >= stage_wr_bytes ) begin
                        state_next <= PRE_WR;
                    end
                end
            endcase
            
            //case ({rw_toggle, wr_pending, rd_pending})
            //    3'b000, 3'b100          : begin
            //        state_next <= IDLE;
            //    end
            //    3'b010, 3'b110: begin
            //        if( wr_fifo_rd_count >= stage_wr_bytes ) begin
            //            /*wr_fifo_wr_count_d2*/
            //            state_next <= PRE_WR;
            //        end
            //    end
            //    3'b001, 3'b101: begin
            //        if(rd_fifo_wr_count + stage_rd_bytes < 1023) begin
            //            state_next <= PRE_RD;
            //        end
            //    end
            //    3'b011: begin
            //        if( wr_fifo_rd_count >= stage_wr_bytes ) begin
            //            /*wr_fifo_wr_count_d2*/
            //            state_next <= PRE_WR;
            //        end else if(rd_fifo_wr_count + stage_rd_bytes < 1023) begin
            //            state_next <= PRE_RD;
            //        end
            //    end
            //    3'b111: begin
            //        if(rd_fifo_wr_count + stage_rd_bytes < 1023) begin
            //            state_next <= PRE_RD;
            //        end else if( wr_fifo_rd_count >= stage_wr_bytes ) begin
            //            state_next <= PRE_WR;
            //        end
            //    end
            //endcase
        end
        PRE_WR: begin
            state_next <= WRITING;
        end
        WRITING: begin
            if (stage_sdram_wr_cnt == sdwr_byte) begin
                state_next <= WR_STAGE_CPLT;
            end
        end
        WR_STAGE_CPLT: begin
            rw_toggle_next  <= ~rw_toggle;
            if (wr_length_r == 0) begin
                state_next  <= WR_DONE;
                cnt_next    <= 2'd0;
            end else begin
                state_next  <= IDLE;
            end
        end
        WR_DONE: begin
            cnt_next <= cnt + 2'd1;
            if (2'd2 == cnt) state_next <= IDLE;
            else             state_next <= WR_DONE;
        end
        PRE_RD: begin
            state_next <= READING;
        end
        READING: begin
            if (stage_sdram_rd_cnt == sdrd_byte) begin
                state_next <= RD_STAGE_CPLT;
            end
        end
        RD_STAGE_CPLT: begin
            rw_toggle_next  <= ~rw_toggle;
            if (rd_length_r == 0) state_next    <= RD_DONE;
            else                  state_next    <= IDLE;
        end
        RD_DONE: state_next <= IDLE;
    endcase
end

/****************************************************************************\
*                                                                            *
*                       Read Part (FIFO and Read Logic)                      *
*                                                                            *
\****************************************************************************/
assign rd_load_pulse = rd_load_d2 & ~rd_load_d3;
assign rd_done = (state == RD_DONE) ? 1'b1 : 1'b0;
assign stage_rd_bytes = (10'd512 - {1'b0, rd_addr_r[8:0]}) < rd_length_r ? (10'd512 - {1'b0, rd_addr_r[8:0]}) : rd_length_r;
assign rd_rdy = (sdram_init_done && ~rd_fifo_empty);
assign rd_fifo_cnt = rd_fifo_rd_count;

// sync rd_addr and rd_length with internal clock domain
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        rd_addr_d1      <= 24'd0;
        rd_addr_d2      <= 24'd0;
        rd_length_d1    <= 24'd0;
        rd_length_d2    <= 24'd0;
        rd_load_d1      <= 1'b0;
        rd_load_d2      <= 1'b0;
        rd_load_d3      <= 1'b0;
    end else begin
        rd_addr_d1      <= rd_addr;
        rd_addr_d2      <= rd_addr_d1;
        rd_length_d1    <= rd_length;
        rd_length_d2    <= rd_length_d1;
        rd_load_d1      <= rd_load;
        rd_load_d2      <= rd_load_d1;
        rd_load_d3      <= rd_load_d2;
    end
end

// register rd_addr_r and rd_length_r
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        rd_addr_r   <= 24'd0;
        rd_length_r <= 24'd0;
    end else begin
        if (rd_load_pulse && ~rd_pending) begin
            rd_addr_r   <= rd_addr_d2;
            rd_length_r <= rd_length_d2;
        end else if (RD_STAGE_CPLT == state_next)begin
            rd_length_r <= rd_length_r - stage_sdram_rd_cnt;
            rd_addr_r   <= rd_addr_r + stage_sdram_rd_cnt;
        end
    end
end

// rd_pending
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        rd_pending  <= 1'b0;
    end else begin
        if (rd_load_pulse && ~rd_pending) begin
            rd_pending <= 1'b1;
        end else if (state_next == RD_DONE) begin
            rd_pending <= 1'b0;
        end
    end
end

// stage_sdram_rd_cnt
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n) begin
        stage_sdram_rd_cnt   <= 10'b0;
    end else begin
        case (state_next)
            PRE_RD: begin
                stage_sdram_rd_cnt <= 10'b0;
            end
            READING: begin
                if(rd_fifo_wen) begin
                    stage_sdram_rd_cnt <= stage_sdram_rd_cnt + 10'd1;
                end
            end
        endcase
    end
end

// sdram_rd_req
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n)                     sdram_rd_req <= 1'b0;
    else if(PRE_RD == state_next)   sdram_rd_req <= 1'b1;
    else if((READING == state_next) && (sdram_rd_req == 1'b1) && (rd_fifo_wen == 1'b1))  sdram_rd_req <= 1'b0;
    else                            sdram_rd_req <= sdram_rd_req;
end

// sdrd_byte
always @(posedge clk_sdram, negedge rst_n) begin
    if (~rst_n)                     sdrd_byte <= 10'd0;
    else if(PRE_RD == state_next)   sdrd_byte <= stage_rd_bytes;
    else                            sdrd_byte <= sdrd_byte;
end

// sdram clock doman
sdram_top sdram_top
(
	//global clock
	.clk				(clk_sdram      ),  //sdram reference clock
	.rst_n				(rst_n          ),  //global reset

	//internal interface
	.sdram_wr_req		(sdram_wr_req   ), 	//sdram write request
	.sdram_rd_req		(sdram_rd_req   ), 	//sdram write ack
	.sdram_wr_ack		(wr_fifo_ren    ), 	//sdram read request
	.sdram_rd_ack		(rd_fifo_wen    ),	//sdram read ack
	.sys_wraddr			(wr_addr_r      ), 	//sdram write address
	.sys_rdaddr			(rd_addr_r      ), 	//sdram read address
	.sys_data_in		(wr_fifo_dout   ),  //fifo 2 sdram data input
	.sys_data_out		(rd_fifo_din    ),  //sdram 2 fifo data input
	.sdram_init_done	(sdram_init_done),	//sdram init done

	//burst length
	.sdwr_byte			(sdwr_byte      ),	//sdram write burst length
	.sdrd_byte			(sdrd_byte      ),	//sdram read burst length

	//sdram interface
//	.sdram_clk			(sdram_clk),		//sdram clock
	.sdram_cke			(S_CKE          ),	//sdram clock enable
	.sdram_cs_n			(S_NCS          ),	//sdram chip select
	.sdram_we_n			(S_NWE          ),	//sdram write enable
	.sdram_ras_n		(S_NRAS         ),	//sdram column address strobe
	.sdram_cas_n		(S_NCAS         ),	//sdram row address strobe
	.sdram_ba			(S_BA           ),	//sdram data enable (H:8)
	.sdram_addr			(S_A            ),	//sdram data enable (L:8)
	.sdram_data			(S_DB           )	//sdram bank address
//	.sdram_udqm			(sdram_udqm),		//sdram address
//	.sdram_ldqm			(sdram_ldqm)		//sdram data
);
sdram_wr_fifo sdram_wr_fifo (
  .rst(~rst_n), // input rst
  .wr_clk(clk_wr), // input wr_clk
  .rd_clk(clk_sdram), // input rd_clk
  .din(din), // input [15 : 0] din
  .wr_en(wr_req), // input wr_en
  .rd_en(wr_fifo_ren), // input rd_en
  .dout(wr_fifo_dout), // output [15 : 0] dout
  .full(wr_fifo_full), // output full
  .almost_full(wr_fifo_almost_full),
  .overflow(wr_fifo_overflow),
  .empty(wr_fifo_empty), // output empty
  .rd_data_count(wr_fifo_rd_count), // output [9 : 0] rd_data_count
  .wr_data_count(wr_fifo_wr_count) // output [9 : 0] wr_data_count
);

// read fifo, depth = 1023
sdram_rd_fifo sdram_rd_fifo (
  .rst(~rst_n), // input rst
  .wr_clk(clk_sdram), // input wr_clk
  .rd_clk(clk_rd), // input rd_clk
  .din(rd_fifo_din), // input [15 : 0] din
  .wr_en(rd_fifo_wen), // input wr_en
  .rd_en(rd_req), // input rd_en
  .dout(dout), // output [15 : 0] dout
  .full(rd_fifo_full), // output full
  .empty(rd_fifo_empty), // output empty
  .underflow(rd_fifo_underflow),
  .rd_data_count(rd_fifo_rd_count), // output [9 : 0] rd_data_count
  .wr_data_count(rd_fifo_wr_count) // output [9 : 0] wr_data_count
);

endmodule
