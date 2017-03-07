import serial
import time
ser = serial.Serial()
ser.port = "COM5"
ser.baudrate = 115200
ser.open()
i = 0
crc = 0
start_time = time.time()
loop = 1000 * 100
bytes_per_loop = 10
while i < loop:
    ser.write(b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09')
    crc = (crc + 45) % 256
    i = i + 1
end_time = time.time()
print "elapse time  : %8.2f" % (end_time - start_time)
print "total bytes  : %8d" % (bytes_per_loop * loop)
print "transfer rate: %8d bps" % (bytes_per_loop * loop * 8 / (end_time - start_time))
print "crc          : %8x" % crc
ser.close()
