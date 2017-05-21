onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmd_process_fsm_tb/clk
add wave -noupdate /cmd_process_fsm_tb/rst_n
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/clk
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/cmd_type
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/compl_done_i
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_addr_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_attr_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_be_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_compl_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_compl_with_data_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_ep_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_len_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_rid_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_tag_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_tc_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/req_td_o
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/rst_n
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/state
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/state_next
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/us_cmd_fifo_dout_i
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/us_cmd_fifo_empty
add wave -noupdate /cmd_process_fsm_tb/CMD_PROCESS_FSMEx01/us_cmd_fifo_rd_en_o
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
