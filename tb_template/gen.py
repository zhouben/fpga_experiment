#! usr/bin/python2.7
# -*- coding: utf-8 -*-  

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("name", help="target module name")
args = parser.parse_args()

file_names = [ "tb.v", "tb.do", "tb_wave.do"]
print u"将 tb.do, tb.v 和 tb_wave.do 重命名为 %s，同时替换里边的部分内容" % args.name

for fn in file_names:
    fn_new = args.name + u"_" + fn
    with open(fn_new, "w") as fout:
        with open(fn) as  fin:
            print u"替换 %s 的内容" % fn ,
            for l in fin.readlines():
                fout.write(l.replace('xxx', args.name))
            print u"\t\t\tOK"

print u"处理完成"
