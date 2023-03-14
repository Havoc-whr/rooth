# 说明

使用NCLaunch仿真所需要的hdl以及激励文件全部放在nclaunch文件夹下，仅需将nclaunch拷贝到配置好环境的系统中即可运行测试。

1. 配置好环境，进入nclaunch目录下。

![](https://gitee.com/havocsite/rooth/raw/master/images/cadence-2023-02-27-19-58-58.png)

2. 设计hdl代码放在hdl_file目录下，激励文件存放在testbench文件夹下，inst_test下存放着测试程序。其余为NClaunch的工程文件。
2. nclaunch目录下输入`nalaunch &`启动nclaunch。

![](https://gitee.com/havocsite/rooth/raw/master/images/cadence-2023-02-27-20-03-05.png)

4. 选中hdl_file和testbench目录下的全部文件编译设计，选择在左侧worklib目录下选择一个tb文件，点击描述，将设计和激励文件生成一个快照。这里的tb_rooth.v是对单个指令测试，设计遇到bug时运行单个测试程序方便查看波形调试，tb_rooth_alltest.v会依次运行全部测试程序。

![](https://gitee.com/havocsite/rooth/raw/master/images/20230227_213131.png)

5. 选择对应的快照，打开仿真窗口，点击运行按钮，若运行成功控制台会输出PASS。

![](https://gitee.com/havocsite/rooth/raw/master/images/20230227_214111.png)

6. 查看波形。

![](https://gitee.com/havocsite/rooth/raw/master/images/cadence-2023-02-27-20-07-24.png)

7. 若运行全部指令测试，会依次输出运行结果，仿真会在运行失败时停止，并输出寄存器的值以及出现错误的程序以及对应的位置。

![](https://gitee.com/havocsite/rooth/raw/master/images/cadence-2023-02-27-20-04-17.png)
