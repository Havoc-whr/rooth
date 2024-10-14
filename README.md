# 简介

## 1. 说明

 处理器为取指、译码、执行、访存、写回的五级流水线，通过VCS(2018-SP2)工具验证通过了[tinyriscv项目中全部旧的指令测试](https://gitee.com/liangkangnan/tinyriscv?_from=gitee_search#431-%E8%BF%90%E8%A1%8C%E6%97%A7%E7%9A%84%E6%8C%87%E4%BB%A4%E6%B5%8B%E8%AF%95%E7%A8%8B%E5%BA%8F),并且也使用[RISC-V][riscv]官方维护的[测试程序][riscv-arch-test]进行了指令的兼容性测试，[测试套件][suite]版本为1.0，设计在除"非对齐访存（MISALIGN）"测试外的rv32i、rv32im、rv32Zicsr以及rv32Zifencei中的测试全部通过。即不支持硬件非对齐访存。

---

## 2. VCS仿真测试运行方式说明，在[VCS目录](https://gitee.com/havocsite/rooth/tree/master/VCS#如何运行)下查看。

![](https://gitee.com/havocsite/rooth/raw/master/images/1677426750198.jpg)

---

## 3. NCLaunch运行测试，在[nclaunch目录](https://github.com/Havoc-whr/rooth/tree/master/nclaunch)下查看。
---
## 4. FPGA相关设计迁移到[fpga分支](https://github.com/Havoc-whr/rooth/tree/fpga)下。
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

[RISC-V-中文读本-v2p1](http://www.havocsite.top:8081/d/DSM/home/RISC-V-%E4%B8%AD%E6%96%87%E6%89%8B%E5%86%8C-v2p1.pdf?sign=cz1enoDbGvqQGEX8I1mt5nnh9sm6RCAE2LHSeymhwKU=:0)

## RISC-V特点：

### 简单了解RISC-V指令集

RSIC-V与ARM、X86等传统商业架构相比，最大的优势之一就是开源。在ARM、X86在各个领域建立起了具有垄断地位的软硬件生态的当下，RISC-V凭借其后发优势，汲取了先前的许多指令集架构的特点，体现着“大道至简”的设计哲学。与ARM和X86动辄千页的架构文档相比，RISC-V文档通过几百页文档实现了对一个增量式、模块化的指令集架构的说明，这也大大降低了学习门槛。

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

![](https://gitee.com/havocsite/rooth/raw/master/images/imags_20230316_221308.png)

以RV32I中的ADD加法指令为例，属于R型指令，Opcode为0110011，funct7为0x00，处理器要完成的操作是rd=rs1+rs2，即将源操作数寄存器1中的数据与源操作数寄存器2中的数据相加，存入目标寄存器rd。

![](https://gitee.com/havocsite/rooth/raw/master/images/imags_20230316_220521.png)

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

除R型之外，还有I、S、B、J、U型指令，I型指令为立即数指令，imm即为立即数，与R型相比，I型指令的源操作数有一位直接来自于指令编码，不需要从相应地址的寄存器读出数据，但需要将立即数扩展成32位之后再进行运算，保证数据位宽的一致性。此外,其他类型指令中M[rs1+imm]表示的是数据存储器，rs1+imm为存储器的地址，PC为指令计数器的值，也就是当前指令在存储器中的地址。

## 处理器设计：

处理器内核在一个指令周期内要完成的工作按照顺序大致可分为五个部分，分别是取指、译码、执行、访存和写回。五个部分的工作在时间上有明显的先后顺序，即一条指令从存储器中读出经过译码，控制各个模块完成运算，运算结果分别被存入内存或内核中的通用寄存器。

![](https://gitee.com/havocsite/rooth/raw/master/images/flow.png)

### 单周期处理器设计：

有了明确任务划分，设计的实现上也就可以划分为五个模块逐一实现。在不考虑实际工作频率的前提下，仅验证内核逻辑功能设计，最简单的方式是首先实现一个单周期的处理器，从取值到最终执行完成完全由组合逻辑完成，指令和数据存储器也同样使用HDL实现，这样的好处是可以在一个时钟周期完成取指和访存、写回等操作，暂时不考虑存储器读写时序，专注于对指令支持的实现和验证。在功能验证正确后，通过在不同模块之间添加触发器和流水线控制模块支持不同读写时序的存储器和流水线功能。

#### 取指：

该部分主要模块有PC（指令计数器）以及执行分支跳转的数据选择器。主要工作是控制指令地址的产生，根据指令地址读出指令并输出。

![](https://gitee.com/havocsite/rooth/raw/master/images/PC.png)

指令地址由两部分来源，其一个是PC计数器计数产生在无分支跳转命令时顺序累加，其二则是外部输入，主要由指令部分产生的分支跳转操作码。后续可拓展输入来源，例如外部中断入口和返回函数的指令地址。

![](https://gitee.com/havocsite/rooth/raw/master/images/pc_flow.png)

##### 输入

PC及MUX操作码：由执行阶段产生，用于控制指令地址的产生。

目标跳转指令地址：由执行阶段计算产生的跳转地址。

##### 输出

指令：用于后续译码、执行等操作。

指令地址：当指令为B型指令需要用到PC值时，作为操作数。

#### 译码：

该部分分为decode和imm_generate两个模块，根据指令格式进行译码操作，产生对应操作码控制执行模块工作。其中decode为主要模块，该部分按照opcode确定指令类型，根据指令类型的不同按照指令格式中的funct3和funct7段确定具体指令。当指令类型为非R型指令时，imm_generate根据指令类型对指令中的立即数段进行扩展，扩展成32位的操作数。

![](https://gitee.com/havocsite/rooth/raw/master/images/decode_flow.png)

##### 译码部分主要RTL代码形式：

```verilog
always  @(*)begin
    branch_o = `WIDTH_BRANCH'b0;
    jump_o  =   `WIDTH_JUMP'b0;
    reg_wr_en_o = 1'b0;
    reg_wr_adder_o = `REG_ADDR_WIDTH'b0;
    reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
    reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
    imm_gen_op_o = `IMM_GEN_OP_WIDTH'b111;
    alu_op_o = `ALU_OP_WIDTH'b0;
    alu_src_sel_o = `ALU_SRC_WIDTH'b0;
    alu_res_op_o = `WIDTH_RESCTRL'b11; //null
    csr_wr_en_o = 1'b0;
    csr_wr_adder_o = `CSR_ADDR_WIDTH'b0;
    csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
    case(opcode)
        `INST_TYPE_R: begin
            reg_wr_en_o     = 1'b1;
            alu_res_op_o = `WIDTH_RESCTRL'b0;
            reg1_rd_adder_o  = rs1;
            reg2_rd_adder_o  = rs2;
            reg_wr_adder_o   = rd;
            alu_src_sel_o = `ALU_SRC_REG;
            if(funct7 != `FUNCT7_INST_M) begin
                case (funct3)
                    `INST_ADD_SUB: 
                        alu_op_o = (funct7 == `FUNCT7_INST_ADD) ? `ALU_ADD : `ALU_SUB;
                    `INST_XOR:
                        alu_op_o = `ALU_XOR;
                    `INST_OR:
                        alu_op_o = `ALU_OR;
                    `INST_AND:
                        alu_op_o = `ALU_AND;
                    `INST_SLL:
                        alu_op_o = `ALU_SLL;
                    `INST_SRL_SRA:
                        alu_op_o = (funct7 == `FUNCT7_INST_SRL) ? `ALU_SRL : `ALU_SRA;//sra:msb_extends
                    `INST_SLT:
                        alu_op_o = `ALU_SLT;
                    `INST_SLTU:
                        alu_op_o = `ALU_SLTU;//zero-extends
                    default: 
                        alu_op_o = `ALU_NULL;
                endcase
            end
            else begin
                case (funct3)
                    `INST_MUL: 
                        alu_op_o = `ALU_MUL;
                    `INST_MULH:
                        alu_op_o = `ALU_MULH;
                    `INST_MULHSU:
                        alu_op_o = `ALU_MULHSU;
                    `INST_MULHU:
                        alu_op_o = `ALU_MULHU;
                    `INST_DIV:
                        alu_op_o = `ALU_DIV;
                    `INST_DIVU:
                        alu_op_o = `ALU_DIVU;//sra:msb_extends
                    `INST_REM:
                        alu_op_o = `ALU_REM;
                    `INST_REMU:
                        alu_op_o = `ALU_REMU;//zero-extends
                    default:
                        alu_op_o = `ALU_NULL;
                endcase
            end
        end
end
```

按照上面的描述形式，跟据riscv-card依次实现不同类型、不同指令的译码工作并输出控制ALU源操作数选择、PC跳转以及ALU运算结果数据流向的控制编码。

---

各个编码的含义及作用：

- **branch_o 、 jump_o**：B和J型指令产生分支跳转的标志信号
- **reg_wr_en_o、reg_wr_adder_o**：通用寄存器写使能和写地址信号
- **reg1_rd_adder_o、reg2_rd_adder_o**：通用寄存器读地址信号
- **imm_gen_op_o**：立即数扩展操作码，按照指令类型产生立即数并进行扩展
- **alu_op_o**：ALU运算操作码，控制ALU进行不同类型的运算
- **alu_src_sel_o**：ALU源操作数选择码，控制用于选择ALU源操作数的数据选择器
- **alu_res_op_o**：控制运算结果存储位置，根据类型将结果存入内存、通用寄存器、CSR寄存器或直接作为取指地址等
- **csr_wr_en_o、csr_wr_adder_o**：CSR寄存器写使能和写地址
- **csr_rd_adder_o**：CSR寄存器读地址

---

##### 立即数扩展：

根据risc-card的指令格式，将立即数扩展至32位，经过比较和查阅资料，可以发现无论是何种类型的指令，只要是存在立即数的指令类型，立即数的（符号位）最高位都都对应了指令的最高位即31位，按照符号位扩展的方式，对立即数高位补符号位、低位补零。

```verilog
always  @(*) begin
    imm_o = `CPU_WIDTH'b0;
    case(imm_gen_op_i)
        `IMM_GEN_I:
            imm_o = {{20{inst_i[31]}},inst_i[31:20]};
        `IMM_GEN_S:
            imm_o = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
        `IMM_GEN_B:
            imm_o = {{20{inst_i[31]}},inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
        `IMM_GEN_U:
            imm_o = {inst_i[31:12],{12{1'b0}}};
        `IMM_GEN_J:
            imm_o = {{12{inst_i[31]}},inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
        `IMM_GEN_CSRRWI:
            imm_o = {{27{1'b0}},{inst_i[19:15]}};
        `IMM_GEN_CSRRSI:
            imm_o = {{27{1'b0}},{inst_i[19:15]}};
        `IMM_GEN_CSRRCI:
            imm_o = ~{{27{1'b0}},{inst_i[19:15]}};
    endcase
end
```

对于CSR操作指令的立即数，根据中文手册中的说明，立即数需要进行的时零扩展，即高位补零。但在后期测试中发现，CSRRCI指令按照零扩展方式并不能通过指令测试。这时再回到中午手册中比较文字描述和上方式子中的描述，发现需要对zimm取反，目前还未找到具体原因，以及为何要进行取反。但按照取反运算产生的结果可以通过指令兼容性测试程序。

![imags_20230409_172749](https://gitee.com/havocsite/rooth/raw/master/images/imags_20230409_172749.png)

#### 执行：

该部分主要由输入数据选择器、ALU、和输出数据选择器组成。

![](https://gitee.com/havocsite/rooth/raw/master/images/ex_flow.png)

- MUX：ALU的输入由数据选择器模块按照译码结果进行选择，数据主要来源于内核中的通用寄存器、经过扩展后的立即数、CSR寄存器、以及当前指令PC值。ALU单元前添加数据选择器，用于运算输入选择，这样使得ALU的输入仅有两个32位数据输入，通过ALU操作码控制运算类型，方便后期修改ALU设计或整体替换。

- ALU：ALU的设计上，在单周期处理器设计阶段，可以由简单的加、减、与和或运算进行初期验证，在处理器内核整体框架建立并通过验证之后再进行扩展。

- result ctrl：处理器基本所有运算都是在ALU中进行的，包括分支跳转指令的跳转地址，也是经过ALU运算得到的，优点是可以针对内核的ALU运算单元进行集中的优化设计，当然由于分支跳转地址等也是ALU运算得到的，所以流水线设计上，指令至少需要经过取指、译码、以及执行三个阶段才能发生跳转，带来冲刷流水线导致的效率降低。

#### 访存：

该阶段实现访存类型的数据读取和存储，数据存储器的读和写操作都在该阶段完成，可以有效避免不同阶段访存带来的数据冒险。该阶段逻辑功能比较简单，后期流水线划分上可以承担部分执行阶段的逻辑功能，例如ALU运算结果控制和运算后的位扩展等。

#### 写回：

该阶段将运算结果写回通用寄存器以及CSR寄存器。到此，一条指令执行结束。

### 流水线设计：

单周期处理器设计完成后经过测试，可以通过指令兼容性测试程序。但处理器目前所有电路均为组合逻辑，从取指到写回是一条很长的时序路径，电路只能运行在很低的主频下，此外路径数量较多且复杂，为优化带来的很大的困难。在单周期设计时已经考虑到这个问题，为添加流水线做好了许多铺垫，由于五个部分的电路工作在时间维度上有着明显的先后顺序，这里仅需要将五个模块中间添加触发器便可以很方便的划分出流水线结构，这样以来综合出的时序路径的起点和终点全部落在了两级流水线模块的中间，为后期时序的优化提供了方便。

![](https://gitee.com/havocsite/rooth/raw/master/images/flow_design.png)

然而，并不是所有指令都是从取指开始到写回结束。对于分支跳转指令、中断等，需要对流水线进行冲刷、暂停等操作。每一级流水线当前所执行的指令是由该模块前面的触发器控制的，所以只要对五个触发器模块进行统一的控制，便可以高效地管理处理器中的流水线状态。所以需要设计一个流水线控制模块对流水线进行管理控制，后期添加外部中断或添加多内核时，修改流水线管理模块的设计即可。

![](https://gitee.com/havocsite/rooth/raw/master/images/flow_ctrl.png)

##### 数据冒险：

流水线添加后，在对存储器、寄存器进行读写操作时，不可避免地会出现数据冒险。将处理器中存储总结出来，包括指令存储器、数据存储器、通用寄存器以及CSR寄存器。对于存储指令的指令存储器，该部分只读，且仅在取指阶段进行读取，尽管在测试中会将测试结果写入该存储器，但写入空间是单独划分出来的，且仅仅是进行读操作所以不用考虑。而对于数据存储器，前面也提到过，其读写操作都在访存阶段完成，该部分暂时也不用考虑。剩下的就是两种类型的寄存器组，下面是在不断调试、迭代后总结出的数据冒险的情况分析以及最终解决办法。

通用寄存器读操作是执行阶段进行的，需要从寄存器中读出数据进行运算，而写操作发生在写回阶段，不可避免会产生数据的冒险。

例如，当`指令1`为加法指令，那么`指令1`需要读取寄存器中的值`a1`和`a2`并将运算结果`b1`写回寄存器。在执行阶段，处理器会读取通用寄存器中的值`a1`和`a2`，而运算结果不会立即存入`b1`，而是经过访存阶段到写回阶段再写入寄存器。当`指令1`运行在访存阶段，紧接着下一条`指令2`需要读取`b2`的值时，由于还未写入，`指令2`读取到的值为`指令1`执行前的结果，程序的运行结果就会产生错误。

![](https://gitee.com/havocsite/rooth/raw/master/images/clash.png)

对于该问题，首先想到的是冲刷流水线，让指令2重新从取指阶段开始重新执行，这样在处理器需要频繁对通用寄存器进行读写操作时会极大地降低执行效率。解决办法是在通用寄存器中添加一个模块，读取访存和写回阶段要写入的数据和对应的写入地址，执行阶段读取值`b1`和`b2`时会首先判断是否存在还未写入的数据值，当未写入的值的地址与读地址一致时，直接返回为未写入的`b1`的值而不用去读通用寄存器，这样既避免了流水线的冲刷又解决了冒险。

![](https://gitee.com/havocsite/rooth/raw/master/images/Data%C2%A0Hazard%20Process.png)

对于CSR寄存器，其读写行为与通用寄存器相似，解决方法也相似，但CSR读写操作还会发生在出现中断的状况下，此时一般会暂停整个处理器内核处理中断，读写操作也有中断处理的模块来实现。

到这里，处理器内核的设计基本上已经完成了，后续添加总线、外设，以及添加中断处理器模块，通过流水线控制模块可以很方便地暂停模块整条或任意哪级流水线，以便于使用总线接口时序和等待中断处理等。

# ...

[riscv]: https://riscv.org/china/	"RISC-V"
[riscv-arch-test]: https://github.com/riscv-non-isa/riscv-arch-test	"riscv-arch-test"
[suite]: https://github.com/riscv-non-isa/riscv-arch-test/tags?after=2.0	"suite"

