vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../../alinx_ipcore/sdram_vga_pll.v \
         ../sdram_vga_clk_gen.v     \
         ../vga_data_gen.v      \
         ./sdram_para.v     \
         ../../alinx_ipcore/sdram_wr_fifo.v \
         ../../alinx_ipcore/sdram_rd_fifo.v \
         ../../sdram_ip/sdram_cmd.v      \
         ../../sdram_ip/sdram_ctrl.v     \
         ../../sdram_ip/sdram_mcb.v      \
         ../../sdram_ip/sdram_top.v      \
         ../../sdram_ip/sdram_wr_data.v      \
         ../../sdram_ip/tb/sdram_model.v    \
         ../mem_arbitor.v       \
         ../../vga/vga_ctrl.v  \
         ../sdram_vga_exp.v    \
         ./sdram_vga_exp_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.sdram_vga_exp_tb -t 1ps -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do sdram_vga_exp_tb_wave.do

run -All


