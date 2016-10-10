`timescale 1ns / 1ps

module seven_seg_interface
(
    input           clk,
    input           rst_n,
    input  [31:0]   data,
    input           wen,
    input           base,   // 1: decimal, 0: hexadecimal
    output reg      rdy,
    output reg      done,
    output [7:0]    leds_o,
    output [5:0]    sels_o
);

localparam SEL_REFRESH_CYCLES = 19'd99_999; // 2ms
//localparam SEL_REFRESH_CYCLES = 19'd3;
localparam IDLE = 2'd0;
localparam ENC  = 2'd1;
localparam WAIT = 2'd2;

reg  [7:0]  seg_bitmap;
reg  [5:0]  sel_bitmap;
reg  [31:0] data_r;
reg  [1:0]  state;
reg  [23:0] data_encode;   // encoded from data_r, each 4bits for one seven segment display.
reg  [3:0]  val_to_display;
reg  [18:0] cnt;
reg         bcd_en;
wire [23:0] bcd_dout;
wire        bcd_done;

assign sels_o = sel_bitmap;
assign leds_o = seg_bitmap;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 19'd0;
    end else begin
        if (cnt == SEL_REFRESH_CYCLES)  cnt <= 19'd0;
        else                            cnt <= cnt + 19'd1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        sel_bitmap <= 6'b111_110;
    end else begin
        if (cnt == SEL_REFRESH_CYCLES)  sel_bitmap <= {sel_bitmap[4:0], sel_bitmap[5]};
    end
end

always @(*) begin
    case (sel_bitmap)
        6'b111_110: val_to_display <= data_encode[ 3: 0];
        6'b111_101: val_to_display <= data_encode[ 7: 4];
        6'b111_011: val_to_display <= data_encode[11: 8];
        6'b110_111: val_to_display <= data_encode[15:12];
        6'b101_111: val_to_display <= data_encode[19:16];
        6'b011_111: val_to_display <= data_encode[23:20];
        default   : val_to_display <= data_encode[ 3: 0];
    endcase
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state   <= IDLE;
        data_r  <= 32'b0;
        rdy     <= 1'b0;
        data_encode <= 24'd0;
    end else begin
        done    <= 1'b0;
        bcd_en  <= 1'b0;
        rdy     <= 1'b0;
        case (state)
            IDLE: begin
                if(wen) begin
                    data_r  <= data;
                    rdy     <= 1'b0;
                    state   <= ENC;
                end else begin
                    rdy <= 1'b1;
                end
            end
            ENC: begin
                if(~base) begin
                    data_encode <= data_r[23:0];
                    state       <= IDLE;
                    done        <= 1'b1;
                end else begin
                    bcd_en  <= 1'b1;
                    state   <= WAIT;
                end
            end
            WAIT: begin
                if (bcd_done) begin
                    data_encode <= bcd_dout;
                    state       <= IDLE;
                    rdy         <= 1'b1;
                    done        <= 1'b1;
                end
            end
        endcase
    end
end

localparam _0 = 8'b1100_0000;   // C0
localparam _1 = 8'b1111_1001;   // F9
localparam _2 = 8'b1010_0100;   // A4
localparam _3 = 8'b1011_0000;   // B0
localparam _4 = 8'b1001_1001;   // 99
localparam _5 = 8'b1001_0010;   // 92
localparam _6 = 8'b1000_0010;   // 82
localparam _7 = 8'b1111_1000;   // F8
localparam _8 = 8'b1000_0000;   // 80
localparam _9 = 8'b1001_0000;   // 90
localparam _A = 8'b1000_1000;   // 88
localparam _B = 8'b1000_0011;   // 83
localparam _C = 8'b1000_0110;   // 86
localparam _D = 8'b1010_0001;   // A1
localparam _E = 8'b1000_0110;   // 86
localparam _F = 8'b1000_1110;   // 8E


always @(*) begin
    case (val_to_display)
        4'h0:   seg_bitmap <= _0;
        4'h1:   seg_bitmap <= _1;
        4'h2:   seg_bitmap <= _2;
        4'h3:   seg_bitmap <= _3;
        4'h4:   seg_bitmap <= _4;
        4'h5:   seg_bitmap <= _5;
        4'h6:   seg_bitmap <= _6;
        4'h7:   seg_bitmap <= _7;
        4'h8:   seg_bitmap <= _8;
        4'h9:   seg_bitmap <= _9;
        4'hA:   seg_bitmap <= _A;
        4'hB:   seg_bitmap <= _B;
        4'hC:   seg_bitmap <= _C;
        4'hD:   seg_bitmap <= _D;
        4'hE:   seg_bitmap <= _E;
        4'hF:   seg_bitmap <= _F;
        default:seg_bitmap <= 8'b1111_1111;
    endcase
end

bin2bcd u0(
    .clk    (clk        ),
    .rst_n  (rst_n      ),
    .din    (data_r     ),
    .en     (bcd_en     ),
    .done   (bcd_done   ),
    .dout   (bcd_dout   )
);

endmodule
