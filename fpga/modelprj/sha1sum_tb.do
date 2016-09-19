vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../sha1sum.v    \
         ../testbench/sha1sum_tb.v  \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.sha1sum_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do sha1sum_wave.do

run 100us


