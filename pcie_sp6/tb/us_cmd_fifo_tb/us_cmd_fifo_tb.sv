`timescale 1ns / 1ns

module us_cmd_fifo_tb();

parameter CLOCKPERIOD = 20;

logic               clk;
logic               rst;
logic   [127 : 0]   din;
logic               wr_en;
logic               rd_en;
logic   [127 : 0]   dout;
logic               full;
logic               empty;
logic   [3 : 0]     data_count;
logic               prog_full;
logic  [31:0]       din32;
logic  [31:0]       dout32;

assign din32 = din[31:0];
assign dout32 = dout[31:0];

us_cmd_fifo	us_cmd_fifoEx01
(
	.clk       	(	clk       	),
	.rst       	(	rst       	),
	.din       	(	din       	),
	.wr_en     	(	wr_en     	),
	.rd_en     	(	rd_en     	),
	.dout      	(	dout      	),
	.full      	(	full      	),
	.empty     	(	empty     	),
	.data_count	(	data_count	),
	.prog_full 	(	prog_full 	)
) ;

logic rd_en_state;  // 0: not want to read, 1: want to read
assign rd_en = (rd_en_state == 1) ? (~empty) : 0;
task tsk_fifo_init;
    begin
        din[31:0]  = 0;
        wr_en= 0;
        rd_en_state = 0;
    end
endtask

assign din[127:32] = 'b0;
logic rd_en_d;
always @(posedge clk) begin
    rd_en_d <= rd_en;
end

task tsk_wr_rd_test;
    integer seed;
    integer _i;
    integer value;
    integer error_flag;
    
    begin
        seed = 1;
        wait (empty);
        while(~prog_full)
        begin
            din[31:0] = $random(seed);
            wr_en = 1;
            @(posedge clk);
        end
        wr_en = 0;
        seed = 1;
        _i = 0;
        error_flag = 0;

        fork
            begin
                while(~empty)
                begin
                    rd_en_state = 1; @(posedge clk);
                end
                rd_en_state = 0;
            end
            while(~empty)
            begin
                if (rd_en_d) begin
                    value = $random(seed);
                    if (dout[31:0] !== value) begin
                        error_flag = 1;
                        $display("[%8t] No.%3d write and read back fifo dout %x expected %x\n", $realtime, _i, dout[31:0], value);
                    end else begin
                    end
                    _i++;
                end
                @(posedge clk);
            end
        join
        if (error_flag) begin
            $display("[%8t] tsk_wr_rd_test FAILED\n", $realtime);
        end else begin
            $display("[%8t] tsk_wr_rd_test PASSED\n", $realtime);
        end
    end
endtask

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;
initial begin
    rst   <= 1'b1;
    clk     <= 1'b0;
    tsk_fifo_init();
    #100 rst <= 1'b0;

    repeat (10) @(posedge clk);
    tsk_wr_rd_test();

    #100 $display("[%t] TEST PASSED", $realtime);
    $finish(0);
end
endmodule
