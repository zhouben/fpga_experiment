vlib work
vmap work work
vlog -reportprogress 300 -work work \
         "+incdir+../../hdl" \
         ../../hdl/inbound_fsm.v \
         ../../hdl/cmd_process_fsm.v \
         ../../ipcore_dir/us_cmd_fifo.v \
         ../../hdl/MY_EP_MEM_CTRL.v    \
         ./MY_EP_MEM_CTRL_tb.sv    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.MY_EP_MEM_CTRL_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do MY_EP_MEM_CTRL_tb_wave_sv.do

run -All


