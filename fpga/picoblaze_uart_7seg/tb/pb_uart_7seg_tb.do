vlib work
vmap work work
vlog -reportprogress 300 +define+MODELSIM_SIM -work work \
         ../../uart.v          \
         ../../seven_seg/bin2bcd.v \
         ../../seven_seg/seven_seg_interface.v \
         ../fw.v \
         ../../picoblaze/kcpsm6.v \
         ../pb_uart_7seg.v    \
         ./pb_uart_7seg_tb.v    \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.pb_uart_7seg_tb -t 1ns -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do pb_uart_7seg_tb_wave.do

run -All


