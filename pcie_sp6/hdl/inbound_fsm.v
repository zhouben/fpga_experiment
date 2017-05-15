module INBOUND_FSM (
    input                 clk,
    input                 rst_n,

    output                rx_np_ok_o,
    input                 cmd_compl_i, // 1: active
    input  [1:0]          cmd_id_i,   // cmd ID

    input                 req_compl_i,   // from RX engine
    input                 req_compl_with_data_i,
    output                compl_done_o,

    input       [10:0]    rd_addr_i, /* read port */
    input       [3:0]     rd_be_i,
    output reg  [31:0]    rd_data_o,
    input       [10:0]    wr_addr_i, /* write port */
    input       [7:0]     wr_be_i,
    input       [31:0]    wr_data_i,
    input                 wr_en_i,
    output                wr_busy_o,

    input  [2:0]          req_tc_i,
    input                 req_td_i,
    input                 req_ep_i,
    input  [1:0]          req_attr_i,
    input  [9:0]          req_len_i,
    input  [15:0]         req_rid_i,
    input  [7:0]          req_tag_i,
    input  [7:0]          req_be_i,
    input  [12:0]         req_addr_i,

    input                 us_cmd_fifo_full_i,
    input                 us_cmd_fifo_prog_full_i,
    output reg [127:0]    us_cmd_fifo_din_o,
    output                us_cmd_fifo_wr_en_o
);

localparam US_CMD_CPL_TYPE  = 2'b00;
localparam US_CMD_CPLD_TYPE = 2'b01;
localparam US_CMD_WR32_TYPE = 2'b10;
localparam US_CMD_INVALID   = 2'b11;

localparam WR_MEM_IDLE          = 3'd0;
localparam WR_MEM_WRITING       = 3'd1;
localparam WR_MEM_PRE_ISSUE_CMD = 3'd2;
localparam WR_MEM_ISSUE_CMD     = 3'd3;
localparam WR_MEM_PRE_ISSUE_CPL = 3'd4;
localparam WR_MEM_ISSUE_CPL     = 3'd5;
localparam WR_MEM_PRE_ISSUE_CPLD= 3'd6;
localparam WR_MEM_ISSUE_CPLD    = 3'd7;

/*
+-------+-------+-------+-------+
| cmd   | len   | state |       |
+-------+-------+-------+-------+
| addr0 |       | addr1 |       |
+-------+-------+-------+-------+
    */
reg [1:0]   cmd;     // 0: idle, 1: need to upstream DMA xfer
reg [1:0]   cmd_next;
wire [1:0]  cmd_id;
reg [1:0]   state;   // 0: idle, 1: busy
reg [1:0]   state_next;
reg [4:0]   len;      // 2^(len)
reg [31:0]  addr_0;  // host memory address 0
reg [31:0]  addr_1;  // host memory address 1

reg  [1:0]   us_cmd_type;   // one of US_CMD_xxx_TYPE

reg [2:0]   inbound_state;
reg [2:0]   inbound_state_next;

wire        us_cmd_fifo_empty;
wire        us_cmd_fifo_prog_full;
reg [54:0]  req_d;
wire [31:0] host_addr_to_write;

