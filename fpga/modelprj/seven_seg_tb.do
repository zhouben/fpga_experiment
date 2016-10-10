vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../seven_seg/seven_seg_interface.v    \
         ../seven_seg/bin2bcd.v  \
         ../testbench/seven_seg_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.seven_seg_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do seven_seg_wave.do

run 100us


