/*
* input data (all HEX)
*
* 1. HEADER (xy position, one bytes)
* 2. Print Message (HEX value, one or more bytes, depending on wen)
*
* All input data will be stored into an internal buffer until wen is disable
* Then the data (HEX) in the internal buffer will be printed in OLED display.
*/
module oled_dot_matrix_disp
(
    input           clk         ,
    input           rst_n       ,
    output reg      rdy         ,
    input           wen         ,
    input [7:0]     din         ,
    output reg      done        ,
    output [7:0]    reg_addr    ,
    output [7:0]    reg_data    ,
    output          i2c_wen     ,
    input           i2c_done    
);

localparam IDLE         = 0;
localparam RECV_HEADER  = 1;
localparam RECV_DATA    = 2;
localparam WAIT_FOR_DISP= 3;
localparam START_DISP   = 5;
localparam WAIT_FOR_CPLT= 6;
localparam SET_DATA     = 7;

localparam DISP_DELAY_MAX = 24'h10;

reg [23:0]  disp_cnt;
reg [3:0]   state;
reg [3:0]   state_next;
reg [3:0]   x_cfg;
reg [3:0]   y_cfg;
reg [6:0]   ram_recv_idx;
reg [6:0]   ram_idx;
wire [7:0]  ram_data;
reg         data_half;  // 0: hight, 1: low
wire [63:0] dot_matrix_data;
reg [2:0]   x_sub;
reg         is_sequential;
reg         disp_start;
reg [7:0]   disp_data;

wire [3:0]  rom_addr;

assign rom_addr = (data_half ? ram_data[3:0] : ram_data[7:4]);

dot_matrix_rom dot_matrix_rom (
  .clka(clk), // input clka
  .addra(rom_addr), // input [3 : 0] addra
  .douta(dot_matrix_data) // output [63 : 0] douta
);

oled_dot_matrix_buffer oled_dot_matrix_buffer (
  .clka(clk), // input clka
  .wea(wen), // input [0 : 0] wea
  .addra(wen ? ram_recv_idx : ram_idx), // input [6 : 0] addra
  .dina(din), // input [7 : 0] dina
  .douta(ram_data) // output [7 : 0] douta
);

oled_disp_v2 oled_disp_v2(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .rdy        (               ),
    .start      (disp_start     ),
    .done       (disp_done      ),
    .pos        ({x_cfg, y_cfg} ),
    .data       (disp_data      ),
    .seqential  (is_sequential  ),
    .reg_addr   (reg_addr       ),
    .reg_data   (reg_data       ),
    .i2c_wen    (i2c_wen        ),
    .i2c_done   (i2c_done       )
);

always @(posedge clk) begin
    if (~rst_n) begin
        state   <= IDLE;
    end else begin
        state   <= state_next;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        disp_cnt    <= 24'd0;
    end else begin
        if (done)               disp_cnt    <= DISP_DELAY_MAX;
        else if (disp_cnt != 0) disp_cnt    <= disp_cnt - 24'd1;
        else                    disp_cnt    <= disp_cnt;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
    end else begin
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        x_sub           <= 4'd0;
        data_half   <= 1'b0;
        ram_idx         <= 7'd0;
    end else begin
        case (state)
            START_DISP, SET_DATA : begin
                x_sub   <= x_sub + 3'd1;
                if (x_sub == 3'd7) begin
                    data_half    <= data_half + 1'b1;
                    if (data_half == 1'b1) ram_idx  <= ram_idx + 7'd1;
                end
            end
            WAIT_FOR_CPLT: begin
                x_sub   <= x_sub;
                data_half       <= data_half;
                ram_idx         <= ram_idx;
            end
            default: begin
                x_sub           <= 4'd0;
                data_half       <= 1'd0;
                ram_idx         <= 7'd0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        is_sequential   <= 1'b0;
    end else begin
        case (state_next)
            START_DISP: begin
                is_sequential   <= 1'd0;
                disp_start      <= 1'b1;
            end
            SET_DATA : begin
                is_sequential   <= 1'd1;
                disp_start      <= 1'b1;
            end
            default : begin
                is_sequential   <= 1'd0;
                disp_start      <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        x_cfg   <= 4'd0;
        y_cfg   <= 4'd0;
    end else begin
        if (state_next == RECV_HEADER) begin
            x_cfg <= din[7:4];
            y_cfg <= din[3:0];
        end
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        ram_recv_idx    <= 7'd0;
    end else begin
        case (state_next)
            RECV_HEADER : ram_recv_idx <= 7'd0;
            RECV_DATA   : ram_recv_idx <= ram_recv_idx + 7'd1;
            default     : ram_recv_idx <= ram_recv_idx;
        endcase
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        rdy    <= 1'b1;
    end else begin
        case (state_next)
            WAIT_FOR_DISP, START_DISP, WAIT_FOR_CPLT, SET_DATA: rdy <= 1'b0;
            IDLE, RECV_HEADER, RECV_DATA : rdy <= 1'b1;
        endcase
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        done    <= 1'b0;
    end else begin
        if((state == WAIT_FOR_CPLT) && (disp_done) && (ram_idx == ram_recv_idx)) begin
            done    <= 1'd1;
        end else begin
            done    <= 1'b0;
        end
    end
end

always @(*) begin
    state_next  <= state;
    case (state)
        IDLE        : if(wen) state_next  <= RECV_HEADER;
        RECV_HEADER : begin
            if(wen) begin 
                state_next  <= RECV_DATA;
            end else begin
                state_next  <= IDLE;
            end
        end
        RECV_DATA   : begin
            if(wen) state_next  <= RECV_DATA;
            else    state_next  <= WAIT_FOR_DISP;
        end
        WAIT_FOR_DISP: if(disp_cnt == 0) state_next  <= START_DISP;
        START_DISP  : begin
            state_next  <= WAIT_FOR_CPLT;
        end
        WAIT_FOR_CPLT : begin
            if (disp_done) begin
                if (ram_idx == ram_recv_idx) state_next  <= IDLE;
                else state_next <= SET_DATA;
            end else            state_next <= WAIT_FOR_CPLT;
        end
        SET_DATA : begin
            state_next  <= WAIT_FOR_CPLT;
        end
    endcase
end

always @(*) begin
    disp_data   <= 8'bx;
    case (x_sub)
        0:  disp_data <= dot_matrix_data[63:56];
        1:  disp_data <= dot_matrix_data[55:48];
        2:  disp_data <= dot_matrix_data[47:40];
        3:  disp_data <= dot_matrix_data[39:32];
        4:  disp_data <= dot_matrix_data[31:24];
        5:  disp_data <= dot_matrix_data[23:16];
        6:  disp_data <= dot_matrix_data[15:8];
        7:  disp_data <= dot_matrix_data[7:0];
    endcase
end

// synthesis translate_off
reg [8*22:0] state_ascii;
always @(state) begin
    case (state)
        IDLE         : state_ascii <= "IDLE";
        RECV_HEADER  : state_ascii <= "RECV_HEADER";
        RECV_DATA    : state_ascii <= "RECV_DATA";
        WAIT_FOR_DISP: state_ascii <= "WAIT_FOR_DISP";
        START_DISP   : state_ascii <= "START_DISP";
        WAIT_FOR_CPLT: state_ascii <= "WAIT_FOR_CPLT";
        SET_DATA     : state_ascii <= "SET_DATA";
        default      : state_ascii <= "N/A";
    endcase
end
// synthesis translate_on

endmodule
