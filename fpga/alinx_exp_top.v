`timescale 1ns / 100ps

module alinx_exp_top
(
    input           clk_50m,
    input           sw_rst_n,
    output [7:0]    leds_o,
    output [5:0]    sels_o
);

wire    clk;
wire    rst_n;

BUFGP u0(
    .I  (clk_50m    ),
    .O  (clk        )
);

IBUF u1(
    .I  (sw_rst_n   ),
    .O  (rst_n      )
);

localparam CNT_MAX = (26'd50_000_000 - 1);

reg [31:0] rst_n_d;
wire        wen;
reg [25:0] cnt;
reg [7:0]  second;

assign wen = (cnt == 26'd1);

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) rst_n_d <= 32'd0;
    else        rst_n_d <= {rst_n_d[30:0], 1'b1};
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin cnt <= 26'd0; second <= 8'd0; end
    else begin
        if( cnt == CNT_MAX) begin cnt <= 26'd0; second <= second + 8'd1; end
        else                begin cnt <= cnt + 26'd1; end
    end
end

seven_seg_interface u2(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   (second ),
    .wen    (wen    ),
    .base   (1'b1   ),
    .rdy    (       ),
    .done   (       ),
    .leds_o (leds_o ),
    .sels_o (sels_o )
);

endmodule
