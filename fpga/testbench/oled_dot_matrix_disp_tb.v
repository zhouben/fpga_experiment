`timescale 1ns / 100ps
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
module oled_dot_matrix_disp_tb ();
parameter CLOCKPERIOD = 10;
parameter OLED_CHIP_ADDR = 7'h3C;

reg reset;
reg clock;

wire        rdy         ;
reg         wen         ;
reg [7:0]   din         ;
wire        done        ;
wire [7:0]  reg_addr    ;
wire [7:0]  reg_data    ;
wire        i2c_wen     ;
reg         i2c_wen_d   ;
reg         i2c_done    ;

oled_dot_matrix_disp oled_dot_matrix_disp
(
    .clk         (clock     ),
    .rst_n       (reset     ),
    .rdy         (rdy       ),
    .wen         (wen       ),
    .din         (din       ),
    .done        (done      ),
    .reg_addr    (reg_addr  ),
    .reg_data    (reg_data  ),
    .i2c_wen     (i2c_wen   ),
    .i2c_done    (i2c_done  )
);

// Initial conditions; setup
initial begin
    //$timeformat(-9,1, "ns", 12);

    reset <= 1'b0;
    clock <= 1'b0;

    #60 reset <= 1'b1;

    $display("Beginning configuring OLED's registers for initialization");

    // kick off configure oled
    #100
    @(posedge clock)
    din <= 8'h35;
    wen <= 1'b1;
    @(posedge clock)
    din <= 8'hAB;
    wen <= 1'b1;
    @(posedge clock)
    din <= 8'hCD;
    wen <= 1'b1;

    @(posedge clock)
    wen <= 1'b0;

    wait (done == 1'b1);
    $display("Init oled display completed!");
    #100 $finish;
end

always @(posedge clock) begin
    i2c_wen_d   <= i2c_wen;
    i2c_done    <= i2c_wen_d;
end
/**************************************************************/
/* The following can be left as-is unless necessary to change */
/**************************************************************/

// Clock generation
always #(CLOCKPERIOD / 2) clock <= ~clock;

/*
  Conditional Environment Settings for the following:
      - Icarus Verilog
      - VCS
      - Altera Modelsim
      - Xilinx ISIM
      */
     // Icarus Verilog
     `ifdef IVERILOG
         initial $dumpfile("vcdbasic.vcd");
         initial $dumpvars();
     `endif

 // VCS
 `ifdef VCS
     initial $vcdpluson;
 `endif

// Altera Modelsim
`ifdef MODEL_TECH
`endif

// Xilinx ISIM
`ifdef XILINX_ISIM
`endif
endmodule
