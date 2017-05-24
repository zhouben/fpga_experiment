`timescale 1ns/1ns

module LOCAL_MEM(
    input               clk     ,    // input clk
    input               we      ,
    input  [6:0]        addr    ,
    input  [31:0]       din     ,
    output [31:0]       dout
);

reg [31:0] dout_q;
assign dout = dout_q;
always @(posedge clk) begin
    dout_q <= {
        9'b0, addr + 'd3,
        9'b0, addr + 'd2,
        9'b0, addr + 'd1,
        9'b0, addr
    };
end
endmodule
