onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {SYS Interface}
add wave -noupdate /board/EP/sys_clk_c
add wave -noupdate /board/EP/sys_reset_n_c
add wave -noupdate -divider {AXI Common}
add wave -noupdate /board/EP/user_clk
add wave -noupdate /board/EP/user_reset
add wave -noupdate /board/EP/user_lnk_up
add wave -noupdate /board/EP/fc_sel
add wave -noupdate /board/EP/fc_cpld
add wave -noupdate /board/EP/fc_cplh
add wave -noupdate /board/EP/fc_npd
add wave -noupdate /board/EP/fc_nph
add wave -noupdate /board/EP/fc_pd
add wave -noupdate /board/EP/fc_ph
add wave -noupdate -divider {AXI Rx}
add wave -noupdate -radix hexadecimal /board/EP/m_axis_rx_tdata
add wave -noupdate /board/EP/m_axis_rx_tready
add wave -noupdate /board/EP/m_axis_rx_tvalid
add wave -noupdate /board/EP/m_axis_rx_tlast
add wave -noupdate /board/EP/m_axis_rx_tuser
add wave -noupdate /board/EP/rx_np_ok
add wave -noupdate -divider {AXI Tx}
add wave -noupdate -radix unsigned /board/EP/app/PIO/PIO_EP/EP_TX/state
add wave -noupdate -radix hexadecimal /board/EP/s_axis_tx_tdata
add wave -noupdate /board/EP/s_axis_tx_tready
add wave -noupdate /board/EP/s_axis_tx_tvalid
add wave -noupdate /board/EP/s_axis_tx_tlast
add wave -noupdate /board/EP/s_axis_tx_tuser
add wave -noupdate /board/EP/tx_buf_av
add wave -noupdate /board/EP/tx_err_drop
add wave -noupdate /board/EP/tx_cfg_req
add wave -noupdate /board/EP/tx_cfg_gnt
add wave -noupdate -radix unsigned /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_count
add wave -noupdate -radix unsigned /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_count_next
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_data_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_host_mem_addr_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_local_mem_addr_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_TX/up_wr_req_i
add wave -noupdate -divider inbound
add wave -noupdate -radix unsigned /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/inbound_state
add wave -noupdate -radix ascii /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/inbound_state_ascii
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/addr_0
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/addr_1
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/clk
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/cmd
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/cmd_id
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/cmd_id_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/cmd_next
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/host_addr_to_write
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/inbound_state_next
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/len
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/rd_addr_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/rd_be_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/rd_data_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_addr_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_attr_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_be_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_compl_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_compl_with_data_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_d
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_ep_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_len_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_rid_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_tag_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_tc_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/req_td_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/state
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/state_next
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/to_rxe_compl_done_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/up_wr_cmd_compl_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_din_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_empty
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_full_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_prog_full
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_prog_full_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_fifo_wr_en_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/us_cmd_type
add wave -noupdate -radix hexadecimal -childformat {{{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[10]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[9]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[8]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[7]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[6]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[5]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[4]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[3]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[2]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[1]} -radix hexadecimal} {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[0]} -radix hexadecimal}} -subitemconfig {{/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[10]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[9]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[8]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[7]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[6]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[5]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[4]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[3]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[2]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[1]} {-height 15 -radix hexadecimal} {/board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i[0]} {-height 15 -radix hexadecimal}} /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_addr_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_be_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_busy_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_data_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/inbound_fsm_inst/wr_en_i
add wave -noupdate -divider cmd_process
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/cmd_type
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/req_addr_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/state
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/state_next
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/txe_compl_done_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/up_wr_cmd_compl_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/us_cmd_fifo_dout_i
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/us_cmd_fifo_empty
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/us_cmd_fifo_rd_en_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/up_wr_cmd_compl_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/up_wr_host_mem_addr_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/up_wr_local_mem_addr_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_MEM/cmd_process_fsm_inst/up_wr_req_o
add wave -noupdate -divider rx_usrapp
add wave -noupdate /board/RP/rx_usrapp/trn_clk
add wave -noupdate /board/RP/rx_usrapp/trn_lnk_up_n
add wave -noupdate /board/RP/rx_usrapp/trn_rbar_hit_n
add wave -noupdate /board/RP/rx_usrapp/trn_rd
add wave -noupdate /board/RP/rx_usrapp/trn_rdst_rdy_n
add wave -noupdate /board/RP/rx_usrapp/trn_rdst_rdy_toggle_count
add wave -noupdate /board/RP/rx_usrapp/trn_reof_n
add wave -noupdate /board/RP/rx_usrapp/trn_rerrfwd_n
add wave -noupdate /board/RP/rx_usrapp/trn_reset_n
add wave -noupdate /board/RP/rx_usrapp/trn_rnp_ok_n
add wave -noupdate /board/RP/rx_usrapp/trn_rnp_ok_toggle_count
add wave -noupdate /board/RP/rx_usrapp/trn_rrem_n
add wave -noupdate /board/RP/rx_usrapp/trn_rsof_n
add wave -noupdate /board/RP/rx_usrapp/trn_rsrc_dsc_n
add wave -noupdate /board/RP/rx_usrapp/trn_rsrc_rdy_n
add wave -noupdate /board/RP/rx_usrapp/trn_rx_in_channel
add wave -noupdate /board/RP/rx_usrapp/trn_rx_in_frame
add wave -noupdate /board/RP/rx_usrapp/trn_rx_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68135102000 fs} 0} {{Cursor 2} {40559659310 fs} 0}
configure wave -namecolwidth 243
configure wave -valuecolwidth 61
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 fs} {78570603300 fs}
