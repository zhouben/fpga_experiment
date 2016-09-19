`timescale 1ns / 1ns
/*
----------------------------------------
Zhou Changzhi
test bench for SHA1
----------------------------------------

%MODULE_TITLE%

Authors:  %AUTHOR% (%AUTHOR_EMAIL%)

Description:
  %MODULE_DESCRIPTION%
*/
module sha1sum_tb ();
parameter CLOCKPERIOD = 20;

reg         rst;
reg         clk;
reg [31:0]  msg[0:31];
wire        rdy;
wire        done;
reg         write_en;
wire [31:0] h0;
wire [31:0] h1;
wire [31:0] h2;
wire [31:0] h3;
wire [31:0] h4;

reg [31:0] h0_expected;
reg [31:0] h1_expected;
reg [31:0] h2_expected;
reg [31:0] h3_expected;
reg [31:0] h4_expected;
reg         display_expected_value;
wire [31:0] msg_input;
integer     msg_index;

sha1sum sha1sum(
    .clk(clk),
    .rst_n(rst),
    .rdy(rdy),
    .msg_input(msg_input),
    .write_en(write_en),
    .h0(h0),
    .h1(h1),
    .h2(h2),
    .h3(h3),
    .h4(h4),
    .done(done)
);

task input_msg;
    input integer msg_length;   // in units of DWORD
    integer block_num;
    integer n;
    integer i;
    begin
        block_num = msg_length / 16;
        rst <= 1'b0;
        display_expected_value = 1'b0;
        #100 rst <= 1'b1;

        $display("msg_length %d block_num %d", msg_length, block_num);
        n = 0;
        msg_index = 0;
        while(n < block_num) begin

            wait (rdy == 1);
            @(posedge clk);
            if (n == block_num - 1) display_expected_value = 1'b1;
            $display("No.%d display_expected_value %d", n, display_expected_value);
            $display("SHA1_pre : %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
                sha1sum.h0_pre[31:24], sha1sum.h0_pre[23:16], sha1sum.h0_pre[15:8], sha1sum.h0_pre[7:0],
                sha1sum.h1_pre[31:24], sha1sum.h1_pre[23:16], sha1sum.h1_pre[15:8], sha1sum.h1_pre[7:0],
                sha1sum.h2_pre[31:24], sha1sum.h2_pre[23:16], sha1sum.h2_pre[15:8], sha1sum.h2_pre[7:0],
                sha1sum.h3_pre[31:24], sha1sum.h3_pre[23:16], sha1sum.h3_pre[15:8], sha1sum.h3_pre[7:0],
                sha1sum.h4_pre[31:24], sha1sum.h4_pre[23:16], sha1sum.h4_pre[15:8], sha1sum.h4_pre[7:0]);

            @(posedge clk);
            i = 0;
            write_en  = 1'b1;
            msg_index = n * 16;

            @(posedge clk);
            i = 0;
            write_en  = 1'b0;
            @(posedge clk);

            while( i < 15) begin
                @(posedge clk);
                write_en  = 1'b1;
                msg_index = msg_index + 1;
                i = i + 1;
            end

            @(posedge clk);
            write_en = 1'b0;

            @(posedge clk);
            if (rdy == 1) begin
                $display("SHA1 should be busy, rdy should be 0, but actaully %b", rdy);
                $finish(1);
            end
            wait (done == 1);
            n = n + 1;
            @(posedge clk);
        end
        @(posedge clk);
    end
endtask

/*
* test case for 512 bits
input message is just "abc"

expected sha1sum message is
a9993e36 4706816a ba3e2571 7850c26c 9cd0d89d
*/
task genmsg_abc;
    integer i;
    begin
        // big-endian
        msg[0] = 32'h61626380; // 'abc'
        for( i = 1; i < 16; i = i + 1) begin
            msg[i] = 32'd0;
        end
        msg[15] = 32'h00000018;
        h0_expected = 32'ha9993e36;
        h1_expected = 32'h4706816a;
        h2_expected = 32'hba3e2571;
        h3_expected = 32'h7850c26c;
        h4_expected = 32'h9cd0d89d;

        input_msg(16);

    end
endtask

/*
* test case for 512 bits
input message is
abcdefghijklmnopqrstuvwxyz0123456789
|<----------   36 bytes   -------->|

expected sha1sum message is
d2985049 a677bbc4 b4e8dea3 b89c4820 e5668e3a
*/
task genmsg_abcd789;
    integer i;
    begin
        // big-endian
        msg[0] = 32'h61626364;  // 'abcd'
        msg[1] = 32'h65666768;  // 'efgh'
        msg[2] = 32'h696a6b6c;  // 'ijkl'
        msg[3] = 32'h6d6e6f70;  // 'mnop'
        msg[4] = 32'h71727374;  // 'qrst'
        msg[5] = 32'h75767778;  // 'uvwx'
        msg[6] = 32'h797a3031;  // 'yz01'
        msg[7] = 32'h32333435;  // '2345'
        msg[8] = 32'h36373839;  // '6789'
        msg[9] = 32'h80000000;
        for( i = 10; i < 16; i = i + 1) begin
            msg[i] = 32'd0;
        end
        msg[15] = 32'h00000120;

        h0_expected = 32'hd2985049;
        h1_expected = 32'ha677bbc4;
        h2_expected = 32'hb4e8dea3;
        h3_expected = 32'hb89c4820;
        h4_expected = 32'he5668e3a;

        input_msg(16);

    end
endtask

/*
* Test for 1024 bits
* input message is
hello                                                                                                             world
|<-----------------------                  119 bytes                                          ----------------------->|
exptected sha1sum is
54c4d722 e164e2db 75dca325 eaf29cde 25afbabc
*/
task genmsg_hello_twoblocks;
    integer i;
    begin
        msg[0] = 32'h6865_6c6c; // 'hell'
        msg[1] = 32'h6F20_2020; // 'oe'
        for( i = 2; i < 28; i = i + 1) begin
            msg[i] = 32'h20202020;
        end
        msg[28] = 32'h2020_776f; // '  wo'
        msg[29] = 32'h726C_6480; // 'rld'
        msg[30] = 32'd0;
        msg[31] = 32'h0000_03B8;
        h0_expected = 32'h54c4d722;
        h1_expected = 32'he164e2db;
        h2_expected = 32'h75dca325;
        h3_expected = 32'heaf29cde;
        h4_expected = 32'h25afbabc;
        input_msg(32);
    end
endtask

assign msg_input = msg[msg_index];

initial begin
    clk <= 1'b0;
    genmsg_abcd789();
    genmsg_abc();
    genmsg_hello_twoblocks();
    #200
    $finish(0);
end

always @(posedge clk) begin
    if (done == 1) begin
        $display("Actual   : %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
            h0[31:24], h0[23:16], h0[15:8], h0[7:0],
            h1[31:24], h1[23:16], h1[15:8], h1[7:0],
            h2[31:24], h2[23:16], h2[15:8], h2[7:0],
            h3[31:24], h3[23:16], h3[15:8], h3[7:0],
            h4[31:24], h4[23:16], h4[15:8], h4[7:0]);
        if (display_expected_value) begin
            $display("Expected : %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
                h0_expected[31:24], h0_expected[23:16], h0_expected[15:8], h0_expected[7:0],
                h1_expected[31:24], h1_expected[23:16], h1_expected[15:8], h1_expected[7:0],
                h2_expected[31:24], h2_expected[23:16], h2_expected[15:8], h2_expected[7:0],
                h3_expected[31:24], h3_expected[23:16], h3_expected[15:8], h3_expected[7:0],
                h4_expected[31:24], h4_expected[23:16], h4_expected[15:8], h4_expected[7:0]);
        end
    end
end

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
endmodule
