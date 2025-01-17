// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rooth.v
// Author        : whr
// Created On    : 2022-07-01 23:14
// Last Modified : 2023-01-14 17:01
// ---------------------------------------------------------------------------------
// Description   : 
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"
`include "alu_core.v"
`include "div.v"
`include "rooth.v"
`include "bus.v"
`include "inst_mem.v"
`include "data_mem.v"
`include "pipeline_ctrl.v"
`include "pc_reg.v"
`include "if_de.v"
`include "decode.v"
`include "imm_gen.v"
`include "if_ex.v"
`include "mux_alu.v"
`include "if_fc.v"
`include "fetch.v"
`include "writeback.v"
`include "if_wb.v"
`include "reg_clash_fb.v"
`include "regs_file.v"
`include "csr_reg.v"
`include "clint.v"
`include "spi.v"
`include "timer.v"
`include "uart.v"
`include "gpio.v"
`include "jtag_top.v"
module rooth_soc(
    input                   clk,
    input                   rst_n,
    
    inout       [15:0]      gpio,
    output                  uart_tx_pin,  // UART发送引脚
    input                   uart_rx_pin,  // UART接收引脚

    input                   spi_miso,     // spi控制器输出、spi设备输入信号脚
    output                  spi_mosi,     // spi控制器输入、spi设备输出信号脚
    output                  spi_ss,       // spi设备片选
    output                  spi_clk,      // spi设备时钟，最大频率为输入clk的一半
    input wire              jtag_TCK,     // JTAG TCK引脚
    input wire              jtag_TMS,     // JTAG TMS引脚
    input wire              jtag_TDI,     // JTAG TDI引脚
    output wire             jtag_TDO,     // JTAG TDO引脚
    output wire             halted_ind
); 

// master 0 interface data_mem
wire[`CPU_WIDTH-1:0] m0_addr_i;
wire[`CPU_WIDTH-1:0] m0_data_i;
wire[`CPU_WIDTH-1:0] m0_data_o;
wire m0_req_i;
wire m0_we_i;

// master 1 interface
wire[`CPU_WIDTH-1:0] m1_addr_i;
wire[`CPU_WIDTH-1:0] m1_data_i;
wire[`CPU_WIDTH-1:0] m1_data_o;
wire m1_req_i;
wire m1_we_i;

// master 2 interface
wire[`CPU_WIDTH-1:0] m2_addr_i;
wire[`CPU_WIDTH-1:0] m2_data_i;
wire[`CPU_WIDTH-1:0] m2_data_o;
wire m2_req_i;
wire m2_we_i;

// master 3 interface
wire[`CPU_WIDTH-1:0] m3_addr_i;
wire[`CPU_WIDTH-1:0] m3_data_i;
wire[`CPU_WIDTH-1:0] m3_data_o;
wire m3_req_i;
wire m3_we_i;

// slave 0 interface
wire[`CPU_WIDTH-1:0] s0_addr_o;
wire[`CPU_WIDTH-1:0] s0_data_o;
wire[`CPU_WIDTH-1:0] s0_data_i;
wire s0_we_o;

// slave 1 interface
wire[`CPU_WIDTH-1:0] s1_addr_o;
wire[`CPU_WIDTH-1:0] s1_data_o;
wire[`CPU_WIDTH-1:0] s1_data_i;
wire s1_we_o;

// slave 2 interface
wire[`CPU_WIDTH-1:0] s2_addr_o;
wire[`CPU_WIDTH-1:0] s2_data_o;
wire[`CPU_WIDTH-1:0] s2_data_i;
wire s2_we_o;

// slave 3 interface
wire[`CPU_WIDTH-1:0] s3_addr_o;
wire[`CPU_WIDTH-1:0] s3_data_o;
wire[`CPU_WIDTH-1:0] s3_data_i;
wire s3_we_o;

// slave 4 interface
wire[`CPU_WIDTH-1:0] s4_addr_o;
wire[`CPU_WIDTH-1:0] s4_data_o;
wire[`CPU_WIDTH-1:0] s4_data_i;
wire s4_we_o;

// slave 5 interface
wire[`CPU_WIDTH-1:0] s5_addr_o;
wire[`CPU_WIDTH-1:0] s5_data_o;
wire[`CPU_WIDTH-1:0] s5_data_i;
wire s5_we_o;

//gpio
wire[15:0]                  io_in;
wire[31:0]                  gpio_ctrl;
wire[31:0]                  gpio_data;

wire[`INT_BUS]              int_flag_i;
wire                        timer0_int;

wire                        jtag_reg_we;
wire[`REG_ADDR_WIDTH-1:0]   jtag_reg_addr;
wire[`CPU_WIDTH-1:0]        jtag_reg_data_o;
wire[`CPU_WIDTH-1:0]        jtag_reg_data_i;
wire                        jtag_halt_req_o;
wire                        jtag_reset_req_o;

