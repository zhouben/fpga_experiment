onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /oled_tb/SCL
add wave -noupdate /oled_tb/SDA
add wave -noupdate /oled_tb/u_oled/busy
add wave -noupdate /oled_tb/u_oled/clk
add wave -noupdate /oled_tb/u_oled/config_reg_addr
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/config_reg_data
add wave -noupdate /oled_tb/u_oled/config_reg_read_en
add wave -noupdate /oled_tb/u_oled/i2c_master_done
add wave -noupdate /oled_tb/u_oled/init_rising
add wave -noupdate /oled_tb/u_oled/oled_complete
add wave -noupdate /oled_tb/u_oled/reset
add wave -noupdate -radix decimal /oled_tb/u_oled/state
add wave -noupdate -radix unsigned /oled_tb/u_oled/state_next
add wave -noupdate -radix decimal /oled_tb/u_oled/i2c_master/clk_count
add wave -noupdate -radix hexadecimal /oled_tb/u_oled/i2c_master/data_in
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {470 ns} 0}
configure wave -namecolwidth 325
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
WaveRestoreZoom {0 ns} {13178 ns}
