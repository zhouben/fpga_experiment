module oled_disp_v2 (
    input               clk        ,
    input               rst_n      ,
    output reg          rdy        ,
    input               start      ,
    output reg          done       ,
    input  [7:0]        pos        ,
    input  [7:0]        data       ,
    input               seqential  ,
    output reg [7:0]    reg_addr   ,
    output reg [7:0]    reg_data   ,
    output reg          i2c_wen    ,
    input               i2c_done   
);

localparam DATA_ADDR = 8'h40;
localparam SLEEP_CYCLE  = 16'h7;
localparam IDLE = 0;
localparam RECV = 1;
localparam WR_Y = 2;
localparam WRXL = 3;
localparam WRXH = 4;
localparam WR_D = 5;
localparam WAIT = 6;

reg [3:0] state;
reg [3:0] state_next;
reg [2:0] cnt;

reg [3:0] x;
reg [2:0] x_sub;
reg [2:0] y;
reg         update_pos;
reg [15:0]  sleep_cnt;
reg [15:0]  sleep_cnt_n;
reg [7:0]   disp_value;

always @(posedge clk) begin
    if(~rst_n) begin
        x   <= 4'd0;
        x_sub   <= 4'd0;
        y   <= 3'd0;
        update_pos  <= 1'b1;
        disp_value  <= 8'd0;
    end else begin
        case (state_next)
            RECV    : begin
                disp_value  <= data;
                if(~seqential) begin
                    x   <= pos[7:4];
                    y   <= pos[2:0];
                    update_pos  <= 1'b1;
                end
            end
            WR_D    : begin
                x_sub   <= x_sub + 3'd1;
                update_pos  <= 1'b0;
                if (x_sub == 3'd7) begin
                    x <= x + 3'd1;
                    if (x == 4'd15) begin
                        y <= y + 4'd1;
                        update_pos <= 1'b1;
                    end
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        state <= IDLE;
    end else begin
        state   <= state_next;
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        sleep_cnt <= 16'd0;
    end else begin
        sleep_cnt  <= sleep_cnt_n;
    end
end

always @(*) begin
    i2c_wen     <= 1'b0;
    done        <= 1'b0;
    state_next  <= state;
    sleep_cnt_n <= 16'd0;
    case (state)
        IDLE    : begin
            if (start) begin
                state_next  <= RECV;
            end
        end
        RECV    : begin
            if (update_pos) begin
                state_next  <= WR_Y;
                reg_addr    <= 8'd0;
                reg_data    <= {5'b1011_0, y};
                i2c_wen     <= 1'b1;
                sleep_cnt_n <= 16'd0;
            end else begin
                state_next  <= WR_D;
            end
        end
        WR_Y    : begin
            if (i2c_done) begin
                sleep_cnt_n <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == SLEEP_CYCLE) begin
                sleep_cnt_n <= 16'd0;
                state_next  <= WRXL;
                reg_addr    <= 8'd0;
                reg_data    <= {4'b0001, 1'b0, x[3:1]};
                i2c_wen     <= 1'b1;
            end else if (sleep_cnt != 16'd0) begin
                sleep_cnt_n <= sleep_cnt + 16'd1;
            end
        end
        WRXL    : begin
            if (i2c_done) begin
                sleep_cnt_n <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == SLEEP_CYCLE) begin
                sleep_cnt_n <= 16'd0;
                state_next  <= WRXH;
                reg_addr    <= 8'd0;
                reg_data    <= {4'b0000, x[0], 3'd0};
                i2c_wen     <= 1'b1;
            end else if (sleep_cnt != 16'd0) begin
                sleep_cnt_n <= sleep_cnt + 16'd1;
            end
        end
        WRXH    : begin
            if (i2c_done) begin
                sleep_cnt_n <= sleep_cnt + 16'd1;
            end else if (sleep_cnt == SLEEP_CYCLE) begin
                sleep_cnt_n     <= 16'd0;
                state_next      <= WR_D;
            end else if (sleep_cnt != 12'd0 )begin
                sleep_cnt_n     <= sleep_cnt + 16'd1;
            end
        end
        WR_D    : begin
            reg_addr        <= DATA_ADDR;
            reg_data        <= disp_value;
            i2c_wen         <= 1'b1;
            state_next      <= WAIT;
        end
        WAIT    : begin
            if (i2c_done) begin
                done        <= 1'b1;
                state_next  <= IDLE;
            end
        end
    endcase
end

// synthesis translate_off
always @(posedge clk) begin
    if (i2c_wen) begin
        $display("I2C: %02x %02X", reg_addr, reg_data);
    end
end

reg [8*22:0] state_ascii;
always @(*) begin
    case (state)
        IDLE : state_ascii <= "IDLE";
        RECV : state_ascii <= "RECV";
        WR_Y : state_ascii <= "WR_Y";
        WRXL : state_ascii <= "WRXL";
        WRXH : state_ascii <= "WRXH";
        WR_D : state_ascii <= "WR_D";
        WAIT : state_ascii <= "WAIT";
    endcase
end
// synthesis translate_on

endmodule
