`timescale 1ns / 1ps

module sdram_vga_exp(
    input           clk_50m_i   , // 100MHz
    input           sw_rst_n    ,

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
localparam DATA_DEPTH = 1024*40;
wire        frame_sync      ;
wire        clk_50m         ;
wire        clk_vga         ;
wire        clk_100m        ;
wire        clk_100m_ref    ;
wire        rst_clk_n_o     ;
wire        rst_n           ;
wire        sdram_rst_n     ;
wire        mem_rdy         ;
wire [15:0] mem_din         ;
wire        mem_wr_req      ;
wire        mem_rdy_to_wr   ;
wire        mem_rdy_to_rd   ;
wire [15:0] mem_dout        ;
wire        vga_gen_den     ;
wire [15:0] vga_gen_dout    ;
wire [15:0] vga_din         ;

assign rst_n = rst_clk_n_o & mem_rdy;
assign mem_din = mem_rdy ? vga_gen_dout : 16'bx;
assign mem_wr_req = mem_rdy ? vga_gen_den : 1'bx;
assign vga_din = mem_rdy ? mem_dout : 16'd0;

sdram_vga_clk_gen sdram_vga_clk_gen
(
    .clk_50m_i   (clk_50m_i      ),
    .rst_n_i     (sw_rst_n       ),
    .clk_50m     (clk_50m        ),
    .clk_vga     (clk_vga        ), // 62.5M
    .clk_100m    (clk_100m       ),
    .clk_100m_ref(clk_100m_ref   ),
    .rst_n       (rst_clk_n_o    ),
    .sdram_rst_n (sdram_rst_n    )
);

vga_data_gen #(
    .DATA_DEPTH (DATA_DEPTH)
) vga_data_gen(
    .clk     (clk_50m       ),
    .rst_n   (rst_n         ),
    .start_i (frame_sync    ),
    .wr_en   (mem_rdy_to_wr ),
    .data_en (vga_gen_den   ),
    .dout    (vga_gen_dout  )
);

mem_arbitor #(
    .WR_DATA_DEPTH (DATA_DEPTH)
) mem_arbitor(
    .clk_sdram      (clk_100m       ),   // input           100MHz
    .clk_sdram_ref  (clk_100m_ref   ),   // input           100MHz for sdram
    .clk_mem_wr     (clk_50m        ),
    .clk_mem_rd     (clk_vga        ),
    .rst_n          (rst_clk_n_o    ),
    .mem_rdy        (mem_rdy        ),
    .mem_toggle     (frame_sync     ),
    .mem_rdy_to_wr  (mem_rdy_to_wr  ),
    .mem_wr_req     (mem_wr_req     ),
    .mem_din        (mem_din        ),
    .mem_rdy_to_rd  (mem_rdy_to_rd  ),
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
    .frame_sync  (frame_sync ),
    .data_req    (mem_rd_req ),
    .din         (vga_din    ),
    .vga_hsync   (vga_hsync  ),
    .vga_vsync   (vga_vsync  ),
    .vga_red     (vga_red    ),
    .vga_green   (vga_green  ),
    .vga_blue    (vga_blue   )
);

endmodule
