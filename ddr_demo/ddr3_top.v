`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    12:00:56 11/30/2014
// Design Name:
// Module Name:    DDR3_Top
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module ddr3_top#
(
    parameter C1_NUM_DQ_PINS            = 16,
    parameter C1_MEM_ADDR_WIDTH         = 14,
    parameter C1_MEM_BANKADDR_WIDTH     = 3,
    parameter C1_P0_MASK_SIZE           = 16,
    parameter C1_P0_DATA_PORT_SIZE      = 128,

    parameter C3_NUM_DQ_PINS            = 16,
    parameter C3_MEM_ADDR_WIDTH         = 14,
    parameter C3_MEM_BANKADDR_WIDTH     = 3,
    parameter C3_P0_MASK_SIZE           = 16,
    parameter C3_P0_DATA_PORT_SIZE      = 128
)
(
    input                                   sw_rst_i,
    input                                   clk_50M,
    input                                   clk_20M,
    output                                  led_1,

    output                                  calib_done_led,
    inout  [C1_NUM_DQ_PINS-1:0]             mcb1_dram_dq,
    output [C1_MEM_ADDR_WIDTH-1:0]          mcb1_dram_a,
    output [C1_MEM_BANKADDR_WIDTH-1:0]      mcb1_dram_ba,
    output                                  mcb1_dram_ras_n,
    output                                  mcb1_dram_cas_n,
    output                                  mcb1_dram_we_n,
    output                                  mcb1_dram_odt,
    output                                  mcb1_dram_reset_n,
    output                                  mcb1_dram_cke,
    output                                  mcb1_dram_dm,
    inout                                   mcb1_dram_udqs,
    inout                                   mcb1_dram_udqs_n,
    inout                                   mcb1_rzq,
    inout                                   mcb1_zio,
    output                                  mcb1_dram_udm,
    inout                                   mcb1_dram_dqs,
    inout                                   mcb1_dram_dqs_n,
    output                                  mcb1_dram_ck,
    output                                  mcb1_dram_ck_n

//    inout  [C3_NUM_DQ_PINS-1:0]             mcb3_dram_dq,
//    output [C3_MEM_ADDR_WIDTH-1:0]          mcb3_dram_a,
//    output [C3_MEM_BANKADDR_WIDTH-1:0]      mcb3_dram_ba,
//    output                                  mcb3_dram_ras_n,
//    output                                  mcb3_dram_cas_n,
//    output                                  mcb3_dram_we_n,
//    output                                  mcb3_dram_odt,
//    output                                  mcb3_dram_reset_n,
//    output                                  mcb3_dram_cke,
//    output                                  mcb3_dram_dm,
//    inout                                   mcb3_dram_udqs,
//    inout                                   mcb3_dram_udqs_n,
//    inout                                   mcb3_rzq,
//    inout                                   mcb3_zio,
//    output                                  mcb3_dram_udm,
//    inout                                   mcb3_dram_dqs,
//    inout                                   mcb3_dram_dqs_n,
//    output                                  mcb3_dram_ck,
//    output                                  mcb3_dram_ck_n
);

localparam WR = 3'b0;
localparam RD = 3'b1;
localparam WP = 3'b010; // write with auto precharge
localparam RP = 3'b011; // read with auto precharge
localparam RF = 3'b1xx; // refresh

wire    rst_n;
wire    c1_calib_done;
wire    clk;
wire    c1_rst0;
wire    led_1_n;
reg     error;

assign rst_n = ~c1_rst0;

OBUF   led_1_obuf (.O(led_1), .I(led_1_n));

reg [7:0] cnt_clk0;
always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
        cnt_clk0 <= 8'b0;
    end else begin
        cnt_clk0 <= cnt_clk0 + 8'b1;
    end
end

reg             c1_p0_cmd_en            ;
reg  [2:0]      c1_p0_cmd_instr         ;
reg  [5:0]      c1_p0_cmd_bl            ;
reg  [29:0]     c1_p0_cmd_byte_addr     ;
wire            c1_p0_cmd_empty         ;
wire            c1_p0_cmd_full          ;

reg             c1_p0_wr_en             ;
wire [15:0]     c1_p0_wr_mask           ;
reg  [127:0]    c1_p0_wr_data           ;
wire            c1_p0_wr_full           ;
wire            c1_p0_wr_empty          ;
wire [6:0]      c1_p0_wr_count          ;
wire            c1_p0_wr_underrun       ;
wire            c1_p0_wr_error          ;

reg             c1_p0_rd_en             ;
wire [127:0]    c1_p0_rd_data           ;
wire            c1_p0_rd_full           ;
wire            c1_p0_rd_empty          ;
wire [6:0]      c1_p0_rd_count          ;
wire            c1_p0_rd_overflow       ;
wire            c1_p0_rd_error          ;


/*
wire            c3_cmd_en               ;
wire            c3_p0_cmd_en            ;
wire            c3_p0_cmd_instr         ;
wire            c3_p0_cmd_bl            ;
wire            c3_p0_cmd_byte_addr     ;
wire            c3_p0_cmd_empty         ;
wire            c3_p0_cmd_full          ;

wire            c3_p0_wr_en             ;
wire            c3_p0_wr_mask           ;
wire            c3_p0_wr_data           ;
wire            c3_p0_wr_full           ;
wire            c3_p0_wr_empty          ;
wire            c3_p0_wr_count          ;
wire            c3_p0_wr_underrun       ;
wire            c3_p0_wr_error          ;

wire            c3_p0_rd_en             ;
wire            c3_p0_rd_data           ;
wire            c3_p0_rd_full           ;
wire            c3_p0_rd_empty          ;
wire            c3_p0_rd_count          ;
wire            c3_p0_rd_overflow       ;
wire            c3_p0_rd_error          ;

wire            clk_20M_o;

//IBUFG u5_bufg(.I(clk_20M), .O(clk_20M_o));
wire mcb3_dram_udqs_s;
IBUFDS u2(
    .I (mcb3_dram_udqs    ),
    .IB(mcb3_dram_udqs_n  ),
    .O (mcb3_dram_udqs_s  )
);
//wire mcb3_dram_ck_s;
//
OBUFDS u4(
    .O (mcb3_dram_ck    ),
    .OB(mcb3_dram_ck_n  ),
    .I (1'b0            )
);
wire mcb3_dram_dqs_s;

IBUFDS u6(
    .I (mcb3_dram_dqs    ),
    .IB(mcb3_dram_dqs_n  ),
    .O (mcb3_dram_dqs_s  )
);
*/


my_ddr3_mig # (
    .C1_P0_MASK_SIZE(16),
    .C1_P0_DATA_PORT_SIZE(128),
    .DEBUG_EN(0),
    .C1_MEMCLK_PERIOD(2500),
    .C1_CALIB_SOFT_IP("TRUE"),
    .C1_SIMULATION("FALSE"),
    .C1_RST_ACT_LOW(1),
    .C1_INPUT_CLK_TYPE("SINGLE_ENDED"),
    .C1_MEM_ADDR_ORDER("ROW_BANK_COLUMN"),
    .C1_NUM_DQ_PINS(16),
    .C1_MEM_ADDR_WIDTH(14),
    .C1_MEM_BANKADDR_WIDTH(3)
    //.C3_P0_MASK_SIZE(16),
    //.C3_P0_DATA_PORT_SIZE(128),
    //.C3_MEMCLK_PERIOD(3000),
    //.C3_CALIB_SOFT_IP("TRUE"),
    //.C3_SIMULATION("FALSE"),
    //.C3_RST_ACT_LOW(0),
    //.C3_INPUT_CLK_TYPE("SINGLE_ENDED"),
    //.C3_MEM_ADDR_ORDER("ROW_BANK_COLUMN"),
    //.C3_NUM_DQ_PINS(16),
    //.C3_MEM_ADDR_WIDTH(14),
    //.C3_MEM_BANKADDR_WIDTH(3)
)
u_my_ddr3_mig (

    .c1_sys_clk             (clk_20M                ),
    .c1_sys_rst_i           (sw_rst_i               ),

    .mcb1_dram_dq           (mcb1_dram_dq           ),
    .mcb1_dram_a            (mcb1_dram_a            ),
    .mcb1_dram_ba           (mcb1_dram_ba           ),
    .mcb1_dram_ras_n        (mcb1_dram_ras_n        ),
    .mcb1_dram_cas_n        (mcb1_dram_cas_n        ),
    .mcb1_dram_we_n         (mcb1_dram_we_n         ),
    .mcb1_dram_odt          (mcb1_dram_odt          ),
    .mcb1_dram_cke          (mcb1_dram_cke          ),
    .mcb1_dram_ck           (mcb1_dram_ck           ),
    .mcb1_dram_ck_n         (mcb1_dram_ck_n         ),
    .mcb1_dram_dqs          (mcb1_dram_dqs          ),
    .mcb1_dram_dqs_n        (mcb1_dram_dqs_n        ),
    .mcb1_dram_udqs         (mcb1_dram_udqs         ),    // for X16 parts
    .mcb1_dram_udqs_n       (mcb1_dram_udqs_n       ),  // for X16 parts
    .mcb1_dram_udm          (mcb1_dram_udm          ),     // for X16 parts
    .mcb1_dram_dm           (mcb1_dram_dm           ),
    .mcb1_dram_reset_n      (mcb1_dram_reset_n      ),
    .c1_clk0		        (clk                    ),
    .c1_rst0		        (c1_rst0                ),



    .c1_calib_done          (c1_calib_done          ),
    .mcb1_rzq               (mcb1_rzq               ),

    .mcb1_zio               (mcb1_zio               ),

    .c1_p0_cmd_clk          (clk                    ),
    .c1_p0_cmd_en           (c1_p0_cmd_en           ),
    .c1_p0_cmd_instr        (c1_p0_cmd_instr        ),
    .c1_p0_cmd_bl           (c1_p0_cmd_bl           ),
    .c1_p0_cmd_byte_addr    (c1_p0_cmd_byte_addr    ),
    .c1_p0_cmd_empty        (c1_p0_cmd_empty        ),
    .c1_p0_cmd_full         (c1_p0_cmd_full         ),
    .c1_p0_wr_clk           (clk                    ),
    .c1_p0_wr_en            (c1_p0_wr_en            ),
    .c1_p0_wr_mask          (16'b0                  ),
    .c1_p0_wr_data          (c1_p0_wr_data          ),
    .c1_p0_wr_full          (c1_p0_wr_full          ),
    .c1_p0_wr_empty         (c1_p0_wr_empty         ),
    .c1_p0_wr_count         (c1_p0_wr_count         ),
    .c1_p0_wr_underrun      (c1_p0_wr_underrun      ),
    .c1_p0_wr_error         (c1_p0_wr_error         ),
    .c1_p0_rd_clk           (clk                    ),
    .c1_p0_rd_en            (c1_p0_rd_en            ),
    .c1_p0_rd_data          (c1_p0_rd_data          ),
    .c1_p0_rd_full          (c1_p0_rd_full          ),
    .c1_p0_rd_empty         (c1_p0_rd_empty         ),
    .c1_p0_rd_count         (c1_p0_rd_count         ),
    .c1_p0_rd_overflow      (c1_p0_rd_overflow      ),
    .c1_p0_rd_error         (c1_p0_rd_error         )

    //.c3_sys_clk             (clk_20M               ),
    //.c3_sys_rst_i           (~rst_n                 ),

    //.mcb3_dram_dq           (mcb3_dram_dq           ),
    //.mcb3_dram_a            (mcb3_dram_a            ),
    //.mcb3_dram_ba           (mcb3_dram_ba           ),
    //.mcb3_dram_ras_n        (mcb3_dram_ras_n        ),
    //.mcb3_dram_cas_n        (mcb3_dram_cas_n        ),
    //.mcb3_dram_we_n         (mcb3_dram_we_n         ),
    //.mcb3_dram_odt          (mcb3_dram_odt          ),
    //.mcb3_dram_cke          (mcb3_dram_cke          ),
    //.mcb3_dram_ck           (mcb3_dram_ck           ),
    //.mcb3_dram_ck_n         (mcb3_dram_ck_n         ),
    //.mcb3_dram_dqs          (mcb3_dram_dqs          ),
    //.mcb3_dram_dqs_n        (mcb3_dram_dqs_n        ),
    //.mcb3_dram_udqs         (mcb3_dram_udqs         ),    // for X16 parts
    //.mcb3_dram_udqs_n       (mcb3_dram_udqs_n       ),  // for X16 parts
    //.mcb3_dram_udm          (mcb3_dram_udm          ),     // for X16 parts
    //.mcb3_dram_dm           (mcb3_dram_dm           ),
    //.mcb3_dram_reset_n      (mcb3_dram_reset_n      ),
    //.c3_clk0		        (                       ),
    //.c3_rst0		        (                       ),



    //.c3_calib_done          (c3_calib_done          ),
    //.mcb3_rzq               (mcb3_rzq               ),

    //.mcb3_zio               (mcb3_zio               ),

    //.c3_p0_cmd_clk          (clk                    ),
    //.c3_p0_cmd_en           (c3_p0_cmd_en           ),
    //.c3_p0_cmd_instr        (c3_p0_cmd_instr        ),
    //.c3_p0_cmd_bl           (c3_p0_cmd_bl           ),
    //.c3_p0_cmd_byte_addr    (c3_p0_cmd_byte_addr    ),
    //.c3_p0_cmd_empty        (c3_p0_cmd_empty        ),
    //.c3_p0_cmd_full         (c3_p0_cmd_full         ),
    //.c3_p0_wr_clk           (clk                    ),
    //.c3_p0_wr_en            (c3_p0_wr_en            ),
    //.c3_p0_wr_mask          (c3_p0_wr_mask          ),
    //.c3_p0_wr_data          (c3_p0_wr_data          ),
    //.c3_p0_wr_full          (c3_p0_wr_full          ),
    //.c3_p0_wr_empty         (c3_p0_wr_empty         ),
    //.c3_p0_wr_count         (c3_p0_wr_count         ),
    //.c3_p0_wr_underrun      (c3_p0_wr_underrun      ),
    //.c3_p0_wr_error         (c3_p0_wr_error         ),
    //.c3_p0_rd_clk           (clk                    ),
    //.c3_p0_rd_en            (c3_p0_rd_en            ),
    //.c3_p0_rd_data          (c3_p0_rd_data          ),
    //.c3_p0_rd_full          (c3_p0_rd_full          ),
    //.c3_p0_rd_empty         (c3_p0_rd_empty         ),
    //.c3_p0_rd_count         (c3_p0_rd_count         ),
    //.c3_p0_rd_overflow      (c3_p0_rd_overflow      ),
    //.c3_p0_rd_error         (c3_p0_rd_error         )
);

assign calib_done_led = ~(c1_calib_done); // & c3_calib_done);

localparam WAIT_CALI_DONE   = 3'd0;
localparam PREPARE_WR       = 3'd1;
localparam WRITE_DATA       = 3'd2;
localparam WRITE_CMD        = 3'd3;
localparam WAIT_WR_DONE     = 3'd4;
localparam READ_CMD         = 3'd5;
localparam READ_DATA        = 3'd6;


reg [15:0]  c1_calib_done_r;
reg [2:0]   state;
reg [29:0]  write_addr;
reg [29:0]  read_addr;
reg [5:0]   read_cnt;
reg [15:0]  read_expected_data;

always @(posedge clk) begin
    if (~rst_n) begin
        c1_calib_done_r <= 16'd0;
    end else begin
        c1_calib_done_r <= {c1_calib_done_r[14:0], c1_calib_done};
    end
end
assign led_1_n = ~error;
always @(posedge clk) begin
    if (~rst_n) begin
        state               <= WAIT_CALI_DONE;
        c1_p0_wr_en         <= 1'b0;
        c1_p0_rd_en         <= 1'b0;
        c1_p0_cmd_en        <= 1'b0;
        c1_p0_cmd_byte_addr <= 30'd0;
        c1_p0_wr_data       <= 128'b0;
        write_addr          <= 30'd0;
        read_addr           <= 30'd0;
        read_expected_data  <= 16'd0;
        error               <= 1'b0;
    end else begin
        case (state)
            WAIT_CALI_DONE: begin
                if (c1_calib_done_r[15]) begin
                    state <= PREPARE_WR;
                end
            end
            PREPARE_WR: begin
//                if (write_addr == 330'h1000) $stop;
                if (c1_p0_wr_empty) begin
                    c1_p0_wr_en <= 1'b1;
                    state <= WRITE_DATA;
                end
            end
            WRITE_DATA: begin
                if (c1_p0_wr_data[5:0] == 6'h3f) begin
                    state <= WRITE_CMD;
                    c1_p0_wr_en <= 1'b0;
                    c1_p0_wr_data <= c1_p0_wr_data + 128'b1;
                end else if(~c1_p0_wr_full) begin
                    c1_p0_wr_en <= 1'b1;
                    c1_p0_wr_data <= c1_p0_wr_data + 128'b1;
                end else begin
                    c1_p0_wr_en <= 1'b0;
                    c1_p0_wr_data <= c1_p0_wr_data;
                end
            end
            WRITE_CMD: begin
                if (c1_p0_cmd_empty) begin
                    state               <= WAIT_WR_DONE;
                    c1_p0_cmd_en        <= 1'b1;
                    c1_p0_cmd_instr     <= WR;
                    c1_p0_cmd_bl        <= 6'h3f;
                    c1_p0_cmd_byte_addr <= write_addr;
                    write_addr          <= write_addr + 30'h400;
                end
            end
            WAIT_WR_DONE: begin
                c1_p0_cmd_en    <= 1'b0;
                if (c1_p0_cmd_empty) begin
                    state               <= READ_CMD;
                end
            end
            READ_CMD: begin
                c1_p0_cmd_en    <= 1'b0;
                if (c1_p0_cmd_empty) begin
                    c1_p0_cmd_en    <= 1'b1;
                    c1_p0_cmd_instr <= RD;
                    c1_p0_cmd_bl    <= 6'h3f;
                    c1_p0_cmd_byte_addr <= read_addr;
                    read_addr           <= read_addr + 30'h400;
                    state               <= READ_DATA;
                    read_cnt            <= 6'd0;
                end
            end
            READ_DATA: begin
                c1_p0_cmd_en    <= 1'b0;
                c1_p0_rd_en     <= 1'b1;
                if (read_cnt == 6'h3f) begin
                    c1_p0_rd_en <= 1'b0;
                    state       <= PREPARE_WR;
                    read_expected_data  <= read_expected_data + 16'd1;
                end else if (~c1_p0_rd_empty) begin
                    read_cnt    <= read_cnt + 6'd1;
                    read_expected_data  <= read_expected_data + 16'd1;
                    if (c1_p0_rd_data[15:0] != read_expected_data) error <= 1'b1;
                    $display("No.%d %X %X, expected: %X", read_cnt, c1_p0_rd_data[15:8], c1_p0_rd_data[7:0], read_expected_data);
                end
            end
        endcase
    end
end

/* -----------------  ICON, ILA, IVIO ------------------------------------- */
wire [35:0] CONTROL0;
wire [35:0] CONTROL1;
wire [ 7:0] ASYNC_IN;
wire [ 2:0] ASYNC_OUT;
wire [ 3:0] ila_trig0;
wire [31:0] ila_data;

assign ila_trig0[3:0] = { rst_n, cnt_clk0[0], state[0], error};
assign ila_data[31:0] = {
    cnt_clk0[2:0]               ,
    c1_p0_wr_en                 ,
    c1_p0_cmd_en                ,
    c1_p0_cmd_instr[0]          ,
    c1_p0_cmd_byte_addr[2:0]    ,
    c1_p0_cmd_empty             ,
    c1_p0_cmd_full              ,

    c1_p0_wr_en                 ,
    c1_p0_wr_data[3:0]          ,
    c1_p0_wr_full               ,
    c1_p0_wr_empty              ,
    c1_p0_wr_error              ,

    c1_p0_rd_en                 ,
    c1_p0_rd_data[3:0]          ,
    c1_p0_rd_full               ,
    c1_p0_rd_empty              ,
    c1_p0_rd_overflow           ,
    c1_p0_rd_error              ,
    state                       ,
    error
    };

//assign ASYNC_IN = ram_douta;

my_icon my_icon_inst (
    .CONTROL0(CONTROL0), // INOUT BUS [35:0]
    .CONTROL1(CONTROL1) // INOUT BUS [35:0]
);
my_vio my_vio_inst (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .ASYNC_IN(ASYNC_IN), // IN BUS [7:0]
    .ASYNC_OUT(ASYNC_OUT) // OUT BUS [2:0]
);
my_ila my_ila_inst (
    .CONTROL(CONTROL1), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .DATA(ila_data), // IN BUS [31:0]
    .TRIG0(ila_trig0) // IN BUS [3:0]
);
endmodule
