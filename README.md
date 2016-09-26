#Mars6Sample

PCIe transfer experiment on MARS6 FPGA.

1. implement marquee for LED0~4, press sw key to reset.
1. i2c slave, address 0x29, receive 2 bytes (16 bits)
    1. host side: Raspberry Pi 3 run ``i2cset -y 1 0x29 0x12 0x34`` to write 0x12 0x34 to FPGA
1. add icon, ila and vio for debug.
1. implement I2C slave on FPGA and communicate, as a memory I2C slave, with Raspberry Pi, Read/Write ok.
1. add python scripts to control OLED display. Work well on Raspberry Pi.
1. configure OLED display by I2C passed on test bench.
1. switch display mode, all black/white, interlace/reverse interlace.
1. add debounce module for avoiding button debounce on display mode switch.
1. add md5sum module and testbench for modulesim.
1. add sh1sum module and testbench for modulesim.
1. add oled dot matrix display module, just passed modelsim test parially.
