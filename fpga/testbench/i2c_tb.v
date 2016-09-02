`timescale 1ns / 100ps
/*
----------------------------------------
Stereoscopic Vision System
Senior Design Project - Team 11
California State University, Sacramento
Spring 2015 / Fall 2015
----------------------------------------

%MODULE_TITLE%

Authors:  %AUTHOR% (%AUTHOR_EMAIL%)

Description:
  %MODULE_DESCRIPTION%
*/
module i2c_tb ();
parameter CLOCKPERIOD = 20;
parameter CHIP_ADDR = 7'h2C;
parameter I2C_DIV = 40;
parameter I2C_LOW_CYCLE = 400;
parameter I2C_HIGH_CYCLE = 200;

reg reset;
reg clock;

// For storing slave data
reg [15:0]  slave_data[0:255];

wire SDA, SCL;
wire [11:0] clk_div = 100;

reg  [6:0]  slave_chip_addr;
wire [7:0]  slave_reg_addr;

wire        slave_busy;
wire        slave_done;

wire        slave_write_en;
wire  [ 7:0] slave_data_in;
wire [ 7:0] slave_data_out;

wire        slave_sda_in;
wire        slave_scl_in;

wire        slave_sda_out;
wire        slave_sda_oen;
wire        slave_scl_out;
wire        slave_scl_oen;

reg         write_mode;

// for counting the cycles
reg [3:0] i2c_cnt;
reg i2c_cycle;
reg i2c_oe;

reg master_sda_oen;
reg master_scl_oen;

assign SDA = (master_sda_oen == 0 ) ? 1'b0 : (slave_sda_oen  ? 1'bz : slave_sda_out );
assign SCL = master_scl_oen; //(master_scl_oen == 0 ) ? 1'b0 : (slave_scl_oen  ? 1'bz : slave_scl_out );

pullup(SDA);
pullup(SCL);

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
    .data_in    (slave_data_in),
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

my_ram my_ram_inst (
    .clka(clock), // input clka
    .ena(slave_busy), // input ena
    .wea(slave_write_en), // input [0 : 0] wea
    .addra(slave_reg_addr[2:0]), // input [2 : 0] addra
    .dina(slave_data_out), // input [7 : 0] dina
    .douta(slave_data_in) // output [7 : 0] douta
);
// Initial conditions; setup
initial begin
    //$timeformat(-9,1, "ns", 12);

    // Initial Conditions
    reset <= 1'b0;

    master_sda_oen <= 1'b1;
    master_scl_oen <= 1'b1;

    slave_chip_addr  <= CHIP_ADDR;
    // multibyte
    write_mode       <= 1'b0;

    // Initialize clock
    #1
    clock <= 1'b0;

    // Deassert reset
    #60
    reset <= 1'b1;

    $display("Beginning write/read tests");
    //read_txt_file();
    //read_mem_file();


    #60
    write_i2c_slave(CHIP_ADDR, 8'h5B, 8'h25);
    /*
    #100 write_read(CHIP_ADDR, 8'h00, 16'hCAFE);
    #100 write_read(CHIP_ADDR, 8'h0A, 16'hBEEF);
    #100 write_read(CHIP_ADDR, 8'h10, 16'hD0D0);
    #100 write_read(CHIP_ADDR, 8'h1A, 16'h3E3E);

    #100 read_i2c(CHIP_ADDR, 8'h00);
    if (master_data_out == 16'hCAFE) begin
        $display("PASS: delayed read");
    end
    else begin
        $display("FAIL: delayed read");
    end

    //        $writememh("regdata.hex", slave_data);
    */

    #100 $stop;
end

// Save slave data to register
always @ (posedge clock) begin
    if (slave_write_en) begin
        $display("Writing to slave reg=%x data=%x", slave_reg_addr, slave_data_out);
        slave_data[slave_reg_addr] <= slave_data_out;
    end

    //slave_data_in <= slave_data[slave_reg_addr];
end

/*
task write_read;
    input [6:0]  chip_addr;
    input [7:0]  reg_addr;
    input [15:0] data;

    begin
        write_i2c(chip_addr, reg_addr, data);
        read_i2c(chip_addr, reg_addr);

        if (master_data_out == data) begin
            $display("PASS: write=%x | read=%x", data, master_data_out);
        end
        else begin
            $display("FAIL: write=%x | read=%x", data, master_data_out);
        end
    end
endtask


always @ (posedge clock) begin
    if (~reset)                     i2c_cnt <= 0;
    else if (i2c_cnt == I2C_DIV)    i2c_cnt <= 0;
    else                            i2c_cnt <= i2c_cnt + 1;
end

always @ (posedge clock) begin
    if (~reset)                     i2c_cycle <= 1;
    else if ((i2c_cnt == I2C_DIV) && (i2c_oe == 1))  i2c_cycle <= ~i2c_cycle;
end
*/

reg [7:0] data_r[0:255];
initial $readmemh("data_in.txt", data_r );

// write one data and wait for slave ACK/NAK
task write_one_byte;
    input [7:0] data;
    input [8*10:1] str;
    integer i;
    reg ack_from_slave;
    begin
        // write chip address and wr bit
        for(i = 0; i < 8; i = i + 1) begin
            #I2C_DIV master_sda_oen = data[ 7 - i];
            #I2C_LOW_CYCLE master_scl_oen = 1'b1;
            #I2C_HIGH_CYCLE master_scl_oen = 1'b0;
        end
        #I2C_DIV master_sda_oen = 1'b1;

        // receive ACK/NAK from slave
        #I2C_LOW_CYCLE master_scl_oen = 1'b1;
        ack_from_slave = SDA;
        if (ack_from_slave == 0) begin
            $display("[%t] Slave ACK for %s", $realtime, str);
        end else begin
            $display("[%t] Slave NAK for %s!", $realtime, str);
            $stop;
    end
    #I2C_HIGH_CYCLE master_scl_oen = 1'b0;
end
endtask

task write_i2c_slave;
    input [6:0]  chip_addr;
    input [7:0]  reg_addr;
    input [7:0] data;

    begin

        master_sda_oen = 1'b1;
        master_scl_oen = 1'b1; 

        // start signal
        #I2C_HIGH_CYCLE master_sda_oen = 1'b0;
        #I2C_HIGH_CYCLE master_scl_oen = 1'b0;

        write_one_byte({chip_addr, 1'b0}, "chip_addr");
        write_one_byte(reg_addr, "reg_addr");
        write_one_byte(data, "data");
        write_one_byte(data + 1, "data");

        // stop signal
        master_sda_oen = 1'b0;
        #I2C_LOW_CYCLE master_scl_oen = 1'b1;
        #I2C_HIGH_CYCLE master_sda_oen = 1'b1;
    end
endtask

task read_txt_file;
    integer line;
    integer fp_r;
    integer count;
    reg [7:0] data_r;

    begin
        fp_r = $fopen("data_in.txt", "r");
        $display("fp_r %d", fp_r);
        line = 1;
        if (fp_r) begin
            while(!$feof(fp_r)) begin
                count = $fscanf(fp_r, "%d", data_r);
                $display("%d: %d", line, data_r);
                line = line + 1;
            end
            $fclose(fp_r);
        end
    end
endtask

task read_mem_file;
    integer i;
    begin
        for( i = 0; i < 16; i = i + 1)
        begin
            $display("%d: %d", i, data_r[i]);
        end
    end
endtask
/*
task read_i2c;
    input [6:0] chip_addr;
    input [7:0] reg_addr;

    begin
        @ (posedge clock) begin
            master_chip_addr = chip_addr;
            master_reg_addr  = reg_addr;
            master_read_en   = 1'b1;
        end

        @ (posedge clock) begin
            master_read_en = 1'b0;
        end

        @ (posedge clock);

        while (master_busy) begin
            @ (posedge clock);
        end
    end
endtask
*/


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
