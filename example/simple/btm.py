import sys
import os

# 主函数
def main():
    # 1.将bin文件转成mem文件
    cmd = r'python ../../tools/BinToMem_CLI.py' + ' ' + sys.argv[1] + ' ' + sys.argv[2]
    f = os.popen(cmd)
    f.close()

if __name__ == '__main__':
    sys.exit(main())