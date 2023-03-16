# 简介

## 1. 说明

 处理器为取指、译码、执行、访存、写回的五级流水线，通过VCS(2018-SP2)工具验证通过了[tinyriscv项目中全部旧的指令测试](https://gitee.com/liangkangnan/tinyriscv?_from=gitee_search#431-%E8%BF%90%E8%A1%8C%E6%97%A7%E7%9A%84%E6%8C%87%E4%BB%A4%E6%B5%8B%E8%AF%95%E7%A8%8B%E5%BA%8F),并且也使用[RISC-V][riscv]官方维护的[测试程序][riscv-arch-test]进行了指令的兼容性测试，[测试套件][suite]版本为1.0，设计在除"非对齐访存（MISALIGN）"测试外的rv32i、rv32im、rv32Zicsr以及rv32Zifencei中的测试全部通过。即不支持硬件非对齐访存。

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

# 设计笔记

通俗理解指令集在处理器的设计中的作用，就是操作各个模块的编解码规则标准，有了这个标准，就可以通过编译器将软件与硬件联系起来。一个优秀的处理器架构可以高效地将高级语言转化成可以执行的二进制编码，根据这个编码标准，不同软件开发者设计的各种软件应用以及算法可以运行在不同硬件开发者设计的不同微架构的处理器上，适应格式各样的需求。

## 前期准备：

RISC-V凭借其开源特点以及后发优势，经过十多年的发展，逐渐形成了完善的软硬件生态，这使得基于RISC-V无论是硬件设计还是软件设计都可以找到相应的开源的编译器或有完善微架构设计的硬件，串联起来形成完整的体系进行学习、开发测试。从许多开源项目中可以找到比较完善的，工具链微架构的设计思路。

开源项目：

[Lichee-Pi/Tang_E203_Mini: LicheeTang 蜂鸟E203 Core (github.com)](https://github.com/Lichee-Pi/Tang_E203_Mini)

[tinyriscv: 一个从零开始写的极简、非常易懂的RISC-V处理器核。 (gitee.com)](https://gitee.com/liangkangnan/tinyriscv)

[香山项目总体介绍 - XiangShan 官方文档 (xiangshan-doc.readthedocs.io)](https://xiangshan-doc.readthedocs.io/zh_CN/latest/)

标准文档：

[Specifications – RISC-V International (riscv.org)](https://riscv.org/technical/specifications/)

[jameslzhu/riscv-card: An unofficial assembly reference for RISC-V. (github.com)](https://github.com/jameslzhu/riscv-card)

[RISC-V-中文手册-v2p1](http://www.havocsite.top:8081/d/DSM/home/RISC-V-%E4%B8%AD%E6%96%87%E6%89%8B%E5%86%8C-v2p1.pdf?sign=cz1enoDbGvqQGEX8I1mt5nnh9sm6RCAE2LHSeymhwKU=:0)

## RISC-V特点：

### 简单了解RISC-V指令集

RSIC-V与ARM、X86等传统商业架构相比，最大的优势之一就是开源，开源意味着开放，但并不意味着可以随意修改，更不是意味着没有标准。在ARM、X86在各个领域建立起了具有垄断地位的软硬件生态的当下，RISC-V凭借其后发优势，汲取了先前的许多指令集架构的特点，体现着“大道至简”的设计哲学。与ARM和X86动辄千页的架构文档相比，RISC-V文档通过几百页文档实现了对一个增量式、模块化的指令集架构的说明，这也大大降低了学习门槛。

要设计设计微架构，首先要学习RISC-V的ISA编码格式。前面提到，RISC-V是一个增量式模块化设计的指令集架构，这使得RISC-V处理器的设计可以从支持最小的指令集合开始进行设计，根据需求场景进行增量式的拓展，这个最小的指令集合可以实现完整的CPU的软件栈。

| 扩展指令集 | 描   述                                                      |
| ---------- | ------------------------------------------------------------ |
| M          | 整数乘法与除法指令                                           |
| A          | 存储器原子（Atomic）操作指令和Load-Reserved/Store-Conditional指令 |
| F          | 单精度（32比特）浮点指令                                     |
| D          | 双精度（64比特）浮点指令，必须支持F扩展指令                  |
| C          | 压缩指令，指令长度为16位                                     |
| Q          | 四倍精度浮点数扩展指令集                                     |
| B          | 位操作指令                                                   |
| E          | 表示为嵌入式设计的整型指令                                   |
| H          | 虚拟化扩展                                                   |
| K          | 密码运算扩展                                                 |
| V          | 可伸缩矢量扩展                                               |
| P          | 打包SIMD（Packed-SIMD）扩展                                  |
| J          | 动态翻译语言（DYnamically Translated Language）扩展          |
| T          | 事务中断（Transactional Memory）                             |
| N          | 用户态中断                                                   |

这意味着只需要支持RV32I或RV64I最小指令集合就可以成功在设计的处理器上运行高级语言的编写的程序。

---

### RV32I指令集合

RISC-V的核心指令格式以及RV32I指令在riscv-card、中文手册和其他相关资料中都有讲解。riscv-card中清晰列出了各种指令格式以及RV32I指令。

![imags_20230316_221308](D:\rooth\rooth-master\images\imags_20230316_221308.png)

以RV32I中的ADD加法指令为例，属于R型指令，Opcode为0110011，funct7为0x00，处理器要完成的操作是rd=rs1+rs2，即将源操作数寄存器1中的数据与源操作数寄存器2中的数据相加，存入目标寄存器rd。

![imags_20230316_220521](D:\rooth\rooth-master\images\imags_20230316_220521.png)

找到上面描述指令格式的表格，可以看到R-type从右侧低位开始，依次是opcode、rd、funct3、rs1、rs2、funct7，这里就是32位指令编码的划分。

---

##### 每个字段基本含义：

- **opcode**(操作码):指令的基本操作，这个缩写是它惯用名称。

- **rd**: 目的操作寄存器（地址），用来存放操作结果。

- **funct3**: 一个另外的操作码字段。

- **rs1**: 第一个源操作数寄存器（地址）。

- **rs2**: 第二个源操作数寄存器（地址）。

- **funct7**: 一个另外的操作码字段。

- **imm**：立即数

---

了解了这些，已经大致可以知道处理器是如何理解一条32的指令编码了。首先，处理器要根据Opcode确定指令类型，在确定的指令类型范围内根据funct3和fucnt7确定具体的指令，根据源操作数寄存器地址，从相应的寄存器读出数据，经过计算，将计算结果写入目标寄存器。

[riscv]: https://riscv.org/china/	"RISC-V"
[riscv-arch-test]: https://github.com/riscv-non-isa/riscv-arch-test	"riscv-arch-test"
[suite]: https://github.com/riscv-non-isa/riscv-arch-test/tags?after=2.0	"suite"

