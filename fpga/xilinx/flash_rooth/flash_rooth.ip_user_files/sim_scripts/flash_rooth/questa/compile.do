vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_6
vlib questa_lib/msim/processing_system7_vip_v1_0_8
vlib questa_lib/msim/xil_defaultlib

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_6 questa_lib/msim/axi_vip_v1_1_6
vmap processing_system7_vip_v1_0_8 questa_lib/msim/processing_system7_vip_v1_0_8
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xilinx_vip -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/ec67/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/2d50/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ip/flash_rooth_processing_system7_0_0" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_6 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/ec67/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/2d50/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ip/flash_rooth_processing_system7_0_0" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/dc12/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_8 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/ec67/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/2d50/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ip/flash_rooth_processing_system7_0_0" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/2d50/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/ec67/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ipshared/2d50/hdl" "+incdir+../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ip/flash_rooth_processing_system7_0_0" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/ip/flash_rooth_processing_system7_0_0/sim/flash_rooth_processing_system7_0_0.v" \
"../../../../flash_rooth.srcs/sources_1/bd/flash_rooth/sim/flash_rooth.v" \

vlog -work xil_defaultlib \
"glbl.v"

