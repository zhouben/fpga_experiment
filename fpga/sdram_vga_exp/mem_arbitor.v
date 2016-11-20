`timescale 1ns / 1ps

module mem_arbitor #(
    parameter DATA_DEPTH     = (1024*768),
    parameter WR_INIT_ADDR   = (0),
    parameter RD_INIT_ADRR   = (1024*1024)
)
(
    input           clk_sdram       , // 100MHz
    input           clk_sdram_ref   ,
    input           clk_mem_wr      ,
    input           clk_mem_rd      ,
    input           rst_n           ,
    output          mem_rdy         ,
    input           mem_toggle      ,
    output          mem_rdy_to_wr   ,   // memory is ready to be written
    input           mem_wr_req      ,   // external modules want to write data
    input [15:0]    mem_din         ,
    output          mem_rdy_to_rd   ,   // memory is ready to be read.
    input           mem_rd_req      ,
    output [15:0]   mem_dout        ,
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

localparam STATE_IDLE = 2'd0;
localparam STATE_PRE_TOGGLE = 2'd1;
localparam STATE_RW         = 2'd2;

wire        clk;
reg         mem_wr_load;
wire [23:0] mem_wr_addr;
wire        mem_wr_done;
wire        wr_fifo_rdy;
wire        wr_overrun ;
reg         mem_rd_load;
wire        mem_rd_done;
wire [23:0] mem_rd_addr;
wire [9:0]  rd_fifo_cnt;
wire        rd_fifo_empty;
wire        rd_underrun;

reg         mem_rd_done_d2;
reg         mem_rd_done_d1;


reg [1:0]   state;
reg [1:0]   state_next;
reg         mem_toggle_d1;
reg         mem_toggle_d2;
reg         mem_toggle_d3;
wire        kickoff;

reg         pingpong_state;

assign clk = clk_sdram;
assign mem_wr_addr = (~pingpong_state) ? WR_INIT_ADDR : RD_INIT_ADRR;
assign mem_rd_addr = ( pingpong_state) ? WR_INIT_ADDR : RD_INIT_ADRR;

assign mem_rdy_to_wr = (state == STATE_RW) && wr_fifo_rdy;
assign mem_rdy_to_rd = (state == STATE_RW) && ~rd_fifo_empty;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pingpong_state   <= 1'b0;
    end else begin
        pingpong_state  <= (state_next == STATE_PRE_TOGGLE) ? ~pingpong_state : pingpong_state;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state   <= STATE_IDLE;
    end else begin
        state   <= state_next;
    end
end

always @(*) begin
    state_next <= state;
    mem_wr_load <= 1'b0;
    mem_rd_load <= 1'b0;
    case (state)
        STATE_IDLE: begin
            if (kickoff) begin
                state_next <= STATE_PRE_TOGGLE;
            end
        end
        STATE_PRE_TOGGLE: begin
            mem_wr_load <= 1'b1;
            mem_rd_load <= 1'b1;
            state_next  <= STATE_RW;
        end
        STATE_RW: begin
            if (mem_rd_done_d2) begin
                state_next <= STATE_IDLE;
            end
        end
    endcase
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        mem_rd_done_d1 <= 1'b0;
        mem_rd_done_d2 <= 1'b0;
    end else begin
        mem_rd_done_d1 <= mem_rd_done;
        mem_rd_done_d2 <= mem_rd_done_d1;
    end
end

// toggle signal
assign kickoff = ~mem_toggle_d3 & mem_toggle_d2;
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        mem_toggle_d1 <= 1'b0;
        mem_toggle_d2 <= 1'b0;
        mem_toggle_d3 <= 1'b0;
    end else begin
        mem_toggle_d1 <= mem_toggle;
        mem_toggle_d2 <= mem_toggle_d1;
        mem_toggle_d3 <= mem_toggle_d2;
    end
end

sdram_mcb sdram_mcb
(
    .clk_sdram      (clk_sdram      ),   // input           100MHz
    .clk_sdram_ref  (clk_sdram_ref  ),   // input           100MHz for sdram
    .clk_wr         (clk_mem_wr     ),   // input           
    .clk_rd         (clk_mem_rd     ),
    .rst_n          (rst_n          ),   // input           
    .mem_rdy        (mem_rdy        ),
    .wr_load        (mem_wr_load    ),   // input           users request a new write operation
    .wr_addr        (mem_wr_addr    ),   // input [23:0]    write base address, {Bank{1:0], Row[12:0], Col[8:0]}
    .wr_length      (DATA_DEPTH[23:0]     ),   // input [23:0]    write length, 0's based.
    .wr_req         (mem_wr_req     ),   // input           write data input valid
    .din            (mem_din        ),   // input [15:0]    write data input
    .wr_done        (mem_wr_done    ),   // output          reply users currenct write complete.
    .wr_rdy         (wr_fifo_rdy    ),   // output          write fifo is valid
    .wr_overrun     (wr_overrun     ),   // output          
    .rd_load        (mem_rd_load    ),   // input           
    .rd_addr        (mem_rd_addr    ),   // input [23:0]    
    .rd_length      (DATA_DEPTH[23:0]     ),   // input [23:0]    
    .rd_req         (mem_rd_req     ),   // input           users request data read
    .dout           (mem_dout       ),   // output [15:0]   data output for read
    .rd_done        (mem_rd_done    ),   // output          reply users currenct read complete.
    .rd_fifo_cnt    (rd_fifo_cnt    ),   // output [9:0]    how many data units in rd fifo
    .rd_fifo_empty  (rd_fifo_empty  ),
    .rd_underrun    (rd_underrun    ),   // output          

    .S_CLK      (S_CLK   ),        //sdram clock
    .S_CKE      (S_CKE   ),        //sdram clock enable
    .S_NCS      (S_NCS   ),        //sdram chip select
    .S_NWE      (S_NWE   ),        //sdram write enable
    .S_NCAS     (S_NCAS  ),        //sdram column address strobe
    .S_NRAS     (S_NRAS  ),        //sdram row address strobe
    .S_DQM      (S_DQM   ),        //sdram data enable
    .S_BA       (S_BA    ),        //sdram bank address
    .S_A        (S_A     ),        //sdram address
    .S_DB       (S_DB    )         //sdram data
);
endmodule
