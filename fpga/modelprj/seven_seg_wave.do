onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /seven_seg_tb/u0/base
add wave -noupdate /seven_seg_tb/u0/clk
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/data
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/data_r
add wave -noupdate /seven_seg_tb/u0/done
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/leds_o
add wave -noupdate /seven_seg_tb/u0/rdy
add wave -noupdate /seven_seg_tb/u0/rst_n
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/sels_o
add wave -noupdate /seven_seg_tb/u0/wen
add wave -noupdate -radix hexadecimal -childformat {{{/seven_seg_tb/u0/u0/data_r[31]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[30]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[29]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[28]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[27]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[26]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[25]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[24]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[23]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[22]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[21]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[20]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[19]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[18]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[17]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[16]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[15]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[14]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[13]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[12]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[11]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[10]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[9]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[8]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[7]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[6]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[5]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[4]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[3]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[2]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[1]} -radix hexadecimal} {{/seven_seg_tb/u0/u0/data_r[0]} -radix hexadecimal}} -subitemconfig {{/seven_seg_tb/u0/u0/data_r[31]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[30]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[29]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[28]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[27]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[26]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[25]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[24]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[23]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[22]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[21]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[20]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[19]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[18]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[17]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[16]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[15]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[14]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[13]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[12]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[11]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[10]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[9]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[8]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[7]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[6]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[5]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[4]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[3]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[2]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[1]} {-height 15 -radix hexadecimal} {/seven_seg_tb/u0/u0/data_r[0]} {-height 15 -radix hexadecimal}} /seven_seg_tb/u0/u0/data_r
add wave -noupdate -radix hexadecimal /seven_seg_tb/data
add wave -noupdate -radix hexadecimal /seven_seg_tb/leds_o
add wave -noupdate -radix binary /seven_seg_tb/sels_o
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/data_encode
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/state
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/u0/bcd
add wave -noupdate -radix unsigned /seven_seg_tb/u0/u0/cnt
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/u0/data_r
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/u0/din
add wave -noupdate /seven_seg_tb/u0/u0/done
add wave -noupdate -radix hexadecimal /seven_seg_tb/u0/u0/dout
add wave -noupdate /seven_seg_tb/u0/u0/en
add wave -noupdate /seven_seg_tb/u0/u0/rst_n
add wave -noupdate -radix unsigned /seven_seg_tb/u0/u0/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1441 ns} 0}
configure wave -namecolwidth 219
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {1105 ns} {1432 ns}
