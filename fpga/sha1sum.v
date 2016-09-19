module sha1sum
(
    input           clk,
    input           rst_n,
    input [31:0]    msg_input,
    input           write_en,

    output  [31:0]  h0,
    output  [31:0]  h1,
    output  [31:0]  h2,
    output  [31:0]  h3,
    output  [31:0]  h4,
    output  reg     rdy,
    output  reg     done
);

localparam IDLE     = 0;
localparam RECV     = 1;
localparam PENDING  = 2;
localparam LOOP1    = 3;
localparam LOOP2    = 4;
localparam LOOP3    = 5;
localparam LOOP4    = 6;
localparam CPLT_PRE = 7;
localparam COMPLETE = 8;

localparam K0 = 32'h5A827999;
localparam K1 = 32'h6ED9EBA1;
localparam K2 = 32'h8F1BBCDC;
localparam K3 = 32'hCA62C1D6;

reg [6:0]   round_num;
reg [6:0]   round_num_next;
reg [4:0]   msg_index;
reg [4:0]   msg_index_save;
reg [31:0]  msg[0:15];
reg [31:0]  msg_prev[0:15];
reg [31:0]  msg_current;
reg [3:0]   state;
reg [3:0]   state_next;

reg [31:0]  h0_pre;
reg [31:0]  h1_pre;
reg [31:0]  h2_pre;
reg [31:0]  h3_pre;
reg [31:0]  h4_pre;
reg [31:0]  a;
reg [31:0]  b;
reg [31:0]  c;
reg [31:0]  d;
reg [31:0]  e;
reg [31:0]  temp;

function [31:0] F;
    input [31:0] x, y, z;
    F = (x & y) | ((~x) & z);
endfunction

function [31:0] G;
    input [31:0] x, y, z;
    G = x ^ y ^ z;
endfunction

function [31:0] H;
    input [31:0] x, y, z;
    H = (x & y ) | (x & z) | (y & z);
endfunction

function [31:0] I;
    input [31:0] x, y, z;
    I = x ^ y ^ z;
endfunction

assign h0 = a;
assign h1 = b;
assign h2 = c;
assign h3 = d;
assign h4 = e;

always @(*) begin
    case (state_next)
        IDLE, RECV, PENDING                            : rdy <= 1'b1;
        LOOP1, LOOP2, LOOP3, LOOP4, CPLT_PRE, COMPLETE : rdy <= 1'b0;
        default: rdy <= 1'bx;
    endcase
end

always @(*) begin
    case (state)
        RECV, LOOP1, LOOP2, LOOP3, LOOP4    : round_num_next <= round_num + 7'd1;
        PENDING : round_num_next <= round_num;
        IDLE    : round_num_next <= 7'd0;
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin
        round_num   <= 7'd0;
        state       <= IDLE;
    end else begin
        round_num   <= round_num_next;
        state       <= state_next;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        done    <= 1'b0;
    end else begin
        done    <= (state_next == COMPLETE) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    state_next  <= state;
    case(state)
        IDLE: if (write_en) state_next  <= RECV;
        RECV: begin
            if (round_num[3:0] == 4'hF) state_next   <= LOOP1;
            else if (~write_en) state_next <= PENDING;
        end
        PENDING : if(write_en) state_next   <= RECV;
        LOOP1: if(round_num[4:0] == 5'd19) state_next <= LOOP2;
        LOOP2: if(round_num[5:0] == 6'd39) state_next <= LOOP3;
        LOOP3: if(round_num[5:0] == 6'd59) state_next <= LOOP4;
        LOOP4: if(round_num[6:0] == 7'd79) state_next <= CPLT_PRE;
        CPLT_PRE: state_next    <= COMPLETE;
        COMPLETE: state_next    <= IDLE;
    endcase
end

wire [6:0] i_3 ;
wire [6:0] i_8 ;
wire [6:0] i_14;
wire [6:0] i_16;
wire [31:0] msg_16_79;
wire [31:0] msg_prev_16_79;

assign i_3  = round_num_next - 7'd3;
assign i_8  = round_num_next - 7'd8;
assign i_14 = round_num_next - 7'd14;
assign i_16 = round_num_next - 7'd16;
assign msg_16_79 = msg[ i_3[3:0] ] ^ msg[ i_8[3:0]] ^ msg[i_14[3:0]] ^ msg[i_16[3:0]];
assign msg_prev_16_79 = msg_prev[ i_3[3:0] ] ^ msg_prev[ i_8[3:0]] ^ msg_prev[i_14[3:0]] ^ msg_prev[i_16[3:0]];

always @(posedge clk) begin
    case (round_num_next[6:4])
        3'h0: begin
            if (write_en) msg[round_num_next[3:0]] <= msg_input;
        end
        default: begin
            msg[round_num_next[3:0]] <= {msg_16_79[30:0], msg_16_79[31]};
        end
    endcase
end

always @(*) begin
    msg_current <= msg[round_num[3:0]]; // (round_num[4]) ? msg_prev[round_num[3:0]] : msg[round_num[3:0]];
end

wire [31:0] f;
assign f = F(b, c, d);
always @(*) begin
    case (state)
        RECV, LOOP1 : temp <= ({a[26:0] , a[31:27]}) + F(b, c, d) + e + K0 + msg_current;
        LOOP2       : temp <= ({a[26:0] , a[31:27]}) + G(b, c, d) + e + K1 + msg_current;
        LOOP3       : temp <= ({a[26:0] , a[31:27]}) + H(b, c, d) + e + K2 + msg_current;
        LOOP4       : temp <= ({a[26:0] , a[31:27]}) + I(b, c, d) + e + K3 + msg_current;
        default     : temp <= 32'd0;
    endcase
end

always @(posedge clk) begin
    if(~rst_n) begin
        h0_pre  <= 32'h67452301;
        h1_pre  <= 32'hEFCDAB89;
        h2_pre  <= 32'h98BADCFE;
        h3_pre  <= 32'h10325476;
        h4_pre  <= 32'hC3D2E1F0;
        a       <= 32'd0;
        b       <= 32'd0;
        c       <= 32'd0;
        d       <= 32'd0;
        e       <= 32'd0;
    end else begin
        case (state)
            IDLE    : begin
                a  <= h0_pre;
                b  <= h1_pre;
                c  <= h2_pre;
                d  <= h3_pre;
                e  <= h4_pre;
            end
            RECV, LOOP1, LOOP2, LOOP3, LOOP4 : begin
                e   <= d;
                d   <= c;
                c   <= {b[1:0], b[31:2]};
                b   <= a;
                a   <= temp;
            end
            CPLT_PRE    : begin
                a   <= h0_pre + a;
                b   <= h1_pre + b;
                c   <= h2_pre + c;
                d   <= h3_pre + d;
                e   <= h4_pre + e;
            end
            COMPLETE    : begin
                h0_pre  <= a;
                h1_pre  <= b;
                h2_pre  <= c;
                h3_pre  <= d;
                h4_pre  <= e;
            end
            PENDING: begin
                a   <= a;
                b   <= b;
                c   <= c;
                d   <= d;
                e   <= e;
            end
        endcase
    end
end
endmodule

