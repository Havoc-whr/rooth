## 1. 说明

### 处理器为取指、译码、执行、访存、写回的五级流水线，通过VCS(2018-SP2)工具验证通过了[tinyriscv项目中全部旧的指令测试][tinyriscv],并且也使用[RISC-V][riscv]官方维护的[测试程序][riscv-arch-test]进行了指令的兼容性测试，[测试套件][suite]版本为1.0，设计在除"非对齐访存（MISALIGN）"测试外的rv32i、rv32im、rv32Zicsr以及rv32Zifencei中的测试全部通过。即不支持硬件非对齐访存。

### 最新更新使用cyclone IV FPGA的RAM IP核作为指令和数据存储器，通过RAM IP核暂时只支持初始化方式下载程序，提供程序bin转mif工具(rooth/fpga/altera/EP4CE10F17C8/porgram)。程序demo在example文件夹下，使用了tinyriscv的外设以及配套的demo，编译方法参考tinyriscv项目。

## 2. VCS仿真测试运行方式说明，在[VCS目录](https://gitee.com/havocsite/rooth/tree/master/VCS#如何运行)下查看。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677426750198.jpg)

## 3. NCLaunch运行测试，在[nclaunch目录](https://gitee.com/havocsite/rooth/tree/master/nclaunch)下查看。

## 指令支持：

| 序号 |  指令   | 类型 | 测试 | 备注 |
| :--: | :-----: | :--: | :--: | :--: |
|  1   |   ADD   |  R   | PASS |      |
|  2   |   SUB   |  R   | PASS |      |
|  3   |   XOR   |  R   | PASS |      |
|  4   |   OR    |  R   | PASS |      |
|  5   |   AND   |  R   | PASS |      |
|  6   |   SLL   |  R   | PASS |      |
|  7   |   SRL   |  R   | PASS |      |
|  8   |   SRA   |  R   | PASS |      |
|  9   |   SLT   |  R   | PASS |      |
|  10  |  SLTU   |  R   | PASS |      |
|  11  |  ADDI   |  I   | PASS |      |
|  12  |  XORI   |  I   | PASS |      |
|  13  |   ORI   |  I   | PASS |      |
|  14  |  ANDI   |  I   | PASS |      |
|  15  |  SLLI   |  I   | PASS |      |
|  16  |  SRLI   |  I   | PASS |      |
|  17  |  SRAI   |  I   | PASS |      |
|  18  |  SLTI   |  I   | PASS |      |
|  19  |  SLTIU  |  I   | PASS |      |
|  20  |   LB    |  I   | PASS |      |
|  21  |   LH    |  I   | PASS |      |
|  22  |   LW    |  I   | PASS |      |
|  23  |   LBU   |  I   | PASS |      |
|  24  |   LHU   |  I   | PASS |      |
|  25  |   SB    |  S   | PASS |      |
|  26  |   SH    |  S   | PASS |      |
|  27  |   SW    |  S   | PASS |      |
|  28  |   BEQ   |  B   | PASS |      |
|  29  |   BNE   |  B   | PASS |      |
|  30  |   BLT   |  B   | PASS |      |
|  31  |   BGE   |  B   | PASS |      |
|  32  |  BLTU   |  B   | PASS |      |
|  33  |  BGEU   |  B   | PASS |      |
|  34  |   JAL   |  J   | PASS |      |
|  35  |  JALR   |  J   | PASS |      |
|  36  |   LUI   |  U   | PASS |      |
|  37  |  AUIPC  |  U   | PASS |      |
|  38  |  ECALL  |  I   | PASS |      |
|  39  | EBREAK  |  I   | PASS |      |
|  40  |  CSRRW  |  I   | PASS |      |
|  41  |  CSRRS  |  I   | PASS |      |
|  42  |  CSRRC  |  I   | PASS |      |
|  43  | CSRRWI  |  I   | PASS |      |
|  44  | CSRRSI  |  I   | PASS |      |
|  45  | CSRRCI  |  I   | PASS |      |
|  46  | FENCE.I |  I   | PASS |      |
|  47  |   MUL   |  R   | PASS |      |
|  48  |  MULH   |  R   | PASS |      |
|  49  | MULHSU  |  R   | PASS |      |
|  50  |  MULHU  |  R   | PASS |      |
|  51  |   DIV   |  R   | PASS |      |
|  52  |  DIVU   |  R   | PASS |      |
|  53  |   REM   |  R   | PASS |      |
|  54  |  REMU   |  R   | PASS |      |



[tinyriscv]:https://gitee.com/liangkangnan/tinyriscv?_from=gitee_search#431-%E8%BF%90%E8%A1%8C%E6%97%A7%E7%9A%84%E6%8C%87%E4%BB%A4%E6%B5%8B%E8%AF%95%E7%A8%8B%E5%BA%8F "tinyriscv"
[riscv]: https://riscv.org/china/	"RISC-V"
[riscv-arch-test]: https://github.com/riscv-non-isa/riscv-arch-test	"riscv-arch-test"
[suite]: https://github.com/riscv-non-isa/riscv-arch-test/tags?after=2.0	"suite"

