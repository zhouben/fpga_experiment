onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_top_tb/rst_n
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/S_A
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/S_BA
add wave -noupdate /sdram_top_tb/u0/S_CKE
add wave -noupdate /sdram_top_tb/u0/S_CLK
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/S_DB
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/S_DQM
add wave -noupdate -radix binary /sdram_top_tb/u0/S_NCS
add wave -noupdate -radix binary /sdram_top_tb/u0/S_NRAS
add wave -noupdate -radix binary /sdram_top_tb/u0/S_NCAS
add wave -noupdate -radix binary /sdram_top_tb/u0/S_NWE
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/addr
add wave -noupdate /sdram_top_tb/u0/clk_100m
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/cnt
add wave -noupdate /sdram_top_tb/u0/error
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/state
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/sys_data_in
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/sys_data_out
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/sys_data_verify
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/sys_rdaddr
add wave -noupdate -radix hexadecimal /sdram_top_tb/u0/sys_wraddr
add wave -noupdate /sdram_top_tb/u0/wr_flag
add wave -noupdate -radix binary /sdram_top_tb/u0/wr_kickoff
add wave -noupdate -radix binary /sdram_top_tb/u0/sdram_init_done
add wave -noupdate -radix binary /sdram_top_tb/u0/sdram_rd_ack
add wave -noupdate -radix binary /sdram_top_tb/u0/sdram_rd_req
add wave -noupdate -radix binary /sdram_top_tb/u0/sdram_wr_ack
add wave -noupdate -radix binary /sdram_top_tb/u0/sdram_wr_req
add wave -noupdate -radix unsigned -childformat {{{/sdram_top_tb/u1/state[2]} -radix unsigned} {{/sdram_top_tb/u1/state[1]} -radix unsigned} {{/sdram_top_tb/u1/state[0]} -radix unsigned}} -subitemconfig {{/sdram_top_tb/u1/state[2]} {-height 15 -radix unsigned} {/sdram_top_tb/u1/state[1]} {-height 15 -radix unsigned} {/sdram_top_tb/u1/state[0]} {-height 15 -radix unsigned}} /sdram_top_tb/u1/state
add wave -noupdate -radix unsigned /sdram_top_tb/u1/value
add wave -noupdate -radix binary /sdram_top_tb/u1/cmd
add wave -noupdate -radix hexadecimal /sdram_top_tb/u1/addr
add wave -noupdate -radix hexadecimal /sdram_top_tb/u1/wr_data
add wave -noupdate -radix hexadecimal /sdram_top_tb/u1/value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {200500000 ps} 0} {{Cursor 2} {1000019645 ps} 0}
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {200458717 ps} {200561283 ps}
