vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../md5sum.v    \
         ../testbench/md5sum_tb.v  \
         ../md5_shift_table.v   \
         ../md5_sint_table.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.md5sum_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do md5sum_wave.do

run 100us


