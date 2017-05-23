onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /LOCAL_MEM_tb/clk
add wave -noupdate /LOCAL_MEM_tb/rst_n
add wave -noupdate -radix hexadecimal /LOCAL_MEM_tb/addra
add wave -noupdate -radix hexadecimal /LOCAL_MEM_tb/dina
add wave -noupdate -radix hexadecimal /LOCAL_MEM_tb/douta
add wave -noupdate /LOCAL_MEM_tb/rst_n
add wave -noupdate /LOCAL_MEM_tb/wea
add wave -noupdate /LOCAL_MEM_tb/tsk_write_readback_test/i
add wave -noupdate -radix hexadecimal /LOCAL_MEM_tb/tsk_write_readback_test/seed
add wave -noupdate -radix hexadecimal /LOCAL_MEM_tb/tsk_write_readback_test/value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {217 ns} 0}
configure wave -namecolwidth 348
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
WaveRestoreZoom {154 ns} {592 ns}
