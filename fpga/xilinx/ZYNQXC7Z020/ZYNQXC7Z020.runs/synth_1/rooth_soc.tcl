# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7z020clg400-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.cache/wt [current_project]
set_property parent.project_path D:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/Vivado_prj/ZYNQXC7Z020/program/demo.coe
add_files D:/Vivado_prj/ZYNQXC7Z020/program/spi_oled.coe
add_files D:/Vivado_prj/ZYNQXC7Z020/program/delay.coe
add_files D:/Vivado_prj/ZYNQXC7Z020/program/lcd.coe
add_files D:/Vivado_prj/ZYNQXC7Z020/program/spi_lcd.coe
read_verilog -library xil_defaultlib {
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/rooth_defines.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/alu_core.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/alu_res_ctrl.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/clinet.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/csr_reg.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/decode.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/div.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/flow_ctrl.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/jtag/full_handshake_rx.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/jtag/full_handshake_tx.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/perips/gpio.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/if_as.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/if_de.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/if_ex.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/if_wb.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/imm_gen.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/jtag/jtag_dm.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/jtag/jtag_driver.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/jtag/jtag_top.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/mux_alu.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/pc_reg.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/reg_clash_fb.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/regs_file.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/bus/rib.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/core/rooth.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/perips/spi.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/perips/timer.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/perips/uart.v
  D:/Vivado_prj/ZYNQXC7Z020/rtl/soc/rooth_soc.v
}
read_ip -quiet D:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll.xci
set_property used_in_implementation false [get_files -all d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll_board.xdc]
set_property used_in_implementation false [get_files -all d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll.xdc]
set_property used_in_implementation false [get_files -all d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/clk_pll/clk_pll_ooc.xdc]

read_ip -quiet D:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/inst_mem/inst_mem.xci
set_property used_in_implementation false [get_files -all d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/inst_mem/inst_mem_ooc.xdc]

read_ip -quiet D:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/data_mem/data_mem.xci
set_property used_in_implementation false [get_files -all d:/Vivado_prj/ZYNQXC7Z020/ZYNQXC7Z020.srcs/sources_1/ip/data_mem/data_mem_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Vivado_prj/ZYNQXC7Z020/rooth_xdc.xdc
set_property used_in_implementation false [get_files D:/Vivado_prj/ZYNQXC7Z020/rooth_xdc.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top rooth_soc -part xc7z020clg400-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef rooth_soc.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file rooth_soc_utilization_synth.rpt -pb rooth_soc_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]