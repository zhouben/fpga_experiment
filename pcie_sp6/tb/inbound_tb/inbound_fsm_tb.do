vlib work
vmap work work
vlog -reportprogress 300 -work work \
         "+incdir+../../hdl" \
         ../../hdl/inbound_fsm.v    \
         ./inbound_fsm_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.inbound_fsm_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do inbound_fsm_tb_wave.do

run -All
