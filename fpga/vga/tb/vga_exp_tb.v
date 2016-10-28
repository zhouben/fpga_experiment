`timescale 1ns / 1ps

module vga_exp_tb();

parameter CLOCKPERIOD = 20;

reg         clk     ;
reg         rst_n   ;

vga_exp u0(
    .clk_50m        (clk        ),
    .sw_rst_i       (rst_n      ),
    .vga_hsync      (vga_hsync  ),
    .vga_vsync      (vga_vsync  ),
    .vga_red        (vga_red    ),
    .vga_green      (vga_green  ),
    .vga_blue       (vga_blue   )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #200 rst_n <= 1'b1;

    #40
    @(posedge clk)
    @(posedge clk)

    #1_000_000
    rst_n   <= 1'b0;
    #200 rst_n <= 1'b1;

    #10_000_000 $stop;
end
endmodule
