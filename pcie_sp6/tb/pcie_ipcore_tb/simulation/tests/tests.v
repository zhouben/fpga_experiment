//-----------------------------------------------------------------------------
//
// (c) Copyright 2009 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Spartan-6 Integrated Block for PCI Express
// File       : tests.v
//-----------------------------------------------------------------------------

`timescale 1ns/1ps


module tests ();

reg [255:0] testname;
integer test_vars [31:0];
integer ii;
reg [7:0] expect_cpld_payload [4095:0];
reg [7:0] expect_msgd_payload [4095:0];
reg [7:0] expect_memwr_payload [4095:0];
reg [7:0] expect_memwr64_payload [4095:0];
reg [7:0] expect_cfgwr_payload [3:0];
reg expect_status;
reg expect_finish_check;
reg status;

/**
* Write registers in MMIO space, like addr0, addr1, cmd, len.
*
* @param value the value of register.
* @offset offset for register in MMIO space, in units of bytes.
*/
task WriteMMIO;
    input [7:0] offset;
    input [31:0] value;

    begin
        $display("[%t] Write MMIO %8x@%3d", $realtime, value, offset);
        board.RP.tx_usrapp.DATA_STORE[3] = value[31:24];
        board.RP.tx_usrapp.DATA_STORE[2] = value[23:16];
        board.RP.tx_usrapp.DATA_STORE[1] = value[15:8 ];
        board.RP.tx_usrapp.DATA_STORE[0] = value[ 7:0 ];

        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(
            board.RP.tx_usrapp.DEFAULT_TAG,
            board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
            board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+offset, 4'h0, 4'hF, 1'b0
        );
    end
endtask

/**
* Read register value in MMIO space
*
* @param offset offset in MMIO space.
* @param expect_value the expected value of the register.
*/
task ReadMMIO;
    input [7:0] offset;
    input [31:0] expect_value;
    begin
        $display("[%t] Read  MMIO register @%3d, expected %8x", $realtime,  offset, expect_value);
        board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
        board.RP.tx_usrapp.DATA_STORE[0] = expect_value[31:24];
        board.RP.tx_usrapp.DATA_STORE[1] = expect_value[23:16];
        board.RP.tx_usrapp.DATA_STORE[2] = expect_value[15:8];
        board.RP.tx_usrapp.DATA_STORE[3] = expect_value[7:0];
        fork
            board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG,
                board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
            board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0] + offset, 4'h0, 4'hF);
            board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
        join
        if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[0],
            board.RP.tx_usrapp.DATA_STORE[1], board.RP.tx_usrapp.DATA_STORE[2],
        board.RP.tx_usrapp.DATA_STORE[3] })
        begin
            $display("[%t] : ReadMMIO FAILED --- Register %8x : expected Data %x != actually Read Data %x",
                $realtime, offset,
                {board.RP.tx_usrapp.DATA_STORE[0],board.RP.tx_usrapp.DATA_STORE[1],
                board.RP.tx_usrapp.DATA_STORE[2],board.RP.tx_usrapp.DATA_STORE[3]},
            board.RP.tx_usrapp.P_READ_DATA);

        end else begin
            $display("[%t] : ReadMMIO PASSED --- Read Data: %x@%4d successfully received",
            $realtime, board.RP.tx_usrapp.P_READ_DATA, offset);
        end
    end
endtask


/**
* initiate a signle transfer
*/
task INITIATE_SINGLE_XFER;
    begin
        $display("[%t] : try to set command register", $realtime );
        WriteMMIO(8'h0, 32'd1);
        $display("[%t] : set command completely!", $realtime );

        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        // Wait until endpoint completes UP MemWr
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(2000);

        //--------------------------------------------------------------------------
        // Read XferLen Register
        //--------------------------------------------------------------------------

        board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
        // Expected value
        board.RP.tx_usrapp.DATA_STORE[0] = 8'h02;
        board.RP.tx_usrapp.DATA_STORE[1] = 8'h00;
        board.RP.tx_usrapp.DATA_STORE[2] = 8'h00;
        board.RP.tx_usrapp.DATA_STORE[3] = 8'h00;

        fork
            $display("[%t] : begin to read command register ", $realtime );
            board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(
                board.RP.tx_usrapp.DEFAULT_TAG,
                board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
                board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h0, 4'h0, 4'hF
            );
            $display("[%t] : start waiting for read data!", $realtime);
            board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
    join
    if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[3],
        board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
        board.RP.tx_usrapp.DATA_STORE[0] })
    begin
        $display(
            "[%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
            $realtime, {board.RP.tx_usrapp.DATA_STORE[3],board.RP.tx_usrapp.DATA_STORE[2],
            board.RP.tx_usrapp.DATA_STORE[1],board.RP.tx_usrapp.DATA_STORE[0]},
            board.RP.tx_usrapp.P_READ_DATA
        );

    end
    else
    begin
        $display(
            "[%t] : Test PASSED --- Read Cmd Data: %x successfully received",
            $realtime, board.RP.tx_usrapp.P_READ_DATA
        );
    end
end
endtask

reg mem_clk;
reg [9:0]  mem_addr;
wire [31:0] mem_dout;

LOCAL_MEM_FAKE LOCAL_MEMEx01
(
	.clk 	(	mem_clk 	),
	.we  	(	        	),
	.addr	(	mem_addr	),
	.din 	(	        	),
	.dout	(	mem_dout	)
) ;

/**
* clean expect_memwr_payload by input parameter len.
*/
task tsk_zero_expected_data;
    input [7:0] len; // in units of DWORD
    integer i;
    begin
        for(i = 0; i < len; i = i + 1)
        begin
            expect_memwr_payload[i * 4 + 0] = 0;
            expect_memwr_payload[i * 4 + 1] = 0;
            expect_memwr_payload[i * 4 + 2] = 0;
            expect_memwr_payload[i * 4 + 3] = 0;
        end
    end
endtask

/**
* initiate expect_memwr_payload with LOCAL_MEM module by input param len, in units of DWORD
*/
task tsk_init_expected_data;
    input [7:0] len;  // in units of DWORD
    integer i;
    begin
        mem_clk = 0;
        fork
            repeat (len * 2 + 4) #2 mem_clk = ~mem_clk;
            begin
                mem_addr = 0; @(posedge mem_clk);
                i = 0;
                for(i = 0; i < len; i = i + 1)
                begin
                    mem_addr = mem_addr + 1;
                    @(posedge mem_clk);
                    expect_memwr_payload[i * 4 + 0] = mem_dout[31:24];
                    expect_memwr_payload[i * 4 + 1] = mem_dout[23:16];
                    expect_memwr_payload[i * 4 + 2] = mem_dout[15:8];
                    expect_memwr_payload[i * 4 + 3] = mem_dout[7:0];
                end
            end
        join
    end
endtask
/**
* expect 128 bytes from LOCAL_MEM module
*
* @return expect_status 1: success, 0: failed
*/
task tsk_check_upstream_wr32;
    input [31:0] host_addr;
    integer expect_status;
    begin
        $display("[%t] : wait for MemWr32 to host_addr %8x...", $realtime, host_addr);

        board.RP.com_usrapp.TSK_EXPECT_MEMWR(
            0, 0, 0, 0,
            10'd32, // length, in units of DWs
            15'h1a0, // requester id
            0,  // tag
            4'b1111, 4'b1111, 
            (host_addr >> 2),
            expect_status
        );
        $display("[%t] : MemWr32 complete status %s (%1d)", $realtime, (expect_status == 1) ? "PASSED" : "FAILED", expect_status);
    end
endtask

`define CMD_MAX_NUM 2
task pio_up_wr_test0;
    integer host_addr[`CMD_MAX_NUM -1:0];
    integer i;
    integer cmd_bitmap;
    begin
        tsk_zero_expected_data(32);
        tsk_init_expected_data(32);

        /* This test performs a 32 bit write to a 32 bit Memory space and performs a read back */
        board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(10050);
        board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
        board.RP.tx_usrapp.TSK_BAR_INIT;

        /**
        * Direct Root Port to allow upstream traffic by enabling Mem, I/O and
        * BusMstr in the command register
        */
        board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
        board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h00000001, 32'h00000007, 4'b1110);
        board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);

        for (board.RP.tx_usrapp.ii = 0; board.RP.tx_usrapp.ii <= 6; board.RP.tx_usrapp.ii = board.RP.tx_usrapp.ii + 1)
        begin
            if (board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii] > 2'b00) // bar is enabled
            begin
                case(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii])
                    2'b01 : // IO SPACE
                    begin
                        $display("[%t] : Do nothing for Transmitting TLPs to IO Space BAR %x", $realtime, board.RP.tx_usrapp.ii);

                    end

                    2'b10 : // MEM 32 SPACE
                    begin

                        $display("[%t] : Transmitting TLPs to Memory 32 Space BAR %x", $realtime, board.RP.tx_usrapp.ii);
                        host_addr[0] = 32'h7698CA00;
                        host_addr[1] = 32'h602CE400;
                        cmd_bitmap = 0;
                        for (i = 0; i < `CMD_MAX_NUM; i = i + 1)
                        begin
                            cmd_bitmap = cmd_bitmap | (1 << i);
                            host_addr[i] = $random << 2;
                        end

                        /* write ADDR 0 by 0x7698CA00*/
                        WriteMMIO(8'h10, host_addr[0]);
                        //board.RP.tx_usrapp.TSK_TX_CLK_EAT(50);
                        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                        ReadMMIO(8'h10, host_addr[0]);
                        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                        for (i = 0; i < `CMD_MAX_NUM; i = i + 1)
                        begin
                            WriteMMIO(8'h10 + i * 8, host_addr[i]);
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                            WriteMMIO(8'h0, (1 << i));
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                            tsk_check_upstream_wr32(host_addr[i]);
                            ReadMMIO(8'h8, 32'h00);
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                        end

                        /* Initiate all cmds in one time*/
                        WriteMMIO(8'h0, cmd_bitmap);
                        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                        for(i = 0; i < `CMD_MAX_NUM; i = i + 1)
                        begin
                            tsk_check_upstream_wr32(host_addr[i]);
                        end
                        /* Read State register, should be all 0.*/
                        ReadMMIO(8'h8, 32'h00);
                        //board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
                        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                        host_addr[0] = 32'h70004000;
                        host_addr[1] = 32'hC123B500;
                        for (i = 0; i < 2; i = i + 1)
                        begin
                            WriteMMIO(8'h10 + i * 8, host_addr[i]);
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                            WriteMMIO(8'h0, (1 << i));
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                            tsk_check_upstream_wr32(host_addr[i]);
                            ReadMMIO(8'h8, 32'h00);
                            board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
                        end

                    end
                    2'b11 : // MEM 64 SPACE
                    begin

                        $display("[%t] : Do nothing for Transmitting TLPs to Memory 64 Space BAR %x", $realtime, board.RP.tx_usrapp.ii);
                    end
                    default : $display("Error case in usrapp_tx\n");
                endcase
            end

            $display("[%t] : Finished transmission of PCI-Express TLPs", $realtime);
            $finish(0);
        end
    end
endtask

initial begin
    if ($value$plusargs("TESTNAME=%s", testname))
        $display("Running test {%0s}......", testname);
    else
    begin
      // $display("[%t] %m: No TESTNAME specified!", $realtime);
      // $finish(2);
      testname = "pio_writeReadBack_test0";
      $display("Running default test {%0s}......", testname);
    end
    expect_status = 0;
    expect_finish_check = 0;

    // Payload data initialization.
    board.RP.tx_usrapp.TSK_USR_DATA_SETUP_SEQ;

    //Test starts here
    if (testname == "dummy_test")
    begin
      $display("[%t] %m: Invalid TESTNAME: %0s", $realtime, testname);
      $finish(2);
    end
else if(testname == "pio_up_wr_test0")
begin
    $display("[%t] ready to pio_up_wr_test0", $realtime);
    pio_up_wr_test0;
    $display("[%t] pio_up_wr_test0 PASSED", $realtime);
    $finish(0);
end
  else if(testname == "sample_smoke_test0")
  begin


      board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(5050);

      //System Initialization
      board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;

  



      $display("[%t] : Expected Device/Vendor ID = %x", $realtime, board.RP.tx_usrapp.DEV_VEN_ID);

      //--------------------------------------------------------------------------
      // Read core configuration space via PCIe fabric interface
      //--------------------------------------------------------------------------

      $display("[%t] : Reading from PCI/PCI-Express Configuration Register 0x00", $realtime);

      board.RP.tx_usrapp.TSK_TX_TYPE0_CONFIGURATION_READ(board.RP.tx_usrapp.DEFAULT_TAG, 12'h0, 4'hF);
      board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
      if  (board.RP.tx_usrapp.P_READ_DATA != board.RP.tx_usrapp.DEV_VEN_ID) begin
          $display("[%t] : TEST FAILED --- Data Error Mismatch, Write Data %x != Read Data %x", $realtime,
                                      board.RP.tx_usrapp.DEV_VEN_ID, board.RP.tx_usrapp.P_READ_DATA);
      end
      else begin
          $display("[%t] : TEST PASSED --- Device/Vendor ID %x successfully received", $realtime, board.RP.tx_usrapp.P_READ_DATA);
      end

      //--------------------------------------------------------------------------
      // Direct Root Port to allow upstream traffic by enabling Mem, I/O and
      // BusMstr in the command register
      //--------------------------------------------------------------------------
      board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
      board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h00000001, 32'h00000007, 4'b1110);
      board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);

      expect_finish_check = 1;

    $finish;
  end


else if(testname == "pio_tlp_test0")
begin
    board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(10050);

    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;

    board.RP.tx_usrapp.TSK_BAR_INIT;

//--------------------------------------------------------------------------
//        Testing each BAR specific to its type (Mem32/IO/Mem64). Note
//         that the burst Mem32 and Completion TLPs will be received
//         by the PIO design passing through the core but will be discared. Only
//         1DW Mem32, IO, and mem64 TLPs will be successfully processed. This
//         test is for illustrative purposes and shows how the user can perform
//         various TLP transactions.
//--------------------------------------------------------------------------


  for (ii = 0; ii <= 6; ii = ii + 1) begin
      if (board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[ii] > 2'b00) // bar is enabled
               case(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[ii])
       2'b01 : // IO SPACE
      begin

        $display("[%t] : Transmitting TLPs to IO 32 Space BAR %x", $realtime, ii);


                         //--------------------------------------------------------------------------
        // Event : IO Write TLP
        //--------------------------------------------------------------------------

        board.RP.tx_usrapp.TSK_TX_IO_WRITE(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 32'hdead_beef);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        //--------------------------------------------------------------------------
        // Event : IO Read TLP
        //--------------------------------------------------------------------------

        board.RP.tx_usrapp.TSK_TX_IO_READ(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;



            end

       2'b10 : // MEM 32 SPACE
      begin


              $display("[%t] : Transmitting TLPs to Memory 32 Space BAR %x", $realtime, ii);


        //--------------------------------------------------------------------------
        // Event : Memory Write 32 bit TLPs
        //--------------------------------------------------------------------------


        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'h0, 4'hF, 1'b0);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd16, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF, 1'b0);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd32, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF, 1'b0);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd64, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF, 1'b0);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd128, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF, 1'b0);
        board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
        board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;


        //--------------------------------------------------------------------------
        // Event : Memory Read 32 bit TLPs
        //--------------------------------------------------------------------------


        board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'h0, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

       board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'h0, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

       board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'h0, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

        board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd16, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

              board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd32, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

              board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd64, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

              board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd128, board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0], 4'hF, 4'hF);
              board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
              board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;



         end
    2'b11 : // MEM 64 SPACE
         begin

           $display("[%t] : Transmitting TLPs to Memory 64 Space BAR %x", $realtime, ii);



           //--------------------------------------------------------------------------
           // Event : Memory Write 64 bit TLPs
           //--------------------------------------------------------------------------

           board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'h0, 4'hF, 1'b0);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd16, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF, 1'b0);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd32, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF, 1'b0);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd64, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF, 1'b0);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd128, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF, 1'b0);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;


           //--------------------------------------------------------------------------
           // Event : Memory Read 64 bit TLPs
           //--------------------------------------------------------------------------

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'h0, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'h0, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd1, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'h0, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;


           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd16, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd32, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd64, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

           board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd128, {board.RP.tx_usrapp.BAR_INIT_P_BAR[ii+1][31:0], board.RP.tx_usrapp.BAR_INIT_P_BAR[ii][31:0]}, 4'hF, 4'hF);
           board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
           board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;



               end
    default : $display("Error case in usrapp_tx\n");
      endcase

   end


  $display("[%t] : Transmitting Completion TLPs", $realtime);


    //--------------------------------------------------------------------------
    // Event # 13: Completion TLP
    //--------------------------------------------------------------------------

    $display("[%t] : Sending PCI-Express COMPLETION TLPs", $realtime);

    board.RP.tx_usrapp.TSK_TX_COMPLETION(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 10'd6, 3'h0);
    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    //--------------------------------------------------------------------------
    // Event # 14: Completion with board.RP.tx_usrapp.data TLPs
    //--------------------------------------------------------------------------

    board.RP.tx_usrapp.TSK_TX_COMPLETION_DATA(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 2, 12'hF, 7'b011_0101, 3'h0, 1'b0);
    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    board.RP.tx_usrapp.TSK_TX_COMPLETION_DATA(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 16, 12'hF, 7'b011_0101, 3'h0, 1'b0);
    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    board.RP.tx_usrapp.TSK_TX_COMPLETION_DATA(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 32, 12'hF, 7'b011_0101, 3'h0, 1'b0);
    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    board.RP.tx_usrapp.TSK_TX_COMPLETION_DATA(board.RP.tx_usrapp.DEFAULT_TAG, board.RP.tx_usrapp.DEFAULT_TC, 5, 12'hF, 7'b011_0101, 3'h0, 1'b0);
    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    $display("[%t] : Finished transmission of PCI-Express TLPs", $realtime);
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(1000);
    $finish;
