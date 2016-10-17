onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate                    /xxx_tb/clk
add wave -noupdate                    /xxx_tb/rst_n
add wave -noupdate -radix hexadecimal /xxx_tb/din
add wave -noupdate                    /xxx_tb/wen 
add wave -noupdate                    /xxx_tb/rdy 
add wave -noupdate -radix hexadecimal /xxx_tb/dout
add wave -noupdate                    /xxx_tb/done

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
WaveRestoreZoom {0 ns} {438 ns}
