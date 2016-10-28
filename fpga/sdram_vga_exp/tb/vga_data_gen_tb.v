`timescale 1ns / 1ps

module vga_data_gen_tb();

parameter CLOCKPERIOD = 20;
localparam SPAN_NUM = 9;

reg         clk     ;
reg         rst_n   ;
reg         mem_toggle   ;
reg         mem_wr_rdy   ;
wire        mem_wr_req   ;
wire [15:0] mem_din      ;

localparam VGA_DATA_DEPTH = 1024*768;
vga_data_gen #(
    .DATA_DEPTH (VGA_DATA_DEPTH),
    .SPAN_NUM   (SPAN_NUM)
) u0
(
    .clk     (clk           ),
    .rst_n   (rst_n         ),
    .start_i (mem_toggle    ),
    .wr_en   (mem_wr_rdy    ),
    .data_en (mem_wr_req    ),
    .dout    (mem_din       )
);

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;

task tsk_basic_two_loops_test;
    integer cnt;
    integer init_value;
    integer tmp;
    integer loop;
    begin
        cnt = 0;
        init_value = 0;
        mem_wr_rdy = 0;

        for(loop = 0; loop < 2; loop = loop + 1) begin
            @(posedge clk);
            mem_toggle = 1'b1;
            fork
                begin
                    #64 mem_toggle = 1'b0;
                end
                begin
                    repeat (8) @(posedge clk);
                    mem_wr_rdy = 1'b1;
                    repeat (5) @(posedge clk);
                    mem_wr_rdy = 1'b0;
                    repeat (15) @(posedge clk);
                    mem_wr_rdy = 1'b1;
                end
                begin
                    while (cnt < (VGA_DATA_DEPTH + 10)) begin
                        @(posedge clk);
                        if (cnt >= VGA_DATA_DEPTH) begin
                            if (mem_wr_req) begin
                                $display("[%t] should NOT generate extra VGA data. Test FAILED", $realtime);
                                $finish(1);
                            end
                            cnt = cnt + 1;
                        end else if (mem_wr_req) begin
                            tmp = (cnt + init_value);
                            if (mem_din[9:0] != tmp[9:0]) begin
                                $display("[%t] unexpected VGA data %08X, expected %08X. Test FAILED", $realtime, mem_din, cnt);
                                $finish(1);
                            end
                            cnt = cnt + 1;
                        end
                    end
                    cnt = 0;
                    init_value = init_value + SPAN_NUM;
                end
            join
            mem_wr_rdy = 1'b0;
        end

    end
endtask

initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    mem_wr_rdy <= 1'b0;
    mem_toggle <= 1'b0;
    #100 rst_n <= 1'b1;

    #40 tsk_basic_two_loops_test();

    #10 $display("[%t] TEST PASSED", $realtime);
    $finish(0);
end
endmodule
