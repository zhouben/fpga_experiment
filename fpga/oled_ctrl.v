/*
OLED I2C control

Authors:  Zhou Changzhi

Description:
  i2c master side.
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

    input init,
    input disp_mode     // posedge trigger.
);
localparam i2c_ctrl_state_idle = 0,
    i2c_ctrl_state_init = 1,
    i2c_ctrl_state_disp = 2;

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
        i2c_ctrl_state <= i2c_ctrl_state_idle;
    end else begin
        i2c_ctrl_state <= i2c_ctrl_state_next;
    end
end
always @(*) begin
    i2c_reg_addr    <= 8'bx;
    i2c_reg_data    <= 8'bx;
    i2c_write_en    <= 1'bx;
    busy            <= 1'b0;
    done            <= 1'b0;
    oled_init_start <= 1'b0;
    oled_disp_start <= 1'b0;
    i2c_ctrl_state_next <= i2c_ctrl_state;
    case (i2c_ctrl_state)
        i2c_ctrl_state_idle: begin
            if (init_rising) begin
                i2c_ctrl_state_next <= i2c_ctrl_state_init;
                i2c_reg_addr        <= oled_init_reg_addr;
                i2c_reg_data        <= oled_init_reg_data;
                i2c_write_en        <= oled_init_write_i2c_en;
                oled_init_start     <= 1'b1;
                busy                <= 1'b1;
            end
            else if (disp_mode) begin
                i2c_ctrl_state_next <= i2c_ctrl_state_disp; 
                i2c_reg_addr        <= oled_disp_reg_addr;
                i2c_reg_data        <= oled_disp_reg_data;
                i2c_write_en        <= oled_disp_write_i2c_en;
                oled_disp_start     <= 1'b1;
                busy                <= 1'b1;
            end
        end
        i2c_ctrl_state_init: begin
            i2c_reg_addr <= oled_init_reg_addr;
            i2c_reg_data <= oled_init_reg_data;
            i2c_write_en <= oled_init_write_i2c_en;
            busy         <= 1'b1;
            done         <= oled_init_done;
            if (oled_init_done) i2c_ctrl_state_next <= i2c_ctrl_state_idle;
        end
        i2c_ctrl_state_disp: begin
            i2c_reg_addr <= oled_disp_reg_addr;
            i2c_reg_data <= oled_disp_reg_data;
            i2c_write_en <= oled_disp_write_i2c_en;
            busy         <= 1'b1;
            done         <= oled_disp_done;
            if (oled_disp_done) i2c_ctrl_state_next <= i2c_ctrl_state_idle;
        end
    endcase
end

endmodule
