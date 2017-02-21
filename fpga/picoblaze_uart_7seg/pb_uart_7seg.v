`timescale 1ns / 1ns

module pb_uart_7seg(
    input           clk_50m,
    input           sw_rst_n,

    output          uart_tx,
    output [7:0]    leds_o,
    output [5:0]    sels_o
);
localparam SEG_REFRESH_CYCLE_WIDTH = 26; // 64M

wire    clk;
wire    rst_n;
reg [SEG_REFRESH_CYCLE_WIDTH-1:0] refresh_count;
reg     [4:0] data;
wire    wen_7seg;
wire    baudclk16;
wire    uart_tx_ready;
wire    uart_write_kickoff;
reg [4:0] uart_clk_count;

assign rst_n = sw_rst_n;
assign wen_7seg = (refresh_count == 1) ? 1'b1 : 1'b0;
assign uart_write_kickoff = (refresh_count == 1) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (~rst_n) begin
        refresh_count <= 0;
    end else begin
        refresh_count <= refresh_count + 1;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        data <= 6;
    end else begin
        if (refresh_count == {SEG_REFRESH_CYCLE_WIDTH{1'b1}}) begin
            data <= data + 1;
        end
    end
end

seven_seg_interface _7_seg
(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   (data   ),
    .wen    (wen_7seg),
    .base   (1'b0   ),
    .leds_o (leds_o ),
    .sels_o (sels_o )
);

IBUFG ibufg(
    .O (clk),
    .I (clk_50m)
);

assign baudclk16 = (uart_clk_count == 5'd26) ? 1'b1 : 1'b0;
always @(posedge clk) begin
    if (~rst_n) begin
        uart_clk_count <= 0;
    end else begin
        if (~uart_tx_ready) begin
            if (uart_clk_count == 5'd26) begin
                uart_clk_count <= 5'b0;
            end else begin
                uart_clk_count <= uart_clk_count + 1;
            end
        end else begin
            uart_clk_count <= 5'b0;
        end
    end
end

uart_tx _uart_tx
(
    .clk        (clk                ),
    .reset      (~rst_n             ),
    .baudclk16  (baudclk16          ),
    .tx         (uart_tx            ),
    .data       ({3'b0, data        }),
    .ready      (uart_tx_ready      ),
    .write      (uart_write_kickoff )
);

endmodule
