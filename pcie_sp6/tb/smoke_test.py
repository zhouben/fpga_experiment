import os
import sys
import subprocess
import argparse
import shutil

def main():
    test_case_array = [
        {"name" : "inbound_fsm_tb",       "description" : "test bench for inbound moudle",       "path" : './inbound_tb/',         "script" : 'inbound_fsm_tb.do' },
        {"name" : "us_cmd_fifo_tb",       "description" : "test bench for upstream cmd fifo",    "path" : './us_cmd_fifo_tb/',         "script" : 'us_cmd_fifo_tb_sv.do' },
        {"name" : "my_ep_mem_ctrl_tb",    "description" : "test bench for my_ep_mem_ctrl",       "path" : './my_ep_mem_ctrl_tb/',         "script" : 'MY_EP_MEM_CTRL_tb_sv.do' },
        {"name" : "my_pcie_tb",           "description" : "test bench for my pcie xfer",      "path" : './pcie_ipcore_tb/simulation/functional/', "script" : 'simulate_mti_dma.do' },
        {"name" : "origin_pcie_tb",       "description" : "test bench for origi pcie xfer",      "path" : './pcie_ipcore_tb/simulation/functional/', "script" : 'simulate_mti.do' },
        ]
    parser = argparse.ArgumentParser()
    parser.add_argument("id", action='store', type=int, default=-1,  help="test case idx")
    parser.add_argument("-l", '--list', action='store_true', default=False, required=False, help="list all test cases")

    args = parser.parse_args()
    if args.list:
        for idx, tc in enumerate(test_case_array):
            print "%2d. %-17s : %s" % (idx, tc["name"], tc["description"])
    if args.id >= len(test_case_array):
        print "too large index, should be less than %d" % len(test_case_array)
        return

    origin_path = os.getcwd()
    test_passed = False
    test_failed = False
    tbl_to_run = test_case_array if args.id == -1 else (test_case_array[args.id], )

    for idx, tc in enumerate(tbl_to_run):
        print "No. ", idx, "  ", tc["name"]
        print "========================================="
        print "Description: ", tc["description"]
        print "Test Script: ", tc["script"]
        print ""
        work_path = os.path.normpath(os.path.join(origin_path, tc["path"]))
        if False == os.path.exists(work_path):
            print "{0} ({1}) doesn't exist!".format(tc["path"], work_path)
            sys.exit(1)
        os.chdir(work_path)
        if os.path.exists("./work"):
            shutil.rmtree("./work")
        p = subprocess.Popen(['vsim', '-c', '-do', tc["script"]], stdout = subprocess.PIPE)
        while True:
            if None != p.poll():
                break
            str = p.stdout.readline()
            print str,
            if "PASSED" in str.upper():
                test_passed = True
            if "FAILED" in str.upper():
                test_failed = True
        str = p.stdout.read()
        print str,
        if "PASSED" in str.upper():
            test_passed = True
        if "FAILED" in str.upper():
            test_failed = True
        print ""
        print "-------------------------------------"
        if True == test_failed or False == test_passed:
            print "No.%2d test case %s (%s) FAILED" % (idx, tc["name"], tc["script"])
            break
        else:
            print "No.%2d test case %s PASSED" % (idx, tc["name"])
            if os.path.exists("./work"):
                shutil.rmtree("./work")
        print ""
        print ""
    
    sys.exit(0 if (False == test_failed) and test_passed else 1)
if __name__ == "__main__":
    main()
