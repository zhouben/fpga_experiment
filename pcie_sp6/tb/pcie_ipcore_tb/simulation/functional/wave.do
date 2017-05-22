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
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_RX/wr_addr_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_RX/wr_be_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_RX/wr_busy_i
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_RX/wr_data_o
add wave -noupdate /board/EP/app/PIO/PIO_EP/EP_RX/wr_en_o
add wave -noupdate -divider {AXI Tx}
add wave -noupdate -radix hexadecimal /board/EP/s_axis_tx_tdata
add wave -noupdate /board/EP/s_axis_tx_tready
add wave -noupdate /board/EP/s_axis_tx_tvalid
add wave -noupdate /board/EP/s_axis_tx_tlast
add wave -noupdate /board/EP/s_axis_tx_tuser
add wave -noupdate /board/EP/tx_buf_av
add wave -noupdate /board/EP/tx_err_drop
add wave -noupdate /board/EP/tx_cfg_req
add wave -noupdate /board/EP/tx_cfg_gnt
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/rd_addr_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/rd_be_o
add wave -noupdate -radix hexadecimal /board/EP/app/PIO/PIO_EP/EP_TX/rd_data_i
add wave -noupdate -divider MyMemCtrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {70779340190 fs} 0} {{Cursor 2} {68094168680 fs} 0}
configure wave -namecolwidth 193
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
WaveRestoreZoom {67811534370 fs} {68102159390 fs}
