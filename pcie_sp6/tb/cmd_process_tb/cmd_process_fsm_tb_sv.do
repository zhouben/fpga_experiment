vlib work
vmap work work

vlog -reportprogress 300 -work work \
         "+incdir+../../hdl" \
         ../../hdl/cmd_process_fsm.v    \
         ./cmd_process_fsm_tb.sv    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.cmd_process_fsm_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do cmd_process_fsm_tb_wave_sv.do

run -All


