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
reg [31:0]  msg[0:15];
wire        rdy;
wire        done;
reg         write_en;
wire [31:0] a;
wire [31:0] b;
wire [31:0] c;
wire [31:0] d;
wire [31:0] msg_input;
integer     i;

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

task MsgGen_hello;
    integer i;
    begin
        msg[0] = 32'h6C6C6568; // 'h'
        msg[1] = 32'h0000806F; // 'e'
        for( i = 2; i < 16; i = i + 1) begin
            msg[i] = 32'd0;
        end
        msg[14] = 32'h00000028;
    end
endtask

assign msg_input = msg[i];

initial begin
    rst <= 1'b0;
    clk <= 1'b0;
    MsgGen_hello();
    #100 rst <= 1'b1;

    wait (rdy == 1);
    @(posedge clk);
    i = 0;
    write_en  = 1'b1;

    while( i < 16) begin
        @(posedge clk);
        write_en  = 1'b1;
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
    @(posedge clk);
    $display("%X %X %X %X", a, b, c, d);
    @(posedge clk);
// the result should be 5d41402abc4b2a76b9719d911017c592
    $display("%X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X", a[7:0], a[15:8], a[23:16], a[31:24],
b[7:0], b[15:8], b[23:16], b[31:24],
c[7:0], c[15:8], c[23:16], c[31:24],
d[7:0], d[15:8], d[23:16], d[31:24]);
    #200
    $finish(0);
end

always @(posedge clk) begin
    if (done == 1) begin
        //$display("a : %X", a);
        //$display("b : %X", b);
        //$display("c : %X", c);
        //$display("d : %X", d);
    end
end

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
endmodule
