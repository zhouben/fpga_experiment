vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../testbench/oled_tb.v \
         ../i2c_master.v    \
         ../i2c_slave.v    \
         ../oled_init.v     \
         ../oled_disp.v     \
         ../oled_ctrl.v     \
         ../oled_disp_v2.v  \
         ../oled_dot_matrix_disp.v  \
         ../ipcore_dir/dot_matrix_rom.v \
         ../ipcore_dir/oled_dot_matrix_buffer.v \
         ../ipcore_dir/my_ram.v \
         ../ipcore_dir/oled_config_rom.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.oled_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do oled_wave.do

run -All


