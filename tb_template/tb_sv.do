vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../xxx.v    \
         ./xxx_tb.sv    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.xxx_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do xxx_tb_wave_sv.do

run -All