// 低电平表示已经halt住CPU
assign halted_ind = ~jtag_halt_req_o;
assign int_flag_i = {7'h0, timer0_int};

rooth u_rooth_0(
    .clk                ( clk                   ),
    .rst_n              ( rst_n                 ),
    .int_flag_i         ( int_flag_i            ),
    .bus_data_i         ( m0_data_o             ),
    .bus_addr_o         ( m0_addr_i             ),
    .bus_req_o          ( m0_req_i              ),
    .bus_wr_en_o        ( m0_we_i               ),
    .bus_data_o         ( m0_data_i             ),
    .data_mem_data_out_i( s1_data_i             ),
    .pc_inst_i          ( m1_data_o             ),
    .pc_curr_pc_o       ( m1_addr_i             ),
    .jtag_we_i          ( jtag_reg_we           ),  
    .jtag_addr_i        ( jtag_reg_addr         ),
    .jtag_data_i        ( jtag_reg_data_o       ),
    .jtag_data_o        ( jtag_reg_data_i       ),
    .jtag_halt_flag_i   ( jtag_halt_req_o       ),
    .jtag_reset_flag_i  ( jtag_reset_req_o      )
);
bus u_bus_0(
    .clk                ( clk                   ),
    .rst_n              ( rst_n                 ),

    .m0_addr_i          ( m0_addr_i             ),
    .m0_data_i          ( m0_data_i             ),
    .m0_data_o          ( m0_data_o             ),
    .m0_req_i           ( m0_req_i              ),
    .m0_we_i            ( m0_we_i               ),

    .m1_addr_i          ( m1_addr_i             ),
    .m1_data_o          ( m1_data_o             ),

    .m2_addr_i          ( m2_addr_i             ),
    .m2_data_i          ( m2_data_i             ),
    .m2_data_o          ( m2_data_o             ),
    .m2_req_i           ( m2_req_i              ),
    .m2_we_i            ( m2_we_i               ),

    .m3_addr_i          ( m3_addr_i             ),
    .m3_data_i          ( m3_data_i             ),
    .m3_data_o          ( m3_data_o             ),
    .m3_req_i           ( m3_req_i              ),
    .m3_we_i            ( m3_we_i               ),

    .s0_addr_o          ( s0_addr_o             ),
    .s0_data_o          ( s0_data_o             ),
    .s0_data_i          ( s0_data_i             ),
    .s0_we_o            ( s0_we_o               ),

    .s1_addr_o          ( s1_addr_o             ),
    .s1_data_o          ( s1_data_o             ),
    .s1_data_i          ( s1_data_i             ),
    .s1_we_o            ( s1_we_o               ),

    .s2_addr_o          ( s2_addr_o             ),
    .s2_data_o          ( s2_data_o             ),
    .s2_data_i          ( s2_data_i             ),
    .s2_we_o            ( s2_we_o               ),

    .s3_addr_o          ( s3_addr_o             ),
    .s3_data_o          ( s3_data_o             ),
    .s3_data_i          ( s3_data_i             ),
    .s3_we_o            ( s3_we_o               ),

    .s4_addr_o          ( s4_addr_o             ),
    .s4_data_o          ( s4_data_o             ),
    .s4_data_i          ( s4_data_i             ),
    .s4_we_o            ( s4_we_o               ),

    .s5_addr_o          ( s5_addr_o             ),
    .s5_data_o          ( s5_data_o             ),
    .s5_data_i          ( s5_data_i             ),
    .s5_we_o            ( s5_we_o               )
);

inst_mem u_inst_mem_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .wr_en_i                        ( s0_we_o                     ),
    .data_i                         ( s0_data_o                   ),
    .curr_pc_i                      ( s0_addr_o                   ),
    .inst_o                         ( s0_data_i                   )
);

data_mem u_data_mem_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .adder_i                        ( s1_addr_o                   ),
    .wr_en_i                        ( s1_we_o                     ),
    .data_i                         ( s1_data_o                   ),
    .data_o                         ( s1_data_i                   )
);

// timer模块例化
timer timer_0(
    .clk                    ( clk                       ),
    .rst_n                  ( rst_n                     ),
    .data_i                 ( s2_data_o                 ),
    .addr_i                 ( s2_addr_o                 ),
    .we_i                   ( s2_we_o                   ),
    .data_o                 ( s2_data_i                 ),
    .int_sig_o              ( timer0_int                )
);

// uart模块例化
uart uart_0(
    .clk					( clk					    ),
    .rst_n                  ( rst_n                     ),
    .we_i					( s3_we_o					),
    .addr_i					( s3_addr_o					),
    .data_i					( s3_data_o					),
    .data_o					( s3_data_i					),
    .tx_pin					( uart_tx_pin				),
    .rx_pin					( uart_rx_pin				)
);

