`timescale 1ns / 1ps

module clk_gen
(
    input   clk_50m_i,
    input   rst_n_i,
    output  clk,
    output  clk_100m,
    output  clk_100m_ref,
    output  rst_n,
    output  sdram_rst_n
);

wire        LOCKED;
wire        CLKFB;
reg         powerup_pll_locked;     // pll locked indicator for SDRAM clock
wire        clk_100m_bufg_i;
wire        clk_bufg_i;
reg [7:0]   rst_n_d;

assign clk = clk_100m;
IBUFG ibufg_u0(
    .O (clk_50m_ibufg_o),
    .I (clk_50m_i)
);

//BUFGCE bufg_clk1(
//    .O  (clk ),
//    .I  (clk_bufg_i),
//    .CE (LOCKED)
//);

BUFGCE bufgce_100m(
    .O  (clk_100m),
    .I  (clk_100m_bufg_i),
    .CE (LOCKED)
);

BUFGCE bufgce_100m_ref(
    .O  (clk_100m_ref),
    .I  (clk_100m_bufg_i),
    .CE (LOCKED)
);

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

  sdram_pll sdram_pll
   (// Clock in ports
    .CLK_IN1(clk_50m_ibufg_o),      // IN
    .CLKFB_IN(CLKFB),     // IN
    // Clock out ports
    //.CLK_OUT1(clk_bufg_i),     // OUT
    .CLK_OUT1(),     // OUT
    .CLK_OUT2(clk_100m_bufg_i),     // OUT
    .CLKFB_OUT(CLKFB),    // OUT
    // Status and control signals
    .RESET(~rst_n_i),// IN
    .LOCKED(LOCKED));      // OUT
endmodule