assign wr_busy_o = (inbound_state == WR_MEM_IDLE) ? 1'b0 : 1'b1;
assign cmd_id = (cmd[0] ? 2'd0 : (cmd[1] ? 2'd1 : 2'd0));


always @(*) begin
    case (inbound_state)
        WR_MEM_ISSUE_CPL : us_cmd_type <= US_CMD_CPL_TYPE;
        WR_MEM_ISSUE_CPLD: us_cmd_type <= US_CMD_CPLD_TYPE;
        WR_MEM_ISSUE_CMD : us_cmd_type <= US_CMD_WR32_TYPE;
        default          : us_cmd_type <= US_CMD_INVALID;
    endcase

end

assign us_cmd_fifo_wr_en_o = ((inbound_state == WR_MEM_ISSUE_CMD) || (inbound_state == WR_MEM_ISSUE_CPL) || (inbound_state == WR_MEM_ISSUE_CPLD)) ? 1'b1 : 1'b0;
always @(*) begin
    case (inbound_state)
        WR_MEM_ISSUE_CPLD, WR_MEM_ISSUE_CPL: us_cmd_fifo_din_o[54:0] <= req_d;
        WR_MEM_ISSUE_CMD                   : us_cmd_fifo_din_o[54:0] <= {23'd0, host_addr_to_write};
        default                            : us_cmd_fifo_din_o[54:0] <= 0;
    endcase
end

always @(*) begin
    us_cmd_fifo_din_o[63:55] <= {
        us_cmd_type,    // 2 bits
        len,            // 5 bits
        cmd_id          // 2 bits
        };
    end
assign host_addr_to_write = (cmd[0]? addr_0 : addr_1);

always @(posedge clk) begin
    if (!rst_n) begin
        req_d <= 55'd0;
    end else if (inbound_state == WR_MEM_IDLE) begin
        req_d <= { req_tc_i, req_td_i, req_ep_i, req_attr_i, req_len_i, req_rid_i, req_tag_i, req_be_i, req_addr_i[7:0] };
    end
end

assign compl_done_o = ((inbound_state == WR_MEM_ISSUE_CPL) || (inbound_state == WR_MEM_ISSUE_CPLD)) ? 1 : 0;

// TODO template
always @(posedge clk) begin
    if (!rst_n) begin
    end else begin
    end
end

always @(*) begin
    case (rd_addr_i[4:2])
        3'b000 : rd_data_o <= {30'b0, cmd};
        3'b001 : rd_data_o <= len;
        3'b010 : rd_data_o <= {30'b0, state};
        3'b100 : rd_data_o <= addr_0;
        3'b110 : rd_data_o <= addr_1;
        default: rd_data_o <= 32'd0;
    endcase
end


always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'b0;
    end else begin
        state <= state_next;
    end
end

always @(*) begin
    state_next <= 2'hx;
    case ({cmd_compl_i, (cmd[1] && !state[1]), (cmd[0] && !state[0]) })
        3'b001, 3'b011: begin state_next <= {state[1], 1'b1}; end
        3'b010        : begin state_next <= {1'b1, state[0]}; end
        3'b100        : begin
            case (cmd_id_i)
                2'd0: state_next <= {state[1], 1'b0};
                2'd1: state_next <= {1'b0, state[0]};
                default: state_next <= state;
            endcase
        end
        3'b101: begin
            case (cmd_id_i)
                2'd0: state_next <= {state[1], 1'b1};
                2'd1: state_next <= {1'b0, state[0]};
                default: state_next <= state;
            endcase
        end
        3'b110: begin
            case (cmd_id_i)
                2'd0: state_next <= {state[1], 1'b0};
                2'd1: state_next <= {1'b1, state[0]};
                default: state_next <= state;
            endcase
        end
        3'b111: begin
            case (cmd_id_i)
                2'd0: state_next <= {state[1], 1'b1};
                2'd1: state_next <= {1'b1, state[0]};
                default: state_next <= state;
            endcase
        end
        3'b000: state_next <= state;
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        inbound_state <= WR_MEM_IDLE;
    end else begin
        inbound_state <= inbound_state_next;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        len     <= 8'd6;
        addr_0  <= 32'd0;
        addr_1  <= 32'd0;
    end else if (inbound_state_next == WR_MEM_WRITING) begin
        case (wr_addr_i[4:2])
            3'b001 : len    <= wr_data_i;
            3'b100 : addr_0 <= wr_data_i;
            3'b110 : addr_1 <= wr_data_i;
        endcase
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        cmd <= 2'b0;
    end else begin
        cmd <= cmd_next;
    end
end

