import sys
import os

# 主函数
def main():
    # 1.将bin文件转成mem文件
    cmd = r'python ../tools/BinToMem_CLI.py' + ' ' + './riscv-compliance/build_generated/rv32im/' + sys.argv[1] + '.elf.bin' + ' ' + './generated/rv32im/SIG_' + sys.argv[1]
    f = os.popen(cmd)
    f.close()

if __name__ == '__main__':
    sys.exit(main())