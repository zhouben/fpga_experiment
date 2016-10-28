`timescale 1ns / 1ps

module sdram_vga_exp_tb();

parameter CLOCKPERIOD = 20;
localparam WIDTH = 1024;
localparam DATA_DEPTH = WIDTH*30;
localparam MEMORY_UNIT_FOR_DISP = WIDTH*1024;
localparam MEMORY_UNIT_NUM = 2;

reg         clk     ;
reg         rst_n   ;
wire        S_CLK   ;
wire        S_CKE   ;
wire        S_NCS   ;
wire        S_NWE   ;
wire        S_NCAS  ;
wire        S_NRAS  ;
wire [1:0] 	S_DQM   ;
wire [1:0]	S_BA    ;
wire [12:0]	S_A     ;
wire [15:0]	S_DB    ;

wire        vga_hsync ;
wire        vga_vsync ;
wire [4:0]  vga_red   ;
wire [5:0]  vga_green ;
wire [4:0]  vga_blue  ;

integer frame_cnt;

sdram_vga_exp #(
    .DISPLAY_RESOLUTION( 1024*768),
    .DATA_DEPTH (DATA_DEPTH)
) u0(

    .clk_50m_i      (clk        ), // 100MHz
    .sw_rst_n       (rst_n      ),
    .vga_hsync      (vga_hsync  ),
    .vga_vsync      (vga_vsync  ),
    .vga_red        (vga_red    ),
    .vga_green      (vga_green  ),
    .vga_blue       (vga_blue   ),
    .S_CLK          (S_CLK      ),  //sdram clock
    .S_CKE          (S_CKE      ),  //sdram clock enable
    .S_NCS          (S_NCS      ),  //sdram chip select
    .S_NWE          (S_NWE      ),  //sdram write enable
    .S_NCAS         (S_NCAS     ),  //sdram column address strobe
    .S_NRAS         (S_NRAS     ),  //sdram row address strobe
    .S_DQM          (S_DQM      ),  //sdram data enable
    .S_BA           (S_BA       ),  //sdram bank address
    .S_A            (S_A        ),  //sdram address
    .S_DB           (S_DB       ),  //sdram data
    .led_0          (           )
);

sdram_model #(
    .MEMORY_DEPTH (MEMORY_UNIT_FOR_DISP * MEMORY_UNIT_NUM)
) u1
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
integer ret;
task tsk_check_write_result;
    integer _i;
    integer base_addr;
    integer addr;
    begin
        wait (u0.vga_ctrl.data_req == 1'b1);
        base_addr = (frame_cnt[0] == 1'b0 ? 0 : 1 ) * MEMORY_UNIT_FOR_DISP;
        $display("[%t] VGA begins to display data. base addr %08X", $realtime, base_addr);

        for (_i = 0; _i < DATA_DEPTH; _i = _i + 1) begin
            addr = base_addr + _i;
            if (u1.memory[addr] !== (_i % WIDTH)) begin
               $display("[%t] frame %d addr %8X value %8d != %8d", $realtime, frame_cnt, addr, u1.memory[addr], _i); 
               $finish(1);
           end
        end
        $display("[%t] Written VGA data check passed", $realtime);
    end
endtask
// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
always @(posedge u0.frame_sync) begin
    frame_cnt = frame_cnt + 1;
end
initial begin
    rst_n       = 1'b0;
    clk         = 1'b0;
    frame_cnt   = 0;
    #100 rst_n  = 1'b1;

    tsk_check_write_result();
    //wait (u0.mem_rd_req == 1);
    $display("[%t] VGA begins to read data", $realtime);

    #1_000_000 $display("[%t] TEST PASSED", $realtime);
    //ret = u1.dump_memory("memory.log");
    $finish(0);
end
endmodule
