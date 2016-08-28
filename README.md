#Mars6Sample

PCIe transfer experiment on MARS6 FPGA.

1. implement marquee for LED0~4, press sw key to reset.
1. i2c slave, address 0x29, receive 2 bytes (16 bits)
    1. host side: Raspberry Pi 3 run ``i2cset -y 1 0x29 0x12 0x34`` to write 0x12 0x34 to FPGA
1. add icon, ila and vio for debug.
