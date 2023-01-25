import sys
import filecmp
import subprocess
import sys
import os


# 找出path目录下的所有reference_output文件
def list_ref_files(path):
    files = []
    list_dir = os.walk(path)
    for maindir, subdir, all_file in list_dir:
        for filename in all_file:
            apath = os.path.join(maindir, filename)
            if apath.endswith('.reference_output'):
                files.append(apath)

    return files

# 根据bin文件找到对应的reference_output文件
def get_reference_file(bin_file):
    file_path, file_name = os.path.split(bin_file)
    tmp = file_name.split('.')
    # 得到bin文件的前缀部分
    prefix = tmp[0]
    #print('bin prefix: %s' % prefix)

    files = []
    if (bin_file.find('rv32im') != -1):
        files = list_ref_files(r'../../isa_test/riscv-compliance/riscv-test-suite/rv32im/references')
    elif (bin_file.find('rv32i') != -1):
        files = list_ref_files(r'../../isa_test/riscv-compliance/riscv-test-suite/rv32i/references')
    elif (bin_file.find('rv32Zicsr') != -1):
        files = list_ref_files(r'../../isa_test/riscv-compliance/riscv-test-suite/rv32Zicsr/references')
    elif (bin_file.find('rv32Zifencei') != -1):
        files = list_ref_files(r'../../isa_test/riscv-compliance/riscv-test-suite/rv32Zifencei/references')
    else:
        return None

    # 根据bin文件前缀找到对应的reference_output文件
    for file in files:
        if (file.find(prefix) != -1):
            return file

    return None

# 主函数
def main():
    # 1.将bin文件转成mem文件
    #cmd = r'python ../../isa_test/BinToMem_CLI.py' + ' ' + sys.argv[1] + ' ' + sys.argv[2]
    #f = os.popen(cmd)
    #f.close()

    # 1.将测试文件复制到当前仿真目录
    cmd = r'cp' + ' ' + '../compliance_test/SIG_' + sys.argv[1] + ' ' + 'inst.data'
    f = os.popen(cmd)
    f.close()

    # 2.编译rtl文件
    makevcs_cmd = ['make']
    process = subprocess.Popen(makevcs_cmd)
    process.wait(timeout=5)

    # 3.比较结果
    print('\033[1;34m1:rv32i')
    print('2:rv32im')
    print('3:rv32Zicsr')
    print('4:rv32Zifencei')
    subsets = int(input('Please select subsets:'));
    print('\033[1;32mFinding the reference result. . .')
    if(subsets == 1):
        ref_file = get_reference_file('../../isa_test/riscv-compliance/build_generated/rv32i/I-' + sys.argv[1] + '-01.elf.bin')
    elif(subsets == 2):
        ref_file = get_reference_file('../../isa_test/riscv-compliance/build_generated/rv32im/' + sys.argv[1] + '.elf.bin')
    elif(subsets == 3):
        ref_file = get_reference_file('../../isa_test/riscv-compliance/build_generated/rv32Zicsr/I-' + sys.argv[1] + '-01.elf.bin')
    else:
        ref_file = get_reference_file('../../isa_test/riscv-compliance/build_generated/rv32Zifencei/I-' + sys.argv[1] + '-01.elf.bin')
    if (ref_file != None):
        if(subsets == 1):
            print('\033[1;32mComparing the results with I-' + sys.argv[1] + '-01 of rv32i subsets. . .')
        elif(subsets == 2):
            print('\033[1;32mComparing the results with ' + sys.argv[1] + ' of rv32im subsets. . .')
        elif(subsets == 3):
            print('\033[1;32mComparing the results with I-' + sys.argv[1] + '-01 of rv32Zicsr subsets. . .')
        else:
            print('\033[1;32mComparing the results with I-' + sys.argv[1] + '-01 of rv32Zifencei subsets. . .')
        # 如果文件大小不一致，直接报fail
        if (os.path.getsize('result.output') != os.path.getsize(ref_file)):
            print('\033[1;31m!!! FAIL, size != !!!\033[0m')
            return
        f1 = open('result.output')
        f2 = open(ref_file)
        f1_lines = f1.readlines()
        i = 0
        # 逐行比较
        for line in f2.readlines():
            # 只要有一行内容不一样就报fail
            if (f1_lines[i] != line):
                print('\033[1;31m!!! FAIL, content != !!!\033[0m')
                f1.close()
                f2.close()
                return
            i = i + 1
        f1.close()
        f2.close()
        print('\033[1;32m### PASS ###\033[0m')
    else:
        print('\033[1;31mNo ref file found, please check result by yourself.\033[0m')

if __name__ == '__main__':
    sys.exit(main())
