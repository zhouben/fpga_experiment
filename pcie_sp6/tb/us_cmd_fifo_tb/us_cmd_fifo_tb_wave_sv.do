onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /us_cmd_fifo_tb/clk
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/clk
add wave -noupdate -radix unsigned /us_cmd_fifo_tb/us_cmd_fifoEx01/data_count
add wave -noupdate -radix hexadecimal /us_cmd_fifo_tb/din32
add wave -noupdate -radix hexadecimal /us_cmd_fifo_tb/dout32
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/empty
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/full
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/prog_full
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/rd_en
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/rst
add wave -noupdate /us_cmd_fifo_tb/us_cmd_fifoEx01/wr_en
add wave -noupdate /us_cmd_fifo_tb/tsk_wr_rd_test/_i
add wave -noupdate /us_cmd_fifo_tb/tsk_wr_rd_test/seed
add wave -noupdate /us_cmd_fifo_tb/rd_en_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {930 ns} 0}
configure wave -namecolwidth 252
configure wave -valuecolwidth 55
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
WaveRestoreZoom {736 ns} {1067 ns}
