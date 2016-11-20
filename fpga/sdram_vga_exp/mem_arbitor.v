`timescale 1ns / 1ps

module mem_arbitor #(
    .DATA_DEPTH (1024*768)
)
(
    input           clk_sdram       , // 100MHz
    input           clk_sdram_ref   ,
    input           clk_mem_wr      ,
    input           clk_mem_rd      ,
    input           rst_n           ,
    output          mem_rdy         ,
    input           mem_toggle      ,
    output          mem_wr_rdy      ,   // memory is ready to be written
    input           mem_wr_req      ,   // external modules want to write data
    input [15:0]    mem_din         ,
    output          mem_rd_rdy      ,   // memory is ready to be read.
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

sdram_mcb sdram_mcb
(
    .clk_sdram      (clk_sdram      ),   // input           100MHz
    .clk_sdram_ref  (clk_sdram_ref  ),   // input           100MHz for sdram
    .clk_wr         (clk_mem_wr     ),   // input           
    .clk_rd         (clk_mem_rd     ),
    .rst_n          (rst_n          ),   // input           
    .wr_load        (wr_load        ),   // input           users request a new write operation
    .wr_addr        (wr_addr        ),   // input [23:0]    write base address, {Bank{1:0], Row[12:0], Col[8:0]}
    .wr_length      (DATA_DEPTH     ),   // input [23:0]    write length, 0's based.
    .wr_req         (wr_req         ),   // input           write data input valid
    .din            (din            ),   // input [15:0]    write data input
    .wr_done        (wr_done        ),   // output          reply users currenct write complete.
    .wr_rdy         (wr_rdy         ),   // output          write fifo is valid
    .wr_overrun     (wr_overrun     ),   // output          
    .rd_load        (rd_load        ),   // input           
    .rd_addr        (rd_addr        ),   // input [23:0]    
    .rd_length      (DATA_DEPTH     ),   // input [23:0]    
    .rd_req         (rd_req         ),   // input           users request data read
    .dout           (dout           ),   // output [15:0]   data output for read
    .rd_done        (rd_done        ),   // output          reply users currenct read complete.
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
