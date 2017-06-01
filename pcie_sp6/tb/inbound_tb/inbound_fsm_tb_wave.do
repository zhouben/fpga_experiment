onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /inbound_fsm_tb/clk
add wave -noupdate /inbound_fsm_tb/rst_n
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/cmd
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/cmd_id
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/inbound_state
add wave -noupdate -radix ascii /inbound_fsm_tb/INBOUND_FSMEx01/inbound_state_ascii
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/rd_addr_i
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/rd_be_i
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/rd_data_o
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/state
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/state_next
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/us_cmd_fifo_wr_en_o
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/wr_addr_i
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/wr_be_i
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/wr_busy_o
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/wr_data_i
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/wr_en_i
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/addr_0
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/addr_1
add wave -noupdate -radix hexadecimal /inbound_fsm_tb/INBOUND_FSMEx01/len
add wave -noupdate /inbound_fsm_tb/INBOUND_FSMEx01/us_cmd_type
add wave -noupdate -divider tsk_wr_cmd_register
add wave -noupdate -radix unsigned /inbound_fsm_tb/tsk_wr_cmd_register/addr
add wave -noupdate -radix unsigned /inbound_fsm_tb/tsk_wr_cmd_register/cmd_id
add wave -noupdate -radix unsigned /inbound_fsm_tb/tsk_wr_cmd_register/cmd_type
add wave -noupdate -radix unsigned /inbound_fsm_tb/tsk_wr_cmd_register/len
add wave -noupdate /inbound_fsm_tb/cmd_id_i
add wave -noupdate /inbound_fsm_tb/to_rxe_compl_done_o
add wave -noupdate /inbound_fsm_tb/req_compl_i
add wave -noupdate /inbound_fsm_tb/req_compl_with_data_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {283 ns} 0}
configure wave -namecolwidth 368
configure wave -valuecolwidth 61
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
WaveRestoreZoom {117 ns} {457 ns}
bookmark add wave {写len,addr,cmd,then complete} {{1450 ns} {1818 ns}} 2
