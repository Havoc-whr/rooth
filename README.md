## 1. 介绍

fpga分支，使用片上ram资源作为存储器。

### 更新：

2023-3-13，Zynq7000平台支持SD卡启动。

2023-3-14，Altera跟进支持SD卡启动。

## 2. Altera平台

手上Altera的FPGA开发板是入门的型号，资源有限，实际综合完成后逻辑资源占用超过了90%，时序分析的报告显示最高可以支持的频率有35MHz左右，实际最好设置为33.333MHz或25MHz等频率，保证串口为常见的速率。

### 实际测试条件：

1. 软件：Quartus 18.1
2. FPGA：Cyclone Ⅳ EP4CE10F17C8
3. 工程中包含的引脚约束适应于正点原子FPGA开拓者开发板，输入外部时钟频率50MHz。

![](http://www.openedv.com/docs/_images/DSC_0481.png)

### 运行测试情况：

##### 1. 程序载入方式:

目前在上述平台的设计支持三种载入程序方式，分别是JTAG下载、FPGA片上RAM初始化以及通过SD卡初始化RAM。第一种方式在掉电后无法保存程序，每次上电后都要重新下载程序。第二种初始化方式需要将工具链编译生成的bin文件转换成mif文件，并且修改RAM的IP核设计后重新综合，bin转mif文件的方式是通过python脚本实现，脚本编译生成的可执行文件存放在/program路径下，将需要转换的bin文件放在同一目录下双击运行可执行文件输入文件名回车即可生成mif文件。第三种初始化方式解决了掉电丢失以及RAM初始化重新综合时间过程的问题，为了保证运行效率，这里选择在上电后将程序从SD卡载入RAM中运行，而不是通过映射总线地址的方式直接在SD卡中运行程序，要注意的是目前SD卡启动模块载入程序的扇区地址需要在设计中指定，暂不支持检索程序扇区地址的功能。

##### 2. 程序测试：

时序报告中显示最高支持35MHz，实际测试中在50MHz下，涉及timer、uart、spi以及gpio等模块程序运行也基本没有问题。RAM在没有输出缓冲器的情况下，即使跑在25MHz频率下也会在读数据时出现错误，所以设计中添加了缓冲器并且通过锁相环为RAM提供同相的二倍频时钟来满足核心的访存周期要求。
