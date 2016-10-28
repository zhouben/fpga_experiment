vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../../ipcore_dir/clk_gen_65m.v \
         ../../alinx_ipcore/slogan_rom.v \
         ../vga_ctrl.v  \
         ../vga_exp.v    \
         ./vga_exp_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.vga_exp_tb -t 1ps -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do vga_exp_tb_wave.do

run -All


