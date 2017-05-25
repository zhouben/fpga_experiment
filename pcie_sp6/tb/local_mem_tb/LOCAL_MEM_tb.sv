`timescale 1ns / 1ps

module LOCAL_MEM_tb();

parameter CLOCKPERIOD = 20;
logic               clk;
logic   [0 : 0]     wea;
logic   [9 : 0]     addra;
logic   [31 : 0]    dina;
logic   [31 : 0]    douta;
logic rst_n;


LOCAL_MEM	LOCAL_MEMEx01
(
	.clka 	(	clk 	),
	.wea  	(	wea  	),
	.addra	(	addra	),
	.dina 	(	dina 	),
	.douta	(	douta	)
) ;

task tsk_write_readback_test;
    int i;
    int seed;
    int value;
    begin
        seed = 2;
        @(posedge clk);

        for(i = 0; i < 8; i++)
        begin
            dina = $random(seed); wea = 1; addra = i; @(posedge clk);
        end
        wea = 0;

        seed = 2;
        value = 0;
        for(i = 0; i < 8; i++)
        begin
            addra = i;
            @(posedge clk);
            if ((value != 0) && (value != douta)) begin
                $display("[%t] write_readBack FAILED read %8x, expected %8x", $realtime, douta, value);
            end
            value = $random(seed);
        end
    end
endtask

// Clock generation
always #(CLOCKPERIOD / 2) clk <= ~clk;

initial begin
    rst_n   <= 1'b0;
    clk     <= 1'b0;
    wea     = 0;
    #100 rst_n <= 1'b1;

    #40
    @(posedge clk);
    tsk_write_readback_test;


    #100 $display("[%t] TEST PASSED", $realtime);
    $finish(0);
end
endmodule