end





  else if(testname == "sample_smoke_test1")
  begin

      // This test use tlp expectation tasks.

      board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(5050);

      //System Initialization
      board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
  
  fork
    begin
      //--------------------------------------------------------------------------
      // Read core configuration space via PCIe fabric interface
      //--------------------------------------------------------------------------

      $display("[%t] : Reading from PCI/PCI-Express Configuration Register 0x00", $realtime);

      board.RP.tx_usrapp.TSK_TX_TYPE0_CONFIGURATION_READ(board.RP.tx_usrapp.DEFAULT_TAG, 12'h0, 4'hF);
      board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
      board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
    end
      //---------------------------------------------------------------------------
      // List Rx TLP expections
      //---------------------------------------------------------------------------
    begin
      test_vars[0] = 0;

      $display("[%t] : Expected Device/Vendor ID = %x", $realtime, board.RP.tx_usrapp.DEV_VEN_ID);

      expect_cpld_payload[0] = board.RP.tx_usrapp.DEV_VEN_ID[7:0];
      expect_cpld_payload[1] = board.RP.tx_usrapp.DEV_VEN_ID[15:8];
      expect_cpld_payload[2] = board.RP.tx_usrapp.DEV_VEN_ID[23:16];
      expect_cpld_payload[3] = board.RP.tx_usrapp.DEV_VEN_ID[31:24];
      board.RP.com_usrapp.TSK_EXPECT_CPLD(
        3'h0, //traffic_class;
        1'b0, //td;
        1'b0, //ep;
        2'h0, //attr;
        10'h1, //length;
        16'h0000, //completer_id;
        3'h0, //completion_status;
        1'b0, //bcm;
        12'h4, //byte_count;
        16'h01a0, //requester_id;
        8'h0, //tag;
        7'b0, //address_low;
        expect_status //expect_status;
      );

      if (expect_status)
        test_vars[0] = test_vars[0] + 1;
    end
  join

    expect_finish_check = 1;

    if (test_vars[0] == 1)
      $display("[%t] : TEST PASSED --- Finished transmission of PCI-Express TLPs", $realtime);
    else
      $display("[%t] : TEST FAILED --- Haven't Received All Expected TLPs", $realtime);

      //--------------------------------------------------------------------------
      // Direct Root Port to allow upstream traffic by enabling Mem, I/O and
      // BusMstr in the command register
      //--------------------------------------------------------------------------
      board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
      board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h00000001, 32'h00000007, 4'b1110);
      board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);

    $finish;
  end


