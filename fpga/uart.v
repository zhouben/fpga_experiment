// UART transmitter and receiver
//
// GNSS Firehose
// Copyright (c) 2012 Peter Monta <pmonta@gmail.com>
//
// 8N1

`timescale 1ns / 1ns

module uart_tx(
  input clk, reset,
  input baudclk16,
  output tx,
  input [7:0] data,
  output reg ready,
  input write
);

localparam
  IDLE = 1'b0,
  XMIT = 1'b1;

reg [9:0] bits;
reg [3:0] sb;
reg [3:0] bit;
reg state;
reg bit_flag;

assign tx = bits[0];

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ready <= 1;
        bits <= 10'b1111111111;
        bit_flag <= 0;
    end else begin
        bit_flag <= 1'b0;
        case (state)
            IDLE: begin
                if (write) begin
                    ready <= 0;
                    bits <= {1'b1,data,1'b0};
                    bit <= 4'd0;
                    sb <= 4'd0;
                    state <= XMIT;
                end
            end
            XMIT: begin
                if (baudclk16) begin
                    sb <= sb + 1;
                    if (sb==4'd15) begin
                        bit_flag <= 1'b1;
                        bits <= {1'b1,bits[9:1]};
                        bit <= bit + 1;
                        if (bit==4'd9) begin
                            ready <= 1;
                            state <= IDLE;
                        end
                    end
                end
            end
        endcase
    end
end
endmodule

module uart_rx(
  input clk, reset,
  input baudclk16,
  input rx,
  output reg [7:0] data,
  output reg ready,
  input read
);

localparam [1:0]
  IDLE =  2'd0,
  START = 2'd1,
  RX =    2'd2,
  STOP =  2'd3;

reg [7:0] bits;
reg [3:0] sb;
reg [3:0] bit;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ready <= 0;
    end else begin
        if (read) begin
            ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!rx) begin
                        sb <= 3'd0;
                        state <= START;
                    end
                end
                START: begin
                    if (baudclk16) begin
                        if (sb==4'd7) begin
                            bit <= 4'd0;
                            sb <= 4'd0;
                            state <= RX;
                        end else
                            sb <= sb + 1;
                    end
                end
                RX: begin
                    if (baudclk16) begin
                        sb <= sb + 1;
                        if (sb==4'd15) begin
                            bits <= {rx,bits[7:1]};
                            bit <= bit + 1;
                            if (bit==4'd7)
                                state <= STOP;
                        end
                    end
                end
                STOP: begin
                    if (baudclk16) begin
                        sb <= sb + 1;
                        if (sb==4'd15) begin
                            data <= bits;
                            ready <= 1;
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
end

endmodule
