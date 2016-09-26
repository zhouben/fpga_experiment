onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /oled_tb/SCL
add wave -noupdate /oled_tb/SDA
add wave -noupdate /oled_tb/u_oled/busy
add wave -noupdate /oled_tb/u_oled/clk
add wave -noupdate /oled_tb/u_oled/init_rising
add wave -noupdate /oled_tb/u_oled/reset
add wave -noupdate /oled_tb/u_oled/init_rising
add wave -noupdate /oled_tb/u_oled/i2c_ctrl_state
add wave -noupdate /oled_tb/u_oled/i2c_ctrl_state_next
add wave -noupdate /oled_tb/u_oled/disp_mode
add wave -noupdate /oled_tb/u_oled/oled_disp/i2c_write_en
add wave -noupdate -radix decimal /oled_tb/u_oled/oled_disp/sleep_cnt
add wave -noupdate /oled_tb/u_oled/oled_disp_done
add wave -noupdate /oled_tb/u_oled/oled_disp_start
add wave -noupdate /oled_tb/u_oled/oled_disp/i2c_done
add wave -noupdate /oled_tb/u_oled/oled_disp/sleep_cnt
add wave -noupdate -radix unsigned /oled_tb/u_oled/oled_disp/state
add wave -noupdate -radix ascii /oled_tb/u_oled/oled_init/state_ascii
add wave -noupdate /oled_tb/u_oled/oled_init_done
add wave -noupdate /oled_tb/u_oled/oled_init_reg_addr
add wave -noupdate /oled_tb/u_oled/oled_init_reg_data
add wave -noupdate /oled_tb/u_oled/oled_init_start
add wave -noupdate /oled_tb/u_oled/oled_init_write_i2c_en
add wave -noupdate -radix decimal /oled_tb/u_oled/i2c_master/clk_count
add wave -noupdate -radix hexadecimal -childformat {{{/oled_tb/u_oled/i2c_master/data_in[7]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[6]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[5]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[4]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[3]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[2]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[1]} -radix hexadecimal} {{/oled_tb/u_oled/i2c_master/data_in[0]} -radix hexadecimal}} -subitemconfig {{/oled_tb/u_oled/i2c_master/data_in[7]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[6]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[5]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[4]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[3]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[2]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[1]} {-height 15 -radix hexadecimal} {/oled_tb/u_oled/i2c_master/data_in[0]} {-height 15 -radix hexadecimal}} /oled_tb/u_oled/i2c_master/data_in
add wave -noupdate /oled_tb/u_oled/i2c_master/done
add wave -noupdate /oled_tb/u_oled/i2c_master/in_prog
add wave -noupdate /oled_tb/u_oled/i2c_master/scl_oen
add wave -noupdate /oled_tb/u_oled/i2c_master/scl_out
add wave -noupdate /oled_tb/u_oled/i2c_master/sda_oen
add wave -noupdate /oled_tb/u_oled/i2c_master/sda_out
add wave -noupdate -radix unsigned /oled_tb/u_oled/i2c_master/state
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/i2c_master/scl_count
add wave -noupdate -radix binary /oled_tb/u_oled/i2c_master/sr
add wave -noupdate -radix decimal /oled_tb/u_oled/i2c_master/sr_count
add wave -noupdate /oled_tb/i2c_slave/data_out
add wave -noupdate /oled_tb/i2c_slave/sda_falling
add wave -noupdate /oled_tb/i2c_slave/sr
add wave -noupdate -radix unsigned /oled_tb/i2c_slave/state
add wave -noupdate /oled_tb/i2c_slave/write_en
add wave -noupdate /oled_tb/i2c_slave/writing
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/din
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/disp_cnt
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/disp_data
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_disp/disp_done
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_disp/disp_start
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_disp/done
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/dot_matrix_data
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_disp/is_sequential
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/ram_data
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/ram_idx
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/ram_recv_idx
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_disp/rst_n
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/state
add wave -noupdate -radix ascii /oled_tb/u_oled/oled_dot_matrix_disp/state_ascii
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_done
add wave -noupdate /oled_tb/u_oled/oled_dot_matrix_i2c_wen
add wave -noupdate /oled_tb/u_oled/i2c_write_en
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/oled_disp_v2/reg_addr
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/oled_disp_v2/reg_data
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/oled_disp_v2/x
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/oled_disp_v2/y
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/oled_dot_matrix_disp/oled_disp_v2/pos
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
