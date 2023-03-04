//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Mar  2 21:13:33 2023
//Host        : Z2-R running 64-bit major release  (build 9200)
//Command     : generate_target flash_rooth_wrapper.bd
//Design      : flash_rooth_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module flash_rooth_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    refer_clk,
    refer_rst_n,
    uart_debug_pin,
    gpio,
    uart_tx_pin,
    uart_rx_pin,  
    spi_miso,
    spi_mosi,
    spi_ss,
    spi_clk,
    jtag_TCK,
    jtag_TMS,
    jtag_TDI,
    jtag_TDO,
    halted_ind,
    over,
    succ
    );
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  input wire refer_clk;
  input wire refer_rst_n;
  input wire uart_debug_pin;
  inout wire [15:0] gpio;
  output wire uart_tx_pin;
  input wire uart_rx_pin;
  input wire spi_miso;
  output wire spi_mosi;
  output wire spi_ss;
  output wire spi_clk;
  input wire jtag_TCK;
  input wire jtag_TMS;
  input wire jtag_TDI;
  output wire jtag_TDO;
  output wire halted_ind;
  output wire over;
  output wire succ;
   rooth_soc u_rooth_soc_0(
   .refer_clk        (refer_clk),
   .refer_rst_n      (refer_rst_n),
   .uart_debug_pin   (uart_debug_pin),
   .gpio             (gpio),
   .uart_tx_pin      (uart_tx_pin), 
   .uart_rx_pin      (uart_rx_pin), 
   .spi_miso         (spi_miso),    
   .spi_mosi         (spi_mosi),    
   .spi_ss           (spi_ss),      
   .spi_clk          (spi_clk),     
   .jtag_TCK         (jtag_TCK),    
   .jtag_TMS         (jtag_TMS),    
   .jtag_TDI         (jtag_TDI),    
   .jtag_TDO         (jtag_TDO),    
   .halted_ind       (halted_ind),
   .over             (over),        
   .succ             (succ)         
   );
  flash_rooth flash_rooth_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb));
endmodule
