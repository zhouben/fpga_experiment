vlib work
vmap work work
vlog -reportprogress 300 +define+MODELSIM_DBG -work work \
        ../sdbank_switch.v     \
        ../sdram_cmd.v     \
        ../sdram_ctrl.v        \
        ../sdram_para.v        \
        ../sdram_top.v     \
        ../sdram_wr_data.v     \
        ../../alinx_ipcore/wrfifo.v \
        ../../alinx_ipcore/rdfifo.v \
        ../../alinx_ipcore/sdram_pll.v  \
        ./sdram_model.v    \
        ../../clk_gen.v     \
        ../../sdram_top_exp.v   \
        ./tb.v    \
     $env(XILINX)/verilog/src/unisims/ODDR2.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.sdram_top_tb -t 1ps -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do wave.do

run -All


