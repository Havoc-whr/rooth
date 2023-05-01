# 如何运行

## 1. 运行环境

系统版本：CentOS 7

仿真工具版本：VCS2018和Verdi2018（-SP2）

此外还需要安装Python3的环境

## 2. 运行测试

运行VCS的仿真至少需要isa_test和VCS两个文件夹放在同一目录下，或将整个工程clone下来。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677415752558.jpg)

### 2.1 运行单个指令测试程序

测试项目仓库：[GitHub - riscv-software-src/riscv-tests](https://github.com/riscv-software-src/riscv-tests)

#### 运行方式：

1. 进入VCS/tb/目录查看tb_rooth.v文件，可以修改需要运行的仿真测试程序，程序存放在/VCS/inst_test/目录下，修改后保存退出。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677416694773.jpg)

2.  然后回到VCS/verification/目录，打开终端输入`make clean`命令清除前一次仿真生成的文件，最后输入`make vcsone`运行，等待终端输出。
3.  若运行成功，则会输出PASS。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677417129440.jpg)

4. 运行结束后，在终端输入`make verdi`可以查看仿真过程中的波形。
![](https://gitee.com/havocsite/rooth/raw/master/images/IC_EDA-2023-02-26-21-17-49.png)
### 2.2 运行全部指令测试

前面指令测试每次运行都需要修改testbench文件并重新输入指令，可以运行tb_rooth_alltest.v将isa_test中的测试程序依次运行并输出结果。

1. 同样，打开file_list文件，在文件最下方将tb_rooth_alltest.v取消注释，并将其他testbench文件路径注释掉，保存并退出。
2. 进入VCS/verification/目录，打开终端输入`make clean`命令清除前一次仿真生成的文件，最后输入`make vcsall`运行，等待终端输出。
3. 若运行成功，会看到终端打印出PASS，若未通过测试，testbench文件会在运行第一个未通过的测试的程序时终止。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677417965825.jpg)

### 2.3 运行更加完善的新的指令测试程序

对于前面的指令测试程序，会在程序的最后将标准结果与仿真结果进行比较，用于判断运行结果的正确性。而新的更加完善的指令测试程序会被分成若干子程序，并且将若干子程序的运行结果存放的数据/指令存储器中，程序运行结束后，将存储器中的数据与标准结果进行对比，从而将验证结果精确到对每一个子程序，进而验证设计的规范性。该测试项目仍在不断更新完善，具体程序设计可以查看其github仓库中的介绍：[riscv-arch-test/TestFormatSpec.adoc at main · riscv-non-isa/riscv-arch-test (github.com)](https://github.com/riscv-non-isa/riscv-arch-test/blob/main/spec/TestFormatSpec.adoc)

#### 运行方式：

1. 进入VCS/verification/目录，打开终端,运行python脚本，以运行ADD测试程序为例，输入`make vcs isa=ADD`

![](https://gitee.com/havocsite/rooth/raw/master/images/1677418988813.jpg)

2. 选择测试程序所在的目录，对于ADD测试程序选择`1`选择rv32i。具体对应isa_test/riscv-compliance/build_generated目录下的四个文件夹，要运行文件夹下的测试程序，需要设计支持RISC-V对应的指令子集，例如ADD测试在rv32i目录下，需要设计支持RV32I指令,全部测试运行结果在[项目根目录的介绍](https://gitee.com/havocsite/rooth#指令兼容性测试结果)中已全部列出。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677419298059.jpg)

3. 若运行成功则会输出PASS，否则输出FAIL。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677419494275.jpg)

![](https://gitee.com/havocsite/rooth/raw/master/images/1677419734696.jpg)

## 3. 说明

对于测试程序具体原理和脚本介绍，待更新....