`timescale 1ns/1ps

module sdram_vga_clk_gen
(
    input  clk_50m_i   ,
    input  rst_n_i     ,
    output clk_50m     ,
    output clk_vga     , // 62.5M
    output clk_100m    ,
    output clk_100m_ref,
    output rst_n       ,
    output sdram_rst_n 
);

wire        LOCKED;
wire        CLKFB;
reg         powerup_pll_locked;     // pll locked indicator for SDRAM clock

wire        clk_50m_bufg_i;
wire        clk_vga_bufg_i;
wire        clk_100m_bufg_i;
wire        clk_100m_bufg_o;
reg [7:0]   rst_n_d;

IBUFG ibufg_u0(
    .O (clk_50m_ibufg_o),
    .I (clk_50m_i)
);

BUFG bufg_clk_50m(
    .O  (clk_50m),
    .I  (clk_50m_ibufg_o)
);

BUFGCE bufg_clk_vga(
    .O  (clk_vga),
    .I  (clk_vga_bufg_i),
    .CE (LOCKED)
);

BUFGCE bufgce_clk_100m(
    .O  (clk_100m),
    .I  (clk_100m_bufg_i),
    .CE (LOCKED)
);

BUFGCE bufgce_100m_ref(
    .O  (clk_100m_bufg_o),
    .I  (clk_100m_bufg_i),
    .CE (LOCKED)
);

`ifdef MODELSIM_DBG
assign clk_100m_ref = clk_100m_bufg_o;
`else
ODDR2 #(
    .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1"
    .INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
    .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
    ) U_ODDR2_100MHZ
(
      .Q(clk_100m_ref),   // 1-bit DDR output data
      .C0(clk_100m_bufg_o),   // 1-bit clock input
      .C1(~clk_100m_bufg_o),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D0(1'b1), // 1-bit data input (associated with C0)
      .D1(1'b0), // 1-bit data input (associated with C1)
      .R(1'b0),   // 1-bit reset input
      .S(1'b0)    // 1-bit set input
);
`endif

/*
|<- rst_n_i assert ->|
|      pll not lock --->|<- pll locked --->|<-- pll not locked -->|<-- pll recovery -->|<- rst_n_i
|                        |<- sdram_rst_n not assert                                 -->|

1. sdram_rst_n only looks at pll_lock from PLL during power up. After
   power up and pll_lock is asserted, the powerup_pll_locked will be asserted
   forever until rst_n_i is asserted again. PLL will lose lock when FPGA 
   enters suspend mode. We don't want reset to MCB get
   asserted in the application that needs suspend feature.
*/
assign sdram_rst_n = rst_n_i & powerup_pll_locked;

always @(posedge clk_100m, negedge rst_n_i) begin
    if (~rst_n_i)       powerup_pll_locked <= 1'b0;
    else if (LOCKED)    powerup_pll_locked <= 1'b1;
end

assign rst_n = rst_n_d[7];
always @(posedge clk_100m, negedge rst_n_i) begin
    if (~rst_n_i)       rst_n_d <= 7'b0;
    else if (LOCKED)    rst_n_d <= {rst_n_d[6:0], 1'b1};
    else                rst_n_d <= 7'b0;
end

sdram_vga_pll sdram_vga_pll (
    .CLK_IN1(clk_50m_ibufg_o),    // IN
    .CLK_OUT1(clk_vga_bufg_i),    // OUT
    .CLK_OUT2(clk_100m_bufg_i),   // OUT
    .RESET(~rst_n_i),             // IN
    .LOCKED(LOCKED));             // OUT

endmodule
