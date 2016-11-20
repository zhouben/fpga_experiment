onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_vga_exp_tb/clk
add wave -noupdate /sdram_vga_exp_tb/rst_n
add wave -noupdate -expand -group SDRAM /sdram_vga_exp_tb/u0/S_CLK
add wave -noupdate -expand -group SDRAM /sdram_vga_exp_tb/u0/S_NCS
add wave -noupdate -expand -group SDRAM /sdram_vga_exp_tb/u0/S_NRAS
add wave -noupdate -expand -group SDRAM /sdram_vga_exp_tb/u0/S_NCAS
add wave -noupdate -expand -group SDRAM /sdram_vga_exp_tb/u0/S_NWE
add wave -noupdate -expand -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_BA
add wave -noupdate -expand -group SDRAM -radix hexadecimal /sdram_vga_exp_tb/u0/S_A
add wave -noupdate -expand -group SDRAM -radix unsigned -childformat {{{/sdram_vga_exp_tb/u0/S_DB[15]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[14]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[13]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[12]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[11]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[10]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[9]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[8]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[7]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[6]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[5]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[4]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[3]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[2]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[1]} -radix unsigned} {{/sdram_vga_exp_tb/u0/S_DB[0]} -radix unsigned}} -subitemconfig {{/sdram_vga_exp_tb/u0/S_DB[15]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[14]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[13]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[12]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[11]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[10]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[9]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[8]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[7]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[6]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[5]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[4]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[3]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[2]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[1]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/S_DB[0]} {-height 15 -radix unsigned}} /sdram_vga_exp_tb/u0/S_DB
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_hsync
add wave -noupdate -group VGA /sdram_vga_exp_tb/u0/vga_vsync
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_red
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_green
add wave -noupdate -group VGA -radix unsigned /sdram_vga_exp_tb/u0/vga_blue
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/frame_sync
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_req
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/mem_din
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_load
add wave -noupdate -expand -group mem_arbitor_wr -radix hexadecimal /sdram_vga_exp_tb/u0/mem_arbitor/mem_wr_addr
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_dout
add wave -noupdate -expand -group mem_arbitor_wr -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_rd_count
add wave -noupdate -expand -group mem_arbitor_wr /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/wr_fifo_ren
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rdy_to_rd
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_req
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_dout
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_load
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_done
add wave -noupdate -group mem_arbitor_rd /sdram_vga_exp_tb/u0/mem_arbitor/mem_rd_addr
add wave -noupdate -radix unsigned /sdram_vga_exp_tb/u0/mem_arbitor/state
add wave -noupdate -radix unsigned -childformat {{{/sdram_vga_exp_tb/u0/mem_arbitor/state_next[1]} -radix unsigned} {{/sdram_vga_exp_tb/u0/mem_arbitor/state_next[0]} -radix unsigned}} -subitemconfig {{/sdram_vga_exp_tb/u0/mem_arbitor/state_next[1]} {-height 15 -radix unsigned} {/sdram_vga_exp_tb/u0/mem_arbitor/state_next[0]} {-height 15 -radix unsigned}} /sdram_vga_exp_tb/u0/mem_arbitor/state_next
add wave -noupdate -label sdram_init_done -radix binary /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/sdram_init_done
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/mem_rdy_to_wr
add wave -noupdate -radix binary /sdram_vga_exp_tb/u0/vga_gen_den
add wave -noupdate -radix hexadecimal /sdram_vga_exp_tb/u0/vga_gen_dout
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state
add wave -noupdate /sdram_vga_exp_tb/u0/mem_arbitor/sdram_mcb/state_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {235183343 ps} 0}
configure wave -namecolwidth 400
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
WaveRestoreZoom {203237557 ps} {267102389 ps}
