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
1. add python scripts to control 1.8" TFT display. Work well on Raspberry Pi.
1. demonstrate how to use PLL\_BASE primitive to generate multiple clock.
1. add demo project ddr\_demo to show how to use ddr3 mig, modelsim passed.
1. add seven segment display module and test bench, passed in Alinx platform.
1. add an experiment(sdram\_top\_exp) to read/write sdram by sdram\_top.
    1. improve sdram\_model.v for test bench with the maximum of 64k WORDs.
    1. fpga/sdram\_top\_exp.xise is the project file.
    1. fpga/sdram\_ip/tb is the test bench for sdram\_top
1. add an interface(sdram\_mcb) and related test bench.
    1. sdram\_mcb\_tb.do is the script to test sdram\_mcb mod
    1. improve sdram\_model to meet writing at the last several WORDs every row.
1. add automatic test script (python version) for sdram\_top and sdram\_mcb modules.
1. add VGA display module, display RGB and France National Flag
1. add crc module and testbench.
1. add sdram\_vga display experiment. The data to display is written into sdram and then VGA module reads it to display.
    1. entry: sdram\_vga\_exp.v
1. add picoblaze\_uart\_7seg, receive data from uart and display byte count and crc via 7-segments. Send crc to host once "STOP" detected. Integrate picoblaze soft core to accomplish it. 
    1. Add uart receive and crc32 test. Receiving data by 115200,8N1 pass on FPGA platform
    1. Add python script to send data via UART.
    1. Send crc32 value to host once the magic number "STOP" being detected.

