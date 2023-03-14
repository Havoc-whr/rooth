## 1. 说明

### 处理器为取指、译码、执行、访存、写回的五级流水线，通过VCS(2018-SP2)工具验证通过了[tinyriscv项目中全部旧的指令测试][tinyriscv],并且也使用[RISC-V][riscv]官方维护的[测试程序][riscv-arch-test]进行了指令的兼容性测试，[测试套件][suite]版本为1.0，设计在除"非对齐访存（MISALIGN）"测试外的rv32i、rv32im、rv32Zicsr以及rv32Zifencei中的测试全部通过。即不支持硬件非对齐访存。

---

## 2. VCS仿真测试运行方式说明，在[VCS目录](https://gitee.com/havocsite/rooth/tree/master/VCS#如何运行)下查看。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677426750198.jpg)

---

## 3. NCLaunch运行测试，在[nclaunch目录](https://gitee.com/havocsite/rooth/tree/master/nclaunch)下查看。
---
## 4. FPGA相关设计迁移到[fpga分支](https://gitee.com/havocsite/rooth/tree/fpga/)下。
---
## 指令兼容性测试结果：

| 序号 |  指令   | 类型 | 测试 |   所属子集   |
| :--: | :-----: | :--: | :--: | :----------: |
|  1   |   ADD   |  R   | PASS |    rv32i     |
|  2   |   SUB   |  R   | PASS |    rv32i     |
|  3   |   XOR   |  R   | PASS |    rv32i     |
|  4   |   OR    |  R   | PASS |    rv32i     |
|  5   |   AND   |  R   | PASS |    rv32i     |
|  6   |   SLL   |  R   | PASS |    rv32i     |
|  7   |   SRL   |  R   | PASS |    rv32i     |
|  8   |   SRA   |  R   | PASS |    rv32i     |
|  9   |   SLT   |  R   | PASS |    rv32i     |
|  10  |  SLTU   |  R   | PASS |    rv32i     |
|  11  |  ADDI   |  I   | PASS |    rv32i     |
|  12  |  XORI   |  I   | PASS |    rv32i     |
|  13  |   ORI   |  I   | PASS |    rv32i     |
|  14  |  ANDI   |  I   | PASS |    rv32i     |
|  15  |  SLLI   |  I   | PASS |    rv32i     |
|  16  |  SRLI   |  I   | PASS |    rv32i     |
|  17  |  SRAI   |  I   | PASS |    rv32i     |
|  18  |  SLTI   |  I   | PASS |    rv32i     |
|  19  |  SLTIU  |  I   | PASS |    rv32i     |
|  20  |  SLTU  |  I   | PASS |    rv32i     |
|  21  |   LB    |  I   | PASS |    rv32i     |
|  22  |   LH    |  I   | PASS |    rv32i     |
|  23  |   LW    |  I   | PASS |    rv32i     |
|  24  |   LBU   |  I   | PASS |    rv32i     |
|  25  |   LHU   |  I   | PASS |    rv32i     |
|  26  |   SB    |  S   | PASS |    rv32i     |
|  27  |   SH    |  S   | PASS |    rv32i     |
|  28  |   SW    |  S   | PASS |    rv32i     |
|  29  |   BEQ   |  B   | PASS |    rv32i     |
|  30  |   BNE   |  B   | PASS |    rv32i     |
|  31  |   BLT   |  B   | PASS |    rv32i     |
|  32  |   BGE   |  B   | PASS |    rv32i     |
|  33  |  BGEU   |  B   | PASS |    rv32i     |
|  34  |   JAL   |  J   | PASS |    rv32i     |
|  35  |  JALR   |  J   | PASS |    rv32i     |
|  36  |   LUI   |  U   | PASS |    rv32i     |
|  37  |  AUIPC  |  U   | PASS |    rv32i     |
|  38  |  ECALL  |  I   | PASS |    rv32i     |
|  39  | EBREAK  |  I   | PASS |    rv32i     |
|  40  | DELAY_SLOTS  |  I   | PASS |    rv32i     |
|  41  | ENDIANESS  |  I   | PASS |    rv32i     |
|  42  | IO  |  I   | PASS |    rv32i     |
|  43  | MISALIGN_JMP  |  I   | **FAIL** |    rv32i     |
|  44  | MISALIGN_LDST  |  I   | **FAIL** |    rv32i     |
|  45  | NOP  |  I   | PASS |    rv32i     |
|  46  | RF_size  |  I   | PASS |    rv32i     |
|  47  | RF_width  |  I   | PASS |    rv32i     |
|  48  | RF_x0  |  I   | PASS |    rv32i     |
|  49  |  CSRRW  |  I   | PASS |  rv32Zicsr   |
|  50  |  CSRRS  |  I   | PASS |  rv32Zicsr   |
|  51  |  CSRRC  |  I   | PASS |  rv32Zicsr   |
|  52  | CSRRWI  |  I   | PASS |  rv32Zicsr   |
|  53  | CSRRSI  |  I   | PASS |  rv32Zicsr   |
|  54  | CSRRCI  |  I   | PASS |  rv32Zicsr   |
|  55  | FENCE.I |  I   | PASS | rv32Zifencei |
|  56  |   MUL   |  R   | PASS |    rv32im    |
|  57  |  MULH   |  R   | PASS |    rv32im    |
|  58  | MULHSU  |  R   | PASS |    rv32im    |
|  59  |  MULHU  |  R   | PASS |    rv32im    |
|  60  |   DIV   |  R   | PASS |    rv32im    |
|  61  |  DIVU   |  R   | PASS |    rv32im    |
|  62  |   REM   |  R   | PASS |    rv32im    |
|  63  |  REMU   |  R   | PASS |    rv32im    |


[tinyriscv]:https://gitee.com/liangkangnan/tinyriscv?_from=gitee_search#431-%E8%BF%90%E8%A1%8C%E6%97%A7%E7%9A%84%E6%8C%87%E4%BB%A4%E6%B5%8B%E8%AF%95%E7%A8%8B%E5%BA%8F "tinyriscv"
[riscv]: https://riscv.org/china/	"RISC-V"
[riscv-arch-test]: https://github.com/riscv-non-isa/riscv-arch-test	"riscv-arch-test"
[suite]: https://github.com/riscv-non-isa/riscv-arch-test/tags?after=2.0	"suite"

