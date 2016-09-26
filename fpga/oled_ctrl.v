/*
OLED I2C control

Authors:  Zhou Changzhi

Description:
  Work on i2c master side to refresh the whole OLED display each time, either init signal or disp_mode.
  Display all white, all block, white and block interlace and reversed mode.

  1. init       : initialize oled display
  2. disp_mode  : switch four types of display mode on all oled display.
*/
module oled_ctrl
#(
    parameter OLED_CHIP_ADDR = 7'h3C,
    parameter FREQ_DIV_I2C = 5'd30
    )(
    input clk,        // System Clock
    input reset,      // Reset signal
    input  scl_in,
    input  sda_in,    // SDA Input
    output sda_out,   // SDA Output
    output sda_oen,   // SDA Output Enable
    output scl_out,   // SCL Output
    output scl_oen,   // SCL Output Enable
    output reg busy,
    output reg done,
    input       wen,    // for dot matrix print message
    input [7:0] din,    // message (HEX), header and message

    input init,
    input disp_mode,    // posedge trigger.
    input dot_matrix_mode   // posedge trigger
);
localparam I2C_CTRL_STATE_IDLE = 0,
    I2C_CTRL_STATE_INIT = 1,
    I2C_CTRL_STATE_DISP = 2,
    I2C_CTRL_STATE_DOT_MATRIX = 3;

reg write_en;
reg init_d1;
reg init_d2;
wire init_rising;

// oled_init module
reg         oled_init_start;
wire        oled_init_done;
wire [7:0]  oled_init_reg_addr;
wire [7:0]  oled_init_reg_data;
wire        oled_init_write_i2c_en;

// oled_init module
reg         oled_disp_start;
wire        oled_disp_done;
wire [7:0]  oled_disp_reg_addr;
wire [7:0]  oled_disp_reg_data;
wire        oled_disp_write_i2c_en;

reg         oled_dot_matrix_rst_n   ;
wire        oled_dot_matrix_rdy     ;
wire        oled_dot_matrix_done    ;
wire [7:0]  oled_dot_matrix_reg_addr;
wire [7:0]  oled_dot_matrix_reg_data;
wire        oled_dot_matrix_i2c_wen ;



// i2c control
reg  [7:0]  i2c_reg_addr;
reg  [7:0]  i2c_reg_data;
reg         i2c_write_en;
wire        i2c_done;

reg  [1:0]  i2c_ctrl_state;
reg  [1:0]  i2c_ctrl_state_next;

oled_init oled_init
(
    .clk         (clk),
    .reset       (reset),
    .start       (oled_init_start        ),
    .done        (oled_init_done         ),
    .reg_addr    (oled_init_reg_addr     ),
    .reg_data    (oled_init_reg_data     ),
    .write_i2c_en(oled_init_write_i2c_en ),
    .i2c_done    (i2c_done               )
);

oled_disp oled_disp
(
    .clk         (clk),
    .reset       (reset),
    .start       (oled_disp_start        ),
    .done        (oled_disp_done         ),
    .reg_addr    (oled_disp_reg_addr     ),
    .reg_data    (oled_disp_reg_data     ),
    .i2c_write_en(oled_disp_write_i2c_en ),
    .i2c_done    (i2c_done               )
);

oled_dot_matrix_disp oled_dot_matrix_disp
(
    .clk            (clk                        ),
    .rst_n          (oled_dot_matrix_rst_n      ),
    .rdy            (oled_dot_matrix_rdy        ),
    .wen            (wen                        ),
    .din            (din                        ),
    .done           (oled_dot_matrix_done       ),
    .reg_addr       (oled_dot_matrix_reg_addr   ),
    .reg_data       (oled_dot_matrix_reg_data   ),
    .i2c_wen        (oled_dot_matrix_i2c_wen    ),
    .i2c_done       (i2c_done                   )
);

// i2c Master
i2c_master #(
    .ADDR_BYTES(1),
    .DATA_BYTES(1),
    .I2C_CLK_DIV(FREQ_DIV_I2C),
    .I2C_CLK_WIDTH(5)
) i2c_master (
    .clk        (clk),
    .reset      (reset),

    .open_drain (1'b1),

    .chip_addr  (OLED_CHIP_ADDR),
    .reg_addr   (i2c_reg_addr),
    .data_in    (i2c_reg_data),
    .write_en   (i2c_write_en),
    .write_mode (1'b0),
    .read_en    (1'b0),
    .status     (),
    .done       (i2c_done),
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
end

assign init_rising = init_d1 & (~init_d2);

always @(posedge clk) begin
    if (~reset) begin
        i2c_ctrl_state <= I2C_CTRL_STATE_IDLE;
    end else begin
        i2c_ctrl_state <= i2c_ctrl_state_next;
    end
end

always @(posedge clk) begin
    if (~reset) begin
        oled_init_start <= 1'b0;
        oled_disp_start <= 1'b0;
        oled_dot_matrix_rst_n   <= 1'b0;
    end else begin
        oled_init_start <= ((i2c_ctrl_state == I2C_CTRL_STATE_IDLE) && (i2c_ctrl_state_next == I2C_CTRL_STATE_INIT)) ? 1'b1 : 1'b0;
        oled_disp_start <= ((i2c_ctrl_state == I2C_CTRL_STATE_IDLE) && (i2c_ctrl_state_next == I2C_CTRL_STATE_DISP)) ? 1'b1 : 1'b0;
        oled_dot_matrix_rst_n   <= 1'b1;
    end
end

always @(*) begin
    i2c_reg_addr    <= 8'bx;
    i2c_reg_data    <= 8'bx;
    i2c_write_en    <= 1'bx;
    busy            <= 1'b0;
    done            <= 1'b0;
    i2c_ctrl_state_next <= i2c_ctrl_state;
    case (i2c_ctrl_state)
        I2C_CTRL_STATE_IDLE: begin
            i2c_reg_addr            <= oled_dot_matrix_reg_addr;
            i2c_reg_data            <= oled_dot_matrix_reg_data;
            i2c_write_en            <= oled_dot_matrix_i2c_wen;
            done                    <= oled_dot_matrix_done;
            if (init_rising) begin
                i2c_ctrl_state_next <= I2C_CTRL_STATE_INIT;
            end
            else if (disp_mode) begin
                i2c_ctrl_state_next <= I2C_CTRL_STATE_DISP; 
            end
        end
        I2C_CTRL_STATE_INIT: begin
            i2c_reg_addr <= oled_init_reg_addr;
            i2c_reg_data <= oled_init_reg_data;
            i2c_write_en <= oled_init_write_i2c_en;
            busy         <= 1'b1;
            done         <= oled_init_done;
            if (oled_init_done) i2c_ctrl_state_next <= I2C_CTRL_STATE_IDLE;
        end
        I2C_CTRL_STATE_DISP: begin
            i2c_reg_addr <= oled_disp_reg_addr;
            i2c_reg_data <= oled_disp_reg_data;
            i2c_write_en <= oled_disp_write_i2c_en;
            busy         <= 1'b1;
            done         <= oled_disp_done;
            if (oled_disp_done) i2c_ctrl_state_next <= I2C_CTRL_STATE_IDLE;
        end
    endcase
end

endmodule
