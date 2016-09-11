module oled_disp
(
    input clk,
    input reset,
    input start,
    input i2c_done,
    output reg done,
    output reg [7:0] reg_addr,
    output reg [7:0] reg_data,
    output reg   i2c_write_en
);

localparam disp_state_init = 0,
    disp_state_y     = 1,
    disp_state_x_base_low = 2,
    disp_state_x_base_high = 3,
    disp_state_writing_data = 4;
localparam DATA_ADDR = 8'h40;

localparam sleep_cycle = 50;
localparam x_pixel_num = 7'd127;
localparam y_pixel_num = 3'd7;
localparam disp_mode_black = 0,
    disp_mode_white = 1,
    disp_mode_interlace = 2,
    disp_mode_interlace_r = 3;

reg [2:0]   state;
reg [2:0]   state_next;
reg [15:0]  sleep_cnt;
reg [15:0]  sleep_cnt_next;
reg [2:0]   y;
reg [2:0]   y_next;
reg [6:0]   x;
reg [6:0]   x_next;
reg [1:0]   disp_mode;
reg [1:0]   disp_mode_next;
reg [7:0]   disp_value;

always @(posedge clk) begin
    if (~reset) sleep_cnt <= 16'b0;
    else        sleep_cnt <= sleep_cnt_next;
end

always @(posedge clk) begin
    if (~reset) state <= disp_state_init;
    else        state <= state_next;
end

always @(posedge clk) begin
    if (~reset) y <= 3'b0;
    else        y <= y_next;
end

always @(posedge clk) begin
    if (~reset) x <= 7'b0;
    else        x <= x_next;
end

always @(posedge clk) begin
    if (~reset) disp_mode <= disp_mode_black;
    else        disp_mode <= disp_mode_next;
end

always @(*) begin
    case (disp_mode)
        disp_mode_black         : disp_value = 8'd0;
        disp_mode_white         : disp_value = 8'hFF;
        disp_mode_interlace     : disp_value = (x[4] ^ y[0]) ? 8'hFF : 8'd0;
        disp_mode_interlace_r   : disp_value = (x[4] ^ y[0]) ? 8'd0 : 8'hFF;
        default                 : disp_value = 8'b0;
    endcase
end

always @(*) begin
    i2c_write_en    <= 1'b0;
    x_next          <= x;
    y_next          <= y;
    state_next      <= state;
    sleep_cnt_next  <= sleep_cnt;
    reg_addr        <= 8'bx;
    reg_data        <= 8'bx;
    done            <= 1'b0;
    disp_mode_next  <= disp_mode;
    case (state)
        disp_state_init: begin
            if (start) begin
                state_next      <= disp_state_y;
                reg_addr        <= 8'd0;
                reg_data        <= {5'b1011_0, y};
                i2c_write_en    <= 1'b1;
                sleep_cnt_next  <= 16'd0;
            end
        end
        disp_state_y: begin
            if (i2c_done) begin
                sleep_cnt_next  <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == sleep_cycle) begin
                sleep_cnt_next  <= 16'd0;
                state_next      <= disp_state_x_base_low;
                y_next          <= y + 3'b1;
                reg_addr        <= 8'd0;
                reg_data        <= 8'h10;
                i2c_write_en    <= 1'b1;
            end else if (sleep_cnt != 12'd0 )begin
                sleep_cnt_next  <= sleep_cnt + 16'd1;
            end
        end
        disp_state_x_base_low: begin
            if (i2c_done) begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == sleep_cycle) begin
                sleep_cnt_next  <= 16'd0;
                state_next      <= disp_state_x_base_high;
                reg_addr        <= 8'd0;
                reg_data        <= 8'h00;
                i2c_write_en    <= 1'b1;
            end else if (sleep_cnt != 12'd0 )begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end
        end
        disp_state_x_base_high: begin
            if (i2c_done) begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == sleep_cycle) begin
                sleep_cnt_next  <= 16'd0;
                state_next      <= disp_state_writing_data;
                reg_addr        <= DATA_ADDR;
                reg_data        <= disp_value;
                i2c_write_en    <= 1'b1;
            end else if (sleep_cnt != 12'd0 )begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end
        end
        disp_state_writing_data: begin
            if (i2c_done) begin
                sleep_cnt_next  <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == sleep_cycle) begin
                sleep_cnt_next  <= 16'd0;
                if ( x == 7'h7F ) begin
                    x_next      <= 7'd0;
                    if (y == 3'd0) begin
                        state_next      <= disp_state_init;
                        done            <= 1'b1;
                        disp_mode_next  <= disp_mode + 2'b1;
                    end else begin
                        state_next      <= disp_state_y;
                        reg_addr        <= 8'd0;
                        reg_data        <= {5'b1011_0, y};
                        i2c_write_en    <= 1'b1;
                        sleep_cnt_next  <= 16'd0;
                    end
                end else begin
                    x_next          <= x + 7'd1;
                    reg_addr        <= DATA_ADDR;
                    reg_data        <= disp_value;
                    i2c_write_en    <= 1'b1;
                end
            end else if (sleep_cnt != 12'd0 )begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end
        end
    endcase
end

endmodule
