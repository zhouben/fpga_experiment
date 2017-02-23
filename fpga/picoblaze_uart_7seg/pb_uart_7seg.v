`timescale 1ns / 1ns

module pb_uart_7seg(
    input           clk_50m,
    input           sw_rst_n,

    output          uart_tx,
    input           uart_rx,
    output [7:0]    leds_o,
    output [5:0]    sels_o
);
`ifdef MODELSIM_SIM
localparam SEG_REFRESH_CYCLE_WIDTH = 10; // 64M
`else
localparam SEG_REFRESH_CYCLE_WIDTH = 26; // 64M
`endif

wire    clk;
wire    rst_n;
reg [SEG_REFRESH_CYCLE_WIDTH-1:0] refresh_count;
reg     [7:0] data;
wire     [7:0] data_rx;
wire    wen_7seg;
wire    baudclk16;
wire    uart_tx_ready;
wire    uart_write_kickoff;
reg [4:0] uart_clk_count;

wire    uart_rx_ready;
reg [7:0] data_rx_r;
reg     uart_rx_ready_d;

// CPU related stuff

wire    [11:0]  address;
wire    [17:0]  instruction;
wire            bram_enable;
wire    [7:0]   port_id;
wire    [7:0]   out_port;
wire    [7:0]   in_port;
wire            write_strobe;
wire            k_write_strobe;
wire            read_strobe;
wire            kcpsm6_reset;         //See note above
wire            rdl;

reg [7:0]       pb_out;
reg             write_strobe_d;

IBUFG ibufg(
    .O (clk),
    .I (clk_50m)
);

seven_seg_interface _7_seg
(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .data   ({8'b0, pb_out, data_rx_r, data} ),
    .wen    (wen_7seg | uart_rx_ready_d | write_strobe_d),
    .base   (1'b0   ),
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
    .tx         (uart_tx            ),
    .data       (data               ),
    .ready      (uart_tx_ready      ),
    .write      (uart_write_kickoff )
);

uart_rx _uart_rx
(
    .clk        (clk                ),
    .reset      (~rst_n             ),
    .baudclk16  (baudclk16          ),
    .rx         (uart_rx            ),
    .data       (data_rx            ),
    .ready      (uart_rx_ready      ),
    .read       (uart_rx_ready      )
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
assign uart_write_kickoff = (refresh_count == 1) ? 1'b1 : 1'b0;
assign baudclk16 = (uart_clk_count == 5'd26) ? 1'b1 : 1'b0;
assign kcpsm6_reset = rdl | ~rst_n;
assign in_port = data;

always @(posedge clk) begin
    if (~rst_n) begin
        refresh_count <= 0;
    end else begin
        refresh_count <= refresh_count + 1;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        data <= 6;
    end else begin
        if (refresh_count == {SEG_REFRESH_CYCLE_WIDTH{1'b1}}) begin
            data <= data + 1;
        end
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        uart_clk_count <= 0;
    end else begin
        if (~uart_tx_ready) begin
            if (uart_clk_count == 5'd26) begin
                uart_clk_count <= 5'b0;
            end else begin
                uart_clk_count <= uart_clk_count + 1;
            end
        end else begin
            uart_clk_count <= 5'b0;
        end
    end
end

always @(posedge clk) begin
    uart_rx_ready_d <= uart_rx_ready;
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
