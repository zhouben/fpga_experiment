onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pb_uart_7seg_tb/clk
add wave -noupdate /pb_uart_7seg_tb/rst_n
add wave -noupdate /pb_uart_7seg_tb/u0/uart_tx_ready
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/state
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/write
add wave -noupdate -radix unsigned /pb_uart_7seg_tb/u0/_uart_tx/sb
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/data
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_tx/bit_flag
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/data_rx
add wave -noupdate /pb_uart_7seg_tb/u0/uart_rx_ready
add wave -noupdate /pb_uart_7seg_tb/u0/uart_rx_ready_d
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_rx/read
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/out_port
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/port_id
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/pb_out
add wave -noupdate /pb_uart_7seg_tb/u0/write_strobe
add wave -noupdate /pb_uart_7seg_tb/u0/write_strobe_d
add wave -noupdate /pb_uart_7seg_tb/u0/read_strobe
add wave -noupdate /pb_uart_7seg_tb/u0/uart_rx_i
add wave -noupdate /pb_uart_7seg_tb/u0/baudclk16
add wave -noupdate /pb_uart_7seg_tb/u0/uart_din_count
add wave -noupdate /pb_uart_7seg_tb/u0/_uart_rx/state
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/_crc/crc_out
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/crc
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/u0/_uart_rx/sb
add wave -noupdate -radix hexadecimal /pb_uart_7seg_tb/tsk_host_send_to_uart_8N1/byte_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {385284 ns} 0}
configure wave -namecolwidth 253
configure wave -valuecolwidth 46
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
WaveRestoreZoom {353994 ns} {443654 ns}
