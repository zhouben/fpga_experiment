onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_vga_exp_tb/clk
add wave -noupdate /sdram_vga_exp_tb/rst_n
add wave -noupdate -label sdram_init_done -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/sdram_init_done
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_CLK
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NCS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NRAS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NCAS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NWE
add wave -noupdate -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_BA
add wave -noupdate -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_A
add wave -noupdate -group SDRAM -radix unsigned -childformat {{{/sdram_vga_exp_tb/u0/S_DB[15]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[14]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[13]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[12]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[11]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[10]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[9]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[8]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[7]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[6]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[5]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[4]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[3]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[2]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[1]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[0]} -radix unsigned}} -subitemconfig {{/sdram_vga_exp_tb/u0/S_DB[15]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[14]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[13]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[12]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[11]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[10]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[9]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[8]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[7]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[6]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[5]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[4]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[3]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[2]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[1]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[0]} {-height 15 -radix unsigned}} /sdram_vga_exp_tb/u0/S_DB
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_CLK
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NCS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NRAS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NCAS
add wave -noupdate -group SDRAM /sdram_vga_exp_tb/u0/S_NWE
add wave -noupdate -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_BA
add wave -noupdate -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_A
add wave -noupdate -group SDRAM -radix unsigned -childformat {{{/sdram_vga_exp_tb/u0/S_DB[15]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[14]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[13]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[12]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[11]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[10]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[9]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[8]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[7]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[6]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[5]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[4]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[3]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[2]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[1]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[0]} -radix unsigned}} -subitemconfig {{/sdram_vga_exp_tb/u0/S_DB[15]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[14]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[13]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[12]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[11]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[10]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[9]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[8]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[7]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[6]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[5]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[4]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[3]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[2]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[1]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[0]} {-height 15 -radix unsigned}} /sdram_vga_exp_tb/u0/S_DB
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_hsync
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_vsync
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_red
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_green
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_blue
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_hsync
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_vsync
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_red
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_green
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_blue
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/x_cnt
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/x_cnt_next
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/y_cnt
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/y_cnt_next
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/frame_sync
add wave -noupdate -expand -group mem_arbitor_wr -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_req
add wave -noupdate -expand -group mem_arbitor_wr -format Analog-Step -height 74 -max 1023.0000000000001 -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/mem_din
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_load
add wave -noupdate -expand -group mem_arbitor_wr -radix hexadecimal /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_addr
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_dout
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_full
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_almost_full
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_overflow
add wave -noupdate -expand -group mem_arbitor_wr -format Analog-Step -height 74 -max 1023.0000000000001 -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_rd_count
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_done
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_ren
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/vga_data_gen/pixel_init
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/vga_data_gen/pixel_next
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/wr_overrun
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/wr_fifo_rdy
add wave -noupdate -expand -group mem_arbitor_rd -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/mem_rdy_to_rd
add wave -noupdate -expand -group mem_arbitor_rd -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_req
add wave -noupdate -expand -group mem_arbitor_rd -radix unsigned -childformat {{{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[15]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[14]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[13]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[12]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[11]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[10]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[9]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[8]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[7]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[6]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[5]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[4]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[3]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[2]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[1]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[0]} -radix unsigned}} -subitemconfig {{/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[15]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[14]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[13]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[12]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[11]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[10]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[9]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[8]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[7]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[6]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[5]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[4]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[3]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[2]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[1]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/mem_dout[0]} {-height 15 -radix unsigned}} /sdram_vga_exp_tb/u0/mem_arbitor/mem_dout
add wave -noupdate -expand -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_load
add wave -noupdate -expand -group mem_arbitor_rd -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_done
add wave -noupdate -expand -group mem_arbitor_rd -radix hexadecimal /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_addr
add wave -noupdate -group vga_request_data /sdram_vga_exp_tb/u0/vga_ctrl/data_req
add wave -noupdate -group vga_request_data -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/din
add wave -noupdate -group vga_request_data -radix binary /sdram_vga_exp_tb/u0/vga_gen_den
add wave -noupdate -group vga_request_data -radix hexadecimal /sdram_vga_exp_tb/u0/vga_gen_dout
add wave -noupdate -group vga_request_data /sdram_vga_exp_tb/u0/vga_ctrl/data_req
add wave -noupdate -group vga_request_data -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/din
add wave -noupdate -group vga_request_data -radix binary /sdram_vga_exp_tb/u0/vga_gen_den
add wave -noupdate -group vga_request_data -radix hexadecimal /sdram_vga_exp_tb/u0/vga_gen_dout
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_rdy_to_wr
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state_next
add wave -noupdate -expand -group mcb_read_sdram -format Analog-Step -height 74 -max 1024.0 -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_fifo_rd_count
add wave -noupdate -expand -group mcb_read_sdram -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_fifo_wen
add wave -noupdate -expand -group mcb_read_sdram -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_fifo_wr_count
add wave -noupdate -expand -group mcb_read_sdram -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_fifo_underflow
add wave -noupdate -expand -group mcb_read_sdram -radix hexadecimal /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_addr_r
add wave -noupdate -expand -group mcb_read_sdram -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_req
add wave -noupdate -expand -group mcb_read_sdram /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_done
add wave -noupdate -expand -group mcb_read_sdram /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/sdram_rd_fifo/empty
add wave -noupdate -expand -group mcb_read_sdram /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/sdram_rd_fifo/full
add wave -noupdate -expand -group mcb_read_sdram -radix hexadecimal /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/rd_fifo_din
add wave -noupdate -expand -group mem_arbitor /sdram_vga_exp_tb/u1/cmd
add wave -noupdate -expand -group mem_arbitor -radix unsigned /sdram_vga_exp_tb/u1/cnt
add wave -noupdate -expand -group mem_arbitor -radix unsigned /sdram_vga_exp_tb/u1/state
add wave -noupdate -expand -group mem_arbitor /sdram_vga_exp_tb/u1/value
add wave -noupdate -expand -group mem_arbitor /sdram_vga_exp_tb/u1/cmd
add wave -noupdate -expand -group mem_arbitor -radix unsigned /sdram_vga_exp_tb/u1/cnt
add wave -noupdate -expand -group mem_arbitor -radix unsigned /sdram_vga_exp_tb/u1/state
add wave -noupdate -expand -group mem_arbitor /sdram_vga_exp_tb/u1/value
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_new_frame
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_new_frame_count
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_write_data_level
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock_d1
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock_d2
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/clk
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/rst_n
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/local_rst_n
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/data_en
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/dout
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/rst_n
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/start_i
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/wr_en
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d1
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d2
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d3
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_pulse
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/state
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/data_en
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/dout
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/rst_n
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/start_i
add wave -noupdate -expand -group vga_data_gen -radix binary /sdram_vga_exp_tb/u0/vga_data_gen/wr_en
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d1
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d2
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_d3
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/start_pulse
add wave -noupdate -expand -group vga_data_gen /sdram_vga_exp_tb/u0/vga_data_gen/state
add wave -noupdate /sdram_vga_exp_tb/clk
add wave -noupdate /sdram_vga_exp_tb/rst_n
add wave -noupdate -label sdram_init_done -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/sdram_init_done
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/x_cnt
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/x_cnt_next
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/y_cnt
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/vga_ctrl/y_cnt_next
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/frame_sync
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_rdy_to_wr
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state_next
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_new_frame
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_new_frame_count
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_write_data_level
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock_d1
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/vga_data_lock_d2
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/clk
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/rst_n
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/local_rst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16847007783 ps} 0}
configure wave -namecolwidth 440
configure wave -valuecolwidth 43
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {16632987856 ps} {16991912144 ps}
