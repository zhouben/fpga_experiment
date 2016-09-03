onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /i2c_tb/my_ram_inst/addra
add wave -noupdate /i2c_tb/my_ram_inst/clka
add wave -noupdate -radix hexadecimal /i2c_tb/my_ram_inst/dina
add wave -noupdate -radix hexadecimal /i2c_tb/my_ram_inst/douta
add wave -noupdate /i2c_tb/my_ram_inst/ena
add wave -noupdate /i2c_tb/my_ram_inst/wea
add wave -noupdate /i2c_tb/SCL
add wave -noupdate /i2c_tb/SDA
add wave -noupdate /i2c_tb/clock
add wave -noupdate /i2c_tb/master_scl_oen
add wave -noupdate /i2c_tb/master_sda_oen
add wave -noupdate /i2c_tb/reset
add wave -noupdate /i2c_tb/slave_scl_in
add wave -noupdate /i2c_tb/slave_scl_oen
add wave -noupdate /i2c_tb/slave_scl_out
add wave -noupdate /i2c_tb/slave_sda_oen
add wave -noupdate /i2c_tb/slave_sda_out
add wave -noupdate /i2c_tb/slave_write_en
add wave -noupdate /i2c_tb/i2c_slave/busy
add wave -noupdate /i2c_tb/i2c_slave/scl_s
add wave -noupdate /i2c_tb/i2c_slave/scl_ss
add wave -noupdate /i2c_tb/i2c_slave/sda_falling
add wave -noupdate /i2c_tb/i2c_slave/sda_rising
add wave -noupdate /i2c_tb/i2c_slave/sda_s
add wave -noupdate /i2c_tb/i2c_slave/sda_ss
add wave -noupdate -radix hexadecimal /i2c_tb/i2c_slave/state
add wave -noupdate /i2c_tb/i2c_slave/sr
add wave -noupdate /i2c_tb/i2c_slave/scl_falling
add wave -noupdate /i2c_tb/i2c_slave/scl_rising
add wave -noupdate -radix hexadecimal /i2c_tb/i2c_slave/data_in
add wave -noupdate -radix hexadecimal /i2c_tb/i2c_slave/data_out
add wave -noupdate -radix hexadecimal /i2c_tb/i2c_slave/reg_addr
add wave -noupdate -radix hexadecimal /i2c_tb/i2c_slave/sr_send
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {258710 ns} 0}
configure wave -namecolwidth 235
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
WaveRestoreZoom {256674 ns} {270970 ns}
