vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../vga_data_gen.v    \
         ./vga_data_gen_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.vga_data_gen_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do vga_data_gen_tb_wave.do

run -All


