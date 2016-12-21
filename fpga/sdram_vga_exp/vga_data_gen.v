`timescale 1ns/1ps

module vga_data_gen #(
    parameter   DATA_DEPTH = 1024*768,
    parameter   SPAN_NUM   = 1
)(
    input           clk     ,
    input           rst_n   ,
    input           start_i ,
    input           wr_en   ,
    output reg      data_en ,
    output [15:0]   dout    
);
reg     start_d1;
reg     start_d2;
reg     start_d3;
wire    start_pulse;

reg [ 9:0]  pixel_init;
reg [19:0]  pixel;
reg [19:0]  pixel_next;
reg [1:0]   state;
reg [1:0]   state_next;

localparam IDLE      = 2'd0;
localparam PRE_WRITE = 2'd1;
localparam WRITING   = 2'd2;
localparam COMPLETE  = 2'd3;

`define WRITE_COMPLETE (pixel_init + DATA_DEPTH == pixel_next)

assign start_pulse = start_d2 & ~start_d3;
assign dout = {6'd0, pixel[9:0]};

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        start_d1 <= 1'b0;
        start_d2 <= 1'b0;
        start_d3 <= 1'b0;
    end else begin
        start_d1 <= start_i;
        start_d2 <= start_d1;
        start_d3 <= start_d2;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pixel_init  <= 10'd0;
    end else begin
        if (state_next == COMPLETE) begin
            pixel_init  <= pixel_init + SPAN_NUM;
        end
    end
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        pixel       <= 19'd0;
        pixel_next  <= 19'd0;
        data_en     <= 1'b0;
    end else begin
        pixel       <= pixel;
        pixel_next  <= pixel_next;
        data_en     <= 1'b0;
        case (state_next)
            PRE_WRITE: begin
                pixel_next   <= {10'b0, pixel_init};
            end
            WRITING: begin
                if (wr_en) begin
                    pixel   <= pixel_next;
                    pixel_next <= pixel_next + 16'd1;
                    data_en <= 1'b1;
                end
            end
        endcase
    end
end

always @(*) begin
    state_next <= state;
    case (state)
        IDLE: begin
            if (start_pulse) begin
                state_next <= PRE_WRITE;
            end
        end
        PRE_WRITE: begin
            state_next <= WRITING;
        end
        WRITING: begin
            if `WRITE_COMPLETE begin
                state_next <= COMPLETE;
            end
        end
        COMPLETE: begin
            state_next <= IDLE;
        end
    endcase
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state   <= IDLE;
    end else begin
        state   <= state_next;
    end
end

endmodule
