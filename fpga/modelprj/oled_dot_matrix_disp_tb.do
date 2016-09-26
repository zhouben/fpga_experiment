vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../testbench/oled_dot_matrix_disp_tb.v \
         ../oled_dot_matrix_disp.v  \
         ../oled_disp_v2.v          \
         ../ipcore_dir/dot_matrix_rom.v \
         ../ipcore_dir/oled_dot_matrix_buffer.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.oled_dot_matrix_disp_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do oled_dot_matrix_disp_wave.do

run -All



