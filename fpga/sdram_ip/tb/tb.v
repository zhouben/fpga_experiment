/****************************************************************************\
*
* Test bench for sdram_top_exp module
*
* by zcz on 2016/10/20 8:06:24
*
****************************************************************************/
`timescale 1ns/1ps

module sdram_top_tb();

parameter CLOCKPERIOD = 20;

reg         clk_50m;
reg         rst_n;

wire   	    S_CLK;		//sdram clock
wire   	    S_CKE;		//sdram clock enable
wire   	    S_NCS;		//sdram chip select
wire   	    S_NWE;		//sdram write enable
wire   	    S_NCAS;	   //sdram column address strobe
wire   	    S_NRAS;	   //sdram row address strobe
wire [1:0] 	S_DQM;		//sdram data enable
wire [1:0]	S_BA;		   //sdram bank address
wire [12:0]	S_A;		   //sdram address
wire [15:0]	S_DB;		   //sdram data
wire        led_0;
wire        led_1;
//wire        led_2;
//wire        led_3;
//wire [7:0]  leds_o;
//wire [5:0]  sels_o;

sdram_top_exp u0
(
    .clk_50m    (clk_50m ),
    .sw_rst_n   (rst_n   ),
    .S_CLK      (S_CLK   ),        //sdram clock
    .S_CKE      (S_CKE   ),        //sdram clock enable
    .S_NCS      (S_NCS   ),        //sdram chip select
    .S_NWE      (S_NWE   ),        //sdram write enable
    .S_NCAS     (S_NCAS  ),       //sdram column address strobe
    .S_NRAS     (S_NRAS  ),       //sdram row address strobe
    .S_DQM      (S_DQM   ),        //sdram data enable
    .S_BA       (S_BA    ),           //sdram bank address
    .S_A        (S_A     ),           //sdram address
    .S_DB       (S_DB    ),           //sdram data
    .led_0      (led_0   ),
    .led_1      (led_1   )
    //.led_2      (led_2   ),
    //.led_3      (led_3   ),
    //.leds_o     (leds_o  ),
    //.sels_o     (sels_o  )
);

sdram_model u1
(
    .sdram_clk          (S_CLK      ),
    .sdram_cke          (S_CKE      ),
    .sdram_cs_n         (S_NCS      ),
    .sdram_we_n         (S_NWE      ),
    .sdram_cas_n        (S_NCAS     ),
    .sdram_ras_n        (S_NRAS     ),
	.sdram_udqm			(1'd0       ),		//sdram data enable (H:8)
	.sdram_ldqm			(1'd0       ),		//sdram data enable (L:8)
    .sdram_ba           (S_BA       ),
    .sdram_addr         (S_A        ),
    .sdram_data         (S_DB       )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk_50m <= ~clk_50m;

initial begin
    rst_n   <= 1'b0;
    clk_50m <= 1'b0;

    #100 rst_n <= 1'b1;

    #400_000
    if (0 == u0.error) begin
        $display("[%t] Test PASSED", $realtime);
        $finish(0);
    end else begin
        $display("[%t] Test FAILED", $realtime);
        $finish(1);
    end
end
endmodule
