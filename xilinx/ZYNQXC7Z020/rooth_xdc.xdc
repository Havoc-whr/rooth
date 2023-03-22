set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports refer_clk]
create_clock -period 20.000 -name refer_clk -waveform {0.000 10.000} -add [get_ports refer_clk]

set_property IOSTANDARD LVCMOS33 [get_ports refer_rst_n]
set_property PACKAGE_PIN R16 [get_ports refer_rst_n]

#SD BOOT
set_property IOSTANDARD LVCMOS33 [get_ports soc_rst_key_n]
set_property PACKAGE_PIN T16 [get_ports soc_rst_key_n]

set_property IOSTANDARD LVCMOS33 [get_ports sd_mosi]
set_property PACKAGE_PIN W18 [get_ports sd_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports sd_miso]
set_property PACKAGE_PIN U19 [get_ports sd_miso]

set_property IOSTANDARD LVCMOS33 [get_ports sd_cs]
set_property PACKAGE_PIN Y18 [get_ports sd_cs]

set_property IOSTANDARD LVCMOS33 [get_ports sd_clk]
set_property PACKAGE_PIN Y19 [get_ports sd_clk]

#UART
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_pin]
set_property PACKAGE_PIN V20 [get_ports uart_tx_pin]

set_property IOSTANDARD LVCMOS33 [get_ports uart_rx_pin]
set_property PACKAGE_PIN P18 [get_ports uart_rx_pin]

#JTAG
set_property IOSTANDARD LVCMOS33 [get_ports jtag_TDI]
set_property PACKAGE_PIN N20 [get_ports jtag_TDI]

set_property IOSTANDARD LVCMOS33 [get_ports jtag_TMS]
set_property PACKAGE_PIN N18 [get_ports jtag_TMS]

set_property IOSTANDARD LVCMOS33 [get_ports jtag_TDO]
set_property PACKAGE_PIN T20 [get_ports jtag_TDO]

set_property IOSTANDARD LVCMOS33 [get_ports jtag_TCK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_TCK_IBUF]
set_property PACKAGE_PIN P20 [get_ports jtag_TCK]

set_property IOSTANDARD LVCMOS33 [get_ports halted_ind]
set_property PACKAGE_PIN R18 [get_ports halted_ind]

#SPI
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk]
set_property PACKAGE_PIN E18 [get_ports spi_clk]
set_property SLEW FAST [get_ports spi_clk]

set_property IOSTANDARD LVCMOS33 [get_ports spi_ss]
set_property PACKAGE_PIN U15 [get_ports spi_ss]
set_property SLEW FAST [get_ports spi_ss]

set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property PACKAGE_PIN E19 [get_ports spi_mosi]
set_property SLEW FAST [get_ports spi_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property PACKAGE_PIN W19 [get_ports spi_miso]

#GPIO
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]
set_property PACKAGE_PIN T17 [get_ports {gpio[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]
set_property PACKAGE_PIN T12 [get_ports {gpio[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[2]}]
set_property PACKAGE_PIN U12 [get_ports {gpio[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[3]}]
set_property PACKAGE_PIN V12 [get_ports {gpio[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[4]}]
set_property PACKAGE_PIN W13 [get_ports {gpio[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[5]}]
set_property PACKAGE_PIN N17 [get_ports {gpio[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[6]}]
set_property PACKAGE_PIN Y14 [get_ports {gpio[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[7]}]
set_property PACKAGE_PIN W14 [get_ports {gpio[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[8]}]
set_property PACKAGE_PIN V16 [get_ports {gpio[8]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[9]}]
set_property PACKAGE_PIN P16 [get_ports {gpio[9]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[10]}]
set_property PACKAGE_PIN R17 [get_ports {gpio[10]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[11]}]
set_property PACKAGE_PIN V15 [get_ports {gpio[11]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[12]}]
set_property PACKAGE_PIN W15 [get_ports {gpio[12]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[13]}]
set_property PACKAGE_PIN U18 [get_ports {gpio[13]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[14]}]
set_property PACKAGE_PIN F17 [get_ports {gpio[14]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[15]}]
set_property PACKAGE_PIN F16 [get_ports {gpio[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports key_ctrl]
set_property PACKAGE_PIN P15 [get_ports key_ctrl]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