else if(testname == "pio_writeReadBack_test0")
begin

    // This test performs a 32 bit write to a 32 bit Memory space and performs a read back

    board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(10050);

    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;

    board.RP.tx_usrapp.TSK_BAR_INIT;

//--------------------------------------------------------------------------
// Event : Testing BARs
//--------------------------------------------------------------------------

        for (board.RP.tx_usrapp.ii = 0; board.RP.tx_usrapp.ii <= 6; board.RP.tx_usrapp.ii =
            board.RP.tx_usrapp.ii + 1) begin
            if (board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii] > 2'b00) // bar is enabled
               case(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii])
                   2'b01 : // IO SPACE
                        begin

                          $display("[%t] : Transmitting TLPs to IO Space BAR %x", $realtime, board.RP.tx_usrapp.ii);

                          //--------------------------------------------------------------------------
                          // Event : IO Write bit TLP
                          //--------------------------------------------------------------------------



                          board.RP.tx_usrapp.TSK_TX_IO_WRITE(board.RP.tx_usrapp.DEFAULT_TAG,
                             board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], 4'hF, 32'hdead_beef);

                          board.RP.com_usrapp.TSK_EXPECT_CPL(3'h0, 1'b0, 1'b0, 2'b0,
                             board.RP.tx_usrapp.COMPLETER_ID_CFG, 3'h0, 1'b0, 12'h4,
                             board.RP.tx_usrapp.COMPLETER_ID_CFG, board.RP.tx_usrapp.DEFAULT_TAG,
                             board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], status);

                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                          //--------------------------------------------------------------------------
                          // Event : IO Read bit TLP
                          //--------------------------------------------------------------------------


                          // make sure P_READ_DATA has known initial value
                          board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
                          fork
                             board.RP.tx_usrapp.TSK_TX_IO_READ(board.RP.tx_usrapp.DEFAULT_TAG,
                                board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], 4'hF);
                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
                          join
                          if  (board.RP.tx_usrapp.P_READ_DATA != 32'hdead_beef)
                             begin
                               $display("[%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
                                   $realtime, 32'hdead_beef, board.RP.tx_usrapp.P_READ_DATA);
                             end
                          else
                             begin
                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
                             end


                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;


                        end

                   2'b10 : // MEM 32 SPACE
                        begin


                          $display("[%t] : Transmitting TLPs to Memory 32 Space BAR %x", $realtime,
                              board.RP.tx_usrapp.ii);

                          //--------------------------------------------------------------------------
                          // Event : Memory Write 32 bit TLP
                          //--------------------------------------------------------------------------

                          board.RP.tx_usrapp.DATA_STORE[0] = 8'h04;
                          board.RP.tx_usrapp.DATA_STORE[1] = 8'h03;
                          board.RP.tx_usrapp.DATA_STORE[2] = 8'h02;
                          board.RP.tx_usrapp.DATA_STORE[3] = 8'h01;

                          board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG,
                              board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
                              board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h10, 4'h0, 4'hF, 1'b0);
                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                          //--------------------------------------------------------------------------
                          // Event : Memory Read 32 bit TLP
                          //--------------------------------------------------------------------------


                         // make sure P_READ_DATA has known initial value
                         board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
                          fork
                             board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG,
                                 board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
                                 board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h10, 4'h0, 4'hF);
                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
                          join
                          if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[3],
                             board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
                             board.RP.tx_usrapp.DATA_STORE[0] })
                             begin
                               $display("[%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
                                    $realtime, {board.RP.tx_usrapp.DATA_STORE[3],board.RP.tx_usrapp.DATA_STORE[2],
                                     board.RP.tx_usrapp.DATA_STORE[1],board.RP.tx_usrapp.DATA_STORE[0]},
                                     board.RP.tx_usrapp.P_READ_DATA);

                             end
                          else
                             begin
                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
                             end


                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                     end
                2'b11 : // MEM 64 SPACE
                     begin


                          $display("[%t] : Transmitting TLPs to Memory 64 Space BAR %x", $realtime,
                              board.RP.tx_usrapp.ii);


                          //--------------------------------------------------------------------------
                          // Event : Memory Write 64 bit TLP
                          //--------------------------------------------------------------------------

                          board.RP.tx_usrapp.DATA_STORE[0] = 8'h64;
                          board.RP.tx_usrapp.DATA_STORE[1] = 8'h63;
                          board.RP.tx_usrapp.DATA_STORE[2] = 8'h62;
                          board.RP.tx_usrapp.DATA_STORE[3] = 8'h61;

                          board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG,
                              board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
                              {board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii+1][31:0],
                              board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h20}, 4'h0, 4'hF, 1'b0);
                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

                          //--------------------------------------------------------------------------
                          // Event : Memory Read 64 bit TLP
                          //--------------------------------------------------------------------------

                          // make sure P_READ_DATA has known initial value
                          board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
                          fork
                             board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG,
                                 board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
                                 {board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii+1][31:0],
                                 board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h20}, 4'h0, 4'hF);
                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
                          join
                          if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[3],
                             board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
                             board.RP.tx_usrapp.DATA_STORE[0] })

                             begin
                               $display("[%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
                                   $realtime, {board.RP.tx_usrapp.DATA_STORE[3],
                                   board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
                                   board.RP.tx_usrapp.DATA_STORE[0]}, board.RP.tx_usrapp.P_READ_DATA);

                             end
                          else
                             begin
                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
                             end


                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;


                     end
                default : $display("Error case in usrapp_tx\n");
            endcase

         end


    $display("[%t] : Finished transmission of PCI-Express TLPs", $realtime);
    $finish(0);
end

    else begin
      $display("[%t] %m: Error: Unrecognized TESTNAME: %0s", $realtime, testname);
      $finish(2);
    end
  end

endmodule

