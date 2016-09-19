`timescale 1ns / 1ns
/*
----------------------------------------
Zhou Changzhi
test bench to control OLED display by I2C bus.
----------------------------------------

%MODULE_TITLE%

Authors:  %AUTHOR% (%AUTHOR_EMAIL%)

Description:
  %MODULE_DESCRIPTION%
*/
module md5sum_tb ();
parameter CLOCKPERIOD = 20;

reg         rst;
reg         clk;
reg [31:0]  msg[0:31];
wire        rdy;
wire        done;
reg         write_en;
wire [31:0] a;
wire [31:0] b;
wire [31:0] c;
wire [31:0] d;

reg [31:0] a_expected;
reg [31:0] b_expected;
reg [31:0] c_expected;
reg [31:0] d_expected;
reg         display_expected_value;
wire [31:0] msg_input;
integer     msg_index;

md5sum md5sum(
    .clk(clk),
    .rst_n(rst),
    .rdy(rdy),
    .msg(msg_input),
    .write_en(write_en),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
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
            if (n == block_num - 1) display_expected_value = 1'b1;
            $display("No.%d display_expected_value %d", n, display_expected_value);
            $display("md5_pre : %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
                md5sum.a_pre[7:0], md5sum.a_pre[15:8], md5sum.a_pre[23:16], md5sum.a_pre[31:24],
                md5sum.b_pre[7:0], md5sum.b_pre[15:8], md5sum.b_pre[23:16], md5sum.b_pre[31:24],
                md5sum.c_pre[7:0], md5sum.c_pre[15:8], md5sum.c_pre[23:16], md5sum.c_pre[31:24],
                md5sum.d_pre[7:0], md5sum.d_pre[15:8], md5sum.d_pre[23:16], md5sum.d_pre[31:24]);

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
                $display("md5 should be busy, rdy should be 0, but actaully %b", rdy);
                $finish(1);
            end
            wait (done == 1);
            n = n + 1;
        end
        @(posedge clk);
    end
endtask

task genmsg_hello;
    integer i;
    begin
        msg[0] = 32'h6C6C6568; // 'h'
        msg[1] = 32'h0000806F; // 'e'
        for( i = 2; i < 16; i = i + 1) begin
            msg[i] = 32'd0;
        end
        msg[14] = 32'h00000028;

        a_expected = 32'h2a40415d;
        b_expected = 32'h762a4bbc;
        c_expected = 32'h919d71b9;
        d_expected = 32'h92c51710;

        input_msg(16);

    end
endtask

task genmsg_hello_twoblocks;
    integer i;
    begin
//"hello                                                                                                             world"
// |<-----------------------                  119 bytes                                          ----------------------->|
        msg[0] = 32'h6C6C6568; // 'h'
        msg[1] = 32'h2020206F; // 'e'
        for( i = 2; i < 28; i = i + 1) begin
            msg[i] = 32'h20202020;
        end
        msg[28] = 32'h6F772020;
        msg[29] = 32'h80646C72;
        msg[30] = 32'h000003B8;
        msg[31] = 32'd0;

        // expected md5sum: 78f19b3ef52de3d80dbf53c36c87e0d2
        a_expected = 32'h3e9bf178;
        b_expected = 32'hd8e32df5;
        c_expected = 32'hc353bf0d;
        d_expected = 32'hd2e0876c;

        input_msg(32);
    end
endtask

assign msg_input = msg[msg_index];

initial begin
    clk <= 1'b0;
    genmsg_hello();
    genmsg_hello_twoblocks();
    #200
    $finish(0);
end

always @(posedge clk) begin
    if (done == 1) begin
        $display("Actual  : %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
            a[7:0], a[15:8], a[23:16], a[31:24],
            b[7:0], b[15:8], b[23:16], b[31:24],
            c[7:0], c[15:8], c[23:16], c[31:24],
            d[7:0], d[15:8], d[23:16], d[31:24]);
        if (display_expected_value) begin
            $display("Expected: %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
                a_expected[7:0], a_expected[15:8], a_expected[23:16], a_expected[31:24],
                b_expected[7:0], b_expected[15:8], b_expected[23:16], b_expected[31:24],
                c_expected[7:0], c_expected[15:8], c_expected[23:16], c_expected[31:24],
                d_expected[7:0], d_expected[15:8], d_expected[23:16], d_expected[31:24]);
        end
    end
end

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
endmodule
