在 Spartan6 上实现 PCIe IP core
1. PCIe upstream Wr32 传输基本128bytes，2 cmd，FPGA测试通过。
 1. offset  0: cmd, bit0 cmd0, bit1 cmd1
 1. offset  8: state, 1 busy, 0 idle
 1. offset 16: address 0
 1. offset 24: address 1
1. Run ``python smoke_test.py -1`` 测试所有的测试用例
1. 读写Device Registers
1. 运行 tb/smoke\_test.py 可以自动运行所有的tb
1. TB for inbound\_fsm
 1. Write register ADDR\_0 tb passed
 1. Read register ADD\_0 tb passed
 1. Write CMD register with two commands and then complet those, passed.
1. TB for us\_cmd\_fifo
 1. simple test for write and read item to/from us\_cmd\_fifo
1. TB for pcie
 1. write ADDR0 and read back using original PCIe modules.
 1. 多笔 write CMD and initiate upstream Wr32 transfer. 原有的tb验证通过。
