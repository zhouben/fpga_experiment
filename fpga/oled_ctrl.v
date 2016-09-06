/*
OLED I2C control

Authors:  Zhou Changzhi

Description:
  i2c master side.
*/
module oled_ctrl
#(
    parameter OLED_CHIP_ADDR = 8'h3C,
    parameter FREQ_DIV_I2C = 10, //(250 - 1),
    parameter CMD_NUM = 28
    )(
    input clk,        // System Clock
    input reset,      // Reset signal
    input  scl_in,
    input  sda_in,    // SDA Input
    output sda_out,   // SDA Output
    output sda_oen,   // SDA Output Enable
    output scl_out,   // SCL Output
    output scl_oen,   // SCL Output Enable
    output busy,
    output done,

    output reg config_reg_read_en,
    output [4:0] config_reg_addr,
    input  [7:0] config_reg_data,
    input init,
    input all_black_disp,
    input all_white_disp,
    input interlace_disp
);
localparam oled_idle = 0,
    oled_read_cmd = 1,
    oled_write_i2c = 2,
    oled_wait_done = 3,
    oled_sleep = 4,
    oled_complete = 5;
localparam sleep_cycle = 50000;

reg write_en;
reg init_d1;
reg init_d2;
wire init_rising;
reg black_d1;
reg black_d2;
wire black_rising;
reg white_d1;
reg white_d2;
wire white_rising;
reg interlace_d1;
reg interlace_d2;
wire interlace_rising;

reg [2:0]  state;
reg [7:0]  reg_addr;
reg [4:0]  reg_num;

reg [2:0] state_next;
wire i2c_master_done;
wire [4:0] reg_num_next;

// i2c Master
i2c_master #(
    .ADDR_BYTES(1),
    .DATA_BYTES(1)
) i2c_master (
    .clk        (clk),
    .reset      (reset),
    .clk_div    (FREQ_DIV_I2C),

    .open_drain (1'b1),

    .chip_addr  (OLED_CHIP_ADDR),
    .reg_addr   (reg_addr),
    .data_in    (config_reg_data),
    .write_en   (write_en),
    .write_mode (1'b0),
    .read_en    (),
    .status     (),
    .done       (i2c_master_done),
    .busy       (),
    .data_out   (),

    .sda_in     (sda_in),
    .scl_in     (scl_in),
    .sda_out    (sda_out),
    .sda_oen    (sda_oen),
    .scl_out    (scl_out),
    .scl_oen    (scl_oen)
);

always @(posedge clk) begin
    init_d1 <= init;
    init_d2 <= init_d1;
    black_d1 <= all_black_disp;
    black_d2 <= black_d1;
    white_d1 <= all_white_disp;
    white_d2 <= white_d1;
    interlace_d1 <= interlace_disp;
    interlace_d2 <= interlace_d1;
end

assign init_rising = init_d1 & (~init_d2);
assign black_rising = black_d1 & (~black_d2);
assign white_rising = white_d1 & (~white_d2);
assign interlace_rising = interlace_d1 & (~interlace_d2);

always @(posedge clk) begin
    if (~reset) state <= oled_idle;
    else        state <= state_next;
end

always @(posedge clk) begin
    if (~reset) reg_addr <= 8'b0;
    else begin
        case (state)
            oled_read_cmd: reg_addr <= reg_addr + 8'b1;
            oled_complete: reg_addr <= 8'b0;
        endcase
    end
end

reg [15:0] sleep_cnt;
reg [15:0] sleep_cnt_next;
assign busy = (state_next != 3'b0) ? 1'b1 : 1'b0;
assign config_reg_addr = reg_addr[4:0];

always @(*) begin
    config_reg_read_en  <= 1'b0;
    state_next          <= state;
    write_en            <= 1'b0;
    sleep_cnt_next      <= 16'b0;
    case (state)
        oled_idle: begin
            if (init_rising) begin
                config_reg_read_en  <= 1'b1;
                state_next          <= oled_read_cmd;
            end
        end
        oled_read_cmd: begin
            write_en            <= 1'b1;
            state_next          <= oled_write_i2c;
        end
        oled_write_i2c: begin
            if (i2c_master_done) begin
                state_next <= oled_sleep;
                sleep_cnt_next <= 16'd0;
            end
        end
        oled_sleep: begin
            if (sleep_cnt < sleep_cycle) begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end else begin
                if (reg_addr == CMD_NUM) begin
                    state_next <= oled_complete;
                end else begin
                    sleep_cnt_next      <= 16'd0;
                    state_next          <= oled_read_cmd;
                    config_reg_read_en  <= 1'b1;
                end
            end
        end
        oled_complete: state_next <= oled_idle;
    endcase

end

endmodule
