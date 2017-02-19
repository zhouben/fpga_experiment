`timescale 1ns / 1ns

module pb_uart_7seg_tb();

parameter CLOCKPERIOD = 20;

reg         clk     ;
reg         rst_n   ;
wire        uart_tx ;

pb_uart_7seg u0(
    .clk_50m    (clk    ),
    .sw_rst_n   (rst_n  ),
    .uart_tx    (uart_tx),
    .leds_o     (       ),
    .sels_o     (       )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)
    @(posedge clk)

    #300_000 $display("[%t] TEST PASSED", $realtime);
    $stop;
end
endmodule
