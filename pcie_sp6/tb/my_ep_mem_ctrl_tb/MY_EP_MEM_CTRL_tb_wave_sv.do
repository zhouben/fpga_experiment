onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider inbound_fsm
add wave -noupdate -label inbound_fsm_inst/state /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/state
add wave -noupdate -label inbound_fsm_inst/us_cmd_type /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/us_cmd_type
add wave -noupdate -label inbound_fsm_inst/wr_addr_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/wr_addr_i
add wave -noupdate -label inbound_fsm_inst/wr_busy_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/wr_busy_o
add wave -noupdate -label inbound_fsm_inst/wr_data_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/wr_data_i
add wave -noupdate -label inbound_fsm_inst/wr_en_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/inbound_fsm_inst/wr_en_i
add wave -noupdate -divider us_cmd_fifo
add wave -noupdate -label us_cmd_fifo_inst/data_count /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/data_count
add wave -noupdate -label us_cmd_fifo_inst/din /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/din
add wave -noupdate -label us_cmd_fifo_inst/dout /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/dout
add wave -noupdate -label us_cmd_fifo_inst/empty /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/empty
add wave -noupdate -label us_cmd_fifo_inst/full /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/full
add wave -noupdate -label us_cmd_fifo_inst/prog_full /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/prog_full
add wave -noupdate -label us_cmd_fifo_inst/rd_en /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/rd_en
add wave -noupdate -label us_cmd_fifo_inst/rst /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/rst
add wave -noupdate -label us_cmd_fifo_inst/wr_en /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_inst/wr_en
add wave -noupdate -divider cmd_process
add wave -noupdate -label cmd_process_fsm_inst/cmd_type /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/cmd_type
add wave -noupdate -label cmd_process_fsm_inst/txe_compl_done_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/txe_compl_done_i
add wave -noupdate -label cmd_process_fsm_inst/req_addr_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_addr_o
add wave -noupdate -label cmd_process_fsm_inst/req_attr_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_attr_o
add wave -noupdate -label cmd_process_fsm_inst/req_be_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_be_o
add wave -noupdate -label cmd_process_fsm_inst/req_compl_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_compl_o
add wave -noupdate -label cmd_process_fsm_inst/req_compl_with_data_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_compl_with_data_o
add wave -noupdate -label cmd_process_fsm_inst/req_ep_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_ep_o
add wave -noupdate -label cmd_process_fsm_inst/req_len_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_len_o
add wave -noupdate -label cmd_process_fsm_inst/req_rid_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_rid_o
add wave -noupdate -label cmd_process_fsm_inst/req_tag_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_tag_o
add wave -noupdate -label cmd_process_fsm_inst/req_tc_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_tc_o
add wave -noupdate -label cmd_process_fsm_inst/req_td_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/req_td_o
add wave -noupdate -label cmd_process_fsm_inst/state /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/state
add wave -noupdate -label cmd_process_fsm_inst/state_next /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/state_next
add wave -noupdate -label cmd_process_fsm_inst/up_wr_cmd_compl_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/up_wr_cmd_compl_o
add wave -noupdate -label cmd_process_fsm_inst/us_cmd_fifo_dout_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/us_cmd_fifo_dout_i
add wave -noupdate -label cmd_process_fsm_inst/us_cmd_fifo_empty /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/us_cmd_fifo_empty
add wave -noupdate -label cmd_process_fsm_inst/us_cmd_fifo_rd_en_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_process_fsm_inst/us_cmd_fifo_rd_en_o
add wave -noupdate -divider my_ep_mem_ctrl
add wave -noupdate -label MY_EP_MEM_CTRLEx01/cmd_id_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/cmd_id_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/txe_compl_done_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/txe_compl_done_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/to_rxe_compl_done_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/to_rxe_compl_done_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/rd_addr_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/rd_addr_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/rd_be_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/rd_be_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/rd_data_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/rd_data_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_addr_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_addr_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_addr_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_addr_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_attr_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_attr_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_attr_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_attr_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_be_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_be_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_be_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_be_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_compl_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_compl_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_compl_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_compl_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_compl_with_data_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_compl_with_data_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_compl_with_data_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_compl_with_data_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_ep_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_ep_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_ep_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_ep_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_len_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_len_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_len_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_len_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_rid_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_rid_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_rid_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_rid_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_tag_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_tag_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_tag_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_tag_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_tc_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_tc_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_tc_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_tc_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_td_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_td_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/req_td_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/req_td_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/rx_np_ok /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/rx_np_ok
add wave -noupdate -label MY_EP_MEM_CTRLEx01/up_wr_cmd_compl /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/up_wr_cmd_compl
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_din /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_din
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_dout /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_dout
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_empty /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_empty
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_full /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_full
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_prog_full /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_prog_full
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_rd_en /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_rd_en
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_cmd_fifo_wr_en /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_cmd_fifo_wr_en
add wave -noupdate -label MY_EP_MEM_CTRLEx01/us_fifo_data_count /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/us_fifo_data_count
add wave -noupdate -label MY_EP_MEM_CTRLEx01/wr_addr_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/wr_addr_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/wr_be_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/wr_be_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/wr_busy_o /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/wr_busy_o
add wave -noupdate -label MY_EP_MEM_CTRLEx01/wr_data_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/wr_data_i
add wave -noupdate -label MY_EP_MEM_CTRLEx01/wr_en_i /MY_EP_MEM_CTRL_tb/MY_EP_MEM_CTRLEx01/wr_en_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {258 ns} 0}
configure wave -namecolwidth 296
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
WaveRestoreZoom {0 ns} {620 ns}
