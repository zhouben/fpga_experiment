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

task tsk_host_send_to_uart_8N1;
    input integer data;
    integer byte_value;
    integer byte;
    integer bit;

    begin
        #1000 $display("[%t] start send data %X to uart", $realtime, data);
        for( byte = 0; byte < 4; byte = byte + 1)
        begin
            byte_value = (data >> ( 24 - byte * 8)) & 8'hFF;

            #8681 uart_rx_i = 0; // start bit
            for (bit = 0; bit < 8; bit = bit + 2)
            begin
                #8681 uart_rx_i = (byte_value >> bit) & 1'b1;
                #8680 uart_rx_i = (byte_value >> (bit + 1)) & 1'b1;
            end
            #8680 uart_rx_i = 1; // stop
            #8681 uart_rx_i = 1; // idle
        end
    end
endtask

integer data = 32'hC9034AF6;
integer crc = 32'h760F306F;

initial begin
    rst_n   = 1'b0;
    uart_rx_i = 1; // idle
    clk     = 1'b0;
    #100 rst_n = 1'b1;

    repeat (2) @(posedge clk);

    $display("[%t] to call task", $realtime);
    tsk_host_send_to_uart_8N1(data);
    repeat (2) @(posedge clk);
    $display("[%t] data: %X  crc %X, result: %s", $realtime, data, u0.crc, (crc == u0.crc) ? "PASSED" : "FAILED");

    tsk_host_send_to_uart_8N1(32'h53544F50);

    #1000_000 $finish(0);
end
endmodule
