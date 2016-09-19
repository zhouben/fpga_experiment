onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sha1sum_tb/msg_index
add wave -noupdate /sha1sum_tb/msg_input
add wave -noupdate /sha1sum_tb/clk
add wave -noupdate /sha1sum_tb/done
add wave -noupdate /sha1sum_tb/rdy
add wave -noupdate /sha1sum_tb/rst
add wave -noupdate /sha1sum_tb/write_en
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/a
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/b
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/c
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/d
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/e
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/f
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/temp
add wave -noupdate -radix hexadecimal /sha1sum_tb/sha1sum/msg_current
add wave -noupdate -radix unsigned -childformat {{{/sha1sum_tb/sha1sum/round_num[6]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[5]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[4]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[3]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[2]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[1]} -radix unsigned} {{/sha1sum_tb/sha1sum/round_num[0]} -radix unsigned}} -subitemconfig {{/sha1sum_tb/sha1sum/round_num[6]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[5]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[4]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[3]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[2]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[1]} {-height 15 -radix unsigned} {/sha1sum_tb/sha1sum/round_num[0]} {-height 15 -radix unsigned}} /sha1sum_tb/sha1sum/round_num
add wave -noupdate -radix unsigned /sha1sum_tb/sha1sum/round_num_next
add wave -noupdate -radix unsigned /sha1sum_tb/sha1sum/state
add wave -noupdate -radix unsigned /sha1sum_tb/sha1sum/state_next
add wave -noupdate -radix hexadecimal -childformat {{{/sha1sum_tb/sha1sum/msg[0]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[1]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[2]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[3]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[4]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[5]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[6]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[7]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[8]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[9]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[10]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[11]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[12]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[13]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[14]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg[15]} -radix hexadecimal}} -subitemconfig {{/sha1sum_tb/sha1sum/msg[0]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[1]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[2]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[3]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[4]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[5]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[6]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[7]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[8]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[9]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[10]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[11]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[12]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[13]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[14]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg[15]} {-height 15 -radix hexadecimal}} /sha1sum_tb/sha1sum/msg
add wave -noupdate -radix hexadecimal -childformat {{{/sha1sum_tb/sha1sum/msg_prev[0]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[1]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[2]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[3]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[4]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[5]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[6]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[7]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[8]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[9]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[10]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[11]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[12]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[13]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[14]} -radix hexadecimal} {{/sha1sum_tb/sha1sum/msg_prev[15]} -radix hexadecimal}} -expand -subitemconfig {{/sha1sum_tb/sha1sum/msg_prev[0]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[1]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[2]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[3]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[4]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[5]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[6]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[7]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[8]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[9]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[10]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[11]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[12]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[13]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[14]} {-height 15 -radix hexadecimal} {/sha1sum_tb/sha1sum/msg_prev[15]} {-height 15 -radix hexadecimal}} /sha1sum_tb/sha1sum/msg_prev
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1991 ns} 0} {{Cursor 2} {99849 ns} 0} {{Cursor 3} {93 ns} 0}
configure wave -namecolwidth 259
configure wave -valuecolwidth 40
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
configure wave -timelineunits us
update
WaveRestoreZoom {1665 ns} {2165 ns}
