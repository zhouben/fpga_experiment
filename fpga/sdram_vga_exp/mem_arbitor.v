`timescale 1ns / 1ps

module mem_arbitor #(
    parameter WR_DATA_DEPTH  = (1024*768),
    parameter RD_DATA_DEPTH  = (1024*768),
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
    input           vga_data_lock   ,   // indicate vga is holding data
    output reg      vga_new_frame   ,   // allow vga data generating module to generate data.
    output          mem_rdy_to_wr   ,   // memory is ready to be written
    input           mem_wr_req      ,   // external modules want to write data
    input [15:0]    mem_din         ,
    output          mem_rdy_to_rd   ,   // memory is ready to be read.
    input           mem_rd_req      ,

    output          dbg_mem_wr_load ,
    output [23:0]   dbg_wr_load_addr,
    output          dbg_mem_rd_load ,
    output [23:0]   dbg_rd_load_addr,
    output [23:0]   dbg_wr_addr     ,
    output [23:0]   dbg_rd_addr     ,
    output          dbg_pingpong    ,
    output          dbg_write_level ,
    output          dbg_data_lock   ,

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
wire        local_rst_n;
wire        mem_wr_load;
wire [23:0] mem_wr_addr;
wire        mem_wr_done;
wire        wr_fifo_rdy;
wire        wr_overrun ;
wire        mem_rd_load;
wire        mem_rd_done;
wire [23:0] mem_rd_addr;
wire [9:0]  rd_fifo_cnt;
wire        rd_fifo_empty;
wire        rd_underrun;

reg         mem_rd_done_d2;
reg         mem_rd_done_d1;

reg         mem_toggle_d1;
reg         mem_toggle_d2;
reg         mem_toggle_d3;
reg         vga_data_lock_d1;
reg         vga_data_lock_d2;

reg         pingpong_state;
reg         vga_write_data_level;   // 1: vga_gen_data is writing date, 0: vga_gen_data isn't writing data.
reg [4:0]   vga_new_frame_count;

assign clk = clk_sdram;
assign local_rst_n = rst_n & mem_rdy;

assign mem_wr_load = (|vga_new_frame_count[4:1]);
assign mem_rd_load = (|vga_new_frame_count[4:1]);
assign mem_wr_addr = (~pingpong_state) ? WR_INIT_ADDR : RD_INIT_ADRR;
assign mem_rd_addr = ( pingpong_state) ? WR_INIT_ADDR : RD_INIT_ADRR;

assign mem_rdy_to_wr = (vga_write_data_level) && wr_fifo_rdy;
assign mem_rdy_to_rd = (vga_data_lock_d2) && ~rd_fifo_empty;

assign dbg_mem_wr_load = mem_wr_load;
assign dbg_wr_load_addr= mem_wr_addr;
assign dbg_mem_rd_load = mem_rd_load;
assign dbg_rd_load_addr= mem_rd_addr;
assign dbg_pingpong    = pingpong_state;
assign dbg_write_level = vga_write_data_level;
assign dbg_data_lock   = vga_data_lock;

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        pingpong_state  <= 1'b0;
    end else begin
        pingpong_state  <= (vga_new_frame_count[0] == 1'b1) ? ~pingpong_state : pingpong_state;
    end
end

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        mem_rd_done_d1 <= 1'b0;
        mem_rd_done_d2 <= 1'b0;
    end else begin
        mem_rd_done_d1 <= mem_rd_done;
        mem_rd_done_d2 <= mem_rd_done_d1;
    end
end

// toggle signal

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        vga_data_lock_d1 <= 1'b0;
        vga_data_lock_d2 <= 1'b0;
    end else begin
        vga_data_lock_d1 <= vga_data_lock;
        vga_data_lock_d2 <= vga_data_lock_d1;
    end
end

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        vga_new_frame    <= 1'b0;
    end else begin
        if (vga_new_frame) begin
            vga_new_frame <= (mem_wr_req) ? 1'b0 : 1'b1;
        end else begin
            vga_new_frame <= (vga_new_frame_count[0]) ? 1'b1 : 1'b0;
        end
    end
end

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        vga_write_data_level    <= 1'b0;
    end else begin
        if (mem_wr_done) begin
            vga_write_data_level <= 1'b0;
        end else if (vga_new_frame_count[1]) begin
            vga_write_data_level <= 1'b1;
        end else begin
            vga_write_data_level <= vga_write_data_level;
        end
    end
end

always @(posedge clk, negedge local_rst_n) begin
    if (~local_rst_n) begin
        vga_new_frame_count     <= 5'b0;
    end else begin
        if ((|vga_new_frame_count) == 1'b0) begin
            if (~(vga_write_data_level | vga_data_lock_d2)) begin
                vga_new_frame_count[0] <= 1'b1;
            end
        end else begin
            vga_new_frame_count <= {vga_new_frame_count[3:0], 1'b0};
        end
    end
end

sdram_mcb sdram_mcb
(
    .clk_sdram      (clk_sdram          ),   // input           100MHz
    .clk_sdram_ref  (clk_sdram_ref      ),   // input           100MHz for sdram
    .clk_wr         (clk_mem_wr         ),   // input           
    .clk_rd         (clk_mem_rd         ),
    .rst_n          (rst_n              ),   // input           
    .mem_rdy        (mem_rdy            ),
    .wr_load        (mem_wr_load        ),   // input           users request a new write operation
    .wr_addr        (mem_wr_addr        ),   // input [23:0]    write base address, {Bank{1:0], Row[12:0], Col[8:0]}
    .wr_length      (WR_DATA_DEPTH[23:0]),   // input [23:0]    write length, 0's based.
    .wr_req         (mem_wr_req         ),   // input           write data input valid
    .din            (mem_din            ),   // input [15:0]    write data input
    .wr_done        (mem_wr_done        ),   // output          reply users currenct write complete.
    .wr_rdy         (wr_fifo_rdy        ),   // output          write fifo is valid
    .wr_overrun     (wr_overrun         ),   // output          
    .rd_load        (mem_rd_load        ),   // input           
    .rd_addr        (mem_rd_addr        ),   // input [23:0]    
    .rd_length      (RD_DATA_DEPTH[23:0]),   // input [23:0]    
    .rd_req         (mem_rd_req         ),   // input           users request data read
    .dout           (mem_dout           ),   // output [15:0]   data output for read
    .rd_done        (mem_rd_done        ),   // output          reply users currenct read complete.
    .rd_fifo_cnt    (rd_fifo_cnt        ),   // output [9:0]    how many data units in rd fifo
    .rd_fifo_empty  (rd_fifo_empty      ),
    .rd_underrun    (rd_underrun        ),   // output          

    .dbg_wr_addr    (dbg_wr_addr        ),
    .dbg_rd_addr    (dbg_rd_addr        ),

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
