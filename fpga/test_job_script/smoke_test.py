import os
import sys
import subprocess

test_case_array = [
        {"name" : "sdram_mcb_tb", "description" : "test bench for sdram_mcb module", "path" : '../sdram_ip/tb/', "script" : 'sdram_mcb_tb.do'},
        {"name" : "sdram_top_tb", "description" : "test bench for sdram_top module", "path" : '../sdram_ip/tb/', "script" : 'tb.do'},
        {"name" : "vga_data_gen_tb", "description" : "test bench for vga_data_gen module", "path" : '../sdram_vga_exp/tb/', "script" : 'vga_data_gen_tb.do'},
        {"name" : "sdram_vga_exp_tb_1",  "description" : "test bench 1 for sdram_vga_exp module", "path" :  '../sdram_vga_exp/tb/', "script" : 'sdram_vga_exp_tb.do'}]

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
