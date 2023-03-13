// ---------------------------------------------------------------------------------
// Filename      : sd_boot_ctrl.v
// Author        : whr
// Created On    : 2023-03-10 17:38
// Last Modified : 2023-03-11 18:24
// ---------------------------------------------------------------------------------
// Description   : 
// 
//
// -FHDR----------------------------------------------------------------------------
module sd_boot_ctrl#(
    parameter FLASH = 1             )(   //FLASH��ַ�ռ��С��KB��
    input                clk           ,  //ʱ���ź�
    input                rst_n         ,  //��λ�ź�,�͵�ƽ��Ч
    input                key_ctrl      ,  //�ⲿ���ư���

    input                sd_init_done  ,  //SD����ʼ������ź�
    //дSD���ӿ�
    input                wr_busy       ,  //д����æ�ź�
    input                wr_req        ,  //д���������ź�
    output  reg          wr_start_en   ,  //��ʼдSD�������ź�
    output  reg  [31:0]  wr_sec_addr   ,  //д����������ַ
    output       [15:0]  wr_data       ,  //д����
    //��SD���ӿ�
    input                rd_val_en     ,  //��������Ч�ź�
    input        [15:0]  rd_val_data   ,  //������
	 input               rd_busy       ,  //������æ�ź�
    output  reg          rd_start_en   ,  //��ʼдSD�������ź�
    output  reg  [31:0]  rd_sec_addr   ,  //������������ַ

    input                inst_mem_wr_en_i,
    input        [31:0]  inst_mem_adder_i,
    input        [31:0]  inst_mem_data_i,
    output       [31:0]  inst_mem_data_o
    );

localparam SD_SEC_NUM    		= 2 * FLASH; //һ��������0.5KB

//��״̬��	 
localparam SD_INITIAL           = 4'b0001;
localparam SD_RSD_WRAM     		= 4'b0010;
localparam SD_IDLE           	= 4'b0100;
localparam SD_WR_SD    		    = 4'b1000;

reg[4:0]    current_state;
reg[4:0]    next_state;
reg         sd_rsd_wram_flag;
reg         ram_test_flag;
reg[8:0]    sec_adder_cnt;
reg[8:0]    sec_num_cnt;
reg         wren_b_flag;
reg[31:0]   key;
reg[31:0]   address_a;
reg[31:0]   address_b_cnt;
reg[31:0]   data_a;
reg[15:0]   data_b;
reg         wren_a;
reg         wren_b;
reg[7:0]    start_wait;
reg         restart_initial;
reg         rd_val_en_wait;
reg         enb;
reg         ena;

	 
//reg define
reg              sd_init_done_d0  ;       //sd_init_done�ź���ʱ����
reg              sd_init_done_d1  ;         

//wire define
wire             pos_init_done    ;       //sd_init_done�źŵ�������,��������д���ź�
wire             key_en;
wire[15:0]       q_b;
wire[15:0]       rd_sd_data;
wire[31:0]       address_b;

assign  rd_sd_data = {rd_val_data[7:0],rd_val_data[15:8]};
assign  address_b = address_b_cnt - 1'b1;
assign  pos_init_done = (~sd_init_done_d1) & sd_init_done_d0;

//sd_init_done�ź���ʱ����
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sd_init_done_d0 <= 1'b0;
        sd_init_done_d1 <= 1'b0;
    end
    else begin
        sd_init_done_d0 <= sd_init_done;
        sd_init_done_d1 <= sd_init_done_d0;
    end        
end

//��״̬��
always @( *) begin
    if(!rst_n) begin
        next_state = SD_INITIAL;
        ena = 1'b0;
        enb = 1'b1;
    end
    else begin
        case(current_state)
            SD_INITIAL: begin
                if(pos_init_done) begin
                    next_state = SD_RSD_WRAM;
                end
                else begin
                    next_state = current_state;
                end
            end
            SD_RSD_WRAM: begin
                if(sd_rsd_wram_flag) begin
                    next_state = SD_IDLE;
                end
                else begin
                    next_state = current_state;
                end
            end
            SD_IDLE: begin
                ena = 1'b1;
                enb = 1'b0;
            end
        endcase
    end        
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        current_state <= SD_INITIAL;
    end
    else begin
        current_state = next_state;
    end        
end
 
localparam READ_INITIAL         = 3'b001;
localparam READ_RSD_WRAM     	= 3'b010;
localparam READ_IDLE           	= 3'b100;

