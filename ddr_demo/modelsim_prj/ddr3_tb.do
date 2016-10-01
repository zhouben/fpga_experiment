

vlib work
vmap work work
vlog  +incdir+. +define+x2Gb +define+sg15E +define+x16 ddr3_model_c1.v
vlog -reportprogress 300 -work work \
         ../testbench/ddr3_tb.v \
         ../ddr3_top.v    \
         ../clk_rst_gen.v   \
         ../ipcore_dir/my_pll.v \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/my_ddr3_mig.v    \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/infrastructure.v \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/memc_wrapper.v   \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/mcb_ui_top.v  \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/iodrp_controller.v    \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/iodrp_mcb_controller.v    \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/mcb_raw_wrapper.v \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/mcb_soft_calibration.v    \
         ../ipcore_dir/my_ddr3_mig/user_design/rtl/mcb_controller/mcb_soft_calibration_top.v    \
         ../ipcore_dir/my_ila.v \
         ../ipcore_dir/my_icon.v    \
         ../ipcore_dir/my_vio.v \
     $env(XILINX)/verilog/src/glbl.v

vsim -novopt  work.ddr3_tb -t 1ps -L secureip \
     -L unisims_ver \
     -L xilinxcorelib_ver \
      glbl

do ddr3_wave.do

run -All


