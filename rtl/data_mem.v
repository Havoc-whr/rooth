// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : data_mem.v
// Author        : whr
// Created On    : 2022-07-15 21:10
// Last Modified : 2023-01-08 15:37
// ---------------------------------------------------------------------------------
// Description   : 
//  测试用代替RAM的模块
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"
module data_mem(
    input                               clk,
    input                               rst_n,

    input   [`CPU_WIDTH-1:0]            adder_i,
    input                               wr_en_i,
    input   [`CPU_WIDTH-1:0]            data_i,

    output reg [`CPU_WIDTH-1:0]         data_o
);

reg [`CPU_WIDTH-1:0] ram_file[0:`DATA_MEM_ADDR_DEPTH-1];

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
    end
	else begin
		if(wr_en_i)ram_file[adder_i[`DATA_MEM_ADDR_WIDHT-1:2]] <= data_i;
	end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) data_o = `CPU_WIDTH'b0;
    else data_o = ram_file[adder_i[`DATA_MEM_ADDR_WIDHT-1:2]];
end

endmodule
