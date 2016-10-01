`timescale 1ns / 100ps
/*
----------------------------------------
Zhou Changzhi
test bench to control OLED display by I2C bus.
----------------------------------------

%MODULE_TITLE%

Authors:  %AUTHOR% (%AUTHOR_EMAIL%)

Description:
  %MODULE_DESCRIPTION%
*/
module ddr3_tb ();
parameter CLOCKPERIOD       = 20;
parameter CLOCKPERIOD_20M   = 50;
parameter OLED_CHIP_ADDR    = 7'h3C;
localparam C1_NUM_DQ_PINS            = 16;
localparam C1_MEM_ADDR_WIDTH         = 14;
localparam C1_MEM_BANKADDR_WIDTH     = 3;
localparam C1_P0_MASK_SIZE           = 16;
localparam C1_P0_DATA_PORT_SIZE      = 128;

localparam C3_NUM_DQ_PINS            = 16;
localparam C3_MEM_ADDR_WIDTH         = 14;
localparam C3_MEM_BANKADDR_WIDTH     = 3;
localparam C3_P0_MASK_SIZE           = 16;
localparam C3_P0_DATA_PORT_SIZE      = 128;

reg reset;
reg clk_50M;
reg clk_20M;
wire    calib_done_led;

wire [C1_NUM_DQ_PINS-1:0]             mcb1_dram_dq;
wire [C1_MEM_ADDR_WIDTH-1:0]          mcb1_dram_a;
wire [C1_MEM_BANKADDR_WIDTH-1:0]      mcb1_dram_ba;
wire                                  mcb1_dram_ras_n;
wire                                  mcb1_dram_cas_n;
wire                                  mcb1_dram_we_n;
wire                                  mcb1_dram_odt;
wire                                  mcb1_dram_reset_n;
wire                                  mcb1_dram_cke;
wire                                  mcb1_dram_dm;
wire                                  mcb1_dram_udqs;
wire                                  mcb1_dram_udqs_n;
wire                                  mcb1_rzq;
wire                                  mcb1_zio;
wire                                  mcb1_dram_udm;
wire                                  mcb1_dram_dqs;
wire                                  mcb1_dram_dqs_n;
wire                                  mcb1_dram_ck;
wire                                  mcb1_dram_ck_n;
    
ddr3_model_c1 u_mem_c1(
    .ck         (mcb1_dram_ck       ),
    .ck_n       (mcb1_dram_ck_n     ),
    .cke        (mcb1_dram_cke      ),
    .cs_n       (1'b0),
    .ras_n      (mcb1_dram_ras_n    ),
    .cas_n      (mcb1_dram_cas_n    ),
    .we_n       (mcb1_dram_we_n     ),
    .dm_tdqs    ({mcb1_dram_udm,mcb1_dram_dm}),
    .ba         (mcb1_dram_ba       ),
    .addr       (mcb1_dram_a        ),
    .dq         (mcb1_dram_dq       ),
    .dqs        ({mcb1_dram_udqs,mcb1_dram_dqs}),
    .dqs_n      ({mcb1_dram_udqs_n,mcb1_dram_dqs_n}),
    .tdqs_n     (),
    .odt        (mcb1_dram_odt      ),
    .rst_n      (mcb1_dram_reset_n  )
);

ddr3_top ddr3_top(
    .sw_rst_i   (reset  ),
    .clk_50M    (clk_50M),
    .clk_20M    (clk_20M),
    .calib_done_led     (calib_done_led   ),
    .mcb1_dram_dq       (mcb1_dram_dq     ),
    .mcb1_dram_a        (mcb1_dram_a      ),
    .mcb1_dram_ba       (mcb1_dram_ba     ),
    .mcb1_dram_ras_n    (mcb1_dram_ras_n  ),
    .mcb1_dram_cas_n    (mcb1_dram_cas_n  ),
    .mcb1_dram_we_n     (mcb1_dram_we_n   ),
    .mcb1_dram_odt      (mcb1_dram_odt    ),
    .mcb1_dram_reset_n  (mcb1_dram_reset_n),
    .mcb1_dram_cke      (mcb1_dram_cke    ),
    .mcb1_dram_dm       (mcb1_dram_dm     ),
    .mcb1_dram_udqs     (mcb1_dram_udqs   ),
    .mcb1_dram_udqs_n   (mcb1_dram_udqs_n ),
    .mcb1_rzq           (mcb1_rzq         ),
    .mcb1_zio           (mcb1_zio         ),
    .mcb1_dram_udm      (mcb1_dram_udm    ),
    .mcb1_dram_dqs      (mcb1_dram_dqs    ),
    .mcb1_dram_dqs_n    (mcb1_dram_dqs_n  ),
    .mcb1_dram_ck       (mcb1_dram_ck     ),
    .mcb1_dram_ck_n     (mcb1_dram_ck_n   )
);

// The PULLDOWN component is connected to the ZIO signal primarily to avoid the
// unknown state in simulation. In real hardware, ZIO should be a no connect(NC) pin.
PULLDOWN zio_pulldown1 (.O(mcb1_zio));   PULLDOWN rzq_pulldown1 (.O(mcb1_rzq));

// Initial conditions; setup
initial begin
    //$timeformat(-9,1, "ns", 12);

    // Initial Conditions
    reset <= 1'b1;
    clk_50M <= 1'b0;
    clk_20M <= 1'b0;

    #10 reset <= 1'b0;


    // Deassert reset
    // low reset more than 8us to make sure PLL has been complete
    // and offered clocks.
    #2000 reset <= 1'b1;

    wait (ddr3_top.c1_calib_done == 1'b1);
    //wait (ddr3_top.cnt_100M == 50);
    #10000000 $display("Complete");
    $finish;
end

/**************************************************************/
/* The following can be left as-is unless necessary to change */
/**************************************************************/

// Clock generation
always #(CLOCKPERIOD / 2) clk_50M <= ~clk_50M;
always #(CLOCKPERIOD_20M / 2) clk_20M <= ~clk_20M;

endmodule
