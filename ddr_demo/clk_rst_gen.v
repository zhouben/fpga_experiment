module clk_rst_gen #
(
    parameter  WDOG_CALC_INIT_WIDTH  = 26
)
(
    input       sys_clk,
    input       sys_rst_n,
    output      clk_100M,
    output      clk_200M,
    output      clk_333M_1,
    //output clk_333M_2,
    output reg  rst_n
);

wire    clk_333M_bufi;
wire    clk_100M_bufi;
wire    clk_200M_bufi;
wire    pll_locked;

wire    sys_clk_ibufg;
IBUFG  u0_clk(
    .I  (sys_clk),
    .O  (sys_clk_ibufg)
);

wire    clk_333M_1_bufi;
BUFGCE u1_clk_333m(
    .O (clk_333M_1),
    .I (clk_333M_1_bufi),
    .CE(pll_locked)
);
   
BUFGCE u2_clk_100m(
    .O (clk_100M),
    .I (clk_100M_bufi),
    .CE(pll_locked)
);

BUFGCE u3_clk_200m(
    .O (clk_200M),
    .I (clk_200M_bufi),
    .CE(pll_locked)
);
reg         rst_n_dly;
wire        rst_internal_n;
wire        clkfb;

assign  rst_internal_n = (sys_rst_n) && (pll_locked);

always @(posedge clk_100M , negedge rst_internal_n) begin
    if (~rst_internal_n)    {rst_n, rst_n_dly} <= 2'b0;
    else                    {rst_n, rst_n_dly} <= {rst_n_dly, 1'b1};
end

my_pll u3_pll
   (// Clock in ports
    .CLK_IN     (sys_clk_ibufg),      // IN
    .CLKFB_IN   (clkfb),     // IN
    // Clock out ports
    .CLK_100M   (clk_100M_bufi),     // OUT
    .CLK_200M   (clk_200M_bufi),
    .CLK_333M   (clk_333M_1_bufi),     // OUT
    .CLKFB_OUT  (clkfb),    // OUT
    // Status and control signals
    .RESET      (~sys_rst_n),// IN
    .LOCKED     (pll_locked));      // OUT

endmodule
