onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pb_uart_7seg_tb/clk
add wave -noupdate /pb_uart_7seg_tb/rst_n
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/uart_tx
add wave -noupdate /pb_uart_7seg_tb/u0/uart_tx_ready
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/state
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/write
add wave -noupdate -radix unsigned /pb_uart_7seg_tb/u0/_uart_tx/sb
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/data
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/bit_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {588 ns} 0}
configure wave -namecolwidth 223
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
WaveRestoreZoom {9192 ns} {10222 ns}