always @(*) begin
    cmd_next <= cmd;
    case (inbound_state)
        WR_MEM_IDLE: begin
            case ({req_compl_i, wr_en_i})
                2'b00 : inbound_state_next <= inbound_state;
                2'b01 : begin
                    case (wr_addr_i[4:2])
                        3'b000 : begin
                            if (|wr_data_i[1:0] && ((wr_data_i[1:0] & (~state )) != 0)) begin
                                inbound_state_next <= (us_cmd_fifo_full_i) ? WR_MEM_PRE_ISSUE_CMD : WR_MEM_ISSUE_CMD;
                                cmd_next <= wr_data_i[1:0] & (~state);
                            end else begin
                                inbound_state_next <= inbound_state;
                            end
                        end
                        3'b001, 3'b100, 3'b110 : inbound_state_next <= WR_MEM_WRITING; 
                        default: inbound_state_next <= inbound_state;
                    endcase
                end
                2'b10 : begin
                    case ({us_cmd_fifo_full_i, req_compl_with_data_i})
                        2'b00 : inbound_state_next <= WR_MEM_ISSUE_CPL;
                        2'b01 : inbound_state_next <= WR_MEM_ISSUE_CPLD;
                        2'b10 : inbound_state_next <= WR_MEM_PRE_ISSUE_CPL;
                        2'b11 : inbound_state_next <= WR_MEM_PRE_ISSUE_CPLD;
                    endcase
                end
                2'b11 : inbound_state_next <= 3'bxxx;
            endcase
        end
        WR_MEM_WRITING: inbound_state_next <= WR_MEM_IDLE;
        WR_MEM_PRE_ISSUE_CMD: begin
            inbound_state_next <= (us_cmd_fifo_full_i) ? WR_MEM_PRE_ISSUE_CMD : WR_MEM_ISSUE_CMD;
        end
        WR_MEM_ISSUE_CMD: begin
            case (cmd)
                2'd1, 2'd2: begin inbound_state_next <= WR_MEM_IDLE; cmd_next <= 2'd0; end
                2'd3      : begin
                    if (!us_cmd_fifo_full_i) begin
                        inbound_state_next <= WR_MEM_ISSUE_CMD;
                        cmd_next <= 2'd2;
                    end
                end
                default   : inbound_state_next <= WR_MEM_IDLE;
            endcase
        end
        WR_MEM_PRE_ISSUE_CPL: begin
            inbound_state_next <= (us_cmd_fifo_full_i) ? WR_MEM_PRE_ISSUE_CPL : WR_MEM_ISSUE_CPL;
        end
        WR_MEM_ISSUE_CPL: begin
            inbound_state_next <= WR_MEM_IDLE;
        end
        WR_MEM_PRE_ISSUE_CPLD: begin
            inbound_state_next <= (us_cmd_fifo_full_i) ? WR_MEM_PRE_ISSUE_CPLD : WR_MEM_ISSUE_CPLD;
        end
        WR_MEM_ISSUE_CPLD: begin
            inbound_state_next <= WR_MEM_IDLE;
        end
    endcase
end

// synthesis translate_off
reg [8*20:0] inbound_state_ascii;
always @(*) begin
    case (inbound_state)
        WR_MEM_IDLE          : inbound_state_ascii <= "IDLE";
        WR_MEM_WRITING       : inbound_state_ascii <= "WRITING";
        WR_MEM_PRE_ISSUE_CMD : inbound_state_ascii <= "PRE_CMD";
        WR_MEM_ISSUE_CMD     : inbound_state_ascii <= "ISSUE_CMD";
        WR_MEM_PRE_ISSUE_CPL : inbound_state_ascii <= "PRE_CPL";
        WR_MEM_ISSUE_CPL     : inbound_state_ascii <= "ISSUE_CPL";
        WR_MEM_PRE_ISSUE_CPLD: inbound_state_ascii <= "PRE_CPLD";
        WR_MEM_ISSUE_CPLD    : inbound_state_ascii <= "ISSUE_CPLD";
    endcase
end
// synthesis translate_on
endmodule
