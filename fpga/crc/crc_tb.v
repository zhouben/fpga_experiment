`timescale 1ns / 1ns

module crc_tb();

parameter CLOCKPERIOD = 20;

reg         clk         ;
reg         reset       ;
reg         en          ;
reg [7:0]   din         ;
wire [31:0] crc_out     ;
reg         en_1        ;
reg         din_1       ;
wire [31:0] crc_out_1   ;

crc u0(
    .clk    (clk    ),
    .reset  (reset  ),
    .en     (en     ),
    .din    (din    ),
    .crc_out(crc_out)
);

crc_by_1bit _u1(
    .clk    (clk        ),
    .reset  (reset      ),
    .en     (en_1       ),
    .din    (din_1      ),
    .crc_out(crc_out_1  )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;

// test crc 1 bytes module
task tsk_crc;
    integer i;
    integer init_value;
    integer exp_value;

    begin
        init_value = 49;
        exp_value = 32'hA3E0E39B;
        for (i = 0; i < 4; i = i + 1)
        begin
            @(posedge clk);
            din = init_value + i;
            en  = 1;
        end
        @(posedge clk);
        en = 0;
        $display("[%t] din %2d ~ %2d, crc_out %X, expected %X. Result: %s", $realtime, init_value, init_value + i - 1, crc_out, exp_value, (crc_out == exp_value) ? "PASSED" : "FAILED" );
        @(posedge clk);
    end
endtask

// test crc_by_1bit module
task tsk_crc_by_1bit;
    integer i, n;
    integer init_value;
    integer exp_value;

    begin
        init_value = 32'h0;
        exp_value = 32'h69B85AFF;
        for (n = 0; n < 128; n = n + 1)
        begin
            for (i = 0; i < 8; i = i + 1)
            begin
                @(posedge clk);
                din_1 = (init_value >> (7 - i)) & 1;
                en_1  = 1;
            end
            init_value = init_value + 1;
        end
        @(posedge clk);
        en_1 = 0;
        $display("[%t] din  0 ~ 7F, crc_out %X, expected %X. Result: %s", $realtime, crc_out_1, exp_value, (crc_out_1 == exp_value) ? "PASSED" : "FAILED" );
        @(posedge clk);
    end
endtask

initial begin
    reset   = 1'b1;
    clk     = 1'b0;
    en      = 0;
    din     = 0;
    en_1    = 0;
    din_1   = 0;
    #100 reset <= 1'b0;

    #40
    repeat (3) @(posedge clk);
    tsk_crc();
    tsk_crc_by_1bit();

    #100 $display("[%t] TEST COMPLETE", $realtime);
    $finish(0);
end
endmodule
