
module oled_init
(
    input clk,
    input reset,
    input start,
    input i2c_done,
    output reg   done,
    output [7:0] reg_addr,
    output [7:0] reg_data,
    output reg   write_i2c_en
);

localparam CMD_NUM = 5'd28;
localparam sleep_cycle = 50000;
localparam oled_idle = 0,
    oled_start_config = 1,
    oled_configuring = 2,
    oled_wait_done = 3,
    oled_sleep = 4,
    oled_complete = 5;

reg [2:0]   state;
reg [2:0]   state_next;
reg [4:0]   reg_num;

reg [15:0]  sleep_cnt;
reg [15:0]  sleep_cnt_next;
reg [4:0]   rom_addr;
reg         rom_en;

oled_config_rom oled_config_rom (
  .clka(clk), // input clka
  .ena(rom_en), // input ena
  .addra(rom_addr), // input [4 : 0] addra
  .douta(reg_data) // output [7 : 0] douta
);

assign reg_addr[7:0] = 8'b0;

always @(posedge clk) begin
    if (~reset) rom_addr <= 5'b0;
    else begin
        case (state)
            oled_start_config: rom_addr <= rom_addr + 5'b1;
            oled_complete: rom_addr <= 5'b0;
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) sleep_cnt <= 16'b0;
    else        sleep_cnt <= sleep_cnt_next;
end

always @(posedge clk) begin
    if (~reset) state <= oled_idle;
    else        state <= state_next;
end

always @(*) begin
    rom_en          <= 1'b0;
    state_next      <= state;
    write_i2c_en    <= 1'b0;
    sleep_cnt_next  <= 16'b0;
    done            <= 1'b0;
    case (state)
        oled_idle: begin
            if (start) begin
                // read config data from RAM
                rom_en      <= 1'b1;
                state_next  <= oled_start_config;
            end
        end
        oled_start_config: begin
            // config data from RAM has arrived
            // kick off i2c write operation.
            write_i2c_en    <= 1'b1;
            state_next      <= oled_configuring;
        end
        oled_configuring: begin
            if (i2c_done) begin
                state_next <= oled_sleep;
                sleep_cnt_next <= 16'd0;
            end
        end
        oled_sleep: begin
            if (sleep_cnt < sleep_cycle) begin
                sleep_cnt_next <= sleep_cnt + 16'd1;
            end else begin
                if (rom_addr == CMD_NUM) begin
                    state_next <= oled_complete;
                    done        <= 1'b1;
                end else begin
                    sleep_cnt_next      <= 16'd0;
                    state_next          <= oled_start_config;
                    rom_en              <= 1'b1;
                end
            end
        end
        oled_complete: state_next <= oled_idle;
    endcase

end

// synthesis translate_off
reg [8*20:1] state_ascii;
always @(state) begin
    case (state)
        oled_idle           : state_ascii <= "IDLE";
        oled_start_config   : state_ascii <= "START";
        oled_configuring    : state_ascii <= "CONFIG";
        oled_wait_done      : state_ascii <= "WAIT";
        oled_sleep          : state_ascii <= "SLEEP";
        oled_complete       : state_ascii <= "CPLT";
        default             : state_ascii <= "N/A";
    endcase
end
// synthesis translate_on
endmodule