reg[2:0]    r_state;

//��������
assign key_en = (key==32'b0) ? 1'b1 : 1'b0;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        key <= 32'hffffffff;
    end
    else begin
        key <= {key[30:0],key_ctrl};
    end        
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rd_start_en <= 1'b0;
        rd_sec_addr <= 32'd0;
        sec_adder_cnt <= 9'b0;
        r_state <= READ_INITIAL;
        address_b_cnt <= 32'b0;
        data_a <= 32'b0;
        data_b <= 16'b0;
        wren_a <= 1'b0;
        wren_b <= 1'b0;
        sd_rsd_wram_flag <= 1'b0;
        restart_initial <= 1'b0;
    end
    else begin
        if(current_state == SD_RSD_WRAM) begin
            case(r_state)
                READ_INITIAL: begin
                    rd_sec_addr <= 32'd16640;
                    sec_adder_cnt <= 9'b0;
                    address_b_cnt <= 32'b0;
                    r_state <= READ_RSD_WRAM;
                    sec_num_cnt <= 9'b0;
                    rd_start_en <= 1'b0;
                    start_wait <= 4'b0;
                    //wren_b_flag <= 1'b0;
                end
                READ_RSD_WRAM: begin
                    if(rd_busy) begin
                        if(rd_val_en) begin
                            if(rd_val_en_wait == 1'b0) begin//�������ź���Ч�󣬵�һ�����ݵ�ַ���ۼ�
                                data_b <= rd_sd_data;
                                wren_b <= 1'b1;
                                rd_val_en_wait <= 1'b1;
                            end
                            if((sec_adder_cnt < 9'd256) & rd_val_en_wait) begin//�������ݺ���
                                sec_adder_cnt <= sec_adder_cnt + 1'b1;
                                address_b_cnt <= address_b_cnt + 1'b1;
                                data_b <= rd_sd_data;
                                wren_b <= 1'b1;
                            end
                            else begin
                                if(restart_initial == 1'b0) begin
                                    restart_initial <= 1'b1;
                                    wren_b <= 1'b0;
                                    sec_num_cnt <= sec_num_cnt + 1'b1;
                                    rd_sec_addr <= rd_sec_addr + 1'b1;
                                    address_b_cnt <= address_b_cnt + 1'b1;
                                    sec_adder_cnt <= 9'b0;
                                    start_wait <= 8'b1;
                                end
                            end
                        end
                        else begin
                            if(restart_initial == 1'b0) begin
                                restart_initial <= 1'b1;
                                wren_b <= 1'b0;
                                sec_num_cnt <= sec_num_cnt + 1'b1;
                                rd_sec_addr <= rd_sec_addr + 1'b1;
                                address_b_cnt <= address_b_cnt + 1'b1;
                                sec_adder_cnt <= 9'b0;
                                start_wait <= 8'b1;
                            end
                        end
                    end
                    else begin
                        if(sec_num_cnt < SD_SEC_NUM) begin
                            if(start_wait == 8'b0)begin
                                rd_start_en <= 1'b1;
                                restart_initial <= 1'b0;
                                rd_val_en_wait <= 1'b0;
                            end
                            else begin
                                if(start_wait == 8'b1111_1111) start_wait <= 8'b0;
                                else start_wait <= start_wait + 1'b1;
                                rd_start_en <= 1'b0;
                            end
                        end
                        else begin
                            r_state <= READ_IDLE;
                        end
                    end
                end
                READ_IDLE: begin
                    sd_rsd_wram_flag <= 1'b1;
                end
                default: begin
                    rd_start_en <= 1'b0;
                end
            endcase
        end
        else begin
            rd_start_en <= 1'b0;
            rd_sec_addr <= 32'd0;
        end
    end        
end

inst_mem u_inst_mem_0 (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(inst_mem_wr_en_i),      // input wire [0 : 0] wea
  .addra(inst_mem_adder_i),  // input wire [13 : 0] addra
  .dina(inst_mem_data_i),    // input wire [31 : 0] dina
  .douta(inst_mem_data_o),  // output wire [31 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(enb),      // input wire enb
  .web(wren_b),      // input wire [0 : 0] web
  .addrb(address_b),  // input wire [14 : 0] addrb
  .dinb(data_b),    // input wire [15 : 0] dinb
  .doutb(q_b)  // output wire [15 : 0] doutb
);
endmodule