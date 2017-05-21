`timescale 1ns / 1ps

module xxx_tb();

parameter CLOCKPERIOD = 20;

logic        clk     ;
logic        rst_n   ;
logic        rdy     ;
logic        wen     ;
logic [31:0] din     ;
logic [31:0] dout    ;
logic        done    ;

xxx u0(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .din    (din    ),
    .wen    (wen    ),
    .rdy    (rdy    ),
    .dout   (dout   ),
    .done   (done   )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)

    #100 $display("[%t] TEST PASSED", $realtime);
end
endmodule
