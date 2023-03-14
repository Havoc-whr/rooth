## 1. 介绍

fpga分支，使用片上ram资源作为存储器。

### 更新：

2023-3-13，Xilinx的Zynq7000平台支持SD卡启动。

2023-3-14，Altera跟进支持SD卡启动。

## 2. Altera平台

手上Altera的FPGA开发板是入门的型号，资源有限，实际综合完成后逻辑资源占用超过了90%，时序分析的报告显示最高可以支持的频率有35MHz左右，实际最好设置为33.333MHz或25MHz等频率，保证串口为常见的速率。

### 实际测试环境：

1. 软件：Quartus 18.1
2. FPGA：Cyclone Ⅳ EP4CE10F17C8
3. 工程中包含的引脚约束适应于正点原子FPGA开拓者开发板，输入外部时钟频率50MHz。

![](https://gitee.com/havocsite/rooth/raw/fpga/images/DSC_0481.png)

### 运行测试情况：

##### 1. 程序载入方式:

目前在上述平台的设计支持三种载入程序方式，分别是JTAG下载、FPGA片上RAM初始化以及通过SD卡初始化RAM。

第一种方式在掉电后无法保存程序，每次上电后都要重新下载程序。

JTAG下载步骤：

1. 进入tools/openocd文件夹下，输入命令。

   ```
   .\openocd.exe -f rooth.cfg
   ```

![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_175825.png)

2. 启动openocd后，创建打开一个新的命令行窗口，输入`telnet localhost 4444`，监听本地4444端口。

![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_180001.png)

3. 在调试窗口输入相应的命令进行下载、读取和调试等操作，搜集到的常用命令如下。

   ```
   halt	-暂停CPU
   reset	-复位目标板
   resume 	-恢复运行
   resume 0x123456   -从0x123456地址恢复运行
   reg <register>    -打印register寄存器的值
   
   load_image <File Name> <Addr>		    -烧写二进制文件到指定地址
   例: load_image image.bin 0x4000000  	-烧写image.bin到0x4000000
   
   dump_image <File Name> <Addr> <Size>    -将内存从地址Addr开始的Size字节数据读出，保存到文件File Name中
   
   verify_image <File Name> <Addr> [bin|ihex|elf] 	-将文件File Name与内存Addr开始的数据进行比较，格式可选，bin、ihex、elf
   
   step [Addr]		-不加地址：从当前位置单步执行; 加地址：从Addr处单步执行
   poll		    -查询目标板当前状态
   bp <Addr> <Length> [hw] 	-在Addr地址设置断点，指令长度为Length，hw代表硬件断点
   rbp <Addr>		 -删除Addr处的断点
   
   mdw <Addr> [Count]	 -显示从物理地址Addr开始的Count(缺省则默认为1)个字（4Bytes）
   mdh <Addr> [Count]	 -显示从物理地址Addr开始的Count(缺省则默认为1)个半字（2Bytes）
   mdb <Addr> [Count]	 -显示从物理地址Addr开始的Count(缺省则默认为1)个字节（1Byte）
   mww <Addr> <Value>   -向物理地址Addr写入Value，大小：一个字（4Bytes）
   mwh <Addr> <Value>   -向物理地址Addr写入Value，大小：一个半字（2Bytes）
   mwb <Addr> <Value>   -向物理地址Addr写入Value，大小：一个字节（1Bytes）
   ```

![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_175944.png)

第二种初始化方式需要将工具链编译生成的bin文件转换成mif文件，并且修改RAM的IP核设计后重新综合，bin转mif文件的方式是通过python脚本实现，脚本编译生成的可执行文件存放在/program路径下。

1. 将需要转换的bin文件放在同一目录下双击运行可执行文件

![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_131709.png)

2. 输入文件名回车即可生成mif文件

![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_183532.png)

第三种初始化方式解决了掉电丢失以及RAM初始化重新综合时间过程的问题，为了保证运行效率，这里选择在上电后将程序从SD卡载入RAM中运行，而不是通过映射总线地址的方式直接在SD卡中运行程序，要注意的是目前SD卡启动模块载入程序的扇区地址需要在设计中指定，暂不支持检索程序扇区地址的功能。![](https://gitee.com/havocsite/rooth/raw/fpga/images/imags_20230314_131413.png)



##### 2. 运行测试：

时序报告中显示最高支持35MHz，实际测试中在50MHz下，涉及timer、uart、spi以及gpio等模块程序运行也基本没有问题。RAM在没有输出缓冲器的情况下，即使跑在25MHz频率下也会在读数据时出现错误，所以设计中添加了缓冲器并且通过锁相环为RAM提供同相的二倍频时钟来满足核心的访存周期要求。

## Xilinx平台

测试的FPGA为ZYNQ系列，仅使用PL端，功能实现上与上述Altera平台相同，设计综合后在50MHz下可以满足时序约束。

1. 软件：Vivado 2019.2
2. FPGA：ZYNQXC7Z020
3. FPGA输入外部时钟频率50MHz

存储器同样使用片上的RAM资源，经过测试使用片上的Block RAM不添加输出缓冲器的条件下数据读写正常，相比Altera平台测试使用的开发板有更加宽裕的片上RAM资源，故可以运行一些编译后产生更大二进制文件的程序，进行更加完善的验证测试。

