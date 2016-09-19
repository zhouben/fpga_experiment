// uncomment the line below for debug
// `define MD5SUM_DEBUG

module md5sum(
    input           clk,
    input           rst_n,
    output reg      rdy,
    input   [31:0]  msg,
    input           write_en,
    output reg [31:0]  a,
    output reg [31:0]  b,
    output reg [31:0]  c,
    output reg [31:0]  d,
    output reg      done
);

localparam A        = 32'h67452301;
localparam B        = 32'hEFCDAB89;
localparam C        = 32'h98BADCFE;
localparam D        = 32'h10325476;


localparam RDY4RECV = 3'd0;
localparam RECV_MSG = 3'd1;
localparam RECVWAIT = 3'd2;
localparam LOOP2    = 3'd3;
localparam LOOP3    = 3'd4;
localparam LOOP4    = 3'd5;
localparam CPLT_PRE = 3'd6;
localparam COMPLETE = 3'd7;

reg [2:0]   state;
reg [2:0]   state_next;
reg [31:0]  msg_buffer [0:15];
reg [3:0]   msg_index;
reg [3:0]   msg_index_save;
reg         new_loop;
reg [5:0]   round_num;
reg [31:0]  temp;

reg [31:0]  a_pre;
reg [31:0]  b_pre;
reg [31:0]  c_pre;
reg [31:0]  d_pre;

wire [31:0] ti;
wire [4:0]  s;
`ifdef MD5SUM_DEBUG
reg  [31:0] sa;
reg  [31:0] sb;
reg  [31:0] fv;
`endif

sint_table sint_table
(
    .index(round_num),
    .data_out(ti)
);

shift_table shift_table
(
    .index(round_num),
    .data_out(s)
);

function [31:0] F;
    input [31:0] x, y, z;
    F = (x & y) | ((~x) & z);
endfunction

function [31:0] G;
    input [31:0] x, y, z;
    G = (z & x) | ((~z) & y);
endfunction

function [31:0] H;
    input [31:0] x, y, z;
    H = x ^ y ^ z;
endfunction

function [31:0] I;
    input [31:0] x, y, z;
    I = y ^ ( x | (~z));
endfunction

function [31:0] SS;
    input [31:0] x;
    input [4:0]  s;
    SS = (x << s) | (x >> (32 - s));
endfunction

always @(posedge clk) begin
    if(~rst_n) begin
        msg_index_save <= 4'd0;
    end else begin
        case (state_next)
            RECV_MSG: msg_index_save <= msg_index_save + 4'd1;
            RECVWAIT: msg_index_save <= msg_index_save;
            default : msg_index_save <= 4'd0;
        endcase
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        msg_index <= 4'd0;
    end else begin
        case (state_next)
            RECV_MSG: msg_index <= msg_index_save;
            RECVWAIT: msg_index <= msg_index_save;
            LOOP2   : msg_index <= (new_loop) ? 4'd1 : (msg_index + 4'd5);
            LOOP3   : msg_index <= (new_loop) ? 4'd5 : (msg_index + 4'd3);
            LOOP4   : msg_index <= (new_loop) ? 4'd0 : (msg_index + 4'd7);
        endcase
    end
end

always @(posedge clk) begin
    if (state_next == RECV_MSG) msg_buffer[msg_index_save] <= msg;
end

always @(*) begin
    rdy <= 1'b0;
    case (state)
        RDY4RECV: rdy <= 1'b1;
        RECV_MSG: rdy <= (msg_index != 15) ? 1'b1 : 1'b0;
        RECVWAIT: rdy <= (msg_index != 15) ? 1'b1 : 1'b0;
    endcase
end

always @(posedge clk) begin
    if(~rst_n)  done <= 1'b0;
    else        done <= (state_next == COMPLETE) ? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    if(~rst_n) begin
        a           <= A;
        b           <= B;
        c           <= C;
        d           <= D;
        a_pre       <= A;
        b_pre       <= B;
        c_pre       <= C;
        d_pre       <= D;
        round_num   <= 6'b0;
    end else begin
        round_num   <= 6'd0;
        case (state)
            RECV_MSG, LOOP2, LOOP3, LOOP4: begin
                round_num   <= round_num + 6'd1;
                d           <= c;
                c           <= b;
                b           <= temp;
                a           <= d;
            end
            RECVWAIT: round_num <= round_num;
            CPLT_PRE: begin
                a   <= a + a_pre;
                b   <= b + b_pre;
                c   <= c + c_pre;
                d   <= d + d_pre;
            end
            COMPLETE: begin
                a_pre   <= a;
                b_pre   <= b;
                c_pre   <= c;
                d_pre   <= d;
            end
        endcase
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        state   <= RDY4RECV;
    end else begin
        state   <= state_next;
    end
end

always @(*) begin
    state_next <= state;
    new_loop    <= 1'b0;
    case (state)
        RDY4RECV: begin
            if (write_en) begin
                state_next <= RECV_MSG;
                new_loop    <= 1'b1;
            end
        end
        RECV_MSG: begin
            `ifdef MD5SUM_DEBUG
                fv <= F(b, c, d);
                sb <= (a + F(b, c, d) + msg_buffer[msg_index] + ti);
                sa <= SS((a + F(b, c, d) + msg_buffer[msg_index] + ti), s);
            `endif 
            temp <= b + SS((a + F(b, c, d) + msg_buffer[msg_index] + ti), s);
            if (msg_index == 4'hF) begin
                state_next <= LOOP2;
                new_loop    <= 1'b1;
            end else if (~write_en) begin
                state_next  <= RECVWAIT;
            end
        end
        RECVWAIT: begin
            if (write_en) state_next <= RECV_MSG;
        end
        LOOP2: begin
            temp <= b + SS((a + G(b, c, d) + msg_buffer[msg_index] + ti), s);
            if (msg_index == 4'd12) begin
                state_next <= LOOP3;
                new_loop    <= 1'b1;
            end
        end
        LOOP3: begin
            temp <= b + SS((a + H(b, c, d) + msg_buffer[msg_index] + ti), s);
            if (msg_index == 4'd2) begin
                state_next <= LOOP4;
                new_loop    <= 1'b1;
            end
        end
        LOOP4: begin
            temp <= b + SS((a + I(b, c, d) + msg_buffer[msg_index] + ti), s);
            if (msg_index == 4'd9) begin
                state_next <= CPLT_PRE;
            end
        end
        CPLT_PRE: begin
            state_next <= COMPLETE;
        end
        COMPLETE: begin
            state_next <= RDY4RECV;
        end
    endcase
end

// synthesis translate_off
reg [8*20:1] state_ascii;
always @(state) begin
    case (state)
        RDY4RECV    : state_ascii <= "RDY";
        RECV_MSG    : state_ascii <= "RECV";
        RECVWAIT    : state_ascii <= "WAIT";
        LOOP2       : state_ascii <= "LOOP2";
        LOOP3       : state_ascii <= "LOOP3";
        LOOP4       : state_ascii <= "LOOP4";
        CPLT_PRE    : state_ascii <= "C_PRE";
        COMPLETE    : state_ascii <= "CPLT";
    endcase
end
// synthesis translate_on
endmodule
