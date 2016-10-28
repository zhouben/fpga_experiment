onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_data_gen_tb/clk
add wave -noupdate /vga_data_gen_tb/rst_n
add wave -noupdate /vga_data_gen_tb/mem_toggle
add wave -noupdate /vga_data_gen_tb/mem_wr_rdy
add wave -noupdate -radix binary /vga_data_gen_tb/mem_wr_req
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/mem_din
add wave -noupdate /vga_data_gen_tb/u0/start_i
add wave -noupdate /vga_data_gen_tb/u0/wr_en
add wave -noupdate /vga_data_gen_tb/u0/data_en
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/dout
add wave -noupdate /vga_data_gen_tb/u0/start_d1
add wave -noupdate /vga_data_gen_tb/u0/start_d2
add wave -noupdate /vga_data_gen_tb/u0/start_d3
add wave -noupdate /vga_data_gen_tb/u0/start_pulse
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/pixel
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/pixel_init
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/pixel_next
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/state
add wave -noupdate -radix hexadecimal /vga_data_gen_tb/u0/state_next
add wave -noupdate /vga_data_gen_tb/tsk_basic_two_loops_test/cnt
add wave -noupdate /vga_data_gen_tb/tsk_basic_two_loops_test/tmp
add wave -noupdate /vga_data_gen_tb/tsk_basic_two_loops_test/init_value
add wave -noupdate /vga_data_gen_tb/tsk_basic_two_loops_test/loop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15729663 ns} 0}
configure wave -namecolwidth 271
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
WaveRestoreZoom {15729634 ns} {15729913 ns}
