// CRC sum
//
// 0x04C11DB7  
// X^32 + X^26 + X^23 + X^22 + X16 + X^12 + X^11 + X^10 + X^8 + X^7 + X^5 + X^4 + X^2 + X + 1
//100000100110000010001110110110111

module crc_by_1bit(
  input clk,
  input reset,
  input en,
  input din,
  output [31:0] crc_out
);

reg [31:0] crc,next;
wire d;

assign crc_out = next;

always @(posedge clk) begin
    if (reset) begin
        crc <= 32'h0;
    end else begin
        crc <= en ? next : crc;
    end
end

assign d = crc[31] ^ din;
always @(*) begin
    next[ 0] <= d          ;
    next[ 1] <= crc[ 0] ^ d;
    next[ 2] <= crc[ 1] ^ d;
    next[ 3] <= crc[ 2]    ;
    next[ 4] <= crc[ 3] ^ d;
    next[ 5] <= crc[ 4] ^ d;
    next[ 6] <= crc[ 5]    ;
    next[ 7] <= crc[ 6] ^ d;
    next[ 8] <= crc[ 7] ^ d;
    next[ 9] <= crc[ 8]    ;
    next[10] <= crc[ 9] ^ d;
    next[11] <= crc[10] ^ d;
    next[12] <= crc[11] ^ d;
    next[13] <= crc[12]    ;
    next[14] <= crc[13]    ;
    next[15] <= crc[14]    ;
    next[16] <= crc[15] ^ d;
    next[17] <= crc[16]    ;
    next[18] <= crc[17]    ;
    next[19] <= crc[18]    ;
    next[20] <= crc[19]    ;
    next[21] <= crc[20]    ;
    next[22] <= crc[21] ^ d;
    next[23] <= crc[22] ^ d;
    next[24] <= crc[23]    ;
    next[25] <= crc[24]    ;
    next[26] <= crc[25] ^ d;
    next[27] <= crc[26]    ;
    next[28] <= crc[27]    ;
    next[29] <= crc[28]    ;
    next[30] <= crc[29]    ;
    next[31] <= crc[30]    ;
end

endmodule
