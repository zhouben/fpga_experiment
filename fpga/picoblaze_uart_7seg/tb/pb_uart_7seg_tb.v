`timescale 1ns / 1ns

module pb_uart_7seg_tb();

parameter CLOCKPERIOD = 20;

reg         clk     ;
reg         rst_n   ;
wire        uart_tx_o;
reg        uart_rx_i;

pb_uart_7seg u0(
    .clk_50m    (clk    ),
    .sw_rst_n   (rst_n  ),
    .uart_tx_o  (uart_tx_o),
    .uart_rx_i  (uart_rx_i),
    .led_disp_switch(1'b0), 
    .leds_o     (       ),
    .sels_o     (       )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;

task tsk_host_send_to_uart;
    begin
        #1000 $display("[%t] start send data to uart", $realtime);

        #8681 uart_rx_i = 0; // start bit
        #8680 uart_rx_i = 1; // 0
        #8681 uart_rx_i = 0;
        #8680 uart_rx_i = 1;
        #8681 uart_rx_i = 0;
        #8680 uart_rx_i = 1; // 4
        #8681 uart_rx_i = 0;
        #8680 uart_rx_i = 1;
        #8681 uart_rx_i = 0;
        #8680 uart_rx_i = 1; // stop
        #8681 uart_rx_i = 1; // idle
    end
endtask

initial begin
    rst_n   = 1'b0;
    uart_rx_i = 1; // idle
    clk     = 1'b0;
    #100 rst_n = 1'b1;

    #40
    @(posedge clk)
    @(posedge clk)

    $display("[%t] to call task", $realtime);
    tsk_host_send_to_uart();

    #300_000 $display("[%t] TEST PASSED", $realtime);
    $stop;
end
endmodule
