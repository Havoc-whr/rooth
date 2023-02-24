-makelib ies_lib/xil_defaultlib -sv \
  "/home/eda/EDA_Tools/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/eda/EDA_Tools/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/eda/EDA_Tools/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../rooth.srcs/sources_1/ip/clk_pll/clk_pll_clk_wiz.v" \
  "../../../../rooth.srcs/sources_1/ip/clk_pll/clk_pll.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

