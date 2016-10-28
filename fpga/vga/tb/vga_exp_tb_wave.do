onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_exp_tb/clk
add wave -noupdate /vga_exp_tb/u0/clk
add wave -noupdate /vga_exp_tb/u0/rst_n
add wave -noupdate -radix unsigned /vga_exp_tb/u0/vga_blue
add wave -noupdate -radix unsigned /vga_exp_tb/u0/vga_green
add wave -noupdate -radix binary /vga_exp_tb/u0/vga_hsync
add wave -noupdate -radix unsigned /vga_exp_tb/u0/vga_red
add wave -noupdate -radix binary /vga_exp_tb/u0/vga_vsync
add wave -noupdate /vga_exp_tb/u0/clk_gen_65m/clkfb
add wave -noupdate -radix unsigned /vga_exp_tb/u0/vga_ctrl/x_cnt
add wave -noupdate -radix unsigned /vga_exp_tb/u0/vga_ctrl/y_cnt
add wave -noupdate -radix hexadecimal -childformat {{{/vga_exp_tb/u0/slogan_rom/addra[12]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[11]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[10]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[9]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[8]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[7]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[6]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[5]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[4]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[3]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[2]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[1]} -radix hexadecimal} {{/vga_exp_tb/u0/slogan_rom/addra[0]} -radix hexadecimal}} -subitemconfig {{/vga_exp_tb/u0/slogan_rom/addra[12]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[11]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[10]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[9]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[8]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[7]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[6]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[5]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[4]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[3]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[2]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[1]} {-height 15 -radix hexadecimal} {/vga_exp_tb/u0/slogan_rom/addra[0]} {-height 15 -radix hexadecimal}} /vga_exp_tb/u0/slogan_rom/addra
add wave -noupdate -radix hexadecimal /vga_exp_tb/u0/slogan_rom/douta
add wave -noupdate -radix hexadecimal /vga_exp_tb/u0/pos
add wave -noupdate -radix hexadecimal /vga_exp_tb/u0/pos_next
add wave -noupdate /vga_exp_tb/u0/frame_sync
add wave -noupdate /vga_exp_tb/u0/pixel_init
add wave -noupdate -radix hexadecimal /vga_exp_tb/u0/pixel_value
add wave -noupdate -radix hexadecimal /vga_exp_tb/u0/pixel
add wave -noupdate -radix hexadecimal -childformat {{{/vga_exp_tb/u0/rom_x_pos[9]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[8]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[7]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[6]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[5]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[4]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[3]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[2]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[1]} -radix hexadecimal} {{/vga_exp_tb/u0/rom_x_pos[0]} -radix hexadecimal}} -expand -subitemconfig {{/vga_exp_tb/u0/rom_x_pos[9]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[8]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[7]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[6]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[5]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[4]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[3]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[2]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[1]} {-radix hexadecimal} {/vga_exp_tb/u0/rom_x_pos[0]} {-radix hexadecimal}} /vga_exp_tb/u0/rom_x_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11000341134 ps} 0} {{Cursor 2} {1811698846 ps} 0}
configure wave -namecolwidth 221
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
WaveRestoreZoom {1778989143 ps} {1801548887 ps}