// io0
assign gpio[0] = (gpio_ctrl[1:0] == 2'b01)? gpio_data[0]: 1'bz;
assign io_in[0] = gpio[0];
// io1
assign gpio[1] = (gpio_ctrl[3:2] == 2'b01)? gpio_data[1]: 1'bz;
assign io_in[1] = gpio[1];
// io2
assign gpio[2] = (gpio_ctrl[5:4] == 2'b01)? gpio_data[2]: 1'bz;
assign io_in[2] = gpio[2];
// io3
assign gpio[3] = (gpio_ctrl[7:6] == 2'b01)? gpio_data[3]: 1'bz;
assign io_in[3] = gpio[3];
// io4
assign gpio[4] = (gpio_ctrl[9:8] == 2'b01)? gpio_data[4]: 1'bz;
assign io_in[4] = gpio[4];
// io5
assign gpio[5] = (gpio_ctrl[11:10] == 2'b01)? gpio_data[5]: 1'bz;
assign io_in[5] = gpio[5];
// io6
assign gpio[6] = (gpio_ctrl[13:12] == 2'b01)? gpio_data[6]: 1'bz;
assign io_in[6] = gpio[6];
// io7
assign gpio[7] = (gpio_ctrl[15:14] == 2'b01)? gpio_data[7]: 1'bz;
assign io_in[7] = gpio[7];
// io8
assign gpio[8] = (gpio_ctrl[17:16] == 2'b01)? gpio_data[8]: 1'bz;
assign io_in[8] = gpio[8];
// io9
assign gpio[9] = (gpio_ctrl[19:18] == 2'b01)? gpio_data[9]: 1'bz;
assign io_in[9] = gpio[9];
// io10
assign gpio[10] = (gpio_ctrl[21:20] == 2'b01)? gpio_data[10]: 1'bz;
assign io_in[10] = gpio[10];
// io11
assign gpio[11] = (gpio_ctrl[23:22] == 2'b01)? gpio_data[11]: 1'bz;
assign io_in[11] = gpio[11];
// io12
assign gpio[12] = (gpio_ctrl[25:24] == 2'b01)? gpio_data[12]: 1'bz;
assign io_in[12] = gpio[12];
// io13
assign gpio[13] = (gpio_ctrl[27:26] == 2'b01)? gpio_data[13]: 1'bz;
assign io_in[13] = gpio[13];
// io14
assign gpio[14] = (gpio_ctrl[29:28] == 2'b01)? gpio_data[14]: 1'bz;
assign io_in[14] = gpio[14];
// io15
assign gpio[15] = (gpio_ctrl[31:30] == 2'b01)? gpio_data[15]: 1'bz;
assign io_in[15] = gpio[15];

// gpio模块例化
gpio gpio_0(
    .clk                    ( clk                       ),
    .rst                    ( rst_n                     ),
    .we_i                   ( s4_we_o                   ),
    .addr_i                 ( s4_addr_o                 ),
    .data_i                 ( s4_data_o                 ),
    .data_o                 ( s4_data_i                 ),
    .io_pin_i               ( io_in                     ),
    .reg_ctrl               ( gpio_ctrl                 ),
    .reg_data               ( gpio_data                 )
);

spi u_spi_O(

    .clk                    ( clk                       ),
    .rst                    ( rst_n                     ),
    .data_i					( s5_data_o					),
    .addr_i					( s5_addr_o					),
    .we_i					( s5_we_o					),
    .data_o					( s5_data_i					),
    .spi_mosi				( spi_mosi				    ),             
    .spi_miso				( spi_miso					),             
    .spi_ss					( spi_ss					),             
    .spi_clk				( spi_clk					)              

);

jtag_top #(
    .DMI_ADDR_BITS(6),
    .DMI_DATA_BITS(32),
    .DMI_OP_BITS(2)
) u_jtag_top(
    .clk                            ( clk                         ),
    .jtag_rst_n                     ( rst_n                       ),
    .jtag_pin_TCK                   ( jtag_TCK                    ),
    .jtag_pin_TMS                   ( jtag_TMS                    ),
    .jtag_pin_TDI                   ( jtag_TDI                    ),
    .jtag_pin_TDO                   ( jtag_TDO                    ),
    .reg_we_o                       ( jtag_reg_we                 ),
    .reg_addr_o                     ( jtag_reg_addr               ),
    .reg_wdata_o                    ( jtag_reg_data_o             ),
    .reg_rdata_i                    ( jtag_reg_data_i             ),
    .mem_we_o                       ( m2_we_i                     ),
    .mem_addr_o                     ( m2_addr_i                   ),
    .mem_wdata_o                    ( m2_data_i                   ),
    .mem_rdata_i                    ( m2_data_o                   ),
    .op_req_o                       ( m2_req_i                    ),
    .halt_req_o                     ( jtag_halt_req_o             ),
    .reset_req_o                    ( jtag_reset_req_o            )
);

endmodule

