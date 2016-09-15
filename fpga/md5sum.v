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
localparam LOOP2    = 3'd3;
localparam LOOP3    = 3'd4;
localparam LOOP4    = 3'd5;
localparam COMPLETE = 3'd6;

reg [2:0]   state;
reg [2:0]   state_next;
reg [31:0]  msg_r [0:15];
reg [3:0]   msg_index;
reg         new_loop;
reg [5:0]   round_num;
reg [31:0]  msg_d;
reg [31:0]  temp;

wire [31:0] ti;
wire [4:0]  s;
reg  [31:0] sa;
reg  [31:0] sb;
reg  [31:0] fv;

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
        msg_index = 4'd0;
    end else begin
        case (state_next)
            RECV_MSG: msg_index <= (new_loop) ? 4'd0 : ((write_en) ? (msg_index + 4'd1) : msg_index);
            LOOP2   : msg_index <= (new_loop) ? 4'd1 : (msg_index + 4'd5);
            LOOP3   : msg_index <= (new_loop) ? 4'd5 : (msg_index + 4'd3);
            LOOP4   : msg_index <= (new_loop) ? 4'd0 : (msg_index + 4'd7);
    endcase
    end
end

always @(posedge clk) begin
    msg_d <= msg;
end

always @(posedge clk) begin
    if (state == RECV_MSG) msg_r[msg_index] <= msg_d;
end

always @(posedge clk) begin
    if(~rst_n) rdy     <= 1'b1;
    else rdy <= ((state_next == RDY4RECV) || (state_next == RECV_MSG)) ? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    if(~rst_n)  done <= 1'b0;
    else        done <= (state_next == COMPLETE) ? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    if(~rst_n)  round_num <= 6'b0;
    else        round_num <= ((state == RECV_MSG) || (state == LOOP2) || (state == LOOP3) || (state == LOOP4)) ? round_num + 6'd1 : 6'd0;
end
always @(posedge clk) begin
    if(~rst_n) begin
        a           <= A;
        b           <= B;
        c           <= C;
        d           <= D;
        round_num   <= 6'b0;
    end else begin
        if((state == RECV_MSG) || (state == LOOP2) || (state == LOOP3) || (state == LOOP4)) begin
            round_num <= round_num + 6'd1;
            d           <= c;
            c           <= b;
            b           <= temp;
            a           <= d;
        end else if (state == COMPLETE) begin
            a   <= a + A;
            b   <= b + B;
            c   <= c + C;
            d   <= d + D;
        end
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        done    <= 1'b0;
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
            fv <= F(b, c, d);
            sb <= (a + F(b, c, d) + msg_d + ti);
            sa <= SS((a + F(b, c, d) + msg_d + ti), s);
            temp <= b + SS((a + F(b, c, d) + msg_d + ti), s);
            if (msg_index == 4'hF) begin
                state_next <= LOOP2;
                new_loop    <= 1'b1;
            end
        end
        LOOP2: begin
            temp <= b + SS((a + G(b, c, d) + msg_r[msg_index] + ti), s);
            if (msg_index == 4'd12) begin
                state_next <= LOOP3;
                new_loop    <= 1'b1;
            end
        end
        LOOP3: begin
            temp <= b + SS((a + H(b, c, d) + msg_r[msg_index] + ti), s);
            if (msg_index == 4'd2) begin
                state_next <= LOOP4;
                new_loop    <= 1'b1;
            end
        end
        LOOP4: begin
            temp <= b + SS((a + I(b, c, d) + msg_r[msg_index] + ti), s);
            if (msg_index == 4'd9) begin
                state_next <= COMPLETE;
            end
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
        LOOP2       : state_ascii <= "LOOP2";
        LOOP3       : state_ascii <= "LOOP3";
        LOOP4       : state_ascii <= "LOOP4";
        COMPLETE    : state_ascii <= "CPLT";
    endcase
end
// synthesis translate_on
endmodule
