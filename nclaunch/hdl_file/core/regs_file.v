// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : regs_file.v
// Author        : whr
// Created On    : 2022-07-01 22:34
// Last Modified : 2023-01-06 11:33
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/soc/rooth_defines.v"

module regs_file(
    input                           clk,
    input                           rst_n,

    input                           reg_wr_en_i,
    input   [`REG_ADDR_WIDTH-1:0]   reg_wr_adder_i,
    input   [`CPU_WIDTH-1:0]        reg_wr_data_i,

    input   [`REG_ADDR_WIDTH-1:0]   reg1_rd_adder_i,
    output reg   [`CPU_WIDTH-1:0]   reg1_rd_data_o,

    input   [`REG_ADDR_WIDTH-1:0]   reg2_rd_adder_i,
    output reg   [`CPU_WIDTH-1:0]   reg2_rd_data_o,
    // jtag
    input wire                      jtag_we_i,      // 写寄存器标志
    input wire[`REG_ADDR_WIDTH-1:0] jtag_addr_i,    // 读、写寄存器地址
    input wire[`CPU_WIDTH-1:0]      jtag_data_i,    // 写寄存器数据
    output reg[`CPU_WIDTH-1:0]      jtag_data_o     // 读寄存器数据
);

reg [`REG_NUM-1:0]    register[0:`REG_DATA_DEPTH-1];

always  @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
    end
	else begin
		if(reg_wr_en_i && (reg_wr_adder_i != `REG_ADDR_WIDTH'b0))
			register[reg_wr_adder_i] <= reg_wr_data_i;
        else if((jtag_we_i == 1'b1) && (jtag_addr_i != `REG_ADDR_WIDTH'b0)) begin
            register[jtag_addr_i] <= jtag_data_i;
        end
	end
end

always @(*) begin
    if(!rst_n || (reg1_rd_adder_i == `REG_ADDR_WIDTH'b0)) begin
        reg1_rd_data_o = `CPU_WIDTH'b0;
    end
    else begin
        reg1_rd_data_o = register[reg1_rd_adder_i];
    end
end

always @(*) begin
    if(!rst_n || (reg2_rd_adder_i == `REG_ADDR_WIDTH'b0)) begin
        reg2_rd_data_o = `CPU_WIDTH'b0;
    end
    else begin
        reg2_rd_data_o = register[reg2_rd_adder_i];
    end
end

// jtag读寄存器
always @ (*) begin
    if (jtag_addr_i == `REG_ADDR_WIDTH'b0) begin
        jtag_data_o = `CPU_WIDTH'b0;
    end
    else begin
        jtag_data_o = register[jtag_addr_i];
    end
 end
endmodule
