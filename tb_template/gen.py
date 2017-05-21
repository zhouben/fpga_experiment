#! usr/bin/python2.7
# -*- coding: utf-8 -*-  

import argparse

file_name_dict = {
        "verilog": [ "tb.v", "tb.do", "tb_wave.do"],
        "sv"     : [ "tb.sv", "tb_sv.do", "tb_wave_sv.do"]
        }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("name", help="target module name")
    parser.add_argument("type", default="sv", choices=file_name_dict.keys(), help="verilog or systemverilog")

    args = parser.parse_args()

    file_names = file_name_dict[args.type]
    print u"将 %s 重命名为 %s，同时替换里边的部分内容" % (", ".join(file_names), args.name)

    for fn in file_names:
        fn_new = args.name + u"_" + fn
        with open(fn_new, "w") as fout:
            with open(fn) as  fin:
                print u"替换 %s 的内容" % fn ,
                for l in fin.readlines():
                    fout.write(l.replace('xxx', args.name))
                print u"\t\t\tOK"

    print u"处理完成"


if __name__ == "__main__":
    main()
