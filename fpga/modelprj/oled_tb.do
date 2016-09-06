vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../testbench/oled_tb.v \
         ../i2c_master.v    \
         ../i2c_slave.v    \
         ../oled_ctrl.v     \
         ../ipcore_dir/my_ram.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.oled_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do oled_ctrl_wave.do

run -All


