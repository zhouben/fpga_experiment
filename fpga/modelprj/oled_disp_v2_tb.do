vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../oled_disp_v2.v    \
         ../testbench/oled_disp_v2_tb.v  \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.oled_disp_v2_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do oled_disp_v2_wave.do

run 10us


