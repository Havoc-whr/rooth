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
//`include "/home/ICer/ic_prjs/rooth/VCS/rtl/core/rooth_defines.v"

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
	 output wire                     s10_o,
    output wire                     s11_o
);

wire [`CPU_WIDTH-1:0] s10;
wire [`CPU_WIDTH-1:0] s11;

reg [`REG_NUM-1:0]    register[0:`REG_DATA_DEPTH-1];

assign s10 = register[26];
assign s11 = register[27];
assign s10_o = s10[0];
assign s11_o = s11[0];

always  @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
    end
	else begin
		if(reg_wr_en_i && (reg_wr_adder_i != `REG_ADDR_WIDTH'b0))
			register[reg_wr_adder_i] <= reg_wr_data_i;
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

endmodule
