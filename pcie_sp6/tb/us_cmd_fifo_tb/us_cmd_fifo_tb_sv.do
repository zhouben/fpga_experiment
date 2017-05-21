vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../../ipcore_dir/us_cmd_fifo.v    \
         ./us_cmd_fifo_tb.sv    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.us_cmd_fifo_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do us_cmd_fifo_tb_wave_sv.do

run -All


