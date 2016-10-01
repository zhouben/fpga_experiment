onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ddr3_tb/ddr3_top/clk_20M
add wave -noupdate /ddr3_tb/ddr3_top/clk_50M
add wave -noupdate /ddr3_tb/ddr3_top/clk
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/rst_n
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/sw_rst_i
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/c1_calib_done
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/state
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/read_addr
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/read_cnt
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/write_addr
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_cmd_bl
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_cmd_byte_addr
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_cmd_empty
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_cmd_en
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_cmd_full
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_cmd_instr
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_rd_count
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_rd_data
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_rd_empty
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_rd_en
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_rd_error
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_rd_full
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_rd_overflow
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_wr_count
add wave -noupdate -radix unsigned /ddr3_tb/ddr3_top/c1_p0_wr_data
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/c1_p0_wr_empty
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/c1_p0_wr_en
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/c1_p0_wr_error
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/c1_p0_wr_full
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_wr_mask
add wave -noupdate /ddr3_tb/ddr3_top/c1_p0_wr_underrun
add wave -noupdate /ddr3_tb/ddr3_top/c1_rst0
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/clk0
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/clk_2x_0
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/clk_2x_180
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/locked
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/mcb_drp_clk
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/pll_ce_0
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/pll_ce_90
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/pll_lock
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/rst0
add wave -noupdate -radix binary /ddr3_tb/ddr3_top/u_my_ddr3_mig/memc1_infrastructure_inst/sys_rst
add wave -noupdate /ddr3_tb/mcb1_dram_a
add wave -noupdate /ddr3_tb/mcb1_dram_ba
add wave -noupdate /ddr3_tb/mcb1_dram_cas_n
add wave -noupdate /ddr3_tb/mcb1_dram_ck
add wave -noupdate /ddr3_tb/mcb1_dram_ck_n
add wave -noupdate /ddr3_tb/mcb1_dram_cke
add wave -noupdate /ddr3_tb/mcb1_dram_dm
add wave -noupdate /ddr3_tb/mcb1_dram_dq
add wave -noupdate /ddr3_tb/mcb1_dram_dqs
add wave -noupdate /ddr3_tb/mcb1_dram_dqs_n
add wave -noupdate /ddr3_tb/mcb1_dram_odt
add wave -noupdate /ddr3_tb/mcb1_dram_ras_n
add wave -noupdate /ddr3_tb/mcb1_dram_reset_n
add wave -noupdate /ddr3_tb/mcb1_dram_udm
add wave -noupdate /ddr3_tb/mcb1_dram_udqs
add wave -noupdate /ddr3_tb/mcb1_dram_udqs_n
add wave -noupdate /ddr3_tb/mcb1_dram_we_n
add wave -noupdate /ddr3_tb/mcb1_rzq
add wave -noupdate /ddr3_tb/mcb1_zio
add wave -noupdate /ddr3_tb/ddr3_top/c1_calib_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26601837 ps} 0} {{Cursor 2} {365001424 ps} 0}
configure wave -namecolwidth 249
configure wave -valuecolwidth 73
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {364718991 ps} {365480477 ps}
