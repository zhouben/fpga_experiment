vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../../ipcore_dir/LOCAL_MEM.v    \
         ./LOCAL_MEM_tb.sv    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.LOCAL_MEM_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do LOCAL_MEM_tb_wave_sv.do

run -All


