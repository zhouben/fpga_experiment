`timescale 1ns / 1ns

module seven_seg_tb();
parameter CLOCKPERIOD = 20;
reg         clk      ;
reg         rst_n    ;
wire        rdy      ;
reg [31:0]  data     ;
reg         wen      ;
wire [7:0]  leds_o   ;
wire [5:0]  sels_o   ;

seven_seg_interface u0(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   (data   ),
    .wen    (wen    ),
    .base   (1'b1   ),
    .rdy    (       ),
    .done   (       ),
    .leds_o (leds_o ),
    .sels_o (sels_o )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)
    data <= 32'h101;
    wen <= 1'b1;
    @(posedge clk)
    wen <= 1'b0;

    #10000 $stop;
end
endmodule
