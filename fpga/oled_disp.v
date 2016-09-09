module oled_disp
(
    input clk,
    input reset,
    input start,
    input i2c_done,
    output done,
    output [7:0] reg_addr,
    output [7:0] reg_data,
    output       write_i2c_en
);

localparam disp_state_init = 0,
    disp_state_y     = 1,
    disp_state_x_low = 2,
    disp_state_x_high = 3,
    disp_state_writing_data = 4;

localparam x_pixel_num = 7'd127;
localparam y_pixel_num = 3'd7;

assign reg_addr = 8'd0;
assign reg_data = 8'd0;
assign write_i2c_en = 1'b0;
assign done = 1'b0;

reg [2:0] disp_state;
reg [2:0] disp_state_next;
endmodule
