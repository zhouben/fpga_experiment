import time
import spidev
import RPi.GPIO as g


LCD_CS    = 16
LCD_RESET = 18
LCD_A0    = 22
LCD_W = 128
LCD_H = 160

def test1():
    print "this test1"

def SWITCH_MODE(mode):
    '''
    mode: 0: A0=0 for register, 1: A0=1 for data
    '''
    g.output(LCD_A0, mode)

def LCD_WR_DATA(data):
    '''
    data: 16-bit integer
    '''
    SWITCH_MODE(1)
    spi.writebytes([data >> 8, data])

def LCD_WR_DATA8(data):
    '''
    data: 8-bit integer
    '''
    SWITCH_MODE(1)
    spi.writebytes([data])

def LCD_WR_REG(reg):
    SWITCH_MODE(0)
    spi.writebytes([reg])

def LCD_WR_REG_DATA(reg, data):
    '''
    reg: 8bit integer
    data: 16bit integer
    '''
    LCD_WR_REG(reg)
    LCD_WR_DATA(data)

def lcd_init():
    g.output(LCD_CS   , 1)
    g.output(LCD_RESET, 1)
    time.sleep(0.005)
    g.output(LCD_RESET, 0)
    time.sleep(0.005)
    g.output(LCD_RESET, 1)
    g.output(LCD_CS   , 1)
    time.sleep(0.005)
    g.output(LCD_CS   , 0)
    LCD_WR_REG(0x11)
    time.sleep(0.12)
    #/------------------------------------ST7735S Frame Rate-----------------------------------------
    LCD_WR_REG(0xB1)
    LCD_WR_DATA8(0x05)
    LCD_WR_DATA8(0x3C)
    LCD_WR_DATA8(0x3C)
    LCD_WR_REG(0xB2)
    LCD_WR_DATA8(0x05)
    LCD_WR_DATA8(0x3C)
    LCD_WR_DATA8(0x3C)
    LCD_WR_REG(0xB3)
    LCD_WR_DATA8(0x05)
    LCD_WR_DATA8(0x3C)
    LCD_WR_DATA8(0x3C)
    LCD_WR_DATA8(0x05)
    LCD_WR_DATA8(0x3C)
    LCD_WR_DATA8(0x3C)
    #/------------------------------------End ST7735S Frame Rate-----------------------------------------
    LCD_WR_REG(0xB4); #/Dot inversion
    LCD_WR_DATA8(0x03)
    LCD_WR_REG(0xC0)
    LCD_WR_DATA8(0x28)
    LCD_WR_DATA8(0x08)
    LCD_WR_DATA8(0x04)
    LCD_WR_REG(0xC1)
    LCD_WR_DATA8(0XC0)
    LCD_WR_REG(0xC2)
    LCD_WR_DATA8(0x0D)
    LCD_WR_DATA8(0x00)
    LCD_WR_REG(0xC3)
    LCD_WR_DATA8(0x8D)
    LCD_WR_DATA8(0x2A)
    LCD_WR_REG(0xC4)
    LCD_WR_DATA8(0x8D)
    LCD_WR_DATA8(0xEE)
    #/---------------------------------End ST7735S Power Sequence-------------------------------------
    LCD_WR_REG(0xC5); #/VCOM
    LCD_WR_DATA8(0x1A)
    LCD_WR_REG(0x36); #/MX, MY, RGB mode
    LCD_WR_DATA8(0xC0)
    #/------------------------------------ST7735S Gamma Sequence-----------------------------------------
    LCD_WR_REG(0xE0)
    LCD_WR_DATA8(0x04)
    LCD_WR_DATA8(0x22)
    LCD_WR_DATA8(0x07)
    LCD_WR_DATA8(0x0A)
    LCD_WR_DATA8(0x2E)
    LCD_WR_DATA8(0x30)
    LCD_WR_DATA8(0x25)
    LCD_WR_DATA8(0x2A)
    LCD_WR_DATA8(0x28)
    LCD_WR_DATA8(0x26)
    LCD_WR_DATA8(0x2E)
    LCD_WR_DATA8(0x3A)
    LCD_WR_DATA8(0x00)
    LCD_WR_DATA8(0x01)
    LCD_WR_DATA8(0x03)
    LCD_WR_DATA8(0x13)
    LCD_WR_REG(0xE1)
    LCD_WR_DATA8(0x04)
    LCD_WR_DATA8(0x16)
    LCD_WR_DATA8(0x06)
    LCD_WR_DATA8(0x0D)
    LCD_WR_DATA8(0x2D)
    LCD_WR_DATA8(0x26)
    LCD_WR_DATA8(0x23)
    LCD_WR_DATA8(0x27)
    LCD_WR_DATA8(0x27)
    LCD_WR_DATA8(0x25)
    LCD_WR_DATA8(0x2D)
    LCD_WR_DATA8(0x3B)
    LCD_WR_DATA8(0x00)
    LCD_WR_DATA8(0x01)
    LCD_WR_DATA8(0x04)
    LCD_WR_DATA8(0x13)
    #/------------------------------------End ST7735S Gamma Sequence-----------------------------------------#/
    LCD_WR_REG(0x3A); #/65k mode
    LCD_WR_DATA8(0x05)
    LCD_WR_REG(0x29); #/Display on


def address_set(x1, y1, x2, y2):
   LCD_WR_REG(0x2a);
   LCD_WR_DATA8(x1>>8);
   LCD_WR_DATA8(x1);
   LCD_WR_DATA8(x2>>8);
   LCD_WR_DATA8(x2);
  
   LCD_WR_REG(0x2b);
   LCD_WR_DATA8(y1>>8);
   LCD_WR_DATA8(y1);
   LCD_WR_DATA8(y2>>8);
   LCD_WR_DATA8(y2);

   LCD_WR_REG(0x2C);

def lcd_clear(color):
    vh = color >> 8
    vl = color & 0xFF
    address_set(0, 0, LCD_W-1, LCD_H - 1)
    for i in range(LCD_W):
        for j in range(LCD_H):
            LCD_WR_DATA8(vh)
            LCD_WR_DATA8(vl)

def bus_test():
    '''
    write some data in spi and A0, Reset
    '''
    print "write data..."
    g.output(LCD_A0, 0)
    data = [0x12, 0x55]
    spi.writebytes(data)

    g.output(LCD_A0, 1)
    data = [0xaa, 0xef]
    spi.writebytes(data)

    g.output(LCD_A0, 0)

def bus_init():
    '''
    initialize spi and gpio bus
    BORAD: 18    22
    Func : Rst   A0
    '''
    global spi
    spi = spidev.SpiDev()
    spi.open(0, 0)
    g.setmode(g.BOARD)
    g.setup(LCD_CS, g.OUT)
    g.setup(LCD_RESET, g.OUT)
    g.setup(LCD_A0, g.OUT)

def bus_destroy():
    print("after 3 seconds, spi close")
    time.sleep(3)
    spi.close()

    print("after 3 seconds, gpio cleanup")
    time.sleep(3)
    g.cleanup()


def main():
    test1()
    bus_init()
    # bus_test()
    lcd_init()
    #lcd_clear(0xFFFF)
    lcd_clear(0xffe0)
    bus_destroy()

if __name__ == '__main__':
    main()
