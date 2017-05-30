在 Spartan6 上实现 PCIe IP core
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
