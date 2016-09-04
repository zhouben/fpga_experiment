import smbus
import time
'''
draw several image on oled
this script should be called after initialized
'''
bus = smbus.SMBus(1)
chip_addr = 0x3C
cmd_addr = 0x00
data_addr = 0x40

time.sleep(1)
# clear all pixels
x = 0
for i in range(0xb0, 0xb8):
	bus.write_byte_data(chip_addr, cmd_addr, i)
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0xF0)>> 4 | 0x10))
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0x0F)     | 0x00))
	for n in range(0, 128):
		bus.write_byte_data(chip_addr, data_addr, 0x00)
# draw line
time.sleep(1)
x = 0
for i in range(0xb0, 0xb8):
	bus.write_byte_data(chip_addr, cmd_addr, i)
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0xF0)>> 4 | 0x10))
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0x0F)     | 0x00))
	for n in range(0, 128):
		bus.write_byte_data(chip_addr, data_addr, 0x01)
		
time.sleep(1)
# clear all pixels
x = 0
for i in range(0xb0, 0xb8):
	bus.write_byte_data(chip_addr, cmd_addr, i)
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0xF0)>> 4 | 0x10))
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0x0F)     | 0x00))
	for n in range(0, 128):
		bus.write_byte_data(chip_addr, data_addr, 0x00)

time.sleep(1)
x = 0
for i in range(0xb0, 0xb8):
	bus.write_byte_data(chip_addr, cmd_addr, i)
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0xF0)>> 4 | 0x10))
	bus.write_byte_data(chip_addr, cmd_addr, ((x & 0x0F)     | 0x00))
	for n in range(0, 128):
		bus.write_byte_data(chip_addr, data_addr, 0xFF if (((n >> 3) & 1) ^ (i & 1)) else 0x00)
