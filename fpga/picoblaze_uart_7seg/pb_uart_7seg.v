/*
* Receive data from UART and crc them.
    * Update received data number and crc value via 7-segment LED.
    */
`timescale 1ns / 1ns

module pb_uart_7seg(
    input           clk_50m,
    input           sw_rst_n,
    input           led_disp_switch,

    output          uart_tx_o,
    input           uart_rx_i,
    output [7:0]    leds_o,
    output [5:0]    sels_o
);
`ifdef MODELSIM_SIM
localparam SEG_REFRESH_CYCLE_WIDTH = 10; // 64M
`else
localparam SEG_REFRESH_CYCLE_WIDTH = 16; // 64M
`endif

wire    clk;
wire    rst_n;
reg [SEG_REFRESH_CYCLE_WIDTH-1:0] refresh_count;
wire    wen_7seg;

reg  [4:0]  uart_clk_count;
reg  [7:0]  data_tx;
wire [7:0]  data_rx;
wire        baudclk16;
wire        uart_tx_ready;
reg         uart_tx_en;

wire    uart_rx_ready;

// CPU related stuff

wire    [11:0]  address;
wire    [17:0]  instruction;
wire            bram_enable;
wire    [7:0]   port_id;
wire    [7:0]   out_port;
reg     [7:0]   in_port;
wire            write_strobe;
wire            k_write_strobe;
wire            read_strobe;
wire            kcpsm6_reset;         //See note above
wire            rdl;

reg [7:0]       pb_out;
reg             write_strobe_d;

// xor value for UART data in
reg  [31:0]      crc;
wire [31:0]      crc_out;
// uart data count
reg [19:0]      uart_din_count;
reg  [7:0]      data_rx_r;

IBUFG ibufg(
    .O (clk),
    .I (clk_50m)
);

seven_seg_interface _7_seg
(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   (led_disp_switch ? uart_din_count : crc[23:0] ),
    .wen    (wen_7seg),
    .base   (led_disp_switch ? 1'b1 : 1'b0   ),
    .rdy    (       ),
    .done   (       ),
    .leds_o (leds_o ),
    .sels_o (sels_o )
);

uart_tx _uart_tx
(
    .clk        (clk                ),
    .reset      (~rst_n             ),
    .baudclk16  (baudclk16          ),
    .tx         (uart_tx_o          ),
    .data       (data_tx            ),
    .ready      (uart_tx_ready      ),
    .write      (uart_tx_en         )
);

uart_rx _uart_rx
(
    .clk        (clk                ),
    .reset      (~rst_n             ),
    .baudclk16  (baudclk16          ),
    .rx         (uart_rx_i          ),
    .data       (data_rx            ),
    .ready      (uart_rx_ready      ),
    .read       (uart_rx_ready      )
);

crc _crc
(
    .clk        (clk            ),
    .reset      (~rst_n         ),
    .en         (uart_rx_ready  ),
    .din        (data_rx        ),
    .crc_out    (crc_out        )
);

kcpsm6
#(
    .interrupt_vector       (12'h3FF),
    .scratch_pad_memory_size(64),
    .hwbuild                (8'h00)
)
processor
(
    .address        (address),
    .instruction    (instruction),
    .bram_enable    (bram_enable),
    .port_id        (port_id),
    .write_strobe   (write_strobe),
    .k_write_strobe (k_write_strobe),
    .out_port       (out_port),
    .read_strobe    (read_strobe),
    .in_port        (in_port),
    .interrupt      (1'b0           ),
    .interrupt_ack  (               ),
    .reset          (kcpsm6_reset),
    .sleep          (1'b0           ),
    .clk            (clk)
);

fw _fw
(
    .address    (address    ),
    .instruction(instruction),
    .enable     (bram_enable),
    .rdl        (rdl        ),
    .clk        (clk        )
);

assign rst_n = sw_rst_n;
assign wen_7seg = (refresh_count == 1) ? 1'b1 : 1'b0;
assign baudclk16 = (uart_clk_count == 5'd26) ? 1'b1 : 1'b0;
assign kcpsm6_reset = rdl | ~rst_n;

always @(posedge clk) begin
    if (~rst_n) begin
        refresh_count <= 0;
    end else begin
        refresh_count <= refresh_count + 1;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        data_rx_r <= 0;
    end else begin
        if (uart_rx_ready) begin
            data_rx_r <= data_rx;
        end
    end
end

// to generazte baudrate clock 16 for UART
always @(posedge clk) begin
    if (~rst_n) begin
        uart_clk_count <= 0;
    end else begin
        if (uart_clk_count == 5'd26) begin
            uart_clk_count <= 5'b0;
        end else begin
            uart_clk_count <= uart_clk_count + 1;
        end
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        uart_din_count  <= 20'd0;
        crc             <= 32'd0;
    end else begin
        if (uart_rx_ready) begin
            uart_din_count  <= uart_din_count + 20'd1;
            crc             <= {crc_out[7:0], crc_out[15:8], crc_out[23:16], crc_out[31:24]};
        end
    end
end

// Picoblaze r/w uart
always @(*) begin
    case (port_id)
        8'd0   : in_port <= uart_din_count;
        8'd1   : in_port <= data_rx_r;
        8'd2   : in_port <= crc[ 7: 0];
        8'd3   : in_port <= crc[15: 8];
        8'd4   : in_port <= crc[23:16];
        8'd5   : in_port <= crc[31:24];
        8'd6   : in_port <= {7'd0, uart_tx_ready};
        default: in_port <= 8'd0;
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin
        data_tx <= 8'd0;
        uart_tx_en <= 1'b0;
    end else begin
        uart_tx_en <= 1'b0;
        if (write_strobe) begin
            case (port_id)
                8'd0    : data_tx <= out_port;
                8'd1    : uart_tx_en <= out_port[0];
            endcase
        end
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        pb_out <= 8'b0;
        write_strobe_d <= 1'b0;
    end else begin
        if (write_strobe) begin
            pb_out <= out_port;
            write_strobe_d <= write_strobe;
        end else begin
            pb_out <= pb_out;
            write_strobe_d <= 1'b0;
        end
    end
end
endmodule
