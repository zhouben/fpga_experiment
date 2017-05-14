vlib work
vmap work work
vlog -reportprogress 300 -work work \
         ../spi_master.v    \
         ../spi_slave.v    \
         ./tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do tb_wave.do

run -All


