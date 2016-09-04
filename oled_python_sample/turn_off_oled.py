import smbus
bus = smbus.SMBus(1)
chip_addr = 0x3C
cmd_addr = 0x00
data_addr = 0x40

# turn off display
bus.write_byte_data(chip_addr, cmd_addr, 0x8D)
bus.write_byte_data(chip_addr, cmd_addr, 0x10)
bus.write_byte_data(chip_addr, cmd_addr, 0xAE)
