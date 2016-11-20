`timescale 1ns / 1ps

module sdram_vga_exp(
    input           clk_50m_i   , // 100MHz
    input           rst_n_i     ,

    // sdram interface
	output			S_CLK   ,   //sdram clock
	output			S_CKE   ,   //sdram clock enable
	output			S_NCS   ,   //sdram chip select
	output			S_NWE   ,   //sdram write enable
	output			S_NCAS  ,   //sdram column address strobe
	output			S_NRAS  ,   //sdram row address strobe
	output [1:0] 	S_DQM   ,   //sdram data enable
	output [1:0]	S_BA    ,   //sdram bank address
	output [12:0]	S_A     ,   //sdram address
	inout  [15:0]	S_DB    ,   //sdram data

    // VGA bus
    output          vga_hsync   ,
    output          vga_vsync   ,
    output [4:0]    vga_red     ,
    output [5:0]    vga_green   ,
    output [4:0]    vga_blue    ,

    output          led_0
);

sdram_vga_clk_gen sdram_vga_clk_gen
(
    .clk_50m_i   (clk_50m_i      ),
    .rst_n_i     (rst_n_i        ),
    .clk_50m     (clk_50m        ),
    .clk_vga     (clk_vga        ), // 62.5M
    .clk_100m    (clk_100m       ),
    .clk_100m_ref(clk_100m_ref   ),
    .rst_n       (rst_n          ),
    .sdram_rst_n (sdram_rst_n    )
);

vga_data_gen #(
    .DATA_DEPTH (1024*768)
)(
    .clk     (clk_50m       ),
    .rst_n   (rst_n         ),
    .start_i (mem_toggle    ),
    .wr_en   (mem_wr_rdy    ),
    .data_en (mem_wr_req    ),
    .dout    (mem_din       )
);

mem_arbitor(
    .clk_sdram      (clk_100m       ),   // input           100MHz
    .clk_sdram_ref  (clk_100m_ref   ),   // input           100MHz for sdram
    .clk_mem_wr     (clk_50m        ),
    .clk_mem_rd     (clk_vga        ),
    .rst_n          (rst_n          ),
    .mem_rdy        (mem_rdy        ),
    .mem_toggle     (mem_toggle     ),
    .mem_wr_rdy     (mem_wr_rdy     ),
    .mem_wr_req     (mem_wr_req     ),
    .mem_din        (mem_din        ),
    .mem_rd_rdy     (mem_rd_rdy     ),
    .mem_rd_req     (mem_rd_req     ),
    .mem_dout       (mem_dout       ),
    .S_CLK          (S_CLK          ),        //sdram clock
    .S_CKE          (S_CKE          ),        //sdram clock enable
    .S_NCS          (S_NCS          ),        //sdram chip select
    .S_NWE          (S_NWE          ),        //sdram write enable
    .S_NCAS         (S_NCAS         ),        //sdram column address strobe
    .S_NRAS         (S_NRAS         ),        //sdram row address strobe
    .S_DQM          (S_DQM          ),        //sdram data enable
    .S_BA           (S_BA           ),        //sdram bank address
    .S_A            (S_A            ),        //sdram address
    .S_DB           (S_DB           )         //sdram data
);

vga_ctrl vga_ctrl(
    .clk         (clk_vga    ),
    .rst_n       (rst_n      ),
    .frame_sync  (mem_toggle ),
    .data_req    (mem_rd_req ),
    .din         (mem_dout   ),
    .vga_hsync   (vga_hsync  ),
    .vga_vsync   (vga_vsync  ),
    .vga_red     (vga_red    ),
    .vga_green   (vga_green  ),
    .vga_blue    (vga_blue   )
);

endmodule
