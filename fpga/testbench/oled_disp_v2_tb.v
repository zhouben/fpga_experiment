`timescale 1ns / 1ns

module oled_disp_v2_tb();
parameter CLOCKPERIOD = 20;
reg         clk      ;
reg         rst_n    ;
wire        rdy      ;
reg         start    ;
wire        done     ;
reg [7:0]   pos      ;
reg [7:0]   data     ;
reg         seqential;
wire [7:0]  reg_addr ;
wire [7:0]  reg_data ;
wire        i2c_wen  ;
reg         i2c_done ;
reg         i2c_wen_d;

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
oled_disp_v2 oled_disp_v2
(
    .clk        (clk              ),
    .rst_n      (rst_n            ),
    .rdy        (rdy              ),
    .start      (start            ),
    .done       (done             ),
    .pos        (pos              ),
    .data       (data             ),
    .seqential  (seqential        ),
    .reg_addr   (reg_addr         ),
    .reg_data   (reg_data         ),
    .i2c_wen    (i2c_wen          ),
    .i2c_done   (i2c_done         )
);

task write_with_pos;
    begin
        @(posedge clk);
        pos     <= 8'h35;
        data    <= 8'hab;
        seqential   <= 1'b0;
        start   <= 1'b1;
        @(posedge clk);
        pos     <= 8'hxx;
        data    <= 8'hxx;
        seqential   <= 1'bx;
        start   <= 1'b0;
        wait (done == 1);
    end
endtask

task write_sequential;
    begin
        @(posedge clk);
        pos     <= 8'h35;
        data    <= 8'hcd;
        seqential   <= 1'b1;
        start   <= 1'b1;
        @(posedge clk);
        pos     <= 8'hxx;
        data    <= 8'hxx;
        seqential   <= 1'bx;
        start   <= 1'b0;
        wait (done == 1);
    end
endtask

initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    #100    rst_n   <= 1'b1;
    #100 write_with_pos();
    #100 write_sequential();

end

always @(posedge clk) begin
    i2c_wen_d   <= i2c_wen;
    i2c_done    <= i2c_wen_d;
end
endmodule
