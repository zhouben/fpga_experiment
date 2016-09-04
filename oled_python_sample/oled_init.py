import smbus
'''
initialize oled display
'''
bus = smbus.SMBus(1)
chip_addr = 0x3C
cmd_addr = 0x00
data_addr = 0x40

bus.write_byte_data(chip_addr, cmd_addr, 0xAE)
bus.write_byte_data(chip_addr, cmd_addr, 0x00)
bus.write_byte_data(chip_addr, cmd_addr, 0x10)
bus.write_byte_data(chip_addr, cmd_addr, 0x40)
bus.write_byte_data(chip_addr, cmd_addr, 0x81)
bus.write_byte_data(chip_addr, cmd_addr, 0xCF)
bus.write_byte_data(chip_addr, cmd_addr, 0xA1)
bus.write_byte_data(chip_addr, cmd_addr, 0xC8)
bus.write_byte_data(chip_addr, cmd_addr, 0xA6)
bus.write_byte_data(chip_addr, cmd_addr, 0xA8)
bus.write_byte_data(chip_addr, cmd_addr, 0x3f)
bus.write_byte_data(chip_addr, cmd_addr, 0xD3)
bus.write_byte_data(chip_addr, cmd_addr, 0x00)
bus.write_byte_data(chip_addr, cmd_addr, 0xd5)
bus.write_byte_data(chip_addr, cmd_addr, 0x80)
bus.write_byte_data(chip_addr, cmd_addr, 0xD9)
bus.write_byte_data(chip_addr, cmd_addr, 0xF1)
bus.write_byte_data(chip_addr, cmd_addr, 0xDA)
bus.write_byte_data(chip_addr, cmd_addr, 0x12)
bus.write_byte_data(chip_addr, cmd_addr, 0xDB)
bus.write_byte_data(chip_addr, cmd_addr, 0x40)
bus.write_byte_data(chip_addr, cmd_addr, 0x20)
bus.write_byte_data(chip_addr, cmd_addr, 0x02)
bus.write_byte_data(chip_addr, cmd_addr, 0x8D)
bus.write_byte_data(chip_addr, cmd_addr, 0x14)
bus.write_byte_data(chip_addr, cmd_addr, 0xA4)
bus.write_byte_data(chip_addr, cmd_addr, 0xA6)
bus.write_byte_data(chip_addr, cmd_addr, 0xAF)

