`timescale 1ns / 1ps

module vga_exp(
    input           clk_50m,
    input           sw_rst_i,
    output          vga_hsync,
    output          vga_vsync,
    output [4:0]    vga_red,
    output [5:0]    vga_green,
    output [4:0]    vga_blue
);

wire    clk;
wire    CLK_IN1;
wire    CLK_OUT1;
wire    LOCKED;
wire    rst_n;

wire        data_req;
reg         data_req_d;

reg [19:0]  pos;
reg [19:0]  pos_next;
wire [12:0] rom_addr;
wire [ 7:0] rom_dout;

reg [15:0]  pixel;
reg [ 9:0]  pixel_init;
wire [15:0] pixel_value;
reg [15:0]  pixel_next;

assign rst_n = sw_rst_i & LOCKED;

IBUFG ibufg(
    .O (CLK_IN1),
    .I (clk_50m)
);

BUFGCE bufgce(
    .O (clk     ),
    .I (CLK_OUT1),
    .CE(LOCKED  )
);

  clk_gen_65m clk_gen_65m
   (// Clock in ports
    .CLK_IN1(CLK_IN1),      // IN
    // Clock out ports
    .CLK_OUT1(CLK_OUT1),     // OUT
    // Status and control signals
    .RESET(~sw_rst_i),// IN
    .LOCKED(LOCKED));      // OUT

    vga_ctrl vga_ctrl(
        .clk        (clk        ), 
        .rst_n      (rst_n      ),
        .din        (pixel_value),
        .data_req   (data_req   ),
        .frame_sync (frame_sync ),
        .vga_hsync  (vga_hsync  ),
        .vga_vsync  (vga_vsync  ),
        .vga_red    (vga_red    ),
        .vga_green  (vga_green  ),
        .vga_blue   (vga_blue   )
    );

slogan_rom slogan_rom (
  .clka(clk), // input clka
  .addra(rom_addr), // input [12 : 0] addra
  .douta(rom_dout) // output [15 : 0] douta
);
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pixel_init  <= 10'd0;
    end else begin
        if (frame_sync) begin
            pixel_init  <= pixel_init + 10'd1;
        end
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pos_next <= 20'd0;
    end else begin
        if (frame_sync) pos_next <= 20'd0;
        if (data_req)   pos_next <= pos_next + 20'd1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pos <= 20'd0;
    end else begin
        pos <= pos_next;
    end
end

localparam x_left = 5;
localparam y_top  = 7;
localparam BITS_NUM_PER_BYTE = 3;
localparam BITS_NUM_OF_BYTES_PER_ROME_LINE = 3;
localparam BYTES_PER_ROME_LINE = (1 << BITS_NUM_OF_BYTES_PER_ROME_LINE);
localparam x_size = BYTES_PER_ROME_LINE << 3;

localparam BITS_NUM_OF_ROM_HEIGHT = 4;
localparam y_size = 14;

wire [9:0] rom_x_pos_next;
wire [9:0] rom_y_pos_next;
reg  [9:0] rom_x_pos;

assign rom_x_pos_next = (pos_next[9:0] - x_left);
assign rom_y_pos_next = (pos_next[19:10] - y_top);

`define ROM_X_ACTIVE ((pos[9:0] >= x_left) && (pos[9:0] < x_left + x_size))
`define ROM_Y_ACTIVE ((pos[19:10] >= y_top) && (pos[19:10] < y_top + y_size))
assign rom_addr = {
    3'd0,
    rom_y_pos_next[ BITS_NUM_OF_ROM_HEIGHT - 1: 0],
    rom_x_pos_next[BITS_NUM_OF_BYTES_PER_ROME_LINE + BITS_NUM_PER_BYTE - 1 : BITS_NUM_PER_BYTE]};
assign pixel_value = ( `ROM_X_ACTIVE && `ROM_Y_ACTIVE) ?
    //16'hFFFF
    //( rom_dout[1] ? 16'hFFFF : 16'd0)
    ( rom_dout[rom_x_pos[2:0]] ? 16'hFFFF : pixel)
    : pixel;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) rom_x_pos <= 10'd0;
    else rom_x_pos <= rom_x_pos_next;
end

// dynamic display, like marquee
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) data_req_d <= 1'b0;
    else data_req_d <= data_req;
end

always @(*) begin
    if (data_req_d) pixel_next <= pixel + 16'd1;
    else            pixel_next <= pixel;
end
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pixel       <= 16'd0;
    end else begin
        pixel       <= pixel_init;
        if (data_req) begin
            pixel <= pixel_next;
        end
    end
end
/*
wire [ 9:0] y_pos;
wire [ 9:0] x_pos;

assign x_pos = x_cnt_next - h_start;
assign y_pos = y_cnt_next - v_start;

`define FRANCE_FLAG
`ifdef RGB_INCREMENT
    vga_red   <= (y_pos[9:8] == 2'd0) ? pixel[ 9: 5] : 5'd0;  // 5'b11111;      //
    vga_green <= (y_pos[9:8] == 2'd1) ? pixel[ 9: 4] : 6'd0;  // 6'd111_111;    //
    vga_blue  <= (y_pos[9:8] == 2'd2) ? pixel[ 9: 5] : 5'd0;  // 5'd0;          //
`endif
`ifdef FRANCE_FLAG
    vga_red   <= (x_pos >= 10'd341) ? 5'd31 : 5'd0;
    vga_green <= (x_pos >= 10'd341 && x_pos < 10'd682) ? 6'd63 : 6'd0;
    vga_blue  <= (x_pos <  10'd682) ? 5'd31 : 5'd0;
`endif
*/
endmodule
