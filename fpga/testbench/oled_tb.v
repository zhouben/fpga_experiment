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
module oled_tb ();
parameter CLOCKPERIOD = 20;
parameter OLED_CHIP_ADDR = 7'h3C;

reg reset;
reg clock;

// For storing slave data
reg [7:0]  slave_recv_data[0:255];
reg [7:0]  master_send_data[0:255];
reg [7:0]  master_recv_data[0:255];
wire        oled_disp_done;

wire SDA, SCL;
wire [11:0] clk_div = 100;

reg  [6:0]  slave_chip_addr;
wire [7:0]  slave_reg_addr;

wire        slave_busy;
wire        slave_done;

wire        slave_write_en;
wire [ 7:0] slave_data_out;

wire        slave_sda_in;
wire        slave_scl_in;

wire        slave_sda_out;
wire        slave_sda_oen;
wire        slave_scl_out;
wire        slave_scl_oen;

// for counting the cycles
reg [3:0] i2c_cnt;
reg i2c_cycle;
reg i2c_oe;

wire master_sda_oen;
wire master_scl_oen;

reg [7:0] data_received;
reg config_init;
reg disp_mode;
reg dot_matrix_mode;

reg [7:0]   print_message_data;
reg         print_message_wen;

//
wire       ram_ena;
wire [7:0] ram_addra;
wire [7:0] ram_douta;

integer i;
integer fp_r;

assign SDA = (master_sda_oen == 0 ) ? 1'b0 : (slave_sda_oen  ? 1'bz : slave_sda_out );
assign SCL = (master_scl_oen == 0 ) ? 1'b0 : 1'bz;
assign ram_addra[7:5] = 3'b0;

pullup(SDA);
pullup(SCL);

my_ram my_ram_inst (
  .clka(clock), // input clka
  .ena(ram_ena), // input ena
  .wea(1'b0), // input [0 : 0] wea
  .addra(ram_addra), // input [7 : 0] addra
  .dina(), // input [7 : 0] dina
  .douta(ram_douta) // output [7 : 0] douta
);

oled_ctrl
#(
    .OLED_CHIP_ADDR(OLED_CHIP_ADDR)
) u_oled(
    .clk(clock),        // System Clock
    .reset(reset),      // Reset signal
    .scl_in(SCL),
    .sda_in(SDA),    // SDA Input
    .sda_out(master_sda_out),   // SDA Output
    .sda_oen(master_sda_oen),   // SDA Output Enable
    .scl_out(master_scl_out),   // SCL Output
    .scl_oen(master_scl_oen),   // SCL Output Enable

    .busy(),
    .done(oled_disp_done),
    .wen(print_message_wen),
    .din(print_message_data),

    .init(config_init),
    .disp_mode(disp_mode),
    .dot_matrix_mode(dot_matrix_mode)
);

// i2c Slave
i2c_slave #(
    .ADDR_BYTES(1),
    .DATA_BYTES(1)
) i2c_slave (
    .clk        (clock),
    .reset      (reset),

    .open_drain (1'b1),

    .chip_addr  (slave_chip_addr),
    .reg_addr   (slave_reg_addr),
    .data_in    (),
    .write_en   (slave_write_en),
    .data_out   (slave_data_out),
    .done       (slave_done),
    .busy       (slave_busy),

    .sda_in     (SDA),
    .scl_in     (SCL),
    .sda_out    (slave_sda_out),
    .sda_oen    (slave_sda_oen),
    .scl_out    (slave_scl_out),
    .scl_oen    (slave_scl_oen)
);

task init_oled_disp;
    begin
        fp_r = $fopen("oled_disp_init.txt", "r");
        $display("fp_r: %x", fp_r);
        if (fp_r == 0) begin
            $finish;
        end

        // kick off configure oled
        #100
        config_init <= 1'b1;

        #40
        config_init <= 1'b0;

        wait (oled_disp_done == 1'b1);
        $display("Init oled display completed!");
        #100
        $fclose(fp_r);
    end
endtask

task all_black_oled_disp;
    begin
        #100
        fp_r = $fopen("oled_disp_all_black.txt", "r");
        $display("fp_r: %x", fp_r);
        if (fp_r == 0) begin
            $warning("zcz failed to open");
            //$finish;
        end

        // kick off configure oled
        #100
        disp_mode <=1'b1;
        #40
        disp_mode <=1'b0;

        wait (oled_disp_done == 1'b1);
        $display("black the whole oled display completed!");
        #100
        $fclose(fp_r);
    end
endtask

task oled_dot_matrix_disp_task;
    begin
        fp_r = $fopen("oled_dot_matrix_print_msg.txt", "r");
        $display("fp_r: %x", fp_r);
        if (fp_r == 0) begin
            $finish;
        end

        print_message_wen   <= 1'b0;

        // kick off configure oled
        #100
        @(posedge clock)
        print_message_data  <= 8'h35;
        print_message_wen   <= 1'b1;
        @(posedge clock)
        print_message_data  <= 8'hab;
        print_message_wen   <= 1'b1;
        @(posedge clock)
        print_message_data  <= 8'hcd;
        print_message_wen   <= 1'b1;
        @(posedge clock)
        print_message_data  <= 8'hx;
        print_message_wen   <= 1'b0;

        wait (oled_disp_done == 1'b1);
        $display("Init oled display completed!");
        #100
        $fclose(fp_r);
    end
endtask

// Initial conditions; setup
initial begin
    //$timeformat(-9,1, "ns", 12);

    // Initial Conditions
    reset <= 1'b0;
    clock <= 1'b0;

    config_init <= 1'b0;
    disp_mode <=1'b0;
    dot_matrix_mode <= 1'b0;
    slave_chip_addr  <= OLED_CHIP_ADDR;


    // Deassert reset
    #60
    reset <= 1'b1;

    $display("Beginning configuring OLED's registers");

    oled_dot_matrix_disp_task();
    oled_dot_matrix_disp_task();
    //init_oled_disp();
    //all_black_oled_disp();

    $finish;
end

integer addr, data, cnt;
// Save slave data to register
always @ (posedge clock) begin
    if (slave_write_en) begin
        cnt = $fscanf(fp_r, "%x %x", addr, data);
        if((addr != slave_reg_addr) || (data != slave_data_out)) begin
            $display("Writing to slave reg=%x data=%x, expected: %02X %02X <--- ERROR !!", slave_reg_addr, slave_data_out, addr, data);
        end else begin
            $display("Writing to slave reg=%x data=%x, expected: %02X %02X", slave_reg_addr, slave_data_out, addr, data);
        end
        slave_recv_data[slave_reg_addr] <= slave_data_out;
    end
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
