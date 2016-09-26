onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /oled_disp_v2_tb/clk
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/data
add wave -noupdate /oled_disp_v2_tb/done
add wave -noupdate /oled_disp_v2_tb/i2c_done
add wave -noupdate /oled_disp_v2_tb/i2c_wen
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/pos
add wave -noupdate /oled_disp_v2_tb/rdy
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/reg_addr
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/reg_data
add wave -noupdate /oled_disp_v2_tb/rst_n
add wave -noupdate /oled_disp_v2_tb/seqential
add wave -noupdate /oled_disp_v2_tb/start
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/oled_disp_v2/disp_value
add wave -noupdate /oled_disp_v2_tb/oled_disp_v2/i2c_done
add wave -noupdate /oled_disp_v2_tb/oled_disp_v2/i2c_wen
add wave -noupdate -radix unsigned /oled_disp_v2_tb/oled_disp_v2/sleep_cnt
add wave -noupdate -radix unsigned /oled_disp_v2_tb/oled_disp_v2/state
add wave -noupdate -radix unsigned /oled_disp_v2_tb/oled_disp_v2/state_next
add wave -noupdate /oled_disp_v2_tb/oled_disp_v2/update_pos
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/oled_disp_v2/x
add wave -noupdate -radix hexadecimal /oled_disp_v2_tb/oled_disp_v2/y
add wave -noupdate -radix ascii /oled_disp_v2_tb/oled_disp_v2/state_ascii
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {249 ns} 0}
configure wave -namecolwidth 292
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
WaveRestoreZoom {0 ns} {658 ns}
