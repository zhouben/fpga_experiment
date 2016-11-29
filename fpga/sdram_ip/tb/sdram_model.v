`timescale 1ns/1ps

module sdram_model
#(
    parameter MEMORY_DEPTH = 65536,
    parameter COLUMN_WIDTH = 9,
    parameter CL   = 2
)
(
    input        sdram_clk      ,
    input        sdram_cke      ,
    input        sdram_cs_n     ,
    input        sdram_we_n     ,
    input        sdram_cas_n    ,
    input        sdram_ras_n    ,
    input        sdram_udqm     ,
    input        sdram_ldqm     ,
    input [ 1:0] sdram_ba       ,
    input [12:0] sdram_addr     ,
    inout [15:0] sdram_data
);

localparam COLUMN_MAX_NUM = ((1 << COLUMN_WIDTH) - 1);
localparam IDLE_STATE  = 3'd0;
localparam WRITE_STATE = 3'd1;
localparam WRITE_END   = 3'd2;
localparam PRE_READ    = 3'd3;
localparam READ_STATE  = 3'd4;
localparam READ_END_0  = 3'd5;
localparam READ_END_1  = 3'd6;

localparam CMD_ACTIVE       = 4'b0011;
localparam CMD_NOP          = 4'b0111;
localparam CMD_WRITE        = 4'b0100;
localparam CMD_READ         = 4'b0101;
localparam CMD_BURST_TERM   = 4'b0110;  // burst terminate
localparam CMD_AUTO_REFRESH = 4'b0001;  // auto-refresh

localparam MEMORY_DEPTH_BITS = clogb2(MEMORY_DEPTH - 1);

reg [2:0]   state;
reg [1:0]   bank;
reg [12:0]  row;
reg [8:0]   col;
reg         wen;
wire        rst;
wire [3:0]  cmd;
reg [15:0]  value;
reg [8:0]   cnt;

reg [23:0]  addr;
reg [15:0]  memory[MEMORY_DEPTH - 1:0];
reg [15:0]  wr_data;

reg         read_overflow;  // out of a row

assign sdram_data = (state == READ_STATE || state == READ_END_0 || state == READ_END_1) ? value : 16'bz;
assign rst = sdram_cs_n;
assign cmd = {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n};

integer _i;

initial begin
    for (_i = 0; _i < MEMORY_DEPTH; _i = _i + 1) begin
        memory[_i] = _i;
    end
end


always @(posedge sdram_clk, posedge rst) begin
    if (rst) begin
        state   <= IDLE_STATE;
        value   <= 16'd0;
        cnt     <= 9'd0;
        read_overflow <= 1'b0;
    end else begin
        state   <= state;
        read_overflow <= 1'b0;
        case (state)
            IDLE_STATE: begin
                case (cmd)
                    CMD_ACTIVE: begin
                        row     <= sdram_addr;
                        bank    <= sdram_ba;
                    end
                    CMD_WRITE: begin
                        col <= sdram_addr[8:0];
                        state   <= WRITE_STATE;
                        addr    <= {bank, row, sdram_addr[8:0]};
                        wr_data <= sdram_data;
                    end
                    CMD_READ: begin
                        col     <= sdram_addr[8:0];
                        addr    <= {bank, row, sdram_addr[8:0]};
                        state   <= PRE_READ;
                        cnt     <= 9'd0;
                        read_overflow <= 1'b0;
                    end
                endcase
            end
            WRITE_STATE: begin
                if (cmd == CMD_BURST_TERM) state <= WRITE_END;
                wr_data <= sdram_data;
                addr    <= addr + 24'd1;
                memory[addr[MEMORY_DEPTH_BITS:0]] <= wr_data;
            end
            WRITE_END: begin
                memory[addr[MEMORY_DEPTH_BITS:0]] <= wr_data;
                state   <= IDLE_STATE;
            end
            PRE_READ: begin
                cnt <= cnt + 9'd1;
                if (cmd == CMD_BURST_TERM) begin
                end else if (cnt == (CL -1)) begin
                    state   <= READ_STATE;
                    value   <= memory[addr[MEMORY_DEPTH_BITS:0]];
                    addr    <= addr + 24'd1;
                    cnt     <= 9'd0;
                    if (addr[COLUMN_WIDTH - 1:0] == COLUMN_MAX_NUM) begin
                        state   <= READ_END_0;
                        read_overflow <= 1'b1;
                    end
                end
            end
            READ_STATE: begin
                value   <= memory[addr[MEMORY_DEPTH_BITS:0]];
                if (addr[COLUMN_WIDTH - 1:0] == COLUMN_MAX_NUM) begin
                    state   <= READ_END_0;
                    read_overflow <= 1'b1;
                end
                addr    <= addr + 24'd1;
                if (cmd == CMD_BURST_TERM) begin
                    state   <= READ_END_0;
                end
            end
            READ_END_0: begin
                read_overflow <= 1'b1;
                value   <= read_overflow ? {(MEMORY_DEPTH_BITS + 1){1'bx}} : memory[addr[MEMORY_DEPTH_BITS:0]];
                addr    <= addr + 24'd1;
                state   <= READ_END_1;
            end
            READ_END_1: begin
                value   <= read_overflow ? {MEMORY_DEPTH_BITS + 1{1'bx}} : memory[addr[MEMORY_DEPTH_BITS:0]];
                state   <= IDLE_STATE;
                read_overflow <= 1'b1;
            end
        endcase
    end

end

function integer clogb2(input integer depth);
    begin
        for (clogb2=0; depth > 0; clogb2 = clogb2 + 1)
            depth = depth >> 1;
    end
endfunction

function integer dump_memory(input reg [8*32 -1 :0] file_name);
    integer fp_w;
    integer cnt;
    begin
        fp_w = $fopen(file_name, "w");
        cnt = 0;
        while (cnt < MEMORY_DEPTH) begin
            $fwrite(fp_w, "%d\n", memory[cnt]);
            cnt = cnt + 1;
        end
        $fclose(fp_w);
    end
endfunction

endmodule
