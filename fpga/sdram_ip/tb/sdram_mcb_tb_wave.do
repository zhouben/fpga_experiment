onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_mcb_tb/clk_100m
add wave -noupdate /sdram_mcb_tb/clk_50m
add wave -noupdate /sdram_mcb_tb/rst_n
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/din
add wave -noupdate /sdram_mcb_tb/u0/wr_req
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/wr_addr
add wave -noupdate /sdram_mcb_tb/wr_done
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/wr_length
add wave -noupdate /sdram_mcb_tb/wr_load
add wave -noupdate /sdram_mcb_tb/wr_rdy
add wave -noupdate /sdram_mcb_tb/wr_req
add wave -noupdate -radix hexadecimal -childformat {{{/sdram_mcb_tb/S_A[12]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[11]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[10]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[9]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[8]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[7]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[6]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[5]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[4]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[3]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[2]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[1]} -radix hexadecimal} {{/sdram_mcb_tb/S_A[0]} -radix hexadecimal}} -subitemconfig {{/sdram_mcb_tb/S_A[12]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[11]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[10]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[9]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[8]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[7]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[6]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[5]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[4]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[3]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[2]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[1]} {-height 15 -radix hexadecimal} {/sdram_mcb_tb/S_A[0]} {-height 15 -radix hexadecimal}} /sdram_mcb_tb/S_A
add wave -noupdate /sdram_mcb_tb/S_BA
add wave -noupdate /sdram_mcb_tb/S_CKE
add wave -noupdate /sdram_mcb_tb/S_CLK
add wave -noupdate /sdram_mcb_tb/u0/rd_fifo_wen
add wave -noupdate /sdram_mcb_tb/u0/wr_fifo_ren
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/S_DB
add wave -noupdate /sdram_mcb_tb/S_NCS
add wave -noupdate /sdram_mcb_tb/S_NRAS
add wave -noupdate /sdram_mcb_tb/S_NCAS
add wave -noupdate /sdram_mcb_tb/S_NWE
add wave -noupdate /sdram_mcb_tb/u0/sdram_top/work_state
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/wr_addr_r
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/sdwr_byte
add wave -noupdate /sdram_mcb_tb/u0/sdram_wr_req
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/stage_sdram_wr_cnt
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/stage_wr_bytes
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/wr_length_r
add wave -noupdate /sdram_mcb_tb/u0/wr_load_d2
add wave -noupdate /sdram_mcb_tb/u0/wr_load_d3
add wave -noupdate /sdram_mcb_tb/u0/wr_load_pulse
add wave -noupdate /sdram_mcb_tb/u0/wr_pending
add wave -noupdate /sdram_mcb_tb/u0/rd_fifo_wen
add wave -noupdate /sdram_mcb_tb/u0/wr_fifo_ren
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/wr_fifo_wr_count
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/wr_fifo_rd_count
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/wr_fifo_dout
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/din
add wave -noupdate /sdram_mcb_tb/u0/wr_done
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/state_next
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/state
add wave -noupdate /sdram_mcb_tb/u0/rd_load
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_length_r
add wave -noupdate /sdram_mcb_tb/u0/sdram_rd_req
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/sdrd_byte
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_addr_r
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_addr_d2
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_addr_d1
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_addr
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/dout
add wave -noupdate /sdram_mcb_tb/clk_50m
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/stage_rd_bytes
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/stage_sdram_rd_cnt
add wave -noupdate /sdram_mcb_tb/u0/rd_fifo_wen
add wave -noupdate /sdram_mcb_tb/u0/rd_req
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_fifo_wr_count
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/u0/rd_fifo_cnt
add wave -noupdate /sdram_mcb_tb/u0/rd_fifo_full
add wave -noupdate /sdram_mcb_tb/u0/rd_fifo_empty
add wave -noupdate /sdram_mcb_tb/rd_done
add wave -noupdate -radix hexadecimal /sdram_mcb_tb/wr_load
add wave -noupdate -radix unsigned /sdram_mcb_tb/u1/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44954937 ps} 0} {{Cursor 2} {78140165 ps} 0}
configure wave -namecolwidth 259
configure wave -valuecolwidth 66
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
WaveRestoreZoom {78031758 ps} {78245060 ps}
