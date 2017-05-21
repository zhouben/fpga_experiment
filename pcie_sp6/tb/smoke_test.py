import os
import sys
import subprocess

test_case_array = [
        {"name" : "inbound_fsm_tb",       "description" : "test bench for inbound moudle",       "path" : './inbound_tb/',         "script" : 'inbound_fsm_tb.do' },
        {"name" : "us_cmd_fifo_tb",       "description" : "test bench for upstream cmd fifo",    "path" : './us_cmd_fifo_tb/',         "script" : 'us_cmd_fifo_tb_sv.do' },
        {"name" : "my_ep_mem_ctrl_tb",    "description" : "test bench for my_ep_mem_ctrl",       "path" : './my_ep_mem_ctrl_tb/',         "script" : 'MY_EP_MEM_CTRL_tb_sv.do' },
        ]

origin_path = os.getcwd()
test_passed = False
test_failed = False
for idx, tc in enumerate(test_case_array):
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
    print ""
    print ""

sys.exit(0 if (False == test_failed) and test_passed else 1)
