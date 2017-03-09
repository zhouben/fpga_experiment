vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../crc.v    \
         ../crc_by_1bit.v \
         ./crc_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.crc_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do crc_tb_wave.do

run -All


