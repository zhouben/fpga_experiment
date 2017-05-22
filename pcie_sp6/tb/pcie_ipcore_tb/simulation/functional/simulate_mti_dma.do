vlib work
vmap work
vlog -work work \
         "+incdir+../../../../hdl" \
     $env(XILINX)/verilog/src/glbl.v \
     -f board_dma.f

vsim -voptargs="+acc" +notimingchecks +TESTNAME=pio_writeReadBack_test0 -L work -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
     work.board glbl

do wave_dma.do

run -all

