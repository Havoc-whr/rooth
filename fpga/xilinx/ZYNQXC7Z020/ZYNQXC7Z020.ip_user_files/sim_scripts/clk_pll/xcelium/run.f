-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll_clk_wiz.v" \
  "../../../../ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib
