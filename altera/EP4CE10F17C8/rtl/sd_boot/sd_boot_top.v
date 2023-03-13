// ---------------------------------------------------------------------------------
// Filename      : sd_boot_top.v
// Author        : whr
// Created On    : 2023-03-10 16:35
// Last Modified : 2023-03-11 17:45
// ---------------------------------------------------------------------------------
// Description   : 
// 
//
// -FHDR----------------------------------------------------------------------------

module sd_boot_top#(
    parameter FLASH = 64             )(   //FLASH地址空间大小（KB）
    input               clk_ref     ,  //系统时钟
    input               clk_ref_180deg,
    input               rst_n   ,  //系统复位，低电平有效
    input               key_ctrl    ,  //外部控制按键
    //SD卡接口
    input               sd_miso     ,  //SD卡SPI串行输入数据信号
    output              sd_clk      ,  //SD卡SPI时钟信号
    output              sd_cs       ,  //SD卡SPI片选信号
    output              sd_mosi     ,  //SD卡SPI串行输出数据信号
    //inst_mem
    input               inst_mem_wr_en_i,
    input        [31:0] inst_mem_adder_i,
    input        [31:0] inst_mem_data_i,
    output       [31:0] inst_mem_data_o
    );

//wire define
wire             wr_start_en    ;      //开始写SD卡数据信号
wire     [31:0]  wr_sec_addr    ;      //写数据扇区地址    
wire     [15:0]  wr_data        ;      //写数据            
wire             rd_start_en    ;      //开始写SD卡数据信号
wire     [31:0]  rd_sec_addr    ;      //读数据扇区地址    
wire             error_flag     ;      //SD卡读写错误的标志

wire             wr_busy        ;      //写数据忙信号
wire             wr_req         ;      //写数据请求信号
wire             rd_busy        ;      //读忙信号
wire             rd_val_en      ;      //数据读取有效使能信号
wire     [15:0]  rd_val_data    ;      //读数据
wire             sd_init_done   ;      //SD卡初始化完成信号

//产生SD卡测试数据  
sd_boot_ctrl #(
    .FLASH           (16)
)u_sd_boot_ctrl(
    .clk                (clk_ref),
    .rst_n              (rst_n),
	.key_ctrl           (key_ctrl),
    .sd_init_done       (sd_init_done),
    .wr_busy            (wr_busy),
    .wr_req             (wr_req),
    .wr_start_en        (wr_start_en),
    .wr_sec_addr        (wr_sec_addr),
    .wr_data            (wr_data),
    .rd_val_en          (rd_val_en),
    .rd_val_data        (rd_val_data),
	.rd_busy            (rd_busy),
    .rd_start_en        (rd_start_en),
    .rd_sec_addr        (rd_sec_addr),
    .inst_mem_wr_en_i   (inst_mem_wr_en_i),
    .inst_mem_adder_i   (inst_mem_adder_i),
    .inst_mem_data_i    (inst_mem_data_i),
    .inst_mem_data_o    (inst_mem_data_o)
);

//SD卡顶层控制模块
sd_ctrl_top u_sd_ctrl_top(
    .clk_ref           (clk_ref),
    .clk_ref_180deg    (clk_ref_180deg),
    .rst_n             (rst_n),
    //SD卡接口
    .sd_miso           (sd_miso),
    .sd_clk            (sd_clk),
    .sd_cs             (sd_cs),
    .sd_mosi           (sd_mosi),
    //用户写SD卡接口
    .wr_start_en       (wr_start_en),
    .wr_sec_addr       (wr_sec_addr),
    .wr_data           (wr_data),
    .wr_busy           (wr_busy),
    .wr_req            (wr_req),
    //用户读SD卡接口
    .rd_start_en       (rd_start_en),
    .rd_sec_addr       (rd_sec_addr),
    .rd_busy           (rd_busy),
    .rd_val_en         (rd_val_en),
    .rd_val_data       (rd_val_data),    
    
    .sd_init_done      (sd_init_done)
);

endmodule