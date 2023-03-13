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
    parameter FLASH = 64             )(   //FLASH��ַ�ռ��С��KB��
    input               clk_ref     ,  //ϵͳʱ��
    input               clk_ref_180deg,
    input               rst_n   ,  //ϵͳ��λ���͵�ƽ��Ч
    input               key_ctrl    ,  //�ⲿ���ư���
    //SD���ӿ�
    input               sd_miso     ,  //SD��SPI�������������ź�
    output              sd_clk      ,  //SD��SPIʱ���ź�
    output              sd_cs       ,  //SD��SPIƬѡ�ź�
    output              sd_mosi     ,  //SD��SPI������������ź�
    //inst_mem
    input               inst_mem_wr_en_i,
    input        [31:0] inst_mem_adder_i,
    input        [31:0] inst_mem_data_i,
    output       [31:0] inst_mem_data_o
    );

//wire define
wire             wr_start_en    ;      //��ʼдSD�������ź�
wire     [31:0]  wr_sec_addr    ;      //д����������ַ    
wire     [15:0]  wr_data        ;      //д����            
wire             rd_start_en    ;      //��ʼдSD�������ź�
wire     [31:0]  rd_sec_addr    ;      //������������ַ    
wire             error_flag     ;      //SD����д����ı�־

wire             wr_busy        ;      //д����æ�ź�
wire             wr_req         ;      //д���������ź�
wire             rd_busy        ;      //��æ�ź�
wire             rd_val_en      ;      //���ݶ�ȡ��Чʹ���ź�
wire     [15:0]  rd_val_data    ;      //������
wire             sd_init_done   ;      //SD����ʼ������ź�

//����SD����������  
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

//SD���������ģ��
sd_ctrl_top u_sd_ctrl_top(
    .clk_ref           (clk_ref),
    .clk_ref_180deg    (clk_ref_180deg),
    .rst_n             (rst_n),
    //SD���ӿ�
    .sd_miso           (sd_miso),
    .sd_clk            (sd_clk),
    .sd_cs             (sd_cs),
    .sd_mosi           (sd_mosi),
    //�û�дSD���ӿ�
    .wr_start_en       (wr_start_en),
    .wr_sec_addr       (wr_sec_addr),
    .wr_data           (wr_data),
    .wr_busy           (wr_busy),
    .wr_req            (wr_req),
    //�û���SD���ӿ�
    .rd_start_en       (rd_start_en),
    .rd_sec_addr       (rd_sec_addr),
    .rd_busy           (rd_busy),
    .rd_val_en         (rd_val_en),
    .rd_val_data       (rd_val_data),    
    
    .sd_init_done      (sd_init_done)
);

endmodule