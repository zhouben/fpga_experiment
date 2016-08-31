

vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../testbench/i2c_tb.v \
         ../i2c_slave.v    \
         ../ipcore_dir/my_ram.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.i2c_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do wave.do

run -All


