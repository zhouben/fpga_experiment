`timescale 1ns / 1ps

module bin2bcd
(
    input           clk     ,
    input           rst_n   ,
    input [31:0]    din     ,
    input           en      ,
    output reg      done    ,
    output [23:0]   dout
);

localparam IDLE = 2'd0;
localparam SHIFT = 2'd1;
localparam ADD3  = 2'd2;

reg [31:0]  data_r;
reg [23:0]  bcd;
reg [1:0]   state;
reg [4:0]   cnt;

assign dout = bcd;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state   <= IDLE;
        bcd     <= 24'd0;
    end else begin
        done    <= 1'b0;
        case (state)
            IDLE: begin
                if (en) begin
                    data_r  <= din; 
                    state   <= SHIFT;
                    bcd     <= 24'd0;
                end else begin
                    cnt     <= 5'd0;
                end
            end
            SHIFT: begin
                bcd <= {bcd[22:0], data_r[31]};
                data_r  <= data_r << 1;
                state   <= ADD3;
                cnt     <= cnt + 5'd1;
            end
            ADD3: begin
                if (cnt == 5'd0) begin
                    done    <= 1'b1;
                    state   <= IDLE;
                end else begin
                    state   <= SHIFT;
                    if (bcd[ 3: 0] > 4) bcd[ 3: 0] <= bcd[ 3: 0] + 4'd3;
                    if (bcd[ 7: 4] > 4) bcd[ 7: 4] <= bcd[ 7: 4] + 4'd3;
                    if (bcd[11: 8] > 4) bcd[11: 8] <= bcd[11: 8] + 4'd3;
                    if (bcd[15:12] > 4) bcd[15:12] <= bcd[15:12] + 4'd3;
                    if (bcd[19:16] > 4) bcd[19:16] <= bcd[19:16] + 4'd3;
                    if (bcd[23:20] > 4) bcd[23:20] <= bcd[23:20] + 4'd3;
                end
            end
        endcase
    end
end
endmodule
