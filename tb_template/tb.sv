`timescale 1ns / 1ps

module xxx_tb();

parameter CLOCKPERIOD = 20;


// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;

initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk)

    #100 $display("[%t] TEST PASSED", $realtime);
    $finish(0);
end
endmodule
