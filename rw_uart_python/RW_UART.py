import serial
import time
import zlib
ser = serial.Serial()
ser.port = "COM5"
ser.baudrate = 115200
ser.open()

i = 0
crc = 0
loop = 1000 * 10
bytes_per_loop = 10
data = b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09'

start_time = time.time()
while i < loop:
    ser.write(data)
    crc = zlib.crc32(data, crc)
    i = i + 1
end_time = time.time()
print "elapse time  : %8.2f" % (end_time - start_time)
print "total bytes  : %8d (0x%X)" % (bytes_per_loop * loop, bytes_per_loop * loop )
print "transfer rate: %8d bps" % (bytes_per_loop * loop * 8 / (end_time - start_time))
print "crc          : %8x" % crc
ser.close()
