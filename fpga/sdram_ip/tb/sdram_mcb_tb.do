vlib work
vmap work work
vlog -reportprogress 300 +define+MODELSIM_DBG -work work \
        ../sdram_cmd.v     \
        ../sdram_ctrl.v        \
        ../sdram_para.v        \
        ../sdram_top.v     \
        ../sdram_wr_data.v     \
        ../../alinx_ipcore/sdram_wr_fifo.v \
        ../../alinx_ipcore/sdram_rd_fifo.v \
        ../sdram_mcb.v          \
        ./sdram_model.v    \
        ./sdram_mcb_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.sdram_mcb_tb -t 1ps -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do sdram_mcb_tb_wave.do

run -All


