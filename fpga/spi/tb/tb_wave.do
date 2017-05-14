onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/busy
add wave -noupdate /tb/clk
add wave -noupdate /tb/clk_divider
add wave -noupdate /tb/csb
add wave -noupdate /tb/datai
add wave -noupdate /tb/datai_prev
add wave -noupdate -expand /tb/din
add wave -noupdate /tb/done
add wave -noupdate /tb/dout
add wave -noupdate /tb/go
add wave -noupdate -expand /tb/master_datao0
add wave -noupdate /tb/master_datao1
add wave -noupdate /tb/master_datao2
add wave -noupdate /tb/master_datao3
add wave -noupdate /tb/resetb
add wave -noupdate -expand /tb/sclk
add wave -noupdate -expand /tb/slave_data0
add wave -noupdate /tb/slave_data1
add wave -noupdate /tb/slave_data2
add wave -noupdate /tb/slave_data3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90 ns} 0}
configure wave -namecolwidth 195
configure wave -valuecolwidth 38
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
WaveRestoreZoom {104 ns} {184 ns}
